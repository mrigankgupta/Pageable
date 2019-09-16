//
//  AppDelegate.swift
//  Pageable
//
//  Created by mrigankgupta on 02/23/2019.
//  Copyright (c) 2019 mrigankgupta. All rights reserved.
//

import UIKit
import Pageable

private let firstReqIndex = 1

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let service = UserService()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window else {
            return false
        }
        let pageInteractor: PageInteractor<User, Int> = PageInteractor(firstPage: firstReqIndex, service: service, keyPath: \User.id)
        let viewController = UserView(pageInteractor: pageInteractor)
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        return true
    }

}

