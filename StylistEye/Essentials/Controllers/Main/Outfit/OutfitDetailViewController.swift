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
            if let image = outfitTableData?.stylist?.photo?.image, let imageUrl = URL(string: image) {
                stylistProfileImageView.kf.setImage(with: imageUrl)
            }
            ratingView.rating = outfitTableData?.stylist?.rating ?? 0
            outfitDescriptionLabel.text = outfitTableData?.comment
            dressStyleLabel.text = outfitTableData?.dressStyle?.name
            tableView.reloadData()
        }
    }

    fileprivate let stylistInfoBox = View(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 180))

    fileprivate let stylistProfileImageView = ImageView()

    fileprivate let ratingView = RatingView()
    
    fileprivate let stylistNameLabel = Label()
    //fileprivate let stylistDescriptionLabel = Label()
    fileprivate let dressStyleLabel = Label()
    fileprivate let outfitDescriptionLabel = Label()
    
    fileprivate var componentsCount: Int {
        if let count = outfitTableData?.components.count {
            return count
        } else {
            return 0
        }
    }
    
    fileprivate var outfitCellsCount: Int {
        if let count = outfitTableData?.photos.count {
            let count = min(count, 3) // show max 3 photos
            return max(count, 1) // if no photos, show placeholder
        } else {
            return 1 // placeholder
        }
    }
    
    fileprivate var toolbar = UIToolbar()

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
        
        toolbar.barTintColor = Palette[custom: .purple]
    }

    internal override func addElements() {
        super.addElements()

        view.addSubviews(views:
            [
                mainImageview,
                productDescriptionLabel,
                productNameLabel,
                tableView,
                toolbar,
            ]
        )
        
        stylistInfoBox.addSubviews(views:
            [
                stylistProfileImageView,
                stylistNameLabel,
                //stylistDescriptionLabel,
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

        /*
        stylistDescriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(stylistProfileImageView.snp.trailing).offset(5)
            make.trailing.equalTo(stylistInfoBox).inset(5)
            make.height.equalTo(20)
            make.top.equalTo(stylistNameLabel.snp.bottom).offset(5)
        }
        */
        
        ratingView.snp.makeConstraints { make in
            make.leading.equalTo(stylistProfileImageView.snp.trailing).offset(5)
            make.trailing.equalTo(stylistInfoBox).inset(5)
            make.height.equalTo(20)
            make.top.equalTo(stylistNameLabel.snp.bottom).offset(5)
        }

        outfitDescriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(stylistProfileImageView.snp.trailing).offset(5)
            make.trailing.equalTo(stylistInfoBox).inset(5)
            make.top.equalTo(ratingView.snp.bottom).offset(5)
        }
        
        dressStyleLabel.snp.makeConstraints { make in
            make.leading.equalTo(stylistProfileImageView.snp.trailing).offset(5)
            make.trailing.equalTo(stylistInfoBox).inset(5)
            make.height.equalTo(20)
            make.top.equalTo(outfitDescriptionLabel.snp.bottom).offset(5)
            make.bottom.equalTo(stylistInfoBox).inset(5)
        }

        toolbar.snp.makeConstraints { make in
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
                    self.configureToolbar()
                case .fail:
                    KVNProgress.showError(withStatus: StringContainer[.errorOccured])
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
                if let place = stylist.address?.country {
                    stylistNameLabel.text = "\(stylistName) \(familyName), \(place)"
                } else {
                    stylistNameLabel.text = "\(stylistName) \(familyName)"
                }
                
            }
            //stylistDescriptionLabel.text = "stylist description"
        }

        stylistNameLabel.font = SystemFont[.title]
        stylistNameLabel.textColor = Palette[custom: .appColor]

        //stylistDescriptionLabel.font = SystemFont[.description]
        //stylistDescriptionLabel.textColor = Palette[custom: .appColor]

        dressStyleLabel.text = outfitTableData?.dressStyle?.name
        dressStyleLabel.textColor = Palette[custom: .appColor]

        outfitDescriptionLabel.text = outfitTableData?.comment
        outfitDescriptionLabel.textColor = Palette[custom: .appColor]
        outfitDescriptionLabel.numberOfLines = 0
    }
    
    fileprivate func openCamera(photoType: PhotoType) {
        guard let outfitId = outfitId else {
            return
        }
        
        let cameraController = CameraViewController()
        cameraController.imagePicked = {
            image in
            
            let imageJpeg = image.jpegData()
            let uploadCommand = UploadOutfitPhotoCommand(id: outfitId, photoType: photoType, image: image, imageData: imageJpeg)
            
            UploadQueueManager.main.push(item: uploadCommand)
            
//            KVNProgress.show()
//            uploadCommand.executeCommand {
//                data in
//                
//                switch data {
//                case let .success(_, objectsArray: _, _, apiResponse: apiResponse):
//                    // TODO: @MS
//                    switch apiResponse {
//                    case .ok:
//                        KVNProgress.showSuccess()
//                        self.getOutfitDetailInfo(outfitId: outfitId)
//                    case .fail:
//                        KVNProgress.showError(withStatus: "Upload failed")
//                    }
//                case let .failure(message):
//                    KVNProgress.showError(withStatus: message.message)
//                }
//            }
        }
        let navController = UINavigationController(rootViewController: cameraController)
        navController.navigationBar.applyStyle(style: .solid(withStatusBarColor: Palette[custom: .purple]))
        present(navController, animated: true, completion: nil)
    }
    
    fileprivate func configureToolbar() {
        switch outfitTableData?.photos.count ?? 0 {
        case 0:
            let filler1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let filler2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let image = UIImageView(image: #imageLiteral(resourceName: "camera_icon"))
            image.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            image.contentMode = .scaleAspectFit
            image.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(addFirstPhotoTapped))
            image.addGestureRecognizer(tap)
            let button = UIBarButtonItem(customView: image)
            toolbar.items = [filler1, button, filler2]
            toolbar.isHidden = false
        case 1,2:
            let filler1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let filler2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let image = UIImageView(image: #imageLiteral(resourceName: "cmeraPlus_icon"))
            image.contentMode = .scaleAspectFit
            image.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(addMorePhotosTapped))
            image.addGestureRecognizer(tap)
            image.snp.makeConstraints { make in
                make.width.equalTo(30)
                make.height.equalTo(30)
            }
            let button = UIBarButtonItem(customView: image)
            toolbar.items = [filler1, button, filler2]
            toolbar.isHidden = false
        default:
            toolbar.isHidden = true
        }
    }
    
    func addFirstPhotoTapped() {
        openCamera(photoType: .OutfitPhotoBase)
    }
    
    func addMorePhotosTapped() {
        openCamera(photoType: .OtherOutfitPhoto)
    }
}

// MARK: - <UITableViewDataSource>
extension OutfitDetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: OutfitDetailTableViewCell = tableView.dequeueReusableCell(.value1)
        
        cell.backgroundColor = Palette[basic: .clear]
        cell.delegate = self
      
        let row = indexPath.row
        if row < outfitCellsCount {
            
            cell.zoomButton(shown: true)
            
            if row == 0 {
                cell.labelText = StringContainer[.outfitOverview]
            } else {
                cell.labelText = ""
            }
            
            // if have user provided foto, use it
            if let photo = outfitTableData?.photos[safe: row] {
                cell.mainImageString = photo.image
            } else {
                // do we have upload in progress?
                
                guard let outfitId = outfitId else {
                    return cell
                }
                
                let placeholders = UploadQueueManager.main.placeholders(type: .outfits, category: outfitId)
                
                if placeholders.count > 0 {
                    cell.mainImagePlaceholder = placeholders[0].image
                }
                
                // otherwise, use collection of compoments
                cell.showPlaceholder()
            }
            
            return cell
            
        } else {
            
            cell.zoomButton(shown: false)
            
            if let components = outfitTableData?.components[safe: indexPath.row-outfitCellsCount] {
                cell.labelText = components.garmetType?.name
                cell.mainImageString = components.photo?.image
            }
            
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return outfitCellsCount + componentsCount
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    @objc(tableView:heightForRowAtIndexPath:)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
}

// MARK: - <UITableViewDelegate>
extension OutfitDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 && (outfitTableData?.photos.count ?? 0) == 0 {
            // placeholder - take photo
            openCamera(photoType: .OutfitPhotoBase)
        } else {
            // existing photo - show detail
            let cell = tableView.cellForRow(at: indexPath) as! OutfitDetailTableViewCell
            zoomTapped(cell: cell)
        }
    }
}

extension OutfitDetailViewController: OutfitDetailCellDelegateProtocol {
    
    func zoomTapped(cell: OutfitDetailTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell), let data = outfitTableData else {
            return
        }
        
        let detail = PhotoDetailViewController()
        detail.delegate = self
        
        if indexPath.row < outfitCellsCount {
            detail.imageUrl = data.photos[safe: indexPath.row]?.image?.urlValue
            detail.imageId = data.photos[safe: indexPath.row]?.id
            detail.isDeleteButtonShown = true
        } else {
            let index = indexPath.row - outfitCellsCount
            detail.imageUrl = data.components[safe: index]?.photo?.image?.urlValue
            detail.imageId = data.components[safe: index]?.photo?.id
            
            detail.isDeleteButtonShown = false
        }
        
        let nav = UINavigationController(rootViewController: detail)
        nav.navigationBar.applyStyle(style: .solid(withStatusBarColor: Palette[custom: .purple]))
        
        self.present(nav, animated: true, completion: nil)
    }
    
}

extension OutfitDetailViewController: PhotoDetailDelegate {
    
    func photoDeleted() {
        guard let outfitId = outfitId else {
            return
        }
        self.getOutfitDetailInfo(outfitId: outfitId)
    }
    
}

