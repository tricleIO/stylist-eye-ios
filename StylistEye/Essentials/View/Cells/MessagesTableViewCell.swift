//
//  MessagesTableViewCell.swift
//  StylistEye
//
//  Created by Michal Severín on 15.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import UIKit

class MessagesTableViewCell: AbstractTableViewCell {

    // MARK: - Properties
    // MARK: < public
    var messageText: String? {
        get {
            return descriptionLabel.text
        }
        set {
            descriptionLabel.text = newValue
        }
    }

    var senderName: String?
    
    var time: Date? {
        get {
            return TimeFormatsEnum.czDate.dateFromString(timeLabel.text)
        }
        set {
            timeLabel.text = TimeFormatsEnum.czDate.stringFromDate(newValue)
        }
    }
    
    var isRead: Bool? {
        didSet {
            notificationImageView.isHidden = isRead ?? false
        }
    }
    
    var isSystemMessage: Bool? {
        didSet {
            guard let isSystemMsg = isSystemMessage else {
                return
            }
            nameLabel.text = isSystemMsg ? "StylistEye" : senderName
        }
    }

    // MARK: < private
    fileprivate let nameLabel = Label()
    fileprivate let descriptionLabel = Label()
    fileprivate let timeLabel = Label()

    fileprivate let disclosureImageView = ImageView()
    fileprivate let stapleImageView = ImageView()
    fileprivate let notificationImageView = ImageView()
    
    fileprivate let userImageView = ImageView(image: #imageLiteral(resourceName: "placeholder"))

    // MARK: - <Initializable>
    internal override func initializeElements() {
        super.initializeElements()

        nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        nameLabel.textColor = Palette[basic: .black]
        
        notificationImageView.contentMode = .scaleAspectFit
        notificationImageView.image = #imageLiteral(resourceName: "unreadMark_image")
        
        userImageView.layer.cornerRadius = 20
        userImageView.contentMode = .scaleAspectFit
        userImageView.clipsToBounds = true

//        stapleImageView.image = #imageLiteral(resourceName: "msg_attachment_image")
//        stapleImageView.contentMode = .scaleAspectFit

        disclosureImageView.image = #imageLiteral(resourceName: "message_disclButton_image")
        disclosureImageView.contentMode = .scaleAspectFit

        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = Palette[basic: .gray]

        timeLabel.textAlignment = .right
        timeLabel.adjustsFontSizeToFitWidth = true

    }

    internal override func addElements() {
        super.addElements()

        contentView.addSubviews(views:
            [
                stapleImageView,
                disclosureImageView,
                timeLabel,
                descriptionLabel,
                nameLabel,
                notificationImageView,
                userImageView,
            ]
        )
    }

    internal override func setupConstraints() {
        super.setupConstraints()
        
        

        notificationImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(50)
            make.top.equalTo(contentView).inset(9)
            make.width.equalTo(10)
            make.height.equalTo(10)
        }

        stapleImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(50)
            make.top.equalTo(notificationImageView.snp.bottom).offset(8)
            make.width.equalTo(10)
            make.height.equalTo(10)
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(notificationImageView.snp.trailing).offset(10)
            make.top.equalTo(contentView).inset(4.7)
            make.trailing.equalTo(timeLabel.snp.leading).inset(10)
            make.height.equalTo(20)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(notificationImageView.snp.trailing).offset(10)
            make.trailing.equalTo(contentView).inset(10)
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
            make.bottom.equalTo(contentView)
        }

        disclosureImageView.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).inset(10)
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.top.equalTo(contentView).inset(10)
        }

        timeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(disclosureImageView.snp.leading).offset(-5)
            make.width.equalTo(80)
            make.top.equalTo(contentView).inset(5)
        }
        
        userImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(15)
            make.top.equalTo(contentView).inset(25)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
    }
}
