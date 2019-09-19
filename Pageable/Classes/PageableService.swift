//
//  PageableService.swift
//  Pageable
//
//  Created by Mrigank Gupta on 19/09/19.
//

import Foundation

public protocol PagableService: class {
    func loadPage<Item: Decodable, KeyType>(_ page: Int, interactor: PageInteractor<Item, KeyType>, completion: @escaping (PageInfo<Item>?) -> Void)
    func cancelAllRequests()
}
