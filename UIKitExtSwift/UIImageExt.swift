//
//  UIImageExt.swift
//  Pods-UIKitExtSwiftDemo
//
//  Created by mac on 2017/12/20.
//

import Foundation
import UIKit

extension UIImage {
    public typealias Drawer = (CGContext?) -> Void
    
    public static func draw(size: CGSize = CGSize(width: 1, height: 1),
                            opaque: Bool = false,
                            scale: CGFloat = UIScreen.main.scale,
                            drawer: Drawer? = nil) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        
        drawer?(UIGraphicsGetCurrentContext())
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    public func draw(size: CGSize? = nil,
                     opaque: Bool = false,
                     scale: CGFloat? = nil,
                     drawer: Drawer? = nil) -> UIImage {
        let size = size ?? self.size
        let scale = scale ?? self.scale
        return UIImage.draw(size: size, opaque: opaque, scale: scale, drawer: drawer) ?? self
    }
}

extension UIImage {
    
    /// 创建一个纯色图片
    ///
    /// - Parameters:
    ///   - color: 填充色
    ///   - size: 图片大小
    ///   - storkColor: 边框颜色
    ///   - storkWidth: 边框宽度
    ///   - radius: 圆角大小
    ///   - corners: 圆角位置
    /// - Returns: 创建完成的图片
    public static func `init`(color: UIColor,
                              size: CGSize = CGSize(width: 1, height: 1),
                              storkColor: UIColor? = nil,
                              storkWidth: CGFloat = 0,
                              radius: CGFloat = 0,
                              corners: UIRectCorner = .allCorners) -> UIImage {
        let scale = UIScreen.main.scale
        var rawRect = CGRect(origin: .zero, size: size)
        
        if (storkWidth > 0) {
            rawRect.origin.x    += storkWidth
            rawRect.origin.y    += storkWidth
            rawRect.size.width  -= (storkWidth * 2)
            rawRect.size.height -= (storkWidth * 2)
        }
        
        let path = UIBezierPath.init(roundedRect: rawRect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        return UIImage.draw(size: size, opaque: false, scale: scale, drawer: { _ in
            color.setFill()
            if let sc = storkColor {
                sc.setStroke()
            }
            
            path.fill()
            path.lineWidth = storkWidth
            path.stroke()
        }) ?? UIImage()
    }
    
    
    /// 缩放图片
    ///
    /// - Parameter size: 图片大小
    /// - Returns: 缩放完成的图片
    public func resize(_ size: CGSize) -> UIImage {
        return self.draw { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    
    public func subImage(_ rect: CGRect) -> UIImage {
        let imageRef = CGImage.cropping(self.cgImage!)(to: rect)
        return UIImage(cgImage: imageRef!)
    }
    
    @discardableResult
    public func fixOrientation() -> UIImage {
        if self.imageOrientation == .up {
            return self
        }
        
        guard let cgImage = self.cgImage else {
            return self
        }
        guard let space = cgImage.colorSpace else {
            return self
        }
        var transform = CGAffineTransform.identity
        let size = self.size
        let width = size_t(size.width)
        let height = size_t(size.height)
        
        guard let context = CGContext(data: nil,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: cgImage.bitsPerComponent,
                                      bytesPerRow: 0,
                                      space: space,
                                      bitmapInfo:cgImage.bitmapInfo.rawValue)
            else {
                return self
        }
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: .pi)
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
            break
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: -.pi / 2)
            break
        default:
            break
        }
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
        default:
            break
        }
        
        context.concatenate(transform)
        switch self.imageOrientation {
        case .left, .right, .leftMirrored, .rightMirrored:
            context.draw(cgImage, in: CGRect(origin: .zero, size: CGSize(width: size.height, height: size.width)))
            break
        default:
            context.draw(cgImage, in: CGRect(origin: .zero, size: size))
            break
        }
        guard let cgImg = context.makeImage() else {
            return self
        }
        return UIImage(cgImage: cgImg)
    }
    
    public func clips(_ radius: CGFloat, corners: UIRectCorner = .allCorners) -> UIImage {
        let w = self.size.width
        let h = self.size.height
        let r_ = max(0, radius)
        let m_ = min(w, h) * 0.5
        let r = (r_ > m_) ?m_:r_
        let rect = CGRect(x: 0, y: 0, width: w, height: h)
        
        return self.draw { _ in
            if corners == .allCorners {
                UIBezierPath(roundedRect: rect, cornerRadius: r).addClip()
            } else {
                UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: r, height: r)).addClip()
            }
            self.draw(in: rect)
        }
    }
    
    public func render(_ color: UIColor) -> UIImage {
        let rect = CGRect(origin: .zero, size: self.size)
        
        return self.draw { context in
            self.draw(in: rect)
            context?.setFillColor(color.cgColor)
            context?.setAlpha(1)
            context?.setBlendMode(.sourceAtop)
            context?.fill(rect)
        }
    }
    
    public func blur(radius: CGFloat) -> UIImage {
        do {
            let result = try CIImage(image: self)?.blur(radius: radius)
            return result ?? self
        } catch {
            return self
        }
    }
    
    public func bitmap(size: CGSize) -> UIImage {
        do {
            let result = try CIImage(image: self)?.bitmap(size: size)
            return result ?? self
        } catch {
            return self
        }
    }
    
    public static func qrcode(content: String, size: CGSize) throws -> UIImage? {
        let data = content.data(using: .utf8)
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else {
            throw NSError(domain: "Create filter failure", code: 1001, userInfo: nil)
        }
        
        filter.setDefaults()
        filter.setValue(data, forKey: "inputMessage")
        
        return try filter.outputImage?.bitmap(size: size)
    }
    
    public static func linerGradient(colors: [UIColor],
                                     size: CGSize,
                                     startPoint: CGPoint? = nil,
                                     endPoint: CGPoint? = nil) -> UIImage {
        return UIImage.draw(size: size) { context in
            context?.saveGState()
            
            let colorCount = colors.count
            
            var components: [CGFloat] = Array(repeating: 0.0, count: colorCount*4)
            for (index, color) in colors.enumerated() {
                let cs = color.cgColor.components ?? []
                
                for (j, n) in cs.enumerated() {
                    components[index*4+j] = CGFloat(n)
                }
            }
            
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            
            let gradient = CGGradient(colorSpace: colorSpace, colorComponents: components, locations: nil, count: colorCount)
            let startPoint = startPoint ?? .zero
            let endPoint = endPoint ?? CGPoint(x: size.width, y: 0)
            
            context?.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: .drawsAfterEndLocation)
            
            context?.restoreGState()
        } ?? UIImage()
    }
    
}


extension CIImage {
    func blur(radius: CGFloat) throws -> UIImage? {
        guard let filter = CIFilter(name: "CIGaussianBlur") else {
            throw NSError(domain: "Create filter failure", code: 1001, userInfo: nil)
        }
        filter.setValue(self, forKey: kCIInputImageKey)
        filter.setValue(radius, forKey: kCIInputRadiusKey)
        guard let result = filter.value(forKey: kCIOutputImageKey) as? CIImage else {
            throw NSError(domain: "Get output failure", code: 1002, userInfo: nil)
        }
        
        let context = CIContext(options: nil)
        guard let out = context.createCGImage(result, from: result.extent) else {
            throw NSError(domain: "Create result failure", code: 1003, userInfo: nil)
        }
        
        return UIImage(cgImage: out)
    }
    
    func bitmap(size: CGSize) throws -> UIImage? {
        let extent = self.extent.integral
        let scale = min(size.width/extent.width, size.height/extent.height)
        
        let w = Int(size.width)
        let h = Int(size.height)
        let cs = CGColorSpaceCreateDeviceGray()
        
        guard let bitmapRef = CGContext(data: nil, width: w, height: h, bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: CGImageAlphaInfo.none.rawValue) else {
            throw NSError(domain: "Get context failure", code: 1001, userInfo: nil)
        }
        let context = CIContext(options: nil)
        let bitmapImageRef = context.createCGImage(self, from: extent)
        bitmapRef.interpolationQuality = CGInterpolationQuality.none
        bitmapRef.scaleBy(x: scale, y: scale)
        bitmapRef.draw(bitmapImageRef!, in: extent)
        
        guard let scaledImage = bitmapRef.makeImage() else {
            throw NSError(domain: "Make image failure", code: 1004, userInfo: nil)
        }
        let newImage = UIImage(cgImage: scaledImage)
        
        return newImage
    }
}
