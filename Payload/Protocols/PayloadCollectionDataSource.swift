//
//  CollectionDataSourceDelegate.swift
//  Payload
//
//  Created by Parveen Khatkar on 26/10/18.
//  Copyright © 2018 Codetrix Studio. All rights reserved.
//

import Foundation

public protocol PayloadCollectionDataSource: class {
    func getPayloads<T>(of modelType: T.Type, completionHandler: @escaping (T?) -> Void) -> PayloadTask? where T: Collection
}

public protocol PayloadTask {
    func cancel();
}
