//
//  UIColor.swift
//  LXSegmentManagerModule
//
//  Created by Mac on 2020/4/25.
//  Copyright © 2020 李响. All rights reserved.
//

//给颜色扩展便利构造方法

import UIKit

extension UIColor {
    
    // MARK: - 在extension中给系统的类扩充构造函数,只能扩充`便利构造函数`
   public convenience init(r : CGFloat, g : CGFloat, b : CGFloat, alpha : CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
    
    // MARK: - 构造函数（十六进制）
   public convenience init?(hex : String, _ alpha : CGFloat = 1.0) {
      
        var cHex = hex.trimmingCharacters(in: CharacterSet.whitespaces).uppercased()
        guard cHex.count >= 6 else {
            return nil
        }
        if cHex.hasPrefix("0X") {
            cHex = String(cHex[cHex.index(cHex.startIndex, offsetBy: 2)..<cHex.endIndex])
        }
        if cHex.hasPrefix("#") {
            cHex = String(cHex[cHex.index(cHex.startIndex, offsetBy: 1)..<cHex.endIndex])
        }
 
        var r : UInt64 = 0
        var g : UInt64  = 0
        var b : UInt64  = 0

        let rHex = cHex[cHex.startIndex..<cHex.index(cHex.startIndex, offsetBy: 2)]
        let gHex = cHex[cHex.index(cHex.startIndex, offsetBy: 2)..<cHex.index(cHex.startIndex, offsetBy: 4)]
        let bHex = cHex[cHex.index(cHex.startIndex, offsetBy: 4)..<cHex.index(cHex.startIndex, offsetBy: 6)]

        Scanner(string: String(rHex)).scanHexInt64(&r)
        Scanner(string: String(gHex)).scanHexInt64(&g)
        Scanner(string: String(bHex)).scanHexInt64(&b)

        self.init(red:CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
    
    // MARK: - 类方法 （随即颜色）
    public class func randomColor() -> UIColor {
       return UIColor(red: CGFloat(arc4random_uniform(256)) / 255.0, green: CGFloat(arc4random_uniform(256)) / 255.0, blue: CGFloat(arc4random_uniform(256)) / 255.0, alpha: 1.0)
    }
     // MARK: - 类方法 （颜色差值）
   public class func getRGBDelta(_ firstColor : UIColor, _ seccondColor : UIColor) -> (CGFloat, CGFloat,  CGFloat) {
        let firstRGB = firstColor.getRGB()
        let secondRGB = seccondColor.getRGB()
        return (firstRGB.0 - secondRGB.0, firstRGB.1 - secondRGB.1, firstRGB.2 - secondRGB.2)
    }
    
     // MARK: - 类方法 （颜色RGB值）
    public func getRGB() -> (CGFloat, CGFloat, CGFloat) {
        guard let cmps = cgColor.components else {
            fatalError("保证普通颜色是RGB方式传入")
        }
        
        return (cmps[0] * 255, cmps[1] * 255, cmps[2] * 255)
    }
}
