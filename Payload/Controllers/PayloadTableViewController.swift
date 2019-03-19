//
//  PayloadTableViewController.swift
//  Payload
//
//  Created by Parveen Khatkar on 17/10/18.
//  Copyright © 2018 Codetrix Studio. All rights reserved.
//

import UIKit

open class PayloadTableViewController<T: UITableViewCell & Consignee>: UITableViewController {
    
    public var activityIndicatorView: (UIView & PayloadActivityIndicator)? = UIActivityIndicatorView() {
        didSet {
            tableView.tableFooterView = activityIndicatorView;
        }
    }
    
    open override var refreshControl: UIRefreshControl? {
        didSet {
            oldValue?.removeTarget(self, action: #selector(refresh), for: .valueChanged);
            refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged);
        }
    }
    
    public var collection: PayloadCollection<T.PayloadType>;
    
    public init(collection: PayloadCollection<T.PayloadType> = PayloadCollection<T.PayloadType>()) {
        self.collection = collection;
        
        super.init(style: .plain);
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.collection = PayloadCollection<T.PayloadType>();
        
        super.init(coder: aDecoder);
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        collection.elementsChanged.append(collectionChanged);
        
        tableView.register(T.self);
        loadData(reload: true);
    }
    
    @objc
    open func refresh() {
        collection.removeAll();
        tableView.reloadData();
        
        refreshControl?.beginRefreshing();
        let contentOffset = CGPoint(x: 0, y: -(refreshControl?.frame.height ?? 0));
        tableView.setContentOffset(contentOffset, animated: true);
        
        loadData(reload: true);
    }
    
    public func loadData(reload: Bool = false) {
        if !collection.canLoadMore && !reload {
            return;
        }
        
        if refreshControl == nil || refreshControl?.isRefreshing == false && collection.count != 0 {
            activityIndicatorView?.startAnimating();
        }
        
        if collection.isLoading {
            return;
        }
        
        collection.loadData();
    }
    
    func collectionChanged(changes: [ElementChange]?) {
        if let changes = changes {
            tableView.beginUpdates();
            
            for change in changes {
                switch change {
                case .delete(let index):
                    tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic);
                    break;
                case .insert(let index):
                    tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic);
                    break;
                case .update(let index):
                    if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? T {
                        willSet(cell: cell);
                        cell.set(collection[index]);
                    }
                    break;
                }
            }
            
            tableView.endUpdates();
        } else {
            tableView.reloadData();
            refreshControl?.endRefreshing();
            activityIndicatorView?.stopAnimating();
        }
    }
    
    override open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row + collection.bufferDelta >= collection.count) {
            loadData();
        }
    }
    
    // MARK: DataSource
    
    open override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collection.count;
    }
    
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T;
        
        willSet(cell: cell);
        cell.set(collection[indexPath.row]);
        
        return cell
    }
    
    open func willSet(cell: T) {
    }
}
