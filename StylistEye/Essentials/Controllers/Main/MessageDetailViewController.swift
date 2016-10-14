//
//  MessageDetailViewController.swift
//  StylistEye
//
//  Created by Michal Severín on 16.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import SnapKit
import UIKit

class MessageDetailViewController: AbstractViewController {

    // MARK: - Properties
    // MARK: > private
    fileprivate lazy var backButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow_icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backButtonTapped))

    fileprivate let scrollView = ScrollView()

    fileprivate let coverImageView = ImageView()
    fileprivate let toImageView = ImageView()
    fileprivate let stapleImageView = ImageView()
    fileprivate let notificationImageView = ImageView()

    fileprivate let footerView = View()

    fileprivate let subjectLabel = Label()
    fileprivate let nameLabel = Label()
    fileprivate let descriptionLabel = Label()
    fileprivate let timeLabel = Label()

    // MARK: - <Initializable>
    internal override func addElements() {
        super.addElements()

        view.addSubviews(views:
            [
                coverImageView,
                scrollView,
            ]
        )

        scrollView.addSubviews(views:
            [
                stapleImageView,
                toImageView,
                timeLabel,
                descriptionLabel,
                nameLabel,
                subjectLabel,
                notificationImageView,
                footerView,
            ]
        )
    }

    internal override func initializeElements() {
        super.initializeElements()

        notificationImageView.contentMode = .scaleAspectFit
        notificationImageView.image = #imageLiteral(resourceName: "unreadMark_image")

        stapleImageView.image = #imageLiteral(resourceName: "msg_attachment_image")
        stapleImageView.contentMode = .scaleAspectFit

        toImageView.image = #imageLiteral(resourceName: "messageMarkTo_image")
        toImageView.contentMode = .scaleAspectFit

        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = "ASDFm lasknfklnkdsn fkajsnf kajsnf kasnfkjn kdns kfnask fnks nfs nfksan fksan fksan fkasn fkasn fkans fknsafknsak fnsakn fksan f asndf kasnf ksanfk ansfkjn askjf naksnf aksnf aks fa."
        descriptionLabel.textColor = Palette[basic: .gray]

        nameLabel.text = "Text label"

        subjectLabel.text = "Subject label"

        timeLabel.text = "9:30"
        timeLabel.textAlignment = .right

        footerView.backgroundColor = Palette[custom: .purple]
    }

    internal override func setupView() {
        super.setupView()

        title = StringContainer[.messages]
        coverImageView.image = #imageLiteral(resourceName: "whiteBg_image")
        view.backgroundColor = Palette[basic: .white]

        navigationItem.leftBarButtonItem = backButton
    }

    internal override func setupConstraints() {
        super.setupConstraints()

        footerView.snp.makeConstraints { make in
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.height.equalTo(40)
            make.bottom.equalTo(view)
        }

        coverImageView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }

        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }

        notificationImageView.snp.makeConstraints { make in
            make.leading.equalTo(scrollView).inset(20)
            make.top.equalTo(scrollView).inset(14)
            make.width.equalTo(10)
            make.height.equalTo(10)
        }

        stapleImageView.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(20)
            make.top.equalTo(notificationImageView.snp.bottom).offset(8)
            make.width.equalTo(10)
            make.height.equalTo(10)
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(notificationImageView.snp.trailing).offset(10)
            make.top.equalTo(scrollView).inset(10)
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
            make.leading.equalTo(view).inset(70)
            make.trailing.equalTo(view).inset(10)
            make.top.equalTo(subjectLabel.snp.bottom).offset(10)
            make.bottom.equalTo(scrollView)
        }

        timeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(view).inset(10)
            make.width.equalTo(60)
            make.height.equalTo(30)
            make.top.equalTo(scrollView).inset(10)
        }
    }

    // MARK: - User Action
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
