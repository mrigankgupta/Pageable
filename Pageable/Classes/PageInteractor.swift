//
//  PageInteractor.swift
//
//  Created by Gupta, Mrigank on 19/08/18.
//  Copyright © 2018 Gupta, Mrigank. All rights reserved.
//

import Foundation

public class PageInteractor <Element: Decodable, KeyType: Hashable> {

    public weak var pageDelegate: NewPageLoad?

    public private(set) var array: [Element] = []
    public private(set) var dict: [KeyType : Any] = [:]
    public private(set) var isLoading = false

    public weak var service: PageableService?
    private var currentPage: Int
    private let firstPage: Int
    private let keyPath: KeyPath<Element, KeyType>?
    private var showLoadingCell = false
    /** Initialiser
     - Parameter firstPage: Indicates the starting index of pagination for REST point, default == 0
     - Parameter service: Provide PageableService protocol instance, can be set later also
     - Parameter keyPath: In case if duplicate entries has to be filter out, It requires keypath of
     unique items in model data.
     
     # Example
     If server has added new entry in previous page displayed in pagination,
     it results in repeat of last item in fetched new page.
     
     Displayed                      __1__        On Server
     ____________                 ____2_____
     |  __1__   |                |  __3__   |       1
     |  __2__   |                |  __4__   |       2
     |  __3__   |  +__10__ ==    |  __4__   |      10
     |____4_____|                |____5_____|       3
        __5__                       __6__
        __6__                       __7__
        __7__                       __8__   new fetch
        __8__                       __9__
     */

    public init(firstPage: Int = 0, service: PageableService? = nil, keyPath: KeyPath<Element, KeyType>? = nil) {
        self.firstPage = firstPage
        self.currentPage = firstPage
        self.service = service
        self.keyPath = keyPath
    }

    public func visibleRow() -> Int {
        return showLoadingCell ? count() + 1 : count()
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
    
    /// Get item for index
    /// - Parameter index: index of item to be return
    /// - Return: item of 'Element' type
    public func item(for index: Int) -> Element {
        return array[index]
    }
    
    /// Total item for display
    public func count() -> Int {
        return array.count
    }
    
    #if swift(>=4.2)
    func getUniqueItemsIndexPath(addedRange: Range<Int>) -> [IndexPath] {
        let truncate = showLoadingCell ? addedRange : addedRange.dropLast()
        return truncate.map({IndexPath(row: $0, section: 0)})
    }
    #else
    func getUniqueItemsIndexPath(addedRange: Range<Int>) -> [IndexPath] {
        let truncate = showLoadingCell ? addedRange : addedRange.lowerBound..<addedRange.upperBound - 1
        var path = [IndexPath]()
        for row in truncate.lowerBound..<truncate.upperBound {
            path.append(IndexPath(row: row, section: 0))
        }
        return path
    }
    #endif

    func updateLoading(number: Int, totalPageCount: Int) {
        isLoading = false
        currentPage = number
        showLoadingCell = currentPage < totalPageCount
    }

    func returnedResponse(_ info: PageInfo<Element>?) {
        if let currentResponse = info {
            let lastPageNumber = currentPage
            updateLoading(number: currentResponse.page, totalPageCount: currentResponse.totalPageCount)
            print(currentResponse.page)
            if currentResponse.page == firstPage {
                addAll(items: currentResponse.types, keypath: self.keyPath)
                DispatchQueue.main.async {
                    self.pageDelegate?.reloadAll(true)
                }
            } else if currentResponse.page == lastPageNumber + 1 {
                let numberOfItems = addUniqueFrom(items: currentResponse.types,
                                                   keypath: self.keyPath)
                let newIndexPaths = getUniqueItemsIndexPath(addedRange: numberOfItems)
                DispatchQueue.main.async {
                    self.pageDelegate?.insertAndUpdateRows(new: newIndexPaths)
                }
            }else{
                print("Ignore result as requests landed in non-sequential order")
            }
        }else {
            isLoading = false
            DispatchQueue.main.async {
                self.pageDelegate?.reloadAll(false)
            }
        }
    }
    /**
     Server can add/remove items dynamically so it might be a case that
     an item which appears in previous request can come again due to
     certain element below got removed. This could result as duplicate items
     appearing in the list. To mitigate it, we would be creating a parallel dictionary
     which can be checked for duplicate items
     
     - Parameter items: items to be added
     - Parameter keypath: In case if duplicate entries has to be filter out,
     It requires keypath of unique items in model data.
    */
    
    open func addUniqueFrom(items: [Element], keypath: KeyPath<Element, KeyType>?) -> Range<Int> {
        let startIndex = count()
        if let keypath = keypath {
            for new in items {
                let key = new[keyPath: keypath]
                if dict[key] == nil {
                    dict[key] = key
                    array.append(new)
                }
            }
        }
        return startIndex..<count()
    }
    /** Add all items, If there is empty list in table view
     - Parameter items: items to be added
     - Parameter keypath: In case if duplicate entries has to be filter out,
     It requires keypath of unique items in model data.
     */
    open func addAll(items: [Element], keypath: KeyPath<Element, KeyType>?) {
        array = items
        guard let keypath = keypath else {
            return
        }
        for new in items {
            let key = new[keyPath: keypath]
            dict[key] = key
        }
    }
}
