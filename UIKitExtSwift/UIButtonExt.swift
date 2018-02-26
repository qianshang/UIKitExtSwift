//
//  UIButtonExt.swift
//  UIKitExtSwift
//
//  Created by mac on 2017/12/20.
//

import Foundation
import UIKit

public enum ImageDirection {
    case left
    case right
    case top(CGFloat)
    case bottom(CGFloat)
    
    fileprivate static func build(with direction: Int, distance: CGFloat) -> ImageDirection {
        switch direction {
        case 1:
            return .right
        case 2:
            return .top(distance)
        case 3:
            return .bottom(distance)
        default:
            return .left
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
        let titleSize = labelString.size(withAttributes: [NSAttributedStringKey.font: font])
        let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0
        
        reset(titleSize, imageSize)
        self.contentEdgeInsets = UIEdgeInsets(top: edgeOffset, left: 0.0, bottom: edgeOffset, right: 0.0)
    }
    
    func setImageDirection(_ diretion: ImageDirection) {
        switch diretion {
        case .left:
            self.imageDirection = 0
            self.imageDistance = 0
        case .right:
            if #available(iOS 9.0, *) {
                self.semanticContentAttribute = .forceRightToLeft
            } else {
                self.transform = CGAffineTransform.init(scaleX: -1.0, y: 1.0)
                self.titleLabel?.transform = CGAffineTransform.init(scaleX: -1.0, y: 1.0)
                self.imageView?.transform = CGAffineTransform.init(scaleX: -1.0, y: 1.0)
            }
            
            self.imageDirection = 1
            self.imageDistance = 0
        case .top(let spacing):
            updateContent { titleSize, imageSize in
                self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0.0)
                self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
            }
            
            self.imageDirection = 2
            self.imageDistance = spacing
        case .bottom(let spacing):
            updateContent { titleSize, imageSize in
                self.titleEdgeInsets = UIEdgeInsets(top: -(imageSize.height + spacing), left: -imageSize.width, bottom: 0.0, right: 0.0)
                self.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -(titleSize.height + spacing), right: -titleSize.width)
            }
            
            self.imageDirection = 3
            self.imageDistance = spacing
        }
    }
    
    
}
