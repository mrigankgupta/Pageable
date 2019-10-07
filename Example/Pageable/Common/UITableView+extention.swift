//
//  UITableView+extention.swift
//  Pageable_Example
//
//  Created by Mrigank Gupta on 26/09/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit


extension UITableView {
    // Reusable identifier should be unique across the app.There should be a convention to
    // give identifer names as there are chances for collision if app has
    // lots of cells and views. We can use compiler help here by using Class name as reusable identifier and nib names.
    // As we can only create cell class with unique names, it will help in giving unique reusable identifier name also.
    func dequeueReusableCell<T: UITableViewCell> (for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reusableIdetifier(), for: indexPath) as? T else {
            fatalError("Can't not cast Cell with reusable identfier\(T.reusableIdetifier())")
        }
        return cell
    }

    func dequeueReusableHeaderFooterView<T: UIView> () -> T {
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier:T.reusableIdetifier()) as? T else {
            fatalError("Can't not cast View with reusable identfier\(T.reusableIdetifier())")
        }
        return cell
    }

    func registerNib<T: UITableViewCell>(forCell: T.Type) {
        register(UINib(nibName: T.nibName(), bundle: nil), forCellReuseIdentifier: T.reusableIdetifier())
    }

    func registerNib<T: UIView>(forforHeaderFooterView: T.Type) {
        register(UINib(nibName: T.nibName(), bundle: nil), forHeaderFooterViewReuseIdentifier: T.reusableIdetifier())
    }
}
