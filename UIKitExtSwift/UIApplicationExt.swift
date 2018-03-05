//
//  UIApplicationExt.swift
//  UIKitExtSwift
//
//  Created by mac on 2018/3/5.
//

import Foundation


extension UIApplication {
    
    private static let runOnce: Void = {
        swizzlingForView(UIView.self)
    }()
    
    override open var next: UIResponder? {
        UIApplication.runOnce
        return super.next
    }
}

// 方法交换
fileprivate func swizzling(for type: NSObject.Type,
                           origin originalSelector: Selector,
                           swizzled swizzledSelector: Selector) {
    let originalMethod = class_getInstanceMethod(type, originalSelector)
    let swizzledMethod = class_getInstanceMethod(type, swizzledSelector)
    
    method_exchangeImplementations(originalMethod!, swizzledMethod!)
}

// UIView
private let swizzlingForView: (UIView.Type)->() = { view in
    let originalSelector = #selector(view.point(inside:with:))
    let swizzledSelector = #selector(view.uk_point(inside:with:))
    
    swizzling(for: view, origin: originalSelector, swizzled: swizzledSelector)
}

