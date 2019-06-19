//
//  UIApplicationExt.swift
//  UIKitExtSwift
//
//  Created by mac on 2018/3/5.
//

import Foundation

extension UIKitExt where Base: UIApplication {
    public var currentViewController: UIViewController? {
        var vc: UIViewController? = self.base.keyWindow?.rootViewController
        
        while let v = vc {
            if let nav = v as? UINavigationController {
                vc = nav.visibleViewController
            } else if let tab = v as? UITabBarController {
                vc = tab.selectedViewController
            } else if let vv = v.presentedViewController {
                vc = vv
            } else {
                break
            }
        }
        
        return vc
    }
}


extension UIApplication {
    
    private static let runOnce: Void = {
        swizzlingForView(UIView.self)
        swizzlingForTextView(UITextView.self)
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
    guard let originalMethod = class_getInstanceMethod(type, originalSelector),
        let swizzledMethod = class_getInstanceMethod(type, swizzledSelector) else {
            return
    }
    
    if class_addMethod(type,
                       originalSelector,
                       method_getImplementation(swizzledMethod),
                       method_getTypeEncoding(swizzledMethod)) {
        class_replaceMethod(type,
                            originalSelector,
                            method_getImplementation(swizzledMethod),
                            method_getTypeEncoding(swizzledMethod))
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}

// UIView
private let swizzlingForView: (UIView.Type) -> () = { view in
    let originalSelector = #selector(view.point(inside:with:))
    let swizzledSelector = #selector(view.uk_point(inside:with:))
    
    swizzling(for: view, origin: originalSelector, swizzled: swizzledSelector)
}

// UITextView
private let swizzlingForTextView: (UITextView.Type) -> () = { view in
    let originSelector = #selector(view.layoutSubviews)
    let swizzledSelector = #selector(view.uk_layoutSubviews)
    
    swizzling(for: view, origin: originSelector, swizzled: swizzledSelector)
}

