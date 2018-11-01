//
//  PayloadTableViewController.swift
//  Payload
//
//  Created by Parveen Khatkar on 17/10/18.
//  Copyright © 2018 Codetrix Studio. All rights reserved.
//

import UIKit

open class PayloadTableViewController<T: UITableViewCell & Consignee>: UITableViewController, Searchable {
    public var searchString: String? {
        didSet {
            if oldValue == searchString {return}
            collection.searchString = searchString;
            refresh();
        }
    }
    
    private let activityIndicator = UIRefreshControl();
    
    public var collection: PayloadCollection<T.PayloadType>;
    private let dataSource: PayloadTableViewDataSource<T>;
    
    public init(collection: PayloadCollection<T.PayloadType> = PayloadCollection<T.PayloadType>()) {
        self.collection = collection;
        dataSource = PayloadTableViewDataSource<T>(collection: collection);
        
        super.init(style: .plain);
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.collection = PayloadCollection<T.PayloadType>();
        dataSource = PayloadTableViewDataSource<T>(collection: collection);
        
        super.init(coder: aDecoder);
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        collection.elementsChanged.append(collectionChanged);
        
        setupRefresh();
        
        tableView.register(T.self);
        tableView.dataSource = dataSource;
        loadData(reload: true);
    }
    
    private func setupRefresh() {
        refreshControl = UIRefreshControl();
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged);
        
        tableView.tableFooterView = activityIndicator;
    }
    
    @objc
    private func refresh() {
//        collection.removeAll();
        tableView.reloadData();
        
        refreshControl?.beginRefreshing();
        let contentOffset = CGPoint(x: 0, y: -(refreshControl?.frame.height ?? 0));
        tableView.setContentOffset(contentOffset, animated: true);
        
        loadData(reload: true);
    }
    
    private func loadData(reload: Bool = false) {
        if collection.isLoading {
            return;
        }
        
        if !collection.canLoadMore && !reload {
            return;
        }
        
        if refreshControl?.isRefreshing == false && collection.count != 0 {
            activityIndicator.beginRefreshing();
        }
        
        collection.loadData(reload: reload);
    }
    
    @objc func collectionChanged() {
        self.tableView.reloadData();
        self.refreshControl?.endRefreshing();
        self.activityIndicator.endRefreshing();
    }
    
    override open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row + collection.bufferDelta >= collection.count) {
            loadData();
        }
    }
}
