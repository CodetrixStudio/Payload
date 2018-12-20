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
    
    required public override init() {
        
    }
    
    public func loadData(_ reload: Bool = false) {
        payloadTask?.cancel();
        
        isLoading = true;
        
        payloadTask = dataSource?.getPayloads(of: [T].self) { (result) in
            self.isLoading = false;
            
            guard let result = result else { return }
            self.canLoadMore = result.count == self.bufferSize;
            
            if reload {
                self.elements = result;
            } else {
                self.elements.append(contentsOf: result);
            }
            
            self.elementsChanged.forEach({$0()});
        }
    }
    
    //MARK: Observer
    
    public typealias ElementsChangedCallback = () -> Void;
    
    //MARK: Refactor this to not be an array
    public var elementsChanged: [ElementsChangedCallback] = [];
    
}

extension PayloadCollection {
    public enum Event {
        case elementsChanged
    }
}

extension PayloadCollection: MutableCollection {
    public typealias DataCollectionType = [T]
    public typealias Index = DataCollectionType.Index
    public typealias Element = DataCollectionType.Element
    
    public var startIndex: Index { return elements.startIndex }
    public var endIndex: Index { return elements.endIndex }
    
    public subscript(index: Index) -> T {
        get {
            return elements[index]
        }
        set(newValue) {
            elements[index] = newValue;
        }
    }
    
    public func index(after i: DataCollectionType.Index) -> DataCollectionType.Index {
        return elements.index(after: i)
    }
}

extension PayloadCollection: RangeReplaceableCollection {
    public func removeAll(keepingCapacity keepCapacity: Bool = false) {
        elements.removeAll(keepingCapacity: keepCapacity);
    }
    
    public func insert(_ newElement: T, at i: DataCollectionType.Index) {
        elements.insert(newElement, at: i);
    }
}
