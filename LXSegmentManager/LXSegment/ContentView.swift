//
//  ContentView.swift
//  LXSegmentManagerModule
//
//  Created by Mac on 2020/4/25.
//  Copyright © 2020 李响. All rights reserved.
//
import UIKit

private let kContentCellID = "kContentCellID"

public protocol ContentViewDelegate: AnyObject {
    func contentView(_ contentView: ContentView, targetIndex: Int)
    func contentView(_ contentView: ContentView, targetIndex: Int, progress: CGFloat)
}

public class ContentView: UIView {
    
    weak var delegate: ContentViewDelegate?
    
    fileprivate var childVcs: [UIViewController]
    fileprivate var parentVc: UIViewController
    
    fileprivate var startOffsetX: CGFloat = 0
    fileprivate var isForbidScroll: Bool = false
    
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellID)
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.scrollsToTop = false
        collectionView.showsHorizontalScrollIndicator = false
        

        return collectionView
    }()
    
    /// 指定构造器
   public init(frame: CGRect, childVcs: [UIViewController], parentVc: UIViewController) {
        self.childVcs = childVcs
        self.parentVc = parentVc
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension ContentView {
    fileprivate func setupUI() {
        //添加子控制器到父控制器中
        for childVc in childVcs {
            parentVc.addChild(childVc)
        }
        
        //添加UICollection
        addSubview(collectionView)
    }
}


extension ContentView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellID, for: indexPath)
        
        for subView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
        
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        return cell
    }
}


// MARK:- UICollectionView的delegate
extension ContentView: UICollectionViewDelegate {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        contentEndScroll()
        scrollView.isScrollEnabled = true
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            contentEndScroll()
        } else {
            scrollView.isScrollEnabled = false
        }
    }
    
    private func contentEndScroll() {
        //判断是否是禁止状态
        guard !isForbidScroll else { return }
        
        //获取滚动到的位置
        let currentIndex = Int(collectionView.contentOffset.x / collectionView.bounds.width)
        
        //通知titleView进行调整
        delegate?.contentView(self, targetIndex: currentIndex)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isForbidScroll = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //判断和开始时的偏移量是否一致
        guard startOffsetX != scrollView.contentOffset.x, !isForbidScroll else {
            return
        }
        
        //定义targetIndex/progress
        var targetIndex = 0
        var progress: CGFloat = 0.0
        
        //给targetIndex/progress赋值
        let currentIndex = Int(startOffsetX / scrollView.bounds.width)
        if startOffsetX < scrollView.contentOffset.x { // 左滑动
            targetIndex = currentIndex + 1
            if targetIndex > childVcs.count - 1 {
                targetIndex = childVcs.count - 1
            }
            
            progress = (scrollView.contentOffset.x - startOffsetX) / scrollView.bounds.width
        } else { // 右滑动
            targetIndex = currentIndex - 1
            if targetIndex < 0 {
                targetIndex = 0
            }
            
            progress = (startOffsetX - scrollView.contentOffset.x) / scrollView.bounds.width
        }
        
        //通知代理
        delegate?.contentView(self, targetIndex: targetIndex, progress: progress)
    }
}


// MARK:- 遵守TitleViewDelegate
extension ContentView: TitleViewDelegate {
    public func titleView(_ titleView: TitleView, targetIndex: Int) {
        isForbidScroll = true
        
        let indexPath = IndexPath(item: targetIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
}
