//
//  OutfitCategoryViewController.swift
//  StylistEye
//
//  Created by Michal Severín on 17.12.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import UIKit

class OutfitCategoryViewController: AbstractViewController {
    
    // MARK: - Properties
    // MARK: > public
    var callback: ((_ styleId: String?, _ selectedFilterTitle: String?) -> Swift.Void)?
    
    // MARK: > private
    fileprivate var tableView = TableView(style: .grouped)
    
    fileprivate var categories: [DressStyleDTO]? = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - <Initializable>
    internal override func initializeElements() {
        super.initializeElements()
        
        tableView.register(TableViewCellWithImage.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Palette[basic: .clear]
        tableView.isScrollEnabled = false
        tableView.separatorColor =  Palette[custom: .purple]
        tableView.contentInset = UIEdgeInsets(top: -36, left: 0, bottom: 0, right: 0)
        
        // TODO: @MS
        print(Keychains[.accessTokenKey])
    }
    
    internal override func addElements() {
        super.addElements()
        
        view.addSubviews(views:
            [
                tableView,
            ]
        )
    }
    
    internal override func setupConstraints() {
        super.setupConstraints()

        tableView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view)
        }
    }
    
    internal override func loadData() {
        super.loadData()
      
        DressStyleTypeCommand().executeCommand { data in
            switch data {
            case let .success(data):
                // TODO: select language
                self.categories = data.objectsArray?.filter {$0.languageId == Languages.current}
            case .failure:
                break
            }
        }
    }
    
    override func customInit() {}
    
    internal override func setupView() {
        super.setupView()

        view.backgroundColor = Palette[basic: .white]
    }
}

// MARK: - <UITableViewDataSource>
extension OutfitCategoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCellWithImage = tableView.dequeueReusableCell(forIndexPath: indexPath)
        
        cell.backgroundColor = Palette[basic: .clear]
        cell.textLabel?.textColor = Palette[custom: .purple]
        cell.textLabel?.font = SystemFont[.description]
        cell.tintColor = Palette[custom: .purple]
        cell.separatorInset = UIEdgeInsets.zero
        cell.selectionStyle = .gray
        cell.accessoryType = .disclosureIndicator
        
        if let category = categories?[safe: indexPath.row] {
//            cell.leftCellImage = settingItem?.image
            cell.labelText = category.name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @objc(tableView:heightForRowAtIndexPath:)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(GUIConfiguration.CellHeight)
    }
}

// MARK: - <UITableViewDelegate>
extension OutfitCategoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let category = categories?[safe: indexPath.row] {
            var selectedFilterTitle = String.empty
            if let name = category.name {
                selectedFilterTitle = name
            }
            callback?(category.styleId, selectedFilterTitle)
            navigationController?.popViewController(animated: true)
        }
    }
}
