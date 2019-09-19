//
//  PageInfo.swift
//  Pageable
//
//  Created by Mrigank Gupta on 19/09/19.
//

import Foundation

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
