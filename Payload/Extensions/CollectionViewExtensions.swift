//
//  CollectionViewExtensions.swift
//  Payload
//
//  Created by Parveen Khatkar on 30/10/18.
//  Copyright © 2018 Codetrix Studio. All rights reserved.
//

import Foundation

extension UICollectionViewCell {
    static var reuseIdentifier: String
    {
        let className = String(describing: self);
        return className;
    }
}

extension UICollectionView {
    func register(_ cellClass: UICollectionViewCell.Type) {
        let nib = UINib(nibName: cellClass.reuseIdentifier, bundle: nil);
        self.register(nib, forCellWithReuseIdentifier: cellClass.reuseIdentifier);
    }
}
