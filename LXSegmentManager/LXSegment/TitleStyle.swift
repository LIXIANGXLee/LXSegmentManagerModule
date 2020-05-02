//
//  TitleStyle.swift
//  LXSegmentManagerModule
//
//  Created by Mac on 2020/4/25.
//  Copyright © 2020 李响. All rights reserved.
//
import UIKit
import LXColorManager


// MARK:- TitleStyle
public struct  TitleStyle {
    
    public init() {}
    
    ///默认滚动条高度
    public var titleHeight: CGFloat = 55
    
    
    ///默认颜色
    public var normalColor: UIColor = UIColor.black
    ///选中后的颜色
    public var selectColor: UIColor = UIColor(r: 255, g: 127, b: 0)
    ///字体
    public var titleFont: UIFont = UIFont.systemFont(ofSize: 26, weight: UIFont.Weight.bold)
    
    
    ///是否能滚动
    public var isScrollEnable: Bool = false
    /// item间距是多少
    public var itemMargin: CGFloat = 20
    
    
    /// 是否有滚动的下划线
    public var isShowScrollLine: Bool = false
    public var scrollLineHeight: CGFloat = 2
    public var scrollLineColor: UIColor = .orange
    
    
    ///是否能缩放效果
    public var isTransformScale = false
    /// 缩放的最大倍数
    public var transformScale: CGFloat = 0.3
    
}
