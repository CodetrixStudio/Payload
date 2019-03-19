//
//  ElementChange.swift
//  Payload
//
//  Created by Parveen Khatkar on 19/03/19.
//  Copyright © 2019 Codetrix Studio. All rights reserved.
//

import Foundation

public enum ElementChange {
    case update(index: Int)
    case delete(index: Int)
    case insert(index: Int)
}
