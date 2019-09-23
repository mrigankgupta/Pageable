//
//  PageableService.swift
//  Pageable
//
//  Created by Mrigank Gupta on 19/09/19.
//

import Foundation

public protocol PagableService: class {
    func loadPage<Item: Decodable>(_ page: Int, completion: @escaping (PageInfo<Item>?) -> Void)
    func cancelAllRequests()
}
