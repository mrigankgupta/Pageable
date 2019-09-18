//
//  Created by Gupta, Mrigank on 28/08/18.
//  Copyright © 2018 Gupta, Mrigank. All rights reserved.
//

import Foundation
import Pageable


final class UserService: WebService {
    weak var delegate: WebResponse?

    func fetchUser(page: Int, pageSize: Int = 3) {
        guard let resource: Resourse<PagedResponse<[User]>> = try? prepareResource(page: page, pageSize: pageSize, pathForREST: "/api/users") else { return }
        // construction of PageInfo to be utilised by Pageable
        var info: PageInfo<User>?
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
            self.delegate?.returnedResponse(info)
        }
    }
}

// 2. implement PageableService protocol
extension UserService: PagableService {

    func loadPage(_ page: Int) {
        fetchUser(page: page)
    }

    func cancelAllRequests() {
        cancelAll()
    }
}
