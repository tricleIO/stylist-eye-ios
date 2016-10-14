//
//  UITableViewController+SE.swift
//  StylistEye
//
//  Created by Michal Severín on 13.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import UIKit

extension UITableView {

    /**
     Returns a reusable table-view cell object for the specified reuse identifier and adds it to the table.
     - Parameter style: A constant indicating a cell style. Just for creating new cells. See UITableViewCellStyle for descriptions of these constants.
     - Returns: A cell object with the associated default reuse identifier. This method always returns a valid cell.
     */
    func dequeueReusableCell<T: UITableViewCell>(_ style: UITableViewCellStyle = .default) -> T where T: Reusable {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.reuseIdentifier) as? T else {
            return T(style: style, reuseIdentifier: T.reuseIdentifier)
        }
        return cell
    }

    /**
     Returns a reusable table-view cell object for the specified reuse identifier and adds it to the table.
     - Parameter indexPath: The index path specifying the location of the cell. The data source receives this information when it is asked for the cell and should just pass it along. This method uses the index path to perform additional configuration based on the cell’s position in the table view.
     - Parameter style: A constant indicating a cell style. Just for creating new cells. See UITableViewCellStyle for descriptions of these constants.
     - Returns: A cell object with the associated default reuse identifier. This method always returns a valid cell.
     */
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath, style: UITableViewCellStyle = .default) -> T where T: Reusable {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            return T(style: style, reuseIdentifier: T.reuseIdentifier)
        }
        return cell
    }

    /**
     Registers a class for use in creating new table cells.
     - Parameter cellClass: The class of a cell that you want to use in the table.
     */
    func register<T: UITableViewCell>(_ cellClass: T.Type) where T: Reusable {
        self.register(cellClass.classForCoder(), forCellReuseIdentifier: cellClass.reuseIdentifier)
    }
}
