# LXSegmentManagerModule

#### 项目介绍
 **

### 最完美、最轻量级的 分栏切换
** 

#### 安装说明
方式1 ： cocoapods安装库 
        ** pod 'LXSegmentManager' **
        ** pod install ** 

方式2:   **直接下载压缩包 解压**    **LXSegmentManager **   

#### 使用说明
 **下载后压缩包 解压   请先 pod install  在运行项目** 
  
```
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

```

