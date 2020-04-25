//
//  PageView.swift
//  LXSegmentManagerModule
//
//  Created by Mac on 2020/4/25.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

public class PageView: UIView {
    
    fileprivate var titles: [String]
    fileprivate var childVcs: [UIViewController]
    fileprivate var parentVc: UIViewController
    fileprivate var style: TitleStyle
    
    fileprivate var titleView: TitleView!
    fileprivate var contentView: ContentView!
    
    /// 构造函数
   public init(frame: CGRect, titles: [String], childVcs: [UIViewController], parentVc: UIViewController, style: TitleStyle) {
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = parentVc
        self.style = style
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK:- 设置UI界面
extension PageView {
    fileprivate func setupUI() {
        //添加滚动条
        setupTitleView()
        //添加内容View
        setupContentView()
        
        //contentView&titleView代理设置
        titleView.delegate = contentView
        contentView.delegate = titleView
    }
    
    private func setupTitleView() {
        let titleFrame = CGRect(x: 0, y: 0, width: bounds.width, height: style.titleHeight)
        titleView = TitleView(frame: titleFrame, titles: titles, style: style)
        addSubview(titleView)
        titleView.backgroundColor = UIColor.white
    }
    
    private func setupContentView() {
        let contentFrame = CGRect(x: 0, y: style.titleHeight, width: bounds.width, height: bounds.height - style.titleHeight)
        contentView = ContentView(frame: contentFrame, childVcs: childVcs, parentVc: parentVc)
        addSubview(contentView)
        contentView.backgroundColor = UIColor.white
      
    }
}
