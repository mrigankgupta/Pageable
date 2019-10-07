//
//  ManufacturerCell.swift
//  ShowMyRide
//
//  Created by Gupta, Mrigank on 15/08/18.
//  Copyright © 2018 Gupta, Mrigank. All rights reserved.
//

import Foundation
import UIKit


class InformationCell: UITableViewCell {
    @IBOutlet private weak var user: UILabel!
    @IBOutlet private weak var background: UIView!

    func configureCell(with source: (CellDataSource & CellStyling), for indexPath: IndexPath) {
        user.text = source.titleText
        background.backgroundColor = source.background(index: indexPath.row)
    }
}

protocol CellDataSource {
    var titleText: String { get }
}

protocol CellStyling {
    func background(index: Int) -> UIColor
}

extension UserModel: CellStyling, CellDataSource {
    func background(index: Int) -> UIColor {
        if index % 2 == 0 {
            return UIColor.brown
        }
        return UIColor.white
    }

    var titleText: String {
        return firstName + " " + lastName
    }

}

