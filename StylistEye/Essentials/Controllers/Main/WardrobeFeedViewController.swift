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
    // MARK: > public
    var garmentId: Int? {
        didSet {
            
        }
    }
    
    var categoryName: String? {
        didSet {
            navigationItem.title = categoryName
        }
    }
    
    // MARK: > private
    fileprivate lazy var backButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow_icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backButtonTapped))
    
    fileprivate var tableView = TableView(style: .grouped)
    
    fileprivate let backgroundImageView = ImageView()
    fileprivate let cameraImageView = ImageView()
    
    fileprivate var toolbar = UIToolbar()
    
    fileprivate var pagination: PaginationDTO?
    fileprivate var isRefreshing = false
    
    fileprivate var itemsReal: [WardrobeDTO]? {
        didSet {
            tableView.reloadData()
        }
    }
    // items with placeholders for uploaded items
    fileprivate var items: [WardrobeDTO]? {
        guard let garmentId = garmentId else {
            return itemsReal
        }
        
        return UploadQueueManager.main.placeholders(type: .wardrobe, category: garmentId).map {
            WardrobeDTO(image: $0.image)
        } + (itemsReal ?? [])
    }
    
    // MARK: - <Initializable>
    internal override func initializeElements() {
        super.initializeElements()
        
        backgroundImageView.image = #imageLiteral(resourceName: "purpleBg_image")
        
        cameraImageView.image = #imageLiteral(resourceName: "camera_icon")
        cameraImageView.contentMode = .scaleAspectFit
        cameraImageView.isUserInteractionEnabled = true
        cameraImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cameraImageViewTapped)))
        
        toolbar.barTintColor = Palette[custom: .purple]
        toolbar.isTranslucent = false
        
        let filler1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let filler2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        cameraImageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        if #available(iOS 11.0, *) {
            cameraImageView.snp.makeConstraints { make in
                make.width.equalTo(30)
                make.height.equalTo(30)
            }
        }
        let button = UIBarButtonItem(customView: cameraImageView)
        toolbar.items = [filler1, button, filler2]
        toolbar.isHidden = false
        
        tableView.register(WardrobeTableViewCell.self)
        tableView.dataSource = self
        tableView.backgroundColor = Palette[basic: .clear]
        tableView.separatorColor =  Palette[basic: .clear]
        tableView.allowsSelection = false
        
        navigationItem.leftBarButtonItem = backButton
        
        NotificationCenter.default.addObserver(self, selector: #selector(onUploadFinished), name: .uploadFinished, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    internal override func addElements() {
        super.addElements()
        
        view.addSubviews(views:
            [
                backgroundImageView,
                tableView,
                toolbar,
                ]
        )
        
    }
    
    internal override func setupConstraints() {
        super.setupConstraints()
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        if #available(iOS 11.0, *) {
            toolbar.snp.makeConstraints { make in
                make.leading.equalTo(view)
                make.trailing.equalTo(view)
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            }
        } else {
            toolbar.snp.makeConstraints { make in
                make.leading.equalTo(view)
                make.trailing.equalTo(view)
                make.bottom.equalTo(view)
            }
        }
        
    }
    
    internal override func setupView() {
        super.setupView()
        
        view.backgroundColor = Palette[basic: .white]
    }
    
    override func customInit() {}
    
    override func loadData() {
        super.loadData()
        
        loadWardrobe()
    }
    
    
    fileprivate func loadWardrobe(page: Int = 1) {
        guard let garmentId = garmentId else {
            return
        }
        ProgressHUD.show()
        isRefreshing = true
        WardrobeCommand(garmetType: garmentId).executeCommand(page: page) { data in
            self.isRefreshing = false
            switch data {
            case let .success(_, objectsArray: data, pagination: pagination, apiResponse: apiResponse):
                // TODO: @MS
                switch apiResponse {
                case .ok:
                    self.pagination = pagination
                    ProgressHUD.dismiss()
                    if page == 1 {
                        self.itemsReal = data
                    } else if let items = self.itemsReal, let outfitsData = data {
                        self.itemsReal = items + outfitsData
                    }
                case .fail:
                    ProgressHUD.showError(withStatus: StringContainer[.errorOccured])
                }
            case let .failure(message: message, apiResponse: _):
                ProgressHUD.showError(withStatus: StringContainer[.errorOccured])
            }
        }
    }
    
    // MARK: - User Action
    func backButtonTapped() {
        let _ = navigationController?.popViewController(animated: true)
    }
    
    func cameraImageViewTapped() {
        openCamera()
    }
    
    // MARK: - Actions
    fileprivate func openCamera() {
        guard let garmentId = garmentId else { return }
        
        let cameraController = CameraViewController()
        cameraController.imagePicked = {
            image in
            
            let imageJpeg = image.jpegData()
            let uploadCommand = UploadWardrobePhotoCommand(id: garmentId, image: image, imageData: imageJpeg)
            
            UploadQueueManager.main.push(item: uploadCommand) {
                [weak self]
                in
                DispatchQueue.main.async {
                    self?.loadData()
                }
            }
            
//            ProgressHUD()
//            uploadCommand.executeCommand {
//                data in
//                
//                switch data {
//                case let .success(_, objectsArray: _, _, apiResponse: apiResponse):
//                    // TODO: @MS
//                    switch apiResponse {
//                    case .ok:
//                        KVNProgress.showSuccess()
//                        self.loadData()
//                    case .fail:
//                        KVNProgress.showError(withStatus: "Upload failed")
//                    }
//                case let .failure(message):
//                    ProgressHUD.showError(withStatus: message.message)
//                }
//            }
        }
        let navController = UINavigationController(rootViewController: cameraController)
        navController.navigationBar.applyStyle(style: .solid(withStatusBarColor: Palette[custom: .purple]))
        present(navController, animated: true, completion: nil)
    }
}

// MARK: - <UITableViewDataSource>
extension WardrobeFeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WardrobeTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        
        if let item = items?[safe: indexPath.row] {
        
            cell.backgroundColor = Palette[basic: .clear]
            
            if item.isPlaceholder {
                if let placeholder = item.placeholderImage {
                    cell.placeholderImages = [placeholder]
                }
            } else {
                if let photos = item.photos?.flatMap({$0.image}) {
                    cell.images = photos
                }
            }
            cell.reviews = item.reviews
            cell.selectionStyle = .none
            
            cell.zoomButtonCallback = { [weak self] in
                guard let `self` = self else { return}
                let productVC = WardrobeItemDetailViewController()
                productVC.wardrobeItem = item
                productVC.title = self.categoryName //item.garmetType?.name
                
                if item.isPlaceholder {
                    productVC.mainImageview.image = item.placeholderImage
                    productVC.photoIndex = 0
                } else {
                    
                    if let image = item.photos?[safe: cell.currentImagePage()]?.image?.urlValue {
                        productVC.mainImageview.kf.setImage(with: image, placeholder: #imageLiteral(resourceName: "placeholder"))
                        productVC.photoIndex = cell.currentImagePage()
                    } else {
                        productVC.mainImageview.image = #imageLiteral(resourceName: "placeholder")
                        productVC.photoIndex = -1
                    }
                }
                productVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(productVC, animated: true)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @objc(tableView:heightForRowAtIndexPath:)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 560
    }
}

extension WardrobeFeedViewController {
    
    func onUploadFinished() {
        self.loadData()
    }
}
