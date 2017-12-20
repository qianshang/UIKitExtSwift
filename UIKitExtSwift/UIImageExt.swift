//
//  UIImageExt.swift
//  Pods-UIKitExtSwiftDemo
//
//  Created by mac on 2017/12/20.
//

import Foundation
import UIKit

extension UIImage {
    public static func `init`(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        context.saveGState()
        
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        
        context.restoreGState()
        UIGraphicsEndImageContext()
        
        return image
    }
}
