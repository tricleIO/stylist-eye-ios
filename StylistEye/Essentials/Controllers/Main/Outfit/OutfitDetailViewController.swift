//
//  OutfitDetailViewController.swift
//  StylistEye
//
//  Created by Michal Severín on 16.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import KVNProgress
import SnapKit
import UIKit

class OutfitDetailViewController: AbstractViewController {

    // MARK: - Properties
    // MARK: < public
    var mainImageview = ImageView()
    var outfitId: Int? {
        didSet {
            getOutfitDetailInfo(outfitId: outfitId)
        }
    }

    // MARK: < private
    fileprivate let productNameLabel = Label()
    fileprivate let productDescriptionLabel = Label()

    fileprivate lazy var backButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow_icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backButtonTapped))

    fileprivate var tableView = TableView(style: .grouped)

    fileprivate var outfitTableData: OutfitDetailDTO? {
        didSet {
            stylistDefinition()
            tableView.reloadData()
        }
    }

    fileprivate let stylistInfoBox = View()

    fileprivate let stylistProfileImageView = ImageView()

    fileprivate let stylistNameLabel = Label()
    fileprivate let stylistDescriptionLabel = Label()
    fileprivate let outfitNameLabel = Label()
    fileprivate let dressStyleLabel = Label()
    fileprivate let outfitDescriptionLabel = Label()

    // MARK: - <Initializable>
    internal override func initializeElements() {
        super.initializeElements()

        tableView.register(OutfitDetailTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = Palette[basic: .clear]
        tableView.backgroundColor = Palette[basic: .clear]

        navigationItem.leftBarButtonItem = backButton

        productDescriptionLabel.textColor = Palette[basic: .white]
        productDescriptionLabel.font = SystemFont[.litleDescription]
        productDescriptionLabel.numberOfLines = 0

        productNameLabel.textColor = Palette[custom: .appColor]
        productNameLabel.font = SystemFont[.description]

        mainImageview.image = #imageLiteral(resourceName: "background_image")

        stylistInfoBox.backgroundColor = Palette[basic: .white].withAlphaComponent(0.2)
        stylistInfoBox.layer.borderColor = Palette[custom: .appColor].cgColor
        stylistInfoBox.layer.borderWidth = 1
    }

    internal override func addElements() {
        super.addElements()

        view.addSubviews(views:
            [
                mainImageview,
                productDescriptionLabel,
                productNameLabel,
                tableView,
                stylistInfoBox,
                stylistProfileImageView,
                stylistNameLabel,
                stylistDescriptionLabel,
                outfitNameLabel,
                outfitDescriptionLabel,
                dressStyleLabel,
            ]
        )
    }

    internal override func setupConstraints() {
        super.setupConstraints()

        mainImageview.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }

        productDescriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(10)
            make.trailing.equalTo(view).inset(10)
            make.bottom.equalTo(view).inset(60)
        }

        productNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(10)
            make.trailing.equalTo(view).inset(10)
            make.bottom.equalTo(productDescriptionLabel.snp.top)
        }

        stylistInfoBox.snp.makeConstraints { make in
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.height.equalTo(180)
            make.top.equalTo(view)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(stylistInfoBox.snp.bottom)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view)
        }

        stylistProfileImageView.snp.makeConstraints { make in
            make.leading.equalTo(stylistInfoBox).inset(5)
            make.top.equalTo(stylistInfoBox).inset(5)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }

        stylistNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(stylistProfileImageView.snp.trailing).offset(5)
            make.trailing.equalTo(stylistInfoBox).inset(5)
            make.top.equalTo(stylistInfoBox).inset(5)
            make.height.equalTo(20)
        }

        stylistDescriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(stylistProfileImageView.snp.trailing).offset(5)
            make.trailing.equalTo(stylistInfoBox).inset(5)
            make.height.equalTo(20)
            make.top.equalTo(stylistNameLabel.snp.bottom).offset(5)
        }

        outfitNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(stylistProfileImageView.snp.trailing).offset(5)
            make.trailing.equalTo(stylistInfoBox).inset(5)
            make.height.equalTo(20)
            make.top.equalTo(stylistDescriptionLabel.snp.bottom).offset(5)
        }

        dressStyleLabel.snp.makeConstraints { make in
            make.leading.equalTo(stylistProfileImageView.snp.trailing).offset(5)
            make.trailing.equalTo(stylistInfoBox).inset(5)
            make.height.equalTo(20)
            make.top.equalTo(outfitNameLabel.snp.bottom).offset(5)
        }

        outfitDescriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(stylistProfileImageView.snp.trailing).offset(5)
            make.trailing.equalTo(stylistInfoBox).inset(5)
            make.height.equalTo(20)
            make.top.equalTo(dressStyleLabel.snp.bottom).offset(5)
        }

    }

    internal override func setupView() {
        super.setupView()

        view.backgroundColor = Palette[basic: .white]
    }

    // MARK: - User Action
    func backButtonTapped() {
        let _ = navigationController?.popViewController(animated: true)
    }

    // MARK: - Actions
    fileprivate func getOutfitDetailInfo(outfitId: Int?) {
        guard let outfitId = outfitId else {
            return
        }
        KVNProgress.show()
        OutfitDetailCommand(outfitId: outfitId).executeCommand { data in
            switch data {
            case let .success(data, objectsArray: _, apiResponse: apiResponse):
                // TODO: @MS
                switch apiResponse {
                case .ok:
                    KVNProgress.dismiss()
                    self.outfitTableData = data
                case .fail:
                    KVNProgress.showError(withStatus: "Fail code - outfit detail")
                }
            case let .failure(message):
                KVNProgress.showError(withStatus: message.message)
            }
        }
    }

    fileprivate func stylistDefinition() {

        stylistProfileImageView.image = #imageLiteral(resourceName: "placeholder")
        stylistProfileImageView.layer.cornerRadius = 20
        stylistProfileImageView.contentMode = .scaleToFill
        stylistProfileImageView.clipsToBounds = true
        
        
        if let stylist = outfitTableData?.stylist {
            if let stylistName = stylist.givenName, let familyName = stylist.familyName {
                stylistNameLabel.text = stylistName + String.space + familyName
            }
            stylistDescriptionLabel.text = "stylist description"
        }

        stylistNameLabel.font = SystemFont[.title]
        stylistNameLabel.textColor = Palette[custom: .appColor]

        stylistDescriptionLabel.font = SystemFont[.description]
        stylistDescriptionLabel.textColor = Palette[custom: .appColor]

        outfitNameLabel.text = "Outfit name"
        outfitNameLabel.textColor = Palette[custom: .appColor]

        dressStyleLabel.text = outfitTableData?.dressStyle?.name
        dressStyleLabel.textColor = Palette[custom: .appColor]

        outfitDescriptionLabel.text = outfitTableData?.comment
        outfitDescriptionLabel.textColor = Palette[custom: .appColor]
        outfitDescriptionLabel.numberOfLines = 0
    }
}

// MARK: - <UITableViewDataSource>
extension OutfitDetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OutfitDetailTableViewCell = tableView.dequeueReusableCell(.value1)

        cell.backgroundColor = Palette[basic: .clear]
        
        if let components = outfitTableData?.components[safe: indexPath.row] {
            cell.labelText = components.garmetType?.name
            cell.mainImageString = components.photo?.image
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return outfitTableData?.components.count ?? 0
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
extension OutfitDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

