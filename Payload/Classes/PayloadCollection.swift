//
//  PayloadCollection.swift
//  Payload
//
//  Created by Parveen Khatkar on 26/10/18.
//  Copyright © 2018 Codetrix Studio. All rights reserved.
//

import Foundation

open class PayloadCollection<T>: NSObject, RangeReplaceableCollection, MutableCollection {
    
    public var bufferSize: Int = 30;
    public var bufferDelta: Int = 5;
    
    public var isLoading: Bool = false;
    public var canLoadMore: Bool = true;
    
    private var elements: [T] = [T]();
    open var count: Int {
        return elements.count;
    }
    
    public var courier: Courier<T>?
    
    private var payloadTask: PayloadTask?
    
    required public override init() {
        
    }
    
    public func loadData(_ reload: Bool = false) {
        payloadTask?.cancel();
        
        isLoading = true;
        
        payloadTask = courier?({ (result) in
            self.isLoading = false;
            
            guard let result = result else { return }
            self.canLoadMore = result.count >= self.bufferSize;
            
            if reload {
                self.removeAll();
            }
            
            self.append(contentsOf: result);
            
            self.elementsChanged.forEach({$0()});
        })
    }
    
    //MARK: Observer
    
    public typealias ElementsChangedCallback = () -> Void;
    
    //MARK: Refactor this to not be an array
    public var elementsChanged: [ElementsChangedCallback] = [];
    

    //MARK: MutableCollection {
    public typealias DataCollectionType = [T]
    public typealias Index = DataCollectionType.Index
    public typealias Element = DataCollectionType.Element
    
    public var startIndex: Index { return elements.startIndex }
    public var endIndex: Index { return elements.endIndex }
    
    open subscript(index: Index) -> T {
        get {
            return elements[index]
        }
        set(newValue) {
            elements[index] = newValue;
        }
    }
    
    open func index(after i: DataCollectionType.Index) -> DataCollectionType.Index {
        return elements.index(after: i)
    }
    
    open func append(contentsOf newElements: [Element]) {
        elements.append(contentsOf: newElements);
    }

    //MARK: RangeReplaceableCollection
    open func remove(at position: DataCollectionType.Index) -> T {
        return elements.remove(at: position);
    }
    
    open func removeAll(keepingCapacity keepCapacity: Bool = false) {
        elements.removeAll(keepingCapacity: keepCapacity);
    }
    
    open func insert(_ newElement: T, at i: DataCollectionType.Index) {
        elements.insert(newElement, at: i);
    }
}

extension PayloadCollection {
    public enum Event {
        case elementsChanged
    }
}
