//
//  Created by Gupta, Mrigank on 28/08/18.
//  Copyright © 2018 Gupta, Mrigank. All rights reserved.
//

import Foundation
import Pageable


final class UserService: WebService {
    private let firstPage: Int

    init(firstPage: Int) {
        self.firstPage = firstPage
        super.init()
    }

    func fetchUser(page: Int, pageSize: Int = 4) {
        let resource: Resourse<PagedResponse<[User]>> = prepareResource(page: page, pageSize: pageSize, pathForREST: "users")
        super.getMe(res: resource) { (res) in
            if let res = res {
                let info: PageInfo<User> = PageInfo(types: res.types, page: res.page,
                                                            totalPageCount: res.totalPageCount)
                self.delegate?.returnedResponse(info)
            }
        }
    }
}

extension UserService: PagableService {

    func refreshPage() {
        fetchUser(page: firstPage)
    }

    func loadNextPage(currentPage: Int) {
        fetchUser(page: currentPage + 1)
    }
}
