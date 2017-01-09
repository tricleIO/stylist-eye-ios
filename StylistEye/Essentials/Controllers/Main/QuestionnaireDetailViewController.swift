//
//  QuestionnaireDetailViewController.swift
//  StylistEye
//
//  Created by Michal Severín on 17.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import KVNProgress
import SnapKit
import UIKit

class QuestionnaireDetailViewController: AbstractViewController {

    // MARK: - Properties
    // MARK: < private
    fileprivate lazy var backButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow_icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backButtonTapped))

    fileprivate var tableView = TableView(style: .grouped)

    fileprivate let photoBox = View()

    fileprivate let mainImageview = ImageView()

    // MARK: - <Initializable>
    internal override func initializeElements() {
        super.initializeElements()

        tableView.register(QuestionnaireTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = Palette[basic: .clear]
        tableView.backgroundColor = Palette[basic: .clear]

        navigationItem.leftBarButtonItem = backButton

        mainImageview.image = #imageLiteral(resourceName: "background_image")

        photoBox.backgroundColor = Palette[basic: .white].withAlphaComponent(0.2)
        photoBox.layer.borderColor = Palette[custom: .appColor].cgColor
        photoBox.layer.borderWidth = 1
    }

    internal override func addElements() {
        super.addElements()

        view.addSubviews(views:
            [
                mainImageview,
                tableView,
//                photoBox,
            ]
        )
    }

    internal override func setupConstraints() {
        super.setupConstraints()

        mainImageview.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }

//        photoBox.snp.makeConstraints { make in
//            make.leading.equalTo(view)
//            make.trailing.equalTo(view)
//            make.top.equalTo(view)
//            make.height.equalTo(85)
//        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view)
        }
    }

    internal override func setupView() {
        super.setupView()

        view.backgroundColor = Palette[basic: .white]
    }

    // MARK: - User Action
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}


// MARK: - <UITableViewDataSource>
extension QuestionnaireDetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: QuestionnaireTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)

        cell.backgroundColor = Palette[basic: .clear]
        cell.mainImage = #imageLiteral(resourceName: "placeholder")
        cell.descriptionText = "Aasdf sdf alskdnf lasdnf lasnflnaslfn lasnfl asdlf aslfn asldknf lksadnfksdanf lsda."

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    @objc(tableView:heightForRowAtIndexPath:)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GUIConfiguration.OutfitCellHeight
    }
}

// MARK: - <UITableViewDelegate>
extension QuestionnaireDetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
