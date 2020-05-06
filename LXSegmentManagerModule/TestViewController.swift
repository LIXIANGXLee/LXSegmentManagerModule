//
//  TestViewController.swift
//  LXSegmentManagerModule
//
//  Created by Mac on 2020/5/2.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit
import LXSegmentManager

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
         let titles = ["游戏游戏", "娱乐娱乐"]
       var style = TitleStyle()
       style.isScrollEnable = false
       style.isShowScrollLine = true
//           style.isTransformScale = true
       
        style.titleFont = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        style.selectTitleFont = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        
       // 2.所以的子控制器
       var childVcs = [UIViewController]()
       for _ in 0..<titles.count {
           let vc = aaViewController()
           vc.view.frame.size.height = 667 - 88 - 83
           vc.view.backgroundColor = UIColor.randomColor()
           childVcs.append(vc)
       }
       
       // 3.pageView的frame
       let pageFrame = CGRect(x: 0, y: 88, width: 414, height: 667 - 88 - 83)
       
       // 4.创建HYPageView,并且添加到控制器的view中
       let pageView = PageView(frame: pageFrame, titles: titles, childVcs: childVcs, parentVc: self, style : style)
       view.addSubview(pageView)
    }
}
