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

class RatingView: View {
    
    // MARK: - Properties
    var rating: Int? {
        didSet {
            guard let rating = rating, rating <= 5 else {
                return
            }
            var firstStartImageView: ImageView?
            var cycle: Int = 0
            for _ in 0 ..< 5 {
                cycle += 1
                let starImageView: ImageView
                if cycle <= rating {
                    starImageView = ImageView(image: #imageLiteral(resourceName: "fullStar"))
                }
                else {
                    starImageView = ImageView(image: #imageLiteral(resourceName: "emptyStar"))
                }
                starImageView.contentMode = .scaleAspectFit
                addSubview(starImageView)
                if let firstStartImageView = firstStartImageView {
                    starImageView.snp.makeConstraints { make in
                        make.leading.equalTo(firstStartImageView.snp.trailing).offset(5)
                        make.height.equalTo(15)
                        make.width.equalTo(15)
                        make.top.equalTo(self)
                    }
                }
                else {
                    starImageView.snp.makeConstraints { make in
                        make.leading.equalTo(self)
                        make.height.equalTo(15)
                        make.width.equalTo(15)
                        make.top.equalTo(self)
                    }
                }
                firstStartImageView = starImageView
            }
        }
    }
}


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
            if let image = outfitTableData?.stylist?.photo?.image, let imageUrl = URL(string: image) {
                stylistProfileImageView.kf.setImage(with: imageUrl)
            }
            ratingView.rating = 3
            outfitDescriptionLabel.text = outfitTableData?.comment
            dressStyleLabel.text = outfitTableData?.dressStyle?.name
            tableView.reloadData()
        }
    }

    fileprivate let stylistInfoBox = View(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 180))

    fileprivate let stylistProfileImageView = ImageView()

    fileprivate let ratingView = RatingView()
    
    fileprivate let stylistNameLabel = Label()
    fileprivate let stylistDescriptionLabel = Label()
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
        tableView.tableHeaderView = stylistInfoBox
        tableView.sectionHeaderHeight = 180

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
            ]
        )
        
        stylistInfoBox.addSubviews(views:
            [
                stylistProfileImageView,
                stylistNameLabel,
                stylistDescriptionLabel,
                outfitDescriptionLabel,
                dressStyleLabel,
                ratingView,
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
    
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view)
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

        dressStyleLabel.snp.makeConstraints { make in
            make.leading.equalTo(stylistProfileImageView.snp.trailing).offset(5)
            make.trailing.equalTo(stylistInfoBox).inset(5)
            make.height.equalTo(20)
            make.top.equalTo(outfitDescriptionLabel.snp.bottom).offset(5)
        }
        
        ratingView.snp.makeConstraints { make in
            make.leading.equalTo(stylistProfileImageView.snp.trailing).offset(5)
            make.trailing.equalTo(stylistInfoBox).inset(5)
            make.height.equalTo(30)
            make.top.equalTo(stylistDescriptionLabel.snp.bottom).offset(5)
        }

        outfitDescriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(stylistProfileImageView.snp.trailing).offset(5)
            make.trailing.equalTo(stylistInfoBox).inset(5)
            make.height.equalTo(20)
            make.top.equalTo(ratingView.snp.bottom).offset(5)
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
            case let .success(data, objectsArray: _, pagination: _, apiResponse: apiResponse):
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

        dressStyleLabel.text = outfitTableData?.dressStyle?.name
        dressStyleLabel.textColor = Palette[custom: .appColor]

        outfitDescriptionLabel.text = outfitTableData?.comment
        outfitDescriptionLabel.textColor = Palette[custom: .appColor]
        outfitDescriptionLabel.numberOfLines = 0
    }
    
    fileprivate func openCamera() {
        guard let outfitId = outfitId else {
            return
        }
        
        let cameraController = CameraViewController()
        cameraController.imagePicked = {
            image in
            
            let imageJpeg = image.jpegData()
            let uploadCommand = UploadOutfitPhotoCommand(id: outfitId, photoType: .OutfitPhotoBase, photo: imageJpeg)
            
            KVNProgress.show()
            uploadCommand.executeCommand {
                data in
                
                switch data {
                case let .success(_, objectsArray: _, _, apiResponse: apiResponse):
                    // TODO: @MS
                    switch apiResponse {
                    case .ok:
                        KVNProgress.showSuccess()
                        self.getOutfitDetailInfo(outfitId: outfitId)
                    case .fail:
                        KVNProgress.showError(withStatus: "Upload failed")
                    }
                case let .failure(message):
                    KVNProgress.showError(withStatus: message.message)
                }
            }
        }
        let navController = UINavigationController(rootViewController: cameraController)
        navController.navigationBar.applyStyle(style: .solid(withStatusBarColor: Palette[custom: .purple]))
        present(navController, animated: true, completion: nil)
    }
}

// MARK: - <UITableViewDataSource>
extension OutfitDetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: OutfitDetailTableViewCell = tableView.dequeueReusableCell(.value1)
        
        cell.backgroundColor = Palette[basic: .clear]
      
        let row = indexPath.row
        if row == 0 {
            
            cell.labelText = StringContainer[.outfitOverview]
            
            // if have user provided foto, use it
            if let photo = outfitTableData?.photos.first {
                cell.mainImageString = photo.image
            } else {
                // otherwise, use collection of compoments
                cell.mosaicImages = outfitTableData?.components.flatMap {$0.photo?.image}
            }
            
            return cell
            
        } else {
            
            if let components = outfitTableData?.components[safe: indexPath.row-1] {
                cell.labelText = components.garmetType?.name
                cell.mainImageString = components.photo?.image
            }
            
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = outfitTableData?.components.count {
            return count + 1
        } else {
            return 0
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    @objc(tableView:heightForRowAtIndexPath:)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

// MARK: - <UITableViewDelegate>
extension OutfitDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            openCamera()
        }
    }
}

