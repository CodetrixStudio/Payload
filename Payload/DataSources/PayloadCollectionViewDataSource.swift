//
//  PayloadCollectionViewDataSource.swift
//  Payload
//
//  Created by Parveen Khatkar on 18/10/18.
//  Copyright © 2018 Codetrix Studio. All rights reserved.
//

import UIKit

public class PayloadCollectionViewDataSource<T: UICollectionViewCell & Consignee>: NSObject, UICollectionViewDataSource {
    private let collection: PayloadCollection<T.PayloadType>!
    
    public init(collection: PayloadCollection<T.PayloadType>) {
        self.collection = collection;
        super.init()
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collection.count;
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T;
        
        cell.set(collection[indexPath.row]);
        
        return cell
    }
}
