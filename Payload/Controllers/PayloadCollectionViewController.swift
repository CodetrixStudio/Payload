//
//  PayloadCollectionViewController.swift
//  Payload
//
//  Created by Parveen Khatkar on 2/7/18.
//  Copyright © 2018 Codetrix Studio. All rights reserved.
//

import UIKit

open class PayloadCollectionViewController<T: UICollectionViewCell & Consignee>: UICollectionViewController {
    var cellsPerRow: Int { return 3; }
    var cellSpacing: CGFloat {return 3; }
    
    public var activityIndicatorView: (UIView & PayloadActivityIndicator)? = UIActivityIndicatorView() {
        didSet {
            
        }
    }
    
    open var refreshControl: UIRefreshControl? {
        didSet {
            oldValue?.removeTarget(self, action: #selector(refresh), for: .valueChanged);
            
            if let refreshControl = refreshControl {
                collectionView.addSubview(refreshControl);
            }
            refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged);
        }
    }
    
    public var collection: PayloadCollection<T.PayloadType>;
    
    public init(collection: PayloadCollection<T.PayloadType> = PayloadCollection<T.PayloadType>()) {
        self.collection = collection;
        
        super.init(collectionViewLayout: UICollectionViewFlowLayout());
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.collection = PayloadCollection<T.PayloadType>();
        
        super.init(coder: aDecoder);
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad();
        
        collection.elementsChanged.append(collectionChanged);
        // TODO: Refactor this later to understand best way to update size on viewDidLayout
        setupCellSize();
        
        collectionView?.register(T.self);
        loadData(reload: true);
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        setupCellSize();
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
    open func refresh() {
        collection.removeAll();
        collectionView?.reloadData();
        refreshControl?.beginRefreshing();
        let contentOffset = CGPoint(x: 0, y: -(refreshControl?.frame.height ?? 0));
        collectionView?.setContentOffset(contentOffset, animated: true);
        
        loadData(reload: true);
    }
    
    private func loadData(reload: Bool = false) {
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
    
    private func collectionChanged() {
        collectionView?.reloadData();
        refreshControl?.endRefreshing();
        activityIndicatorView?.stopAnimating();
    }
    
    override open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row + collection.bufferDelta >= collection.count) {
            loadData();
        }
    }
    
    // MARK: DataSource
    
    open override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    open override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collection.count;
    }
    
    open override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T;
        
        willSet(cell: cell);
        cell.set(collection[indexPath.row]);
        
        return cell
    }
    
    open func willSet(cell: T) {
    }
}
