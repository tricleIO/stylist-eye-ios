//
//  QuestionnaireViewController.swift
//  StylistEye
//
//  Created by Michal Severín on 13.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import UIKit

class QuestionnaireViewController: AbstractViewController {
    
    // MARK: - Properties
    // MARK: > private
    fileprivate var garmentTypes: [OutfitCategoryDTO] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    fileprivate lazy var rightBarbutton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "message_icon"), style: .plain, target: self, action: #selector(messagesButtonTapped))
    
    fileprivate var tableView = TableView(style: .grouped)
    
    fileprivate lazy var leftBarButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "hamburger_icon"), style: .plain, target: self, action: #selector(settingsButtonTapped))
    fileprivate let messagesController = MessagesViewController()
    fileprivate let backgroundImageView = ImageView()
    
    // MARK: - <Initializable>
    internal override func initializeElements() {
        super.initializeElements()
        
        backgroundImageView.image = #imageLiteral(resourceName: "whiteBg_image")
        
        navigationItem.leftBarButtonItem = leftBarButton
        
        tableView.register(TableViewCellWithImage.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Palette[basic: .clear]
        tableView.isScrollEnabled = false
        tableView.separatorColor =  Palette[custom: .purple]
        tableView.contentInset = UIEdgeInsets(top: -36, left: 0, bottom: 0, right: 0)
        
        navigationItem.rightBarButtonItem = rightBarbutton
    }
    
    internal override func addElements() {
        super.addElements()
        
        view.addSubviews(views:
            [
                backgroundImageView,
                tableView,
                ]
        )
    }
    
    internal override func setupConstraints() {
        super.setupConstraints()
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view)
        }
    }
    
    override func customInit() {}
    
    internal override func setupView() {
        super.setupView()
        
        title = StringContainer[.questionnaire]
        view.backgroundColor = Palette[basic: .white]
    }
    
    override func loadData() {
        super.loadData()
        
        CurrentOutfitCategoriesCommand().executeCommand { data in
            switch data {
            case let .success(object: _, objectsArray: objects, pagination: _, apiResponse: _):
                if let objects = objects {
                    // TODO language
                    self.garmentTypes = objects.filter { $0.languageId == Languages.current }
                }
            case .failure:
                break
            }
        }
        
        loadMessages()
    }
    
    fileprivate func loadMessages() {
        MessagesCheckCommand().executeCommand(page: 0) { data in
            switch data {
            case let .success(data, objectsArray: _, pagination: _, apiResponse: _):
                
                if let data = data, let unread = data.unread {
                    self.rightBarbutton.pp.setBadgeLabel(attributes: { badgeLabel in
                        badgeLabel.textColor = Palette[custom: .purple]
                    })
                    if unread > 0 {
                        //self.rightBarbutton.yl_showBadgeText("\(unread)")
                        if unread > 99 {
                            self.rightBarbutton.pp.addBadge(text: "99+")
                        } else {
                            self.rightBarbutton.pp.addBadge(number: unread)
                        }
                    } else {
                        //self.rightBarbutton.yl_clearBadge()
                        self.rightBarbutton.pp.hiddenBadge()
                    }
                }
            default:
                break
            }
        }
    }
    
    // MARK: - User Action
    func settingsButtonTapped() {
        openSettingsView()
    }
    
    func messagesButtonTapped() {
        openMessagesView()
    }
    
    // MARK: - Actions
    fileprivate func openSettingsView() {
        let navigationController = UINavigationController(rootViewController: SettingsViewController())
        navigationController.navigationBar.applyStyle(style: .invisibleWithoutShadow(withStatusBarColor: Palette[basic: .clear]))
        present(navigationController, animated: true, completion: nil)
    }
    
    fileprivate func openMessagesView() {
        messagesController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(messagesController, animated: true)
        
    }
    
}

// MARK: - <UITableViewDataSource>
extension QuestionnaireViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCellWithImage = tableView.dequeueReusableCell(forIndexPath: indexPath)
        
        cell.backgroundColor = Palette[basic: .clear]
        cell.textLabel?.textColor = Palette[custom: .purple]
        cell.textLabel?.font = SystemFont[.description]
        cell.accessoryView = ImageView(image: #imageLiteral(resourceName: "disclButton_icon"))
        cell.tintColor = Palette[custom: .purple]
        cell.separatorInset = UIEdgeInsets.zero
        cell.selectionStyle = .gray
        
        if let garmentType = garmentTypes[safe: indexPath.row] {
            cell.labelText = garmentType.name
            if let iconUrl = garmentType.icon {
                cell.leftImageSetFrom(url: URL(string: iconUrl))
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return garmentTypes.count
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
extension QuestionnaireViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = QuestionnaireFeedViewController()
        controller.categoryId = garmentTypes[indexPath.row].categoryId
        controller.categoryName = garmentTypes[indexPath.row].name
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
}
