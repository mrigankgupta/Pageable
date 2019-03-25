//
//  Created by Gupta, Mrigank on 28/08/18.
//  Copyright © 2018 Gupta, Mrigank. All rights reserved.
//

import Foundation
import Pageable


final class UserService: WebService {

    func fetchUser(page: Int, pageSize: Int = 3) {
        guard let resource: Resourse<PagedResponse<[User]>> = try? prepareResource(page: page, pageSize: pageSize, pathForREST: "/api/users") else { return }
        var info: PageInfo<User>?
        super.getMe(res: resource) { (res) in
            switch res {
            case let .success(result):
                info = PageInfo(types: result.types, page: result.page,
                                                        totalPageCount: result.totalPageCount)
            case let .failure(err):
                print(err)
            }
            self.delegate?.returnedResponse(info)
        }
    }
}

extension UserService: PagableService {

    func loadPage(_ page: Int) {
        fetchUser(page: page)
    }

    func cancelAllRequests() {
        cancelAll()
    }
}
