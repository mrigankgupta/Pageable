//
//  WebService.swift
//  MGPicsque
//
//  Created by Gupta, Mrigank on 27/11/18.
//  Copyright © 2018 Gupta, Mrigank. All rights reserved.
//

import Foundation
import Pageable

fileprivate let baseURLString = "https://reqres.in/api/"
fileprivate let baseURL = URL(string: baseURLString)!

struct Resourse<T> {
    var url: URL
    var parse: (Data) -> T?
}

class WebService {
    weak var delegate: WebResponse?

    private var parameters: [String : String] = [:]

    final func getMe<T>(res: Resourse<T>, completion: @escaping (T?) -> Void) {
        URLSession.shared.dataTask(with: res.url) { (data, response, err) in
            if let err = err {
                print("client error", err)
                return completion(nil)
            }
            guard let httpRes = response as? HTTPURLResponse, 200..<300 ~= httpRes.statusCode else {
                print("bad response")
                return completion(nil)
            }
            if let data = data, data.count > 0 {
                return completion(res.parse(data))
            }
            }.resume()
    }

    static func getURL(baseURL: URL, path: String, params: [String : String],
                       argsDict: [String : String]?) -> URL {
        var queryItems = [URLQueryItem]()
        if let argsDict = argsDict {
            for (key,value) in argsDict {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
        }
        for (key,value) in params {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)!
        components.queryItems = queryItems
        print(components.url)
        return components.url!
    }

    final func prepareResource<T: Decodable>(page: Int, pageSize: Int, pathForREST: String,
                                             argsDict: [String : String]? = nil) -> Resourse<T> {
        parameters["page"] = String(page)
        parameters["pageSize"] = String(pageSize)
        let completeURL = WebService.getURL(baseURL: baseURL, path: pathForREST, params: parameters, argsDict: argsDict)
        let downloadable = Resourse<T>(url: completeURL) { (raw) -> T? in
            print(String(bytes: raw, encoding: .utf8)!)
            do {
                let parsedDict = try JSONDecoder().decode(T.self, from: raw)
                return parsedDict
            } catch DecodingError.typeMismatch(let key, let context) {
                print(key, context)
            } catch let err {
                print(err)
            }
            return nil
        }
        return downloadable
    }
}

struct PagedResponse<T: Decodable>: Decodable {
    var types: T
    var page: Int
    var pageSize: Int
    var totalPageCount: Int
    public enum CodingKeys: String, CodingKey {
        case types = "data"
        case page
        case pageSize = "per_page"
        case totalPageCount = "total_pages"
    }
}

