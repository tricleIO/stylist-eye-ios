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

    fileprivate var messagesDTO: [MessagesListDTO] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    fileprivate var pagination: PaginationDTO?
    fileprivate var isRefreshing = false

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
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)

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
        let _ = navigationController?.popViewController(animated: true)
    }

    fileprivate func loadMessages(page: Int = 1) {
        KVNProgress.show()
        isRefreshing = true
        MessagesCommand().executeCommand(page: page) { data in
            self.isRefreshing = false
            switch data {
            case let .success(_, objectsArray: data, pagination: pagination, apiResponse: apiResponse):
                // TODO: @MS
                switch apiResponse {
                case .ok:
                    KVNProgress.dismiss()
                    if let messages = data {
                        self.pagination = pagination
                        if pagination?.page == 1 {
                            self.messagesDTO = messages
                        } else {
                            self.messagesDTO = self.messagesDTO + messages
                        }
                    }
                case .fail:
                    KVNProgress.showError(withStatus: StringContainer[.errorOccured])
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

        if let message = messagesDTO[safe: indexPath.row] {
            cell.messageText = message.lastMessage?.content
            cell.time = message.lastMessage?.timestamp
            let lastMessageIsMine = message.counterparty?.identifier == AccountSessionManager.manager.accountSession?.userInfo?.identifier
            cell.isRead = (message.lastMessage?.read ?? false) || lastMessageIsMine
            if let firstname = message.counterparty?.givenName, let secondname = message.counterparty?.familyName {
                cell.senderName = firstname + String.space + secondname
            }
            cell.isSystemMessage = message.lastMessage?.systemOriginate
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesDTO.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    @objc(tableView:heightForRowAtIndexPath:)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GUIConfiguration.MessageCellHeight
    }
}

// MARK: - <UITableViewDelegate>
extension MessagesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let msgDetail = MessageDetailViewController()
        if let threadId = messagesDTO[safe: indexPath.row]?.order?.identifier,
            let isSelectedMessageRead = messagesDTO[safe: indexPath.row]?.lastMessage?.read, !isSelectedMessageRead {
            
            self.messagesDTO[indexPath.row].lastMessage?.read = true
            UpdateMessageThreadStatusCommand(threadId: threadId).executeCommand(completion: { response in
                switch response {
                case let .success(object: _, objectsArray: _, pagination: _, apiResponse: apiResponse):
                    switch apiResponse {
                    case .ok:
                        fallthrough
                    case .fail:
                        break // TODO
                    }
                case let .failure(message: errorMessage, apiResponse: _):
                    break // TODO
                }
            })
        }
        print(messagesDTO[safe: indexPath.row]?.lastMessage?.systemOriginate)
        msgDetail.isSystem = messagesDTO[safe: indexPath.row]?.lastMessage?.systemOriginate
        msgDetail.orderId = messagesDTO[safe: indexPath.row]?.order?.identifier
        
        if let userId = AccountSessionManager.manager.accountSession?.userInfo?.identifier {
            msgDetail.senderId = String(userId)
        } else {
            msgDetail.senderId = "99"
        }
        msgDetail.senderDisplayName = "\(AccountSessionManager.manager.accountSession?.userInfo?.firstname) \(AccountSessionManager.manager.accountSession?.userInfo?.surname)"
        
        
        
//        if let mesg = messagesDTO[safe: indexPath.row], let author = mesg.lastMessage?.author {
//            let firstname = author.givenName ?? ""
//            let familyname = author.familyName ?? ""
//            let authorName = firstname + String.space + familyname
//            msgDetail.senderId = String(author.identifier)
//            msgDetail.senderDisplayName = authorName
//        }
//        else {
//            msgDetail.senderId = "99" // TODO: ???
//            msgDetail.senderDisplayName = String.empty
//        }
        navigationController?.pushViewController(msgDetail, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let pagination = pagination, let currentPage = pagination.page {
            if scrollView.isAtBottom() && !isRefreshing && currentPage < pagination.totalPages {
                self.loadMessages(page: currentPage+1)
            }
        }
    }
}
