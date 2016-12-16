//
//  StylistListTableViewController.swift
//  StylistEye
//
//  Created by Michal Severín on 16.12.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import UIKit

class StylistListViewController: AbstractViewController {

    
    // MARK: - Properties
    // MARK: > public
    
    // MARK: > private
    fileprivate var stylistListData: [StylistListDTO]? = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    fileprivate let tableView = TableView(style: .grouped)
    
    // MARK: - Initialize
    internal override func initializeElements() {
        super.initializeElements()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(StylistListTableViewCell.self)
    }
    
    internal override func setupView() {
        super.setupView()
        
        view.backgroundColor = Palette[basic: .white]
    }
    
    internal override func loadData() {
        super.loadData()
        
        StylistCommand().executeCommand { data in
            switch data {
            case let .success(data):
                self.stylistListData = data.objectsArray
            case .failure:
                break
            }
        }
        
    }
}

extension StylistListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StylistListTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        
        if let data = stylistListData?[safe: indexPath.row] {
            cell.textLabel?.text = data.familyName
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stylistListData?.count ?? 0
    }
}


extension StylistListViewController: UITableViewDelegate {
    
    
}
