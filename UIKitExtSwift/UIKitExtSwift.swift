//
//  UIKitExtSwift.swift
//  UIKitExtSwift
//
//  Created by mac on 2018/2/26.
//

import Foundation
import UIKit

public final class UIKitExt<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol UIKitExtCompatible {
    associatedtype CompatibleType
    var ex: CompatibleType { get }
}

public extension UIKitExtCompatible {
    public var ex: UIKitExt<Self> {
        get { return UIKitExt(self) }
    }
}

extension UIColor: UIKitExtCompatible {}
extension UIImage: UIKitExtCompatible {}
extension UIView: UIKitExtCompatible {}

