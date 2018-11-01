//
//  TableViewExtensions.swift
//  Payload
//
//  Created by Parveen Khatkar on 26/10/18.
//  Copyright © 2018 Codetrix Studio. All rights reserved.
//

import Foundation

extension UITableView {
    func register(_ cellClass: UITableViewCell.Type) {
        let nib = UINib(nibName: cellClass.reuseIdentifier, bundle: nil);
        self.register(nib, forCellReuseIdentifier: cellClass.reuseIdentifier);
    }
}

extension UITableViewCell {
    static var reuseIdentifier: String
    {
        let className = String(describing: self);
        return className;
    }
}
