//
//  Created by Gupta, Mrigank on 28/08/18.
//  Copyright © 2018 Gupta, Mrigank. All rights reserved.
//

import Foundation
import Pageable

final class UserService: WebService {}

// SETUP:3 implement PageableService protocol
extension UserService: PageableService {
    func loadPage<Item: Decodable>(_ page: Int, completion: @escaping (PageInfo<Item>?) -> Void) {
        guard let resource: Resourse<PagedResponse<[Item]>> = try? prepareResource(page: page, pageSize: 3, pathForREST: "/api/users") else {
            completion(nil)
            return
        }
        // Construction of PageInfo to be utilised by Pageable
        var info: PageInfo<Item>?
        super.getMe(res: resource) { (res) in
            switch res {
            case let .success(result):
                // Provide PageInfo Object from the response or nil in case no response
                info = PageInfo(types: result.types,
                                page: result.page,
                                totalPageCount: result.totalPageCount)
            case let .failure(err):
                print(err)
            }
            // Returning PageInfo Object from callback to PageInteractor
            completion(info)
        }
    }
    
    func cancelAllRequests() {
        cancelAll()
    }
}
