//
//  MessagesViewController.swift
//  StylistEye
//
//  Created by Michal Severín on 15.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import KVNProgress
import UIKit

class MessagesViewController: AbstractViewController {

    // MARK: - Properties
    // MARK: > private
    fileprivate lazy var backButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow_icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backButtonTapped))

    fileprivate let coverImageView = ImageView()

    fileprivate var tableView = TableView(style: .grouped)

    fileprivate var messagesDTO: MessagesDTO? {
        didSet {
            tableView.reloadData()
        }
    }

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

        tableView.register(MessagesTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = Palette[basic: .clear]
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 0)

        navigationItem.leftBarButtonItem = backButton
    }

    internal override func setupView() {
        super.setupView()

        title = StringContainer[.messages]
        coverImageView.image = #imageLiteral(resourceName: "whiteBg_image")
        view.backgroundColor = Palette[basic: .white]
    }

    internal override func setupConstraints() {
        super.setupConstraints()

        coverImageView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view)
        }
    }

    override func customInit() {
    }

    internal override func loadData() {
        super.loadData()

        loadMessages()
    }

    // MARK: - User Action
    func backButtonTapped() {
        popViewController()
    }

    // MARK: - Actions
    fileprivate func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }

    fileprivate func loadMessages() {
        KVNProgress.show()
        MessagesCommand().executeCommand { data in
            switch data {
            case let .success(data, objectsArray: _, apiResponse: apiResponse):
                // TODO: @MS
                switch apiResponse {
                case .ok:
                    KVNProgress.dismiss()
                    self.messagesDTO = data
                case .fail:
                    KVNProgress.showError(withStatus: "Fail code msgs")
                }
            case .failure:
                KVNProgress.showError()
            }
        }
    }
}

// MARK: - <UITableViewDataSource>
extension MessagesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MessagesTableViewCell = tableView.dequeueReusableCell(.value1)

        cell.backgroundColor = Palette[basic: .clear]

        if let message = messagesDTO?.lastMessages[safe: indexPath.row] {
            cell.subjectText = "Subject"
            cell.messageText = message.content
            if let firstname = message.author?.givenName, let secondname = message.author?.familyName {
                cell.senderName = firstname + secondname
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesDTO?.lastMessages.count ?? 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    @objc(tableView:heightForRowAtIndexPath:)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(GUIConfiguration.MessageCellHeight)
    }
}

// MARK: - <UITableViewDelegate>
extension MessagesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(MessageDetailViewController(), animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
