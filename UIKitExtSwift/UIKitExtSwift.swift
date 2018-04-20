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


extension Int: UIKitExtCompatible {}
extension UInt32: UIKitExtCompatible {}
extension UIColor: UIKitExtCompatible {}
extension UIImage: UIKitExtCompatible {}
extension UIView: UIKitExtCompatible {}
extension UIApplication: UIKitExtCompatible {}
extension UIDevice: UIKitExtCompatible {}

/**:
 # 在extension中添加property
 
 使用方法:
 
 extension SimpleClass {
     private static let unsafePointer = ObjectAssociation<Bool>()
 
     var property: Bool {
        get { return SimpleClass.unsafePointer[self] }
        set { SimpleClass.unsafePointer[self] = newValue }
     }
 }
 */
public final class ObjectAssociation<T: Any> {
    
    private let policy: objc_AssociationPolicy
    
    /// - Parameter policy: An association policy that will be used when linking objects.
    public init(policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        
        self.policy = policy
    }
    
    /// Accesses associated object.
    /// - Parameter index: An object whose associated object is to be accessed.
    public subscript(index: Any) -> T? {
        get { return objc_getAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque()) as! T? }
        set { objc_setAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque(), newValue, policy) }
    }
}
