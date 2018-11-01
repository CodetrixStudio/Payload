//
//  PayloadCollectionViewController.swift
//  Payload
//
//  Created by Parveen Khatkar on 2/7/18.
//  Copyright © 2018 Codetrix Studio. All rights reserved.
//

import UIKit

open class PayloadCollectionViewController<T: UICollectionViewCell & Consignee>: UICollectionViewController, Searchable {
    var cellsPerRow: Int { return 3; }
    var cellSpacing: CGFloat {return 3; }
    
    public var searchString: String? {
        didSet {
            if oldValue == searchString {return}
            collection.searchString = searchString;
            refresh();
        }
    }
    
    let refreshControl: UIRefreshControl? = UIRefreshControl();
    
    private let activityIndicator = UIRefreshControl();
    
    public var collection: PayloadCollection<T.PayloadType>;
    private var dataSource: PayloadCollectionViewDataSource<T>;
    
    public init(collection: PayloadCollection<T.PayloadType> = PayloadCollection<T.PayloadType>()) {
        self.collection = collection;
        dataSource = PayloadCollectionViewDataSource<T>(collection: collection);
        
        super.init(collectionViewLayout: UICollectionViewFlowLayout());
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.collection = PayloadCollection<T.PayloadType>();
        dataSource = PayloadCollectionViewDataSource<T>(collection: collection);
        
        super.init(coder: aDecoder);
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad();
        
        collection.elementsChanged.append(collectionChanged);
        // TODO: Refactor this later to understand best way to update size on viewDidLayout
        setupCellSize();
        
        setupRefresh();
        
        collectionView?.register(T.self);
        collectionView?.dataSource = dataSource;
        loadData(reload: true);
        
        applyStyle();
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        setupCellSize();
    }
    
    private func applyStyle() {
        collectionView?.backgroundColor = .clear;
    }
    
    private func setupCellSize() {
        let viewWidth = view.frame.size.width;
        let cellWidth = (viewWidth - cellSpacing * CGFloat(cellsPerRow - 1)) / CGFloat(cellsPerRow);
        
        guard let collectionViewFlowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return }
        collectionViewFlowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth);
        collectionViewFlowLayout.minimumLineSpacing = cellSpacing;
        collectionViewFlowLayout.minimumInteritemSpacing = cellSpacing;
    }
    
    
    private func setupRefresh() {
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged);
        
        if let refreshControl = refreshControl {
            collectionView?.addSubview(refreshControl);
        }
    }
    
    @objc
    private func refresh() {
//        collection.removeAll();
        collectionView?.reloadData();
        refreshControl?.beginRefreshing();
        let contentOffset = CGPoint(x: 0, y: -(refreshControl?.frame.height ?? 0));
        collectionView?.setContentOffset(contentOffset, animated: true);
        
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
    
    private func collectionChanged() {
        collectionView?.reloadData();
        refreshControl?.endRefreshing();
        activityIndicator.endRefreshing();
    }
    
    override open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row + collection.bufferDelta >= collection.count) {
            loadData();
        }
    }
}
