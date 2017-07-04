//
//  LanguagesViewController.swift
//  StylistEye
//
//  Created by Michal Severín on 14.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import UIKit

class LanguagesViewController: AbstractViewController {

    // MARK: - Properties
    // MARK: > private
    fileprivate lazy var backButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow_icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backButtonTapped))

    fileprivate let coverImageView = ImageView()

    internal static let cellItem: [CellItem] = [
        CellItem(image: nil, name: StringContainer[.english], controller: nil),
//        CellItem(image: nil, name: StringContainer[.fransais], controller: nil),
//        CellItem(image: nil, name: StringContainer[.deutch], controller: nil),
//        CellItem(image: nil, name: StringContainer[.cestina], controller: nil),
//        CellItem(image: nil, name: StringContainer[.italy], controller: nil),
    ]

    internal var selected: [Bool] = [
        false,
        false,
        false,
        false,
        false,
    ]

    fileprivate var tableView = TableView(frame: CGRect.zero, style: .grouped)

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
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = Palette[basic: .clear]
        tableView.isScrollEnabled = false
        tableView.separatorColor =  Palette[custom: .appColor]

        navigationItem.leftBarButtonItem = backButton
    }

    internal override func setupView() {
        super.setupView()

        title = StringContainer[.languages]
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

    // MARK: - User Action
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - <UITableViewDataSource>
extension LanguagesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(.value1)
        let settingItem = LanguagesViewController.cellItem[indexPath.row]

        cell.backgroundColor = Palette[basic: .clear]
        cell.textLabel?.textColor = Palette[custom: .appColor]
        cell.textLabel?.font = SystemFont[.description]
        cell.accessoryView?.tintColor = Palette[custom: .appColor]
        cell.tintColor = Palette[custom: .appColor]
        cell.separatorInset = UIEdgeInsets.zero
        cell.selectionStyle = .gray

        if indexPath.row < LanguagesViewController.cellItem.count {
            cell.imageView?.image = settingItem.image
            cell.textLabel?.text = settingItem.name
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LanguagesViewController.cellItem.count
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
extension LanguagesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            selected[indexPath.row] = !selected[indexPath.row]
            if selected[indexPath.row] {
                cell.accessoryType = .checkmark
            }
            else {
                cell.accessoryType = .none
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
