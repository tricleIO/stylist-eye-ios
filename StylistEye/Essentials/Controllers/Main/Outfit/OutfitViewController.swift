//
//  OutfitViewController.swift
//  StylistEye
//
//  Created by Michal Severín on 13.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import KVNProgress
import SnapKit
import UIKit

class OutfitViewController: AbstractViewController {
    
    // MARK: - Enum definition
    enum OutfitFilterIndexes: Int {
        
        case stylist
        case outfitCategory
        case unknown
        
        init(index: Int) {
            self = OutfitFilterIndexes(rawValue: index) ?? .unknown
        }
    }

    // MARK: - Properties
    // MARK: > private
    fileprivate lazy var leftBarButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "hamburger_icon"), style: .plain, target: self, action: #selector(settingsButtonTapped))
    fileprivate lazy var rightBarbutton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "message_icon"), style: .plain, target: self, action: #selector(messagesButtonTapped))

    fileprivate let filterTableView = TableView(style: .grouped)
    fileprivate var filterBox: FilterBox?
    fileprivate var lightPanel = View()
    
    fileprivate var tableView = TableView(style: .grouped)

    fileprivate let backgroundImageView = ImageView()

    fileprivate let messagesController = MessagesViewController()

    fileprivate var outfits: [OutfitsDTO]? {
        didSet {
            stylistId = nil
            styleId = nil
            tableView.reloadData()
            filterTableView.reloadData()
        }
    }
    
    fileprivate var filterNameLabel = Label()
    
    fileprivate let showFilterButton = Button(type: .system)
    
    fileprivate var pagination: PaginationDTO?
    fileprivate var isRefreshing = false

    // MARK: TODO
    fileprivate var selectedFilterTitle: String? {
        didSet {
            guard let selectedFilterTitle = selectedFilterTitle else {
                lightPanel.layer.borderWidth = 0
                lightPanel.backgroundColor = Palette[basic: .white].withAlphaComponent(0)
                showFilterButton.setTitle("Zobrazit", for: .normal)
                showFilterButton.tintColor = Palette[custom: .title]
                showFilterButton.removeTarget(self, action: #selector(resetFilterButtonTapped), for: .touchUpInside)
                showFilterButton.addTarget(self, action: #selector(showFilterButtonTapped), for: .touchUpInside)
                return
            }
            lightPanel.layer.borderWidth = 1
            lightPanel.backgroundColor = Palette[basic: .white].withAlphaComponent(0.1)
            showFilterButton.setTitle("X", for: .normal)
            showFilterButton.tintColor = Palette[custom: .title]
            showFilterButton.removeTarget(self, action: #selector(showFilterButtonTapped), for: .touchUpInside)
            showFilterButton.addTarget(self, action: #selector(resetFilterButtonTapped), for: .touchUpInside)
            filterNameLabel.text = selectedFilterTitle
        }
    }
    
    // MARK: > properties for command
    fileprivate var stylistId: String?
    fileprivate var styleId: String?
    
    // MARK: - <Initializable>
    internal override func initializeElements() {
        super.initializeElements()

        backgroundImageView.image = #imageLiteral(resourceName: "purpleBg_image")

        filterTableView.delegate = self
        filterTableView.dataSource = self
        filterTableView.separatorColor = Palette[custom: .purple]

        filterBox = FilterBox(tableView: filterTableView)
        filterBox?.isHidden = true
        

        tableView.register(OutfitTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = Palette[basic: .clear]
        tableView.separatorColor =  Palette[basic: .clear]
        tableView.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)

        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarbutton
        
        lightPanel.backgroundColor = Palette[basic: .white].withAlphaComponent(0)
        lightPanel.layer.borderColor = Palette[custom: .title].cgColor
        lightPanel.layer.borderWidth = 0
        
        // TODO: @MS
        showFilterButton.setTitle("Zobrazit", for: .normal)
        showFilterButton.tintColor = Palette[custom: .title]
        showFilterButton.addTarget(self, action: #selector(showFilterButtonTapped), for: .touchUpInside)
        
        filterNameLabel.textColor = Palette[custom: .appColor]
    }

    internal override func addElements() {
        super.addElements()

        view.addSubviews(views:
            [
                backgroundImageView,
                tableView,
                lightPanel,
            ]
        )
        
        lightPanel.addSubviews(views: [
                filterNameLabel,
                showFilterButton,
            ]
        )
        
        if let filterBox = filterBox {
            view.addSubview(filterBox)
        }
    }

    internal override func setupConstraints() {
        super.setupConstraints()

        filterNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(lightPanel).inset(10)
            make.top.equalTo(lightPanel).inset(10)
            make.height.equalTo(30)
            make.width.equalTo(150)
        }
        
        showFilterButton.snp.makeConstraints { make in
            make.trailing.equalTo(lightPanel).inset(10)
            make.width.equalTo(60)
            make.height.equalTo(30)
            make.top.equalTo(lightPanel).inset(10)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(filterNameLabel.snp.bottom).offset(10)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        filterBox?.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(20)
            make.trailing.equalTo(view).inset(20)
            make.height.equalTo(78)
            make.top.equalTo(showFilterButton.snp.bottom).offset(5)
        }
        
        lightPanel.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(-1)
            make.top.equalTo(view).inset(10)
            make.height.equalTo(50)
            make.trailing.equalTo(view).inset(-1)
        }
    }

    internal override func setupView() {
        super.setupView()

        title = StringContainer[.outfit]
        view.backgroundColor = Palette[basic: .white]
    }

    override func customInit() {}

    internal override func loadData() {
        super.loadData()

        loadOutfits()
    }

    // MARK: - User Action
    func settingsButtonTapped() {
        openSettingsView()
    }

    func messagesButtonTapped() {
        openMessagesView()
    }

    func showFilterButtonTapped() {
        openFilter()
    }
    
    func resetFilterButtonTapped() {
        resetFilter()
    }

    // MARK: - Actions
    fileprivate func resetFilter() {
        selectedFilterTitle = nil
        filterNameLabel.text = nil
        stylistId = nil
        styleId = nil
        loadOutfits()
    }

    fileprivate func openFilter() {
        if let filterBox = self.filterBox {
            filterBox.isHidden = !filterBox.isHidden
        }
        UIView.animate(withDuration: GUIConfiguration.DefaultAnimationDuration, animations: {
                self.view.layoutIfNeeded()
            }) { completed in
        }
    }
    
    fileprivate func openSettingsView() {
        let navigationController = UINavigationController(rootViewController: SettingsViewController())
        navigationController.navigationBar.applyStyle(style: .invisible(withStatusBarColor: Palette[basic: .clear]))
        present(navigationController, animated: true, completion: nil)
    }

    fileprivate func openMessagesView() {
        messagesController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(messagesController, animated: true)

    }

    fileprivate func loadOutfits(page: Int = 1) {
        KVNProgress.show()
        isRefreshing = true
        OutfitsCommand(stylistId: stylistId, dressstyle: styleId).executeCommand(page: page) { data in
            self.isRefreshing = false
            switch data {
            case let .success(_, objectsArray: data, pagination: pagination, apiResponse: apiResponse):
                // TODO: @MS
                switch apiResponse {
                case .ok:
                    self.pagination = pagination
                    KVNProgress.dismiss()
                    // outfits without photo are shown first
                    // TODO: this will probably interfere with pagination
                    let outfitsData = data?.sorted(by: {$0.photos?.first == nil && $1.photos?.first != nil})
                    if page == 1 {
                        self.outfits = outfitsData
                    } else if let outfits = self.outfits, let outfitsData = outfitsData {
                        self.outfits = outfits + outfitsData
                    }
                case .fail:
                    KVNProgress.showError(withStatus: "Fail code outfit VC")
                }
            case let .failure(message: message, apiResponse: _):
                KVNProgress.showError(withStatus: "ougfit detail: \(message)")
            }
        }
    }
    
}

// MARK: - <UITableViewDataSource>
extension OutfitViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == filterTableView {
            let cell: TableViewCellWithImage = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
            let item = FilterMenu.allCases[indexPath.row]
            
            cell.leftCellImage = item.image
            cell.labelText = item.cellName
            
            return cell
        }

        let cell: OutfitTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)

        if let outfit = outfits?[safe: indexPath.row] {
            cell.backgroundColor = Palette[basic: .clear]
            if let stylistName = outfit.stylist?.givenName, let stylistLastname = outfit.stylist?.familyName {
                cell.stylistNameText = stylistName + String.space + stylistLastname
            }
            cell.descriptionText = outfit.outfitComment
            cell.selectionStyle = .none
            if let outfitImage = outfit.photos?.first?.image {
                // image provided by user
                cell.mainImageString = outfitImage
            } else {
                // use collection mosaic
                cell.mosaicImages = outfit.components?.flatMap({$0.photo?.image})
            }
            cell.stylistImageString = outfit.stylist?.photo?.image
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == filterTableView {
            return FilterMenu.allCases.count
        }
        return outfits?.count ?? 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    @objc(tableView:heightForRowAtIndexPath:)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == filterTableView {
            return 40 // TODO: @MS
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
}

// MARK: - <UITableViewDelegate>
extension OutfitViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == filterTableView {
            switch OutfitFilterIndexes(index: indexPath.row) {

            case .stylist:
                let stylistList = StylistListViewController()
                stylistList.callback = { stylistId, selectedFilterTitle in
                    self.selectedFilterTitle = selectedFilterTitle
                    self.stylistId = stylistId
                    self.loadOutfits()
                }
                openFilter()
                navigationController?.pushViewController(stylistList, animated: true)
            case .outfitCategory:
                let outfitCategory = OutfitCategoryViewController()
                outfitCategory.callback = { styleId, selectedFilterTitle in
                    self.selectedFilterTitle = selectedFilterTitle
                    self.styleId = styleId
                    self.loadOutfits()
                }
                openFilter()
                navigationController?.pushViewController(outfitCategory, animated: true)
            case .unknown:
                break
            }
            return
        }
        
        let outfitDetailVC = OutfitDetailViewController()
        outfitDetailVC.outfitId = outfits?[safe: indexPath.row]?.outfitId
        outfitDetailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(outfitDetailVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let pagination = pagination, let currentPage = pagination.page {
            if scrollView.isAtBottom() && !isRefreshing && currentPage < pagination.totalPages {
                self.loadOutfits(page: currentPage+1)
            }
        }
    }
}
