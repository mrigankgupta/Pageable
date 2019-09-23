//
//  PageInteractor.swift
//
//  Created by Gupta, Mrigank on 19/08/18.
//  Copyright © 2018 Gupta, Mrigank. All rights reserved.
//

import Foundation

public class PageInteractor <Element: Decodable, KeyType: Hashable> {

    public var array: [Element] = []
    public var dict: [KeyType : Any] = [:]
    private weak var service: PagableService?

    public weak var pageDelegate: NewPageLoad?
    public weak var pageDataSource: PageDataSource?
    public private(set) var isLoading = false
    #if swift(>=4.2)
    private var currentPage: Int
    private let firstPage: Int
    private let keyPath: KeyPath<Element, KeyType>
    #else
    fileprivate var currentPage: Int
    fileprivate let firstPage: Int
    fileprivate let keyPath: KeyPath<Element, KeyType>
    #endif

    private var showLoadingCell = false

    public init(firstPage: Int = 0, service: PagableService? = nil, keyPath: KeyPath<Element, KeyType>) {
        self.firstPage = firstPage
        self.currentPage = firstPage
        self.service = service
        self.keyPath = keyPath
    }

    public func visibleRow() -> Int {
        return showLoadingCell ? count()+1 : count()
    }

    public func refreshPage() {
        array.removeAll()
        dict.removeAll()
        isLoading = true
        service?.cancelAllRequests()
        service?.loadPage(firstPage) { (info)  in
            self.returnedResponse(info)
        }
    }
 
    public func loadNextPage() {
        if !isLoading {
            isLoading = true
            service?.loadPage(currentPage + 1) { (info) in
                self.returnedResponse(info)
            }
        }
    }

    public func shouldPrefetch(index: Int) {
        if showLoadingCell && index == count() - 1 {
            loadNextPage()
        }
    }
    
    #if swift(>=4.2)
    public func getUniqueItemsIndexPath(addedRange: Range<Int>) -> [IndexPath] {
        let truncate = showLoadingCell ? addedRange : addedRange.dropLast()
        return truncate.map({IndexPath(row: $0, section: 0)})
    }
    #else
    public func getUniqueItemsIndexPath(addedRange: Range<Int>) -> [IndexPath] {
        let truncate = showLoadingCell ? addedRange : addedRange.lowerBound..<addedRange.upperBound-1
        var path = [IndexPath]()
        for row in truncate.lowerBound..<truncate.upperBound {
            path.append(IndexPath(row: row, section: 0))
        }
        return path
    }
    #endif

    public func updatePage(number: Int, totalPageCount: Int) {
        isLoading = false
        currentPage = number
        showLoadingCell = currentPage < totalPageCount
    }

    public func selectedItem(for index: Int) -> Element {
        return array[index]
    }

    public func count() -> Int {
        return array.count
    }
    
    func returnedResponse(_ info: PageInfo<Element>?) {
        if let currentResponse = info {
            let lastPageNumber = currentPage
            updatePage(number: currentResponse.page, totalPageCount: currentResponse.totalPageCount)
            print(currentResponse.page)
            if currentResponse.page == firstPage {
                //                pageDataSource?.done(items: currentResponse.types)
                //                pageDataSource?.test(keypath: self.keyPath, in: self)
                pageDataSource?.addAll(items: currentResponse.types, keypath: self.keyPath, in: self)
                DispatchQueue.main.async {
                    self.pageDelegate?.reloadAll(true)
                }
            } else if currentResponse.page == lastPageNumber + 1 {
                if let numberOfItems = pageDataSource?.addUniqueItems(items: currentResponse.types,
                                                                      keypath: self.keyPath,
                                                                      in: self) {
                    let newIndexPaths = getUniqueItemsIndexPath(addedRange: numberOfItems)
                    DispatchQueue.main.async {
                        self.pageDelegate?.insertAndUpdateRows(new: newIndexPaths)
                    }
                }
            }else{
                print("Ignore result as requests landed in non-sequential order")
            }
        }else {
            isLoading = false
            DispatchQueue.main.async {
                self.pageDelegate?.reloadAll(false)
            }
//            print("some error")
        }
    }
}
