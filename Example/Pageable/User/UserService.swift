//
//  Created by Gupta, Mrigank on 28/08/18.
//  Copyright © 2018 Gupta, Mrigank. All rights reserved.
//

import Foundation
import Pageable

// 2. implement PageableService protocol
final class UserService: WebService, PagableService {
    
    func loadPage<Item: Decodable, KeyType>(_ page: Int, interactor: PageInteractor<Item, KeyType>, completion: @escaping (PageInfo<Item>?) -> Void) where KeyType : Hashable {
        guard let resource: Resourse<PagedResponse<[Item]>> = try? prepareResource(page: page, pageSize: 3, pathForREST: "/api/users") else {
            completion(nil)
            return
        }
        // construction of PageInfo to be utilised by Pageable
        var info: PageInfo<Item>?
        super.getMe(res: resource) { (res) in
            switch res {
            case let .success(result):
//              1. Provide PageInfo Object from the response or nil in case no response
                info = PageInfo(types: result.types,
                                page: result.page,
                                totalPageCount: result.totalPageCount)
            case let .failure(err):
                print(err)
            }
            completion(info)
        }
    }
    
    func cancelAllRequests() {
        cancelAll()
    }
}
