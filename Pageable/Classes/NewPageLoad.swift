//
//  PageController.swift
//
//  Created by Gupta, Mrigank on 28/08/18.
//  Copyright © 2018 Gupta, Mrigank. All rights reserved.
//

import UIKit

public protocol NewPageLoad: class {
    func insertAndUpdateRows(new: [IndexPath])
    func reloadAll(_ reload: Bool)
    func setupRefreshControl(_ target: Any?, selector: Selector)
}

extension UITableView: NewPageLoad {

    public func insertAndUpdateRows(new: [IndexPath]) {
        self.performBatchUpdates({
            self.insertRows(at: new, with: .none)
        }, completion: nil)

        if let visible = self.indexPathsForVisibleRows {
            let intersection = Set(new).intersection(Set(visible))
            if intersection.count > 0 {
                self.reloadRows(at: Array(intersection), with: .none)
            }
        }
    }

    public func reloadAll(_ reload: Bool) {
        if reload {
            self.reloadData()
        }
        refreshControl?.endRefreshing()
    }

    public func setupRefreshControl(_ target: Any?, selector: Selector) {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(target, action: selector, for: .valueChanged)
        refreshControl.beginRefreshing()
        self.refreshControl = refreshControl
    }

}

extension UICollectionView: NewPageLoad {

    public func insertAndUpdateRows(new: [IndexPath]) {
        self.performBatchUpdates({
            self.insertItems(at: new)
        }, completion: nil)
        let intersection = Set(new).intersection(Set(self.indexPathsForVisibleItems))
        if intersection.count > 0 {
            self.reloadItems(at: Array(intersection))
        }
    }

    public func reloadAll(_ reload: Bool) {
        if reload {
            self.reloadData()
        }
        refreshControl?.endRefreshing()
    }

    public func setupRefreshControl(_ target: Any?, selector: Selector) {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(target, action: selector, for: .valueChanged)
        refreshControl.beginRefreshing()
        self.refreshControl = refreshControl
    }

}
