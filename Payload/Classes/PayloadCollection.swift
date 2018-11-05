//
//  PayloadCollection.swift
//  Payload
//
//  Created by Parveen Khatkar on 26/10/18.
//  Copyright © 2018 Codetrix Studio. All rights reserved.
//

import Foundation

public class PayloadCollection<T: Codable>: NSObject {
    
    public var bufferSize: Int = 30;
    public var bufferDelta: Int = 5;
    
    public var isLoading: Bool = false;
    public var canLoadMore: Bool = true;
    
    private var elements: [T] = [T]();
    
    public weak var dataSource: PayloadCollectionDataSource?
    
    private var payloadTask: PayloadTask?
    
    func loadData(reload: Bool = false) {
        payloadTask?.cancel();
        
        isLoading = true;
        
        payloadTask = dataSource?.getPayloads(of: [T].self) { (result) in
            self.isLoading = false;
            guard let result = result else { return }
            
            self.canLoadMore = result.count == self.bufferSize;
            
            if reload {
                self.elements.removeAll();
            }
            self.elements.append(contentsOf: result);
            
            self.elementsChanged.forEach({$0()});
        }
    }
    
    //MARK: Observer
    
    typealias Callback = () -> Void;
    
    //MARK: Refactor this to not be an array
    var elementsChanged: [Callback] = [];
    
}

extension PayloadCollection {
    public enum Event {
        case elementsChanged
    }
}

extension PayloadCollection: Collection {
    public typealias DataCollectionType = [T]
    public typealias Index = DataCollectionType.Index
    public typealias Element = DataCollectionType.Element
    
    public var startIndex: Index { return elements.startIndex }
    public var endIndex: Index { return elements.endIndex }
    
    public subscript(index: Index) -> Element {
        get { return elements[index] }
    }
    
    public func index(after i: DataCollectionType.Index) -> DataCollectionType.Index {
        return elements.index(after: i)
    }
}
