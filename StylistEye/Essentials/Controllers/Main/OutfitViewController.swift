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

    fileprivate var tableView = TableView(style: .grouped)

    fileprivate let backgroundImageView = ImageView()

    fileprivate let messagesController = MessagesViewController()

    fileprivate var outfits: [OutfitsDTO]? {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: - <Initializable>
    internal override func initializeElements() {
        super.initializeElements()

        backgroundImageView.image = #imageLiteral(resourceName: "purpleBg_image")

        tableView.register(OutfitTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = Palette[basic: .clear]
        tableView.separatorColor =  Palette[basic: .clear]

        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarbutton
    }

    internal override func addElements() {
        super.addElements()

        view.addSubviews(views:
            [
                backgroundImageView,
                tableView,
            ]
        )
    }

    internal override func setupConstraints() {
        super.setupConstraints()

        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }

        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
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

    // MARK: - Actions
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
                    KVNProgress.showError()
                }
            case .failure:
                KVNProgress.showError()
            }
        }
    }
}

// MARK: - <UITableViewDataSource>
extension OutfitViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OutfitTableViewCell = tableView.dequeueReusableCell()

        if let outfit = outfits?[safe: indexPath.row], let count = outfits?.count {
            if indexPath.row < count {
                cell.backgroundColor = Palette[basic: .clear]
                cell.stylistNameText = outfit.author
                cell.descriptionText = outfit.outfitComment
                cell.selectionStyle = .none
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return outfits?.count ?? 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    @objc(tableView:heightForRowAtIndexPath:)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(GUIConfiguration.OutfitCellHeight)
    }
}

// MARK: - <UITableViewDelegate>
extension OutfitViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let outfitDetailVC = OutfitDetailViewController()
        outfitDetailVC.outfitId = outfits?[safe: indexPath.row]?.outfitId
        outfitDetailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(outfitDetailVC, animated: true)
    }
}
