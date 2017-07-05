//
//  QuestionnaireFeedViewController.swift
//  StylistEye
//
//  Created by Martin Stachon on 07.06.17.
//  Copyright © 2017 Michal Severín. All rights reserved.
//

import KVNProgress
import SnapKit
import UIKit

class QuestionnaireFeedViewController: AbstractViewController {
  
  // MARK: - Properties
  // MARK: > public
  var categoryId: Int? {
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
  
  fileprivate let actionView = View()
  
  fileprivate var pagination: PaginationDTO?
  fileprivate var isRefreshing = false
  
  fileprivate var items: [CurrentOutfitDTO]? {
    didSet {
      tableView.reloadData()
    }
  }
  
  // MARK: - <Initializable>
  internal override func initializeElements() {
    super.initializeElements()
    
    backgroundImageView.image = #imageLiteral(resourceName: "purpleBg_image")
    
    cameraImageView.image = #imageLiteral(resourceName: "camera_icon")
    cameraImageView.contentMode = .scaleAspectFit
    cameraImageView.isUserInteractionEnabled = true
    cameraImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cameraImageViewTapped)))
    
    actionView.backgroundColor = Palette[custom: .purple]
    
    tableView.register(WardrobeTableViewCell.self)
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
    
    view.backgroundColor = Palette[basic: .white]
  }
  
  override func customInit() {}
  
  override func loadData() {
    super.loadData()
    
    loadWardrobe()
  }
  
  
  fileprivate func loadWardrobe(page: Int = 1) {
    guard let categoryId = categoryId else {
      return
    }
    KVNProgress.show()
    isRefreshing = true
    CurrentOutfitsCommand(category: categoryId).executeCommand(page: page) { data in
      self.isRefreshing = false
      switch data {
      case let .success(_, objectsArray: data, pagination: pagination, apiResponse: apiResponse):
        // TODO: @MS
        switch apiResponse {
        case .ok:
          self.pagination = pagination
          KVNProgress.dismiss()
          if page == 1 {
            self.items = data
          } else if let items = self.items, let outfitsData = data {
            self.items = items + outfitsData
          }
        case .fail:
          KVNProgress.showError(withStatus: "Fail code wardrobe VC")
        }
      case let .failure(message: message, apiResponse: _):
        KVNProgress.showError(withStatus: "Wardrobe detail: \(message)")
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
    guard let categoryId = categoryId else { return }
    
    let cameraController = CameraViewController()
    cameraController.imagePicked = {
      image in
      
      let imageJpeg = image.jpegData()
      let uploadCommand = UploadCurrentOutfitPhotoCommand(id: categoryId, image: image, imageData: imageJpeg)
      
      let fakeItem = CurrentOutfitDTO(image: image)
      self.items = [fakeItem] + (self.items ?? [])
      
      UploadQueueManager.main.push(item: uploadCommand)
    }
    let navController = UINavigationController(rootViewController: cameraController)
    navController.navigationBar.applyStyle(style: .solid(withStatusBarColor: Palette[custom: .purple]))
    present(navController, animated: true, completion: nil)
  }
}

// MARK: - <UITableViewDataSource>
extension QuestionnaireFeedViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: WardrobeTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
    
    if let item = items?[safe: indexPath.row] {
      
      cell.backgroundColor = Palette[basic: .clear]
      
      if item.isPlaceholder, let image = item.image {
        cell.placeholderImages = [image]
      } else {
        if let photos = item.photo?.image {
          cell.images = [photos]
        }
      }
      cell.reviews = []
      cell.selectionStyle = .none
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

// MARK: - <UITableViewDelegate>
extension QuestionnaireFeedViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
   
//TODO
//    let cell = tableView.cellForRow(at: indexPath) as! WardrobeTableViewCell
//    
//    guard let item = items?[safe: indexPath.row] else {
//      return
//    }
//    
//    let productVC = WardrobeItemDetailViewController()
//    productVC.wardrobeItem = item
//    productVC.title = item.garmetType?.name
//    if let image = item.photos?[safe: cell.currentImagePage()]?.image?.urlValue {
//      productVC.mainImageview.kf.setImage(with: image, placeholder: #imageLiteral(resourceName: "placeholder"))
//      productVC.photoIndex = cell.currentImagePage()
//    } else {
//      productVC.mainImageview.image = #imageLiteral(resourceName: "placeholder")
//      productVC.photoIndex = -1
//    }
//    productVC.hidesBottomBarWhenPushed = true
//    navigationController?.pushViewController(productVC, animated: true)
  }
}
