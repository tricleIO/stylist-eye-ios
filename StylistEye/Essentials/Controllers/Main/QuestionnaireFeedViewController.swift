//
//  QuestionnaireFeedViewController.swift
//  StylistEye
//
//  Created by Martin Stachon on 07.06.17.
//  Copyright © 2017 Michal Severín. All rights reserved.
//

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
  
  fileprivate var toolbar = UIToolbar()
  
  fileprivate var pagination: PaginationDTO?
  fileprivate var isRefreshing = false
  
  fileprivate var itemsReal: [CurrentOutfitDTO]? {
    didSet {
      tableView.reloadData()
    }
  }
  // items with placeholders for uploaded items
  fileprivate var items: [CurrentOutfitDTO]? {
    guard let categoryId = categoryId else {
      return itemsReal
    }
    return UploadQueueManager.main.placeholders(type: .currentOutfits, category: categoryId).map {
      CurrentOutfitDTO(image: $0.image)
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
    
    tableView.register(QuestionnaireTableViewCell.self)
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
    guard let categoryId = categoryId else {
      return
    }
    ProgressHUD.show()
    isRefreshing = true
    CurrentOutfitsCommand(category: categoryId).executeCommand(page: page) { data in
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
    guard let categoryId = categoryId else { return }
    
    let cameraController = CameraViewController()
    cameraController.imagePicked = {
      image in
      
      let imageJpeg = image.jpegData()
      let uploadCommand = UploadCurrentOutfitPhotoCommand2(id: categoryId, image: image, imageData: imageJpeg)
      
      UploadQueueManager.main.push(item: uploadCommand) {
        [weak self]
        in
        DispatchQueue.main.async {
          self?.loadData()
        }
      }
      
      self.tableView.reloadData()
    }
    let navController = UINavigationController(rootViewController: cameraController)
    navController.navigationBar.applyStyle(style: .solid(withStatusBarColor: Palette[custom: .purple]))
    present(navController, animated: true, completion: nil)
  }
}

// MARK: - <UITableViewDataSource>
extension QuestionnaireFeedViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: QuestionnaireTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
    
    if let item = items?[safe: indexPath.row] {
      
      cell.backgroundColor = Palette[basic: .clear]
      
      if item.isPlaceholder, let image = item.placeholderImage {
        cell.mainImage = image
      } else {
        if let photo = item.photo?.image {
          cell.mainImageString = photo
        }
      }
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
    
    guard let item = items?[safe: indexPath.row] else {
      return
    }
    
    let productVC = QuestionnaireDetailViewController()
    productVC.item = item
    productVC.title = ""
    
    if item.isPlaceholder {
      productVC.mainImageview.image = item.placeholderImage
    } else {
      
      if let image = item.photo?.image?.urlValue {
        productVC.mainImageview.kf.setImage(with: image, placeholder: #imageLiteral(resourceName: "placeholder"))
      } else {
        productVC.mainImageview.image = #imageLiteral(resourceName: "placeholder")
      }
    }
    productVC.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(productVC, animated: true)
  }
}
