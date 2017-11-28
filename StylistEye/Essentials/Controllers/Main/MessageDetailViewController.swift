//
//  MessageDetailViewController.swift
//  StylistEye
//
//  Created by Michal Severín on 16.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import JSQMessagesViewController
import SnapKit
import UIKit

class MessageDetailViewController: JSQMessagesViewController {

    // MARK: - Properties
    // MARK: > public
    var orderId: Int?
    var isSystem: Bool?
    
    // MARK: > private
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    fileprivate var messages: [JSQMessage] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    fileprivate var dtoMessages: MessagesDTO? {
        didSet {
            guard let msgs = dtoMessages else {
                return
            }
            messages = msgs.messages
                .flatMap { message in
                guard let content = message.content, let author = message.author else {
                    return nil
                }
                return JSQMessage(senderId: String(author.identifier), senderDisplayName: "", date: message.timestamp ?? Date(), text: content)
                }.sorted(by: {$0.date.timeIntervalSince1970 < $1.date.timeIntervalSince1970})
        }
    }

    fileprivate var pagination: PaginationDTO?
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        MessagesDetailCommand(orderId: orderId).executeCommand { data in
            switch data {
            case let .success(object: data, objectsArray: _, pagination: pagination, apiResponse: _):
                self.pagination = pagination
                self.dtoMessages = data
                self.scrollToBottom(animated: true)
            case .failure(message: _, apiResponse: _):
                break
            }
        }
        
        if let isSystem = isSystem, inputToolbar != nil {
            inputToolbar.contentView.leftBarButtonItem = nil
            /*
            2. Message: tady byla asi chyba v logice návrhu. Pokud po zprávě od stylisty přijde klientovi systémová zpráva, nejde již vytvořit zprávu od klienta pro stylistu (nezobrazuje se řádek New Mesage) a komunikace je tak pro klienta zablokována. Nejlepší řešení takové situace by bylo, aby již od první systémové zprávy v rámci celého vlákna se vždy zobrazoval řádek pro odeslání zprávy a všechny klientem vytvořené zprávy byly adresovány stylistovi. Tzn. neřešit logiku neodpovídání na systémové zprávy, ale umožnit vždy vytvořit zprávu a adresovat ji vždy stylistovi.  Jinak každá příchozí systémová zpráva zablokuje komunikaci...
            */
            //inputToolbar.isHidden = isSystem
            
            if isSystem {
            }
        }
    }
    
    // MARK: - Actions
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: Palette[custom: .purple])
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
}

// MARK: - <DataSource>
extension MessageDetailViewController {
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        if let message = messages[safe: indexPath.item] {
            if message.senderId == senderId {
                return outgoingBubbleImageView
            }
            else {
                return incomingBubbleImageView
            }
        }
        return incomingBubbleImageView
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
}

// MARK: - <Delegate>
extension MessageDetailViewController {
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 20
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message: JSQMessage = self.messages[indexPath.item]
        return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
    }

    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        guard let threadId = dtoMessages?.order?.identifier, let orderId = dtoMessages?.order?.identifier else {
            return
        }
        var newMessage: MyMessagesDTO?
        SendMessageCommand(thread: threadId, content: text, orderId: orderId).executeCommand { response in
            switch response {
            case let .success(object: message, objectsArray: _, pagination: _, apiResponse: apiResponse):
                switch apiResponse {
                case .ok:
                    self.inputToolbar.contentView.textView.text = ""
                    
                    newMessage = message
                    if let newMsg = message {
                        self.dtoMessages?.messages.append(newMsg)
                        self.scrollToBottom(animated: true)
                    }
                case .fail:
                    break
                }
            case .failure:
                break
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        if let message = messages[safe: indexPath.item] {
            if message.senderId == senderId {
                cell.textView.textColor = UIColor.white
            }
            else {
                cell.textView.textColor = Palette[custom: .purple]
            }
        }
        return cell
    }
}
