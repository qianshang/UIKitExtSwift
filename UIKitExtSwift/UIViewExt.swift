//
//  UIViewExt.swift
//  Pods-Demo
//
//  Created by mac on 2017/12/20.
//

import Foundation
import UIKit

extension UIView {
    typealias ResetFrame = (inout CGRect) -> Void
    func updateFrame(_ reset: ResetFrame) {
        var frame = self.frame
        
        reset(&frame)
        
        self.frame = frame
    }
    
    public var x: CGFloat {
        set {
            updateFrame { $0.origin.x = newValue }
        }
        get {
            return self.frame.origin.x
        }
    }
    public var midX: CGFloat {
        set {
            updateFrame { $0.origin.x = newValue - $0.width * 0.5 }
        }
        get {
            return self.frame.origin.x + self.frame.width * 0.5
        }
    }
    public var maxX: CGFloat {
        set {
            updateFrame { $0.origin.x = newValue - $0.width }
        }
        get {
            return self.frame.origin.x + self.frame.width
        }
    }
    public var y: CGFloat {
        set {
            updateFrame { $0.origin.y = newValue }
        }
        get {
            return self.frame.origin.y
        }
    }
    public var midY: CGFloat {
        set {
            updateFrame { $0.origin.y = newValue - $0.height * 0.5 }
        }
        get {
            return self.frame.origin.y + self.frame.height * 0.5
        }
    }
    public var maxY: CGFloat {
        set {
            updateFrame { $0.origin.y = newValue - $0.height }
        }
        get {
            return self.frame.origin.y + self.frame.height
        }
    }
    public var origin: CGPoint {
        set {
            updateFrame { $0.origin = newValue }
        }
        get {
            return self.frame.origin
        }
    }
    public var size: CGSize {
        set {
            updateFrame { $0.size = newValue }
        }
        get {
            return self.frame.size
        }
    }
    public var width: CGFloat {
        set {
            updateFrame { $0.size.width = newValue }
        }
        get {
            return self.frame.width
        }
    }
    public var height: CGFloat {
        set {
            updateFrame { $0.size.height = newValue }
        }
        get {
            return self.frame.height
        }
    }
}

extension UIView {
    @discardableResult
    public func shadow(color: UIColor = .gray,
                       offsetX: CGFloat = 3,
                       offsetY: CGFloat = 3,
                       radius: CGFloat = 1,
                       opacity: Float = 1) -> UIView {
        
        let offset = CGSize(width: offsetX, height: offsetY)
        
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
        return self
    }
    
    public func snapshot() -> UIImage? {
        return UIImage.draw(size: self.size) {
            self.layer.render(in: $0!)
        }
    }
}



// MARK: change touch area for UIView
private let swizzling: (UIView.Type) -> () = { view in
    let originalSelector = #selector(view.point(inside:with:))
    let swizzledSelector = #selector(view.uk_point(inside:with:))
    
    let originalMethod = class_getInstanceMethod(view, originalSelector)
    let swizzledMethod = class_getInstanceMethod(view, swizzledSelector)
    
    method_exchangeImplementations(originalMethod!, swizzledMethod!)
}

extension UIApplication {
    
    private static let runOnce: Void = {
        swizzling(UIView.self)
    }()
    
    override open var next: UIResponder? {
        UIApplication.runOnce
        return super.next
    }
}

extension UIView {
    private static let touchAreaInsetPointer = ObjectAssociation<UIEdgeInsets>()
    
    public var touchAreaInset: UIEdgeInsets {
        set { UIView.touchAreaInsetPointer[self] = newValue }
        get { return UIView.touchAreaInsetPointer[self] ?? .zero }
    }
    
    @objc func uk_point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let inset = self.touchAreaInset
        let bounds = self.bounds
        let hitBounds = UIEdgeInsetsInsetRect(bounds, inset)
        return hitBounds.contains(point)
    }
}
