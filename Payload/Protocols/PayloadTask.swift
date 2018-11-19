//
//  PayloadTask.swift
//  Payload
//
//  Created by Parveen Khatkar on 26/10/18.
//  Copyright © 2018 Codetrix Studio. All rights reserved.
//

import Foundation

public typealias Courier<T> = (@escaping ([T]?) -> Void) -> PayloadTask?

public protocol PayloadTask {
    func cancel();
}
