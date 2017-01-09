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
            for message in msgs.messages {
                if let content = message.content {
                    if let author = message.author {
                        let jsqMessge: JSQMessage = JSQMessage(senderId: String(author.identifier), senderDisplayName: "", date: message.timestamp ?? Date(), text: content)
                        messages.append(jsqMessge)
                    }
                }
            }
        }
    }

    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        MessagesDetailCommand(orderId: orderId).executeCommand { data in
            switch data {
            case let .success(object: data, objectsArray: _, apiResponse: _):
                self.dtoMessages = data
            case .failure(message: _, apiResponse: _):
                break
            }
        }
        
        self.inputToolbar.contentView.leftBarButtonItem = nil
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
}
