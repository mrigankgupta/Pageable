//
//  Created by Gupta, Mrigank on 05/08/18.
//  Copyright © 2018 Gupta, Mrigank. All rights reserved.
//

import Foundation

typealias JsonDict = [String : String]

struct UserModel: Decodable {
    let id: Int
    let firstName: String
    let lastName: String

    public enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

struct UserList: Decodable {

    typealias ArrayType = UserModel
    typealias KeyType = String

    private(set) var array = [UserModel]()
    private(set) var dict = JsonDict()

    struct UserKey: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        var intValue: Int?
        init?(intValue: Int) { return nil }
    }
}

extension UserList {

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserKey.self)
        var list = [UserModel]()
        var dict = JsonDict()
        for key in container.allKeys {
            let value = try container.decode(UserModel.self, forKey: key)
            list.append(UserModel(id: value.id, firstName: value.firstName, lastName: value.lastName))
            let idKey = String(value.id)
            dict[idKey] = idKey
        }
        self.init(array: list, dict: dict)
    }
}

