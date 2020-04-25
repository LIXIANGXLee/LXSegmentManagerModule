//
//  ViewController.swift
//  LXSegmentManagerModule
//
//  Created by Mac on 2020/4/25.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit
import LXSegmentManager

class ViewController: UIViewController {

override func viewDidLoad() {
    super.viewDidLoad()
           
           let titles = ["游戏", "娱乐娱乐", "趣玩", "文章", "颜值","视频","音乐"]
           var style = TitleStyle()
           style.isScrollEnable = true
           style.isShowScrollLine = true
           style.isTransformScale = true
           
           
           // 2.所以的子控制器
           var childVcs = [UIViewController]()
           for _ in 0..<titles.count {
               let vc = UIViewController()
               vc.view.backgroundColor = UIColor.randomColor()
               childVcs.append(vc)
           }
           
           // 3.pageView的frame
           let pageFrame = CGRect(x: 0, y:88, width: 414, height: 667 - 88 - 83)
           
           // 4.创建HYPageView,并且添加到控制器的view中
           let pageView = PageView(frame: pageFrame, titles: titles, childVcs: childVcs, parentVc: self, style : style)
           view.addSubview(pageView)
       }
}

