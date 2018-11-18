//
//  Consignee.swift
//  DataSource
//
//  Created by Parveen Khatkar on 26/10/18.
//  Copyright © 2018 Codetrix Studio. All rights reserved.
//

import Foundation

public protocol Consignee: class {
    associatedtype PayloadType;
    func set(_ payload: PayloadType);
}
