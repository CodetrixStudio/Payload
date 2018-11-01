//
//  PayloadTableViewDataSource.swift
//  Payload
//
//  Created by Parveen Khatkar on 26/10/18.
//  Copyright © 2018 Codetrix Studio. All rights reserved.
//

import Foundation

public class PayloadTableViewDataSource<T: UITableViewCell & Consignee>: NSObject, UITableViewDataSource {
    private let collection: PayloadCollection<T.PayloadType>!
    
    public init(collection: PayloadCollection<T.PayloadType>) {
        self.collection = collection;
        super.init()
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collection.count;
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T;
        
        cell.set(collection[indexPath.row]);
        
        return cell
    }
}
