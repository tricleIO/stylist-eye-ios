//
//  StylistListTableViewController.swift
//  StylistEye
//
//  Created by Michal Severín on 16.12.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import UIKit

class StylistListViewController: AbstractViewController {

    
    // MARK: - Properties
    // MARK: > public
    var callback: ((_ stylistId: String?) -> Swift.Void)?
    
    // MARK: > private
    fileprivate var stylistListData: [StylistListDTO]? = [] {
        didSet {
            tableView.reloadData()
        }
    }

    fileprivate let tableView = TableView(style: .grouped)
    
    // MARK: - Initialize
    internal override func initializeElements() {
        super.initializeElements()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(StylistListTableViewCell.self)
    }
    
    internal override func setupView() {
        super.setupView()
        
        view.backgroundColor = Palette[basic: .white]
        tableView.backgroundColor = Palette[basic: .clear]
    }
    
    internal override func setupBackgroundImage() {
        super.setupBackgroundImage()
    }
    
    internal override func addElements() {
        super.addElements()
        
        view.addSubview(tableView)
    }
    
    internal override func setupConstraints() {
        super.setupConstraints()
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    override func customInit() {
        
    }
    
    internal override func loadData() {
        super.loadData()
        
        StylistCommand().executeCommand { data in
            switch data {
            case let .success(data):
                self.stylistListData = data.objectsArray
            case .failure:
                break
            }
        }
        
    }
}

extension StylistListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StylistListTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.backgroundColor = Palette[basic: .clear]
        if let data = stylistListData?[safe: indexPath.row] {
            cell.textLabel?.text = data.familyName
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stylistListData?.count ?? 0
    }
}


extension StylistListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let data = stylistListData?[safe: indexPath.row] {
            callback?(data.stylistId)
            let _ = navigationController?.popViewController(animated: true)
        }
    }
    
}
