//
//  UIButtonExt.swift
//  UIKitExtSwift
//
//  Created by mac on 2017/12/20.
//

import Foundation
import UIKit

public enum ImageDirection {
    case left(distance: CGFloat)
    case right(distance: CGFloat)
    case top(distance: CGFloat)
    case bottom(distance: CGFloat)
    
    fileprivate static func build(with direction: Int, distance: CGFloat) -> ImageDirection {
        switch direction {
        case 1:
            return .right(distance: distance)
        case 2:
            return .top(distance: distance)
        case 3:
            return .bottom(distance: distance)
        default:
            return .left(distance: distance)
        }
    }
}

extension UIKitExt where Base: UIButton {
    public var imageDirection: ImageDirection {
        get {
            return ImageDirection.build(with: self.base.imageDirection, distance: self.base.imageDistance)
        }
        set {
            self.base.setImageDirection(newValue)
        }
    }
}

extension UIButton {
    typealias ResetContentEdgeInsets = (CGSize, CGSize) -> Void
    
    fileprivate static let direction__ = ObjectAssociation<Int>()
    fileprivate static let distance__  = ObjectAssociation<CGFloat>()
    
    fileprivate var imageDirection: Int {
        get { return UIButton.direction__[self] ?? 0 }
        set { UIButton.direction__[self] = newValue }
    }
    fileprivate var imageDistance: CGFloat {
        get { return UIButton.distance__[self] ?? 0 }
        set { UIButton.distance__[self] = newValue }
    }
    
    func updateContent(_ reset: ResetContentEdgeInsets) {
        guard let imageSize = self.imageView?.image?.size,
            let text = self.titleLabel?.text,
            let font = self.titleLabel?.font
            else { return }
        
        let labelString = NSString(string: text)
        let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: font])
        let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0
        
        reset(titleSize, imageSize)
        self.contentEdgeInsets = UIEdgeInsets(top: edgeOffset, left: 0.0, bottom: edgeOffset, right: 0.0)
    }
    
    func setImageDirection(_ diretion: ImageDirection) {
        switch diretion {
        case .left(distance: let distance):
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: distance * 0.5, bottom: 0, right: -distance * 0.5)
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -distance * 0.5, bottom: 0, right: distance * 0.5)
            
            self.imageDirection = 0
            self.imageDistance = distance
        case .right(distance: let distance):
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -distance * 0.5, bottom: 0, right: distance * 0.5)
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: distance * 0.5, bottom: 0, right: -distance * 0.5)
            
            if #available(iOS 9.0, *) {
                self.semanticContentAttribute = .forceRightToLeft
            } else {
                self.transform = CGAffineTransform.init(scaleX: -1.0, y: 1.0)
                self.titleLabel?.transform = CGAffineTransform.init(scaleX: -1.0, y: 1.0)
                self.imageView?.transform = CGAffineTransform.init(scaleX: -1.0, y: 1.0)
            }
            
            self.imageDirection = 1
            self.imageDistance = distance
        case .top(distance: let distance):
            updateContent { titleSize, imageSize in
                self.titleEdgeInsets = UIEdgeInsets(top: (imageSize.height + distance) * 0.5, left: -imageSize.width, bottom: -(imageSize.height + distance) * 0.5, right: 0.0)
                self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + distance) * 0.5, left: 0.0, bottom: (titleSize.height + distance) * 0.5, right: -titleSize.width)
            }
            
            self.imageDirection = 2
            self.imageDistance = distance
        case .bottom(distance: let distance):
            updateContent { titleSize, imageSize in
                self.titleEdgeInsets = UIEdgeInsets(top: -(imageSize.height + distance) * 0.5, left: -imageSize.width, bottom: (imageSize.height + distance) * 0.5, right: 0.0)
                self.imageEdgeInsets = UIEdgeInsets(top: (titleSize.height + distance) * 0.5, left: 0.0, bottom: -(titleSize.height + distance) * 0.5, right: -titleSize.width)
            }
            
            self.imageDirection = 3
            self.imageDistance = distance
        }
    }
    
    
}
