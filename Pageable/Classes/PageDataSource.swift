//
//  PAgeDataSource.swift
//  Pageable
//
//  Created by Mrigank Gupta on 19/09/19.
//

import Foundation

public protocol PageDataSource {
    
    func addUniqueItems<Element, KeyType>(items: [Element],
                                          keypath: KeyPath<Element, KeyType>?,
                                          in interactor: PageInteractor<Element, KeyType>) -> Range<Int>
    func addAll<Element, KeyType>(items: [Element],
                                  keypath: KeyPath<Element, KeyType>?,
                                  in interactor: PageInteractor<Element, KeyType>)
}

extension PageDataSource {
    /* Server can add/remove items dynamically so it might be a case that
     an item which appears in previous request can come again due to
     certain element below got removed. This could result as duplicate items
     appearing in the list. To mitigate it, we would be creating a parallel dictionary
     which can be checked for duplicate items
     */
    public func addUniqueItems<Element, KeyType>(items: [Element],
                                                 keypath: KeyPath<Element, KeyType>?,
                                                 in interactor: PageInteractor<Element, KeyType>) -> Range<Int> {
        let startIndex = interactor.count()
        if let keypath = keypath {
            for new in items {
                let key = new[keyPath: keypath]
                if interactor.dict[key] == nil {
                    interactor.dict[key] = key
                    interactor.array.append(new)
                }
            }
        }
        return startIndex..<interactor.count()
    }
    
    public func addAll<Element, KeyType>(items: [Element],
                                         keypath: KeyPath<Element, KeyType>?,
                                         in interactor: PageInteractor<Element, KeyType>) {
        interactor.array = items
        guard let keypath = keypath else {
            return
        }
        for new in items {
            let key = new[keyPath: keypath]
            interactor.dict[key] = key
        }
    }
}
