//
//  QuestionnaireViewController.swift
//  StylistEye
//
//  Created by Michal Severín on 13.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import UIKit

class QuestionnaireViewController: AbstractViewController {

    // MARK: - Properties
    // MARK: > private
    internal static let cellItem: [CellItem] = [
        CellItem(image: #imageLiteral(resourceName: "cat_image"), name: StringContainer[.cap], controller: QuestionnaireDetailViewController()),
        CellItem(image: #imageLiteral(resourceName: "work_dress_image"), name: StringContainer[.work], controller: QuestionnaireDetailViewController()),
        CellItem(image: #imageLiteral(resourceName: "long_dress_image"), name: StringContainer[.bussiness], controller: QuestionnaireDetailViewController()),
        CellItem(image: #imageLiteral(resourceName: "shoe_image"), name: StringContainer[.shoe], controller: QuestionnaireDetailViewController()),
        CellItem(image: #imageLiteral(resourceName: "earings_image"), name: StringContainer[.earings], controller: QuestionnaireDetailViewController()),
    ]

    fileprivate var tableView = TableView(style: .grouped)

    fileprivate let backgroundImageView = ImageView()

    // MARK: - <Initializable>
    internal override func initializeElements() {
        super.initializeElements()

        backgroundImageView.image = #imageLiteral(resourceName: "whiteBg_image")

        tableView.register(TableViewCellWithImage.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Palette[basic: .clear]
        tableView.isScrollEnabled = false
        tableView.separatorColor =  Palette[custom: .purple]
        tableView.contentInset = UIEdgeInsets(top: -36, left: 0, bottom: 0, right: 0)

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
            make.top.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view)
        }
    }

    override func customInit() {}

    internal override func setupView() {
        super.setupView()

        title = StringContainer[.questionnaire]
        view.backgroundColor = Palette[basic: .white]
    }
}

// MARK: - <UITableViewDataSource>
extension QuestionnaireViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCellWithImage = tableView.dequeueReusableCell()
        let settingItem = QuestionnaireViewController.cellItem[safe: indexPath.row]

        cell.backgroundColor = Palette[basic: .clear]
        cell.textLabel?.textColor = Palette[custom: .purple]
        cell.textLabel?.font = SystemFont[.description]
        cell.tintColor = Palette[custom: .purple]
        cell.accessoryView = ImageView(image: #imageLiteral(resourceName: "disclButton_icon"))
        cell.separatorInset = UIEdgeInsets.zero
        cell.selectionStyle = .gray

        if indexPath.row < QuestionnaireViewController.cellItem.count {
            cell.leftCellImage = settingItem?.image
            cell.labelText = settingItem?.name
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return QuestionnaireViewController.cellItem.count
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
extension QuestionnaireViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let controller = QuestionnaireViewController.cellItem[indexPath.row].controller {
            controller.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
