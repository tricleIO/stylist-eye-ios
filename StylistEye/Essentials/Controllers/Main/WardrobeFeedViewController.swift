//
//  OutfitViewController.swift
//  StylistEye
//
//  Created by Michal Severín on 13.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import SnapKit
import UIKit

class WardrobeFeedViewController: AbstractViewController {

    // MARK: - Properties
    // MARK: > private
    fileprivate lazy var backButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow_icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backButtonTapped))

    fileprivate var tableView = TableView(style: .grouped)

    fileprivate let backgroundImageView = ImageView()
    fileprivate let cameraImageView = ImageView()

    fileprivate let actionView = View()

    // MARK: - <Initializable>
    internal override func initializeElements() {
        super.initializeElements()

        backgroundImageView.image = #imageLiteral(resourceName: "purpleBg_image")

        cameraImageView.image = #imageLiteral(resourceName: "camera_icon")
        cameraImageView.contentMode = .scaleAspectFit
        cameraImageView.isUserInteractionEnabled = true
        cameraImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cameraImageViewTapped)))

        actionView.backgroundColor = Palette[custom: .purple]

        tableView.register(OutfitTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = Palette[basic: .clear]
        tableView.separatorColor =  Palette[basic: .clear]

        navigationItem.leftBarButtonItem = backButton
    }

    internal override func addElements() {
        super.addElements()

        view.addSubviews(views:
            [
                backgroundImageView,
                tableView,
                actionView,
            ]
        )

        actionView.addSubview(cameraImageView)
    }

    internal override func setupConstraints() {
        super.setupConstraints()

        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }

        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }

        actionView.snp.makeConstraints { make in
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.height.equalTo(40)
            make.bottom.equalTo(view)
        }

        cameraImageView.snp.makeConstraints { make in
            make.centerX.equalTo(actionView)
            make.centerY.equalTo(actionView)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
    }

    internal override func setupView() {
        super.setupView()

        title = StringContainer[.outfit]
        view.backgroundColor = Palette[basic: .white]
    }

    override func customInit() {}

    // MARK: - User Action
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    func cameraImageViewTapped() {
        openCamera()
    }

    // MARK: - Actions
    fileprivate func openCamera() {
        let navController = UINavigationController(rootViewController: CameraViewController())
        navController.navigationBar.applyStyle(style: .solid(withStatusBarColor: Palette[custom: .purple]))
        present(navController, animated: true, completion: nil)
    }
}

// MARK: - <UITableViewDataSource>
extension WardrobeFeedViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OutfitTableViewCell = tableView.dequeueReusableCell()

        cell.backgroundColor = Palette[basic: .clear]
        cell.stylistNameText = "Michal Severín"
        cell.descriptionText = "A -sd fkalsdoih nf kalfh aiosdf hsdanf asidufh sdjf nalsdjhf iusadbf sdfjk safkjashkjfh askdfh ksahfhas iuvsavamsvlakj."
        cell.selectionStyle = .none

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
        return CGFloat(GUIConfiguration.OutfitCellHeight)
    }
}

// MARK: - <UITableViewDelegate>
extension WardrobeFeedViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let productVC = ProductDetailViewController()
        productVC.productInfo = ProductInfo(name: "Kalhoty velice krásné", infoText: "A aksdfn asjkf oas kanfk jasdf sdf knsfk nasdkjfn jads adsf kasdnf nsdanf kasdf nasdf asdnf asdn jasnf kas.")
        productVC.title = "Kalhoty velice krásné"
        productVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(productVC, animated: true)
    }
}
