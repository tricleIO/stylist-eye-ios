//
//  SettingsViewController.swift
//  StylistEye
//
//  Created by Michal Severín on 13.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import KVNProgress
import UIKit

class SettingsViewController: AbstractViewController {

    // MARK: - Properties
    // MARK: > private
    fileprivate lazy var crossButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "cross_icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(crossButtonTapped))

    fileprivate let coverImageView = ImageView()

    internal static let cellItem: [CellItem] = [
        CellItem(image: #imageLiteral(resourceName: "language_image"), name: StringContainer[.language], controller: LanguagesViewController()),
        CellItem(image: #imageLiteral(resourceName: "privacy_image"), name: StringContainer[.privacy], controller: PrivacyViewController()),
        CellItem(image: #imageLiteral(resourceName: "note_image"), name: StringContainer[.note], controller: NoteViewController()),
        CellItem(image: #imageLiteral(resourceName: "about_image"), name: StringContainer[.about], controller: AboutViewController()),
        CellItem(image: #imageLiteral(resourceName: "logout_image"), name: StringContainer[.logout], controller: nil),
    ]

    fileprivate var tableView = TableView(style: .grouped)

    // MARK: - <Initializable>
    internal override func addElements() {
        super.addElements()

        view.addSubviews(views:
            [
                coverImageView,
                tableView,
            ]
        )
    }

    internal override func initializeElements() {
        super.initializeElements()

        coverImageView.image = #imageLiteral(resourceName: "purpleBg_image")

        tableView.register(UITableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Palette[basic: .clear]
        tableView.isScrollEnabled = false
        tableView.separatorColor =  Palette[custom: .appColor]

        navigationItem.leftBarButtonItem = crossButton
    }

    internal override func setupView() {
        super.setupView()

        title = StringContainer[.menu]
    }

    internal override func setupConstraints() {
        super.setupConstraints()

        coverImageView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(view).inset(46)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view)
        }
    }

    override func customInit() {
    }

    // MARK: - User Actions
    func crossButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - <UITableViewDataSource>
extension SettingsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(.value1)
        let settingItem = SettingsViewController.cellItem[safe: indexPath.row]

        cell.backgroundColor = Palette[basic: .clear]
        cell.textLabel?.textColor = Palette[custom: .appColor]
        cell.textLabel?.font = SystemFont[.description]
        cell.accessoryView = ImageView(image: #imageLiteral(resourceName: "disclButton_icon"))
        cell.accessoryView?.tintColor = Palette[custom: .appColor]
        cell.tintColor = Palette[custom: .appColor]
        cell.separatorInset = UIEdgeInsets.zero
        cell.selectionStyle = .gray

        if indexPath.row < SettingsViewController.cellItem.count {
            cell.imageView?.image = settingItem?.image
            cell.textLabel?.text = settingItem?.name
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsViewController.cellItem.count
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
extension SettingsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let controller = SettingsViewController.cellItem[indexPath.row].controller {
            navigationController?.pushViewController(controller, animated: true)
        }
        else {
            KVNProgress.show()
            LogoutCommand().executeCommand { data in
                switch data {
                case let .success(_, _, _, apiResponse: apiResponse):
                    // TODO: @MS
                    switch apiResponse {
                    case .ok:
                        KVNProgress.showSuccess {
                            AccountSessionManager.manager.closeSession()
                            if let window = (UIApplication.shared.delegate as? AppDelegate)?.window {
                                window.rootViewController = LoginViewController()
                            }
                        }
                    case .fail:
                        KVNProgress.showError()
                    }
                case let .failure(message):
                    KVNProgress.showError(withStatus: message.message)
                }
            }
        }
    }
}
