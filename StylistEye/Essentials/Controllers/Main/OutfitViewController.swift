//
//  OutfitViewController.swift
//  StylistEye
//
//  Created by Michal Severín on 13.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import KVNProgress
import SnapKit
import UIKit

class OutfitViewController: AbstractViewController {

    // MARK: - Properties
    // MARK: > private
    fileprivate lazy var leftBarButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "hamburger_icon"), style: .plain, target: self, action: #selector(settingsButtonTapped))
    fileprivate lazy var rightBarbutton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "message_icon"), style: .plain, target: self, action: #selector(messagesButtonTapped))

    fileprivate let filterTableView = TableView(style: .grouped)
    fileprivate var filterBox: FilterBox?
    
    fileprivate var tableView = TableView(style: .grouped)

    fileprivate let backgroundImageView = ImageView()

    fileprivate let messagesController = MessagesViewController()

    fileprivate var outfits: [OutfitsDTO]? {
        didSet {
            tableView.reloadData()
            filterTableView.reloadData()
        }
    }
    
    fileprivate let filterNameLabel = Label()
    
    fileprivate let showFilterButton = Button(type: .system)

    // MARK: - <Initializable>
    internal override func initializeElements() {
        super.initializeElements()

        backgroundImageView.image = #imageLiteral(resourceName: "purpleBg_image")

        filterTableView.delegate = self
        filterTableView.dataSource = self
        filterTableView.separatorColor = Palette[custom: .purple]

        filterBox = FilterBox(tableView: filterTableView)
        filterBox?.isHidden = true

        tableView.register(OutfitTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = Palette[basic: .clear]
        tableView.separatorColor =  Palette[basic: .clear]
        tableView.contentInset = UIEdgeInsets(top: -36, left: 0, bottom: 0, right: 0)

        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarbutton
        
        // TODO: @MS
        showFilterButton.setTitle("Zobrazit", for: .normal)
        showFilterButton.tintColor = Palette[custom: .title]
        showFilterButton.addTarget(self, action: #selector(showFilterButtonTapped), for: .touchUpInside)
        
        filterNameLabel.text = "Společenské šaty"
        filterNameLabel.textColor = Palette[custom: .appColor]
    }

    internal override func addElements() {
        super.addElements()

        view.addSubviews(views:
            [
                backgroundImageView,
                filterNameLabel,
                showFilterButton,
                tableView,
            ]
        )
        
        if let filterBox = filterBox {
            view.addSubview(filterBox)
        }
    }

    internal override func setupConstraints() {
        super.setupConstraints()

        filterNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(10)
            make.top.equalTo(view).inset(10)
            make.height.equalTo(30)
            make.width.equalTo(150)
        }
        
        showFilterButton.snp.makeConstraints { make in
            make.trailing.equalTo(view).inset(10)
            make.width.equalTo(60)
            make.height.equalTo(30)
            make.top.equalTo(view).inset(10)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(filterNameLabel.snp.bottom).offset(10)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        filterBox?.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(20)
            make.trailing.equalTo(view).inset(20)
            make.height.equalTo(78)
            make.top.equalTo(showFilterButton.snp.bottom).offset(5)
        }
    }

    internal override func setupView() {
        super.setupView()

        title = StringContainer[.outfit]
        view.backgroundColor = Palette[basic: .white]
    }

    override func customInit() {}

    internal override func loadData() {
        super.loadData()

        loadOutfits()
    }

    // MARK: - User Action
    func settingsButtonTapped() {
        openSettingsView()
    }

    func messagesButtonTapped() {
        openMessagesView()
    }

    func showFilterButtonTapped() {
        openFilter()
    }

    // MARK: - Actions
    fileprivate func openFilter() {
        UIView.animate(withDuration: GUIConfiguration.DefaultAnimationDuration, animations: {
            if let filterBox = self.filterBox {
                filterBox.isHidden = !filterBox.isHidden
            }
                self.view.layoutIfNeeded()
            }) { completed in
        }
    }
    
    fileprivate func openSettingsView() {
        let navigationController = UINavigationController(rootViewController: SettingsViewController())
        navigationController.navigationBar.applyStyle(style: .invisible(withStatusBarColor: Palette[basic: .clear]))
        present(navigationController, animated: true, completion: nil)
    }

    fileprivate func openMessagesView() {
        messagesController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(messagesController, animated: true)

    }

    fileprivate func loadOutfits() {
        KVNProgress.show()
        OutfitsCommand().executeCommand { data in
            switch data {
            case let .success(_, objectsArray: data, apiResponse: apiResponse):
                // TODO: @MS
                switch apiResponse {
                case .ok:
                    KVNProgress.dismiss()
                    self.outfits = data
                case .fail:
                    KVNProgress.showError(withStatus: "Fail code outfit VC")
                }
            case let .failure(message: message, apiResponse: _):
                KVNProgress.showError(withStatus: "ougfit detail: \(message)")
            }
        }
    }
}

// MARK: - <UITableViewDataSource>
extension OutfitViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == filterTableView {
            let cell: TableViewCellWithImage = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
            let item = FilterMenu.allCases[indexPath.row]
            
            cell.leftCellImage = item.image
            cell.labelText = item.cellName
            
            return cell
        }
        let cell: OutfitTableViewCell = tableView.dequeueReusableCell()

        if let outfit = outfits?[safe: indexPath.row], let count = outfits?.count {
            if indexPath.row < count {
                cell.backgroundColor = Palette[basic: .clear]
                if let stylistName = outfit.stylist?.givenName, let stylistLastname = outfit.stylist?.familyName {
                    cell.stylistNameText = stylistName + String.space + stylistLastname
                }
                cell.descriptionText = outfit.outfitComment
                cell.selectionStyle = .none
                cell.mainImageString = outfit.photos?.first?.image
                cell.stylistImageString = outfit.stylist?.photo?.image
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == filterTableView {
            return FilterMenu.allCases.count
        }
        return outfits?.count ?? 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    @objc(tableView:heightForRowAtIndexPath:)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == filterTableView {
            return 40 // TODO: @MS
        }
        return CGFloat(GUIConfiguration.OutfitCellHeight)
    }
}

// MARK: - <UITableViewDelegate>
extension OutfitViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == filterTableView {
            navigationController?.pushViewController(StylistListViewController(), animated: true)
            return
        }
        
        let outfitDetailVC = OutfitDetailViewController()
        outfitDetailVC.outfitId = outfits?[safe: indexPath.row]?.outfitId
        outfitDetailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(outfitDetailVC, animated: true)
    }
}
