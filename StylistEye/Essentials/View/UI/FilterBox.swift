//
//  FilterBox.swift
//  StylistEye
//
//  Created by Michal Severín on 23.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import SnapKit
import UIKit

class FilterBox: View {
    
    var tableView: TableView?
    
    init(tableView: TableView) {
        super.init(frame: CGRect.zero)
        
        self.tableView = tableView
        addElementsAndApplyConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    internal override func initializeElements() {
        super.initializeElements()
        
        tableView?.contentInset = UIEdgeInsets(top: -36, left: 0, bottom: 0, right: 0)
        tableView?.register(TableViewCellWithImage.self)
        tableView?.backgroundColor = Palette[basic: .gray]
        tableView?.isScrollEnabled = false
        tableView?.clipsToBounds = true
        tableView?.layer.cornerRadius = 10
        tableView?.separatorInset = UIEdgeInsets.zero
    }
    
    internal override func setupView() {
        super.setupView()
        
        backgroundColor = Palette[basic: .white]
        layer.cornerRadius = 10
    }
    
    internal override func addElements() {
        super.addElements()
        
        if let tableView = tableView {
            self.addSubview(tableView)
        }
    }
    
    internal override func setupConstraints() {
        super.setupConstraints()
        
        tableView?.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
}
