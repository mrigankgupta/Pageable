//
//  PageController.swift
//  ShowMyRide
//
//  Created by Gupta, Mrigank on 28/08/18.
//  Copyright © 2018 Gupta, Mrigank. All rights reserved.
//

import UIKit

public protocol Pageable: class {
    func insertAndUpdateRows(new: [IndexPath])
    func reloadAll(_ reload: Bool)
    func setupRefreshControl(_ target: Any?, selector: Selector)
}

public protocol WebResponse: class {
    func returnedResponse<T>(_ info: PageInfo<T>?)
}

public protocol PagableService {
    func loadPage(_ page: Int)
    func cancelAllRequests()
}

public struct PageInfo<T> {
    var types: [T]
    var page: Int
    var totalPageCount: Int

    public init(types: [T], page: Int, totalPageCount: Int) {
        self.types = types
        self.page = page
        self.totalPageCount = totalPageCount
    }
}

extension UITableView: Pageable {

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

extension UICollectionView: Pageable {

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
            print("reload")
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
