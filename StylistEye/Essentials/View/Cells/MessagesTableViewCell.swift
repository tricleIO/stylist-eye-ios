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
            return descriptionLabel.text.forcedValue
        }
        set {
            descriptionLabel.text = newValue
        }
    }

    var senderName: String? {
        get {
            return nameLabel.text.forcedValue
        }
        set {
            nameLabel.text = newValue
        }
    }

    var subjectText: String? {
        get {
            return subjectLabel.text.forcedValue
        }
        set {
            subjectLabel.text = newValue
        }
    }

    // MARK: < private
    fileprivate let subjectLabel = Label()
    fileprivate let nameLabel = Label()
    fileprivate let descriptionLabel = Label()
    fileprivate let timeLabel = Label()

    fileprivate let toImageView = ImageView()
    fileprivate let disclosureImageView = ImageView()
    fileprivate let stapleImageView = ImageView()
    fileprivate let notificationImageView = ImageView()

    // MARK: - <Initializable>
    internal override func initializeElements() {
        super.initializeElements()

        notificationImageView.contentMode = .scaleAspectFit
        notificationImageView.image = #imageLiteral(resourceName: "unreadMark_image")

        stapleImageView.image = #imageLiteral(resourceName: "msg_attachment_image")
        stapleImageView.contentMode = .scaleAspectFit

        disclosureImageView.image = #imageLiteral(resourceName: "message_disclButton_image")
        disclosureImageView.contentMode = .scaleAspectFit

        toImageView.image = #imageLiteral(resourceName: "messageMarkTo_image")
        toImageView.contentMode = .scaleAspectFit

        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = Palette[basic: .gray]

        timeLabel.text = "9:30"
        timeLabel.textAlignment = .right

    }

    internal override func addElements() {
        super.addElements()

        contentView.addSubviews(views:
            [
                stapleImageView,
                disclosureImageView,
                toImageView,
                timeLabel,
                descriptionLabel,
                nameLabel,
                subjectLabel,
                notificationImageView,
            ]
        )
    }

    internal override func setupConstraints() {
        super.setupConstraints()

        notificationImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(40)
            make.top.equalTo(contentView).inset(14)
            make.width.equalTo(10)
            make.height.equalTo(10)
        }

        stapleImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(40)
            make.top.equalTo(notificationImageView.snp.bottom).offset(8)
            make.width.equalTo(10)
            make.height.equalTo(10)
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(notificationImageView.snp.trailing).offset(10)
            make.top.equalTo(contentView).inset(10)
            make.trailing.equalTo(timeLabel.snp.leading).inset(10)
            make.height.equalTo(20)
        }

        toImageView.snp.makeConstraints { make in
            make.leading.equalTo(stapleImageView.snp.trailing).offset(10)
            make.top.equalTo(nameLabel.snp.bottom)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }

        subjectLabel.snp.makeConstraints { make in
            make.leading.equalTo(toImageView.snp.trailing).offset(10)
            make.top.equalTo(nameLabel.snp.bottom)
            make.width.equalTo(180)
            make.height.equalTo(20)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(70)
            make.trailing.equalTo(contentView).inset(10)
            make.top.equalTo(subjectLabel.snp.bottom).offset(10)
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
            make.top.equalTo(contentView).inset(10)
        }
    }
}
