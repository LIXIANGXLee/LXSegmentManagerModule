//
//  TitleView.swift
//  LXSegmentManagerModule
//
//  Created by Mac on 2020/4/25.
//  Copyright © 2020 李响. All rights reserved.
//
import UIKit
import LXFitManager

public protocol TitleViewDelegate: AnyObject {
    func titleView(_ titleView: TitleView, targetIndex: Int)
}

// MARK:- TitleView
public class TitleView: UIView {
    
    public weak var delegate: TitleViewDelegate?
    
    fileprivate var titles: [String]
    fileprivate var style: TitleStyle
    
    fileprivate lazy var currentIndex: Int = 0
    fileprivate lazy var titleLabels: [UILabel] = [UILabel]()
    
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        return scrollView
    }()
    fileprivate lazy var bottomLine: UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.scrollLineColor
        bottomLine.frame.size.height = LXFit.fitFloat(self.style.scrollLineHeight)
        bottomLine.frame.origin.y = self.bounds.height - LXFit.fitFloat(self.style.scrollLineHeight)
        return bottomLine
    }()
    
    /// 指定构造器
   public init(frame: CGRect, titles: [String], style: TitleStyle) {
        self.titles = titles
        self.style = style
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
}

// MARK:- TitleView
extension TitleView {
    fileprivate func setupUI() {
        //添加UIScrollVIew
        addSubview(scrollView)
        
        //添加titleLabel到UIScrollView上
        setupTitleLabels()
        
        //设置titleLabel的frame
        setupTitleLabelsFrame()
        
        //添加滚动条
        if style.isShowScrollLine {
            scrollView.addSubview(bottomLine)
        }
    }
  
    /// 创建title
    private func setupTitleLabels() {
        for (i, title) in titles.enumerated() {
            let titleLabel = UILabel()
            
            titleLabel.isUserInteractionEnabled = true
            titleLabel.text = title
            titleLabel.tag = i
            titleLabel.textAlignment = .center
            titleLabel.textColor = i == 0 ? style.selectColor: style.normalColor
            titleLabel.font = i == 0 ? style.selectTitleFont.fitFont : style.titleFont.fitFont
            scrollView.addSubview(titleLabel)
            titleLabels.append(titleLabel)
            
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_:)))
            titleLabel.addGestureRecognizer(tapGes)
        }
    }
    
    /// 设置title尺寸
    private func setupTitleLabelsFrame() {
        let count = titles.count
        
        for (i, label) in titleLabels.enumerated() {
            var w: CGFloat = 0
            let h: CGFloat = bounds.height
            var x: CGFloat = 0
            let y: CGFloat = 0

            w = (titles[i] as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: style.selectTitleFont.fitFont], context: nil).width
            if style.isScrollEnable { // 可以滚动
                if i == 0 {
                    x = CGFloat(style.itemMargin) * 0.5
                    if style.isShowScrollLine {
                        bottomLine.frame.origin.x = x
                        bottomLine.frame.size.width = w
                    }
                } else {
                    let preLabel = titleLabels[i - 1]
                    x = preLabel.frame.maxX + LXFit.fitFloat(style.itemMargin)
                }
            } else { // 不能滚动
               let margin = (bounds.width - CGFloat(count) * w) / CGFloat(count * 2)
                x = margin + (w + margin * 2) * CGFloat(i)
                
                if i == 0 && style.isShowScrollLine {
                    bottomLine.frame.origin.x = margin
                    bottomLine.frame.size.width = w
                }
            }
            label.frame = CGRect(x: x, y: y, width: w, height: h)
            
            if style.isTransformScale {
                label.transform = CGAffineTransform(scaleX: (i == 0) ? (1.0 + style.transformScale) : 1.0, y: (i == 0) ? (1.0 + style.transformScale) : 1.0)
            }
        }
        
        scrollView.contentSize = style.isScrollEnable ? CGSize(width: titleLabels.last!.frame.maxX + LXFit.fitFloat(style.itemMargin) * 0.5, height: 0): CGSize.zero
    }
}


// MARK:- 监听事件
extension TitleView {
    /// title点击事件
    @objc fileprivate func titleLabelClick(_ tapGes: UITapGestureRecognizer) {

        let targetLabel = tapGes.view as! UILabel
 
        //调整bottomLine
        adjustScrollLine(targetLabel:targetLabel)

       //调整title
        adjustTitleLabel(targetIndex: targetLabel.tag)
        
        //通知代理
        delegate?.titleView(self, targetIndex: currentIndex)
    }
    
    /// 调整title
    fileprivate func adjustTitleLabel(targetIndex: Int) {
        
        if targetIndex == currentIndex { return }
        
        //取出Label
        let targetLabel = titleLabels[targetIndex]
        let sourceLabel = titleLabels[currentIndex]
        
        //切换文字的颜色
        targetLabel.textColor = style.selectColor
        sourceLabel.textColor = style.normalColor
        
        targetLabel.font = style.selectTitleFont.fitFont
        sourceLabel.font = style.titleFont.fitFont
        
        //记录下标值
        currentIndex = targetIndex
        
        //调整位置（剧中显示）
        if style.isScrollEnable {
            if let mW = self.titleLabels.last?.frame.maxX  {
                if  mW < bounds.width {return}
            }
            var offsetX = targetLabel.center.x - scrollView.bounds.width * 0.5
            if offsetX < 0 {
                offsetX = 0
            }
            if offsetX > (scrollView.contentSize.width - scrollView.bounds.width) {
                offsetX = scrollView.contentSize.width - scrollView.bounds.width
            }
            scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        }
        
        //Label渐变过程
        if style.isTransformScale {
            UIView.animate(withDuration: 0.25) {
                targetLabel.transform = CGAffineTransform(scaleX: 1.0 + self.style.transformScale , y:  1.0 + self.style.transformScale )
                sourceLabel.transform = CGAffineTransform(scaleX: 1.0, y:  1.0)
            }
        }
    }
    
    /// 调整line尺寸
    fileprivate func adjustScrollLine(targetLabel: UILabel) {
        if style.isShowScrollLine {
            UIView.animate(withDuration: 0.25) {
                self.bottomLine.frame.origin.x = targetLabel.frame.origin.x
                self.bottomLine.frame.size.width = targetLabel.frame.width
            }
        }
    }
    
  
}


// MARK:- 遵守ContentViewDelegate
extension TitleView: ContentViewDelegate {
    public func contentView(_ contentView: ContentView, targetIndex: Int) {
        adjustTitleLabel(targetIndex: targetIndex)
    }
    
    public func contentView(_ contentView: ContentView, targetIndex: Int, progress: CGFloat) {
        setContentView(of: currentIndex, targetIndex: targetIndex, progress: progress)
    }
}


// MARK:- 给外界扩充函数
extension TitleView {
    public func setContentView(of currentIndex: Int, targetIndex: Int, progress: CGFloat) {
        //取出Label
        let targetLabel = titleLabels[targetIndex]
        let sourceLabel = titleLabels[currentIndex]
        
        //颜色渐变
        let deltaRGB = UIColor.getRGBDelta(style.selectColor, style.normalColor)
        let selectRGB = style.selectColor.getRGB()
        let normalRGB = style.normalColor.getRGB()
        targetLabel.textColor = UIColor(r: normalRGB.0 + deltaRGB.0 * progress, g: normalRGB.1 + deltaRGB.1 * progress, b: normalRGB.2 + deltaRGB.2 * progress)
        sourceLabel.textColor = UIColor(r: selectRGB.0 - deltaRGB.0 * progress, g: selectRGB.1 - deltaRGB.1 * progress, b: selectRGB.2 - deltaRGB.2 * progress)
        
        //bottomLine渐变过程
        if style.isShowScrollLine {
            let deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
            let deltaW = targetLabel.frame.width - sourceLabel.frame.width
            bottomLine.frame.origin.x = sourceLabel.frame.origin.x + deltaX * progress
            bottomLine.frame.size.width = sourceLabel.frame.width + deltaW * progress
        }
        
        //Label渐变过程
        if style.isTransformScale {
            targetLabel.transform = CGAffineTransform(scaleX: 1 + style.transformScale * progress, y:  1 + style.transformScale * progress)
            sourceLabel.transform = CGAffineTransform(scaleX: (1 + style.transformScale) - style.transformScale * progress, y:  (1 + style.transformScale) - style.transformScale * progress)
        }
    }
}
