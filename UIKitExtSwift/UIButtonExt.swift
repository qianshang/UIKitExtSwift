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
}

extension UIButton {
    typealias ResetContentEdgeInsets = (CGSize, CGSize) -> Void
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
    
    public func setImageDirection(_ diretion: ImageDirection) {
        switch diretion {
        case .left:
            break
        case .right:
            if #available(iOS 9.0, *) {
                self.semanticContentAttribute = .forceRightToLeft
            } else {
                self.transform = CGAffineTransform.init(scaleX: -1.0, y: 1.0)
                self.titleLabel?.transform = CGAffineTransform.init(scaleX: -1.0, y: 1.0)
                self.imageView?.transform = CGAffineTransform.init(scaleX: -1.0, y: 1.0)
            }
            
            break
        case .top(let spacing):
            updateContent { titleSize, imageSize in
                self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0.0)
                self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
            }
            
            break
        case .bottom(let spacing):
            updateContent { titleSize, imageSize in
                self.titleEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: -imageSize.width, bottom: 0.0, right: 0.0)
                self.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -(imageSize.height + spacing), right: -titleSize.width)
            }
            break
        }
    }
}
