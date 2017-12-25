//
//  UIImageExt.swift
//  Pods-UIKitExtSwiftDemo
//
//  Created by mac on 2017/12/20.
//

import Foundation
import UIKit
import ImageIO
import Accelerate


// MARK: - Draw
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
    
    public func resize(_ size: CGSize) -> UIImage {
        return self.draw(size: size) { _ in
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
    
    public func gaussianBlur(radius: CGFloat) -> UIImage {
        do {
            let result = try CIImage(image: self)?.gaussianBlur(radius: radius)
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


// MARK: - UIImage Color
// from BCColor
// https://github.com/boycechang/BCColor/tree/master/BCColor/BCColor
public struct ImageColors {
    /// The background color.
    public var backgroundColor: UIColor!
    
    /// The primary color.
    public var primaryColor: UIColor!
    
    /// The secondary color.
    public var secondaryColor: UIColor!
    
    /// The minor color.
    public var minorColor: UIColor!
    
    public var averageColor: UIColor!
}

private class CountedColor {
    let color: UIColor
    let count: Int
    
    init(color: UIColor, count: Int) {
        self.color = color
        self.count = count
    }
}

extension UIImage {
    public var colors: ImageColors {
        
        var result = ImageColors()
        
        // get the ratio of width to height
        let ratio = self.size.width/self.size.height
        
        // calculate new r_width and r_height
        let r_width: CGFloat = min(self.size.width, 100)
        let r_height: CGFloat = r_width/ratio
        
        // resize the image to the new r_width and r_height
        let cgImage = self.resize(CGSize(width: r_width, height: r_height)).cgImage
        
        // get the width and height of the new image
        let width = cgImage?.width
        let height = cgImage?.height
        
        // get the colors from the image
        let bytesPerPixel: Int = 4
        let bytesPerRow: Int = width! * bytesPerPixel
        let bitsPerComponent: Int = 8
        let sortedColorComparator: Comparator = { (main, other) -> ComparisonResult in
            let m = main as! CountedColor, o = other as! CountedColor
            if m.count < o.count {
                return ComparisonResult.orderedDescending
            } else if m.count == o.count {
                return ComparisonResult.orderedSame
            } else {
                return ComparisonResult.orderedAscending
            }
        }
        
        // get black and white colors
        let blackColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        let whiteColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        // color detection
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let raw = malloc(bytesPerRow * height!)
        let bitmapInfo = CGImageAlphaInfo.premultipliedFirst.rawValue
        let ctx = CGContext(data: raw, width: width!, height: height!, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        ctx?.draw(cgImage!, in: CGRect(x: 0, y: 0, width: CGFloat(width!), height: CGFloat(height!)))
        
        let data =  ctx?.data
        let imageColors = NSCountedSet(capacity: width! * height!)
        
        // color detection
        for x in 0..<width! {
            for y in 0..<height! {
                let pixel = ((width! * y) + x) * bytesPerPixel
                let color = UIColor(
                    red: round(CGFloat(data!.load(fromByteOffset: pixel + 1, as: UInt8.self)) / 255 * 120) / 120,
                    green: round(CGFloat(data!.load(fromByteOffset: pixel + 2, as: UInt8.self)) / 255 * 120) / 120,
                    blue: round(CGFloat(data!.load(fromByteOffset: pixel + 3, as: UInt8.self)) / 255 * 120) / 120,
                    alpha: 1
                )
                
                imageColors.add(color)
            }
        }
        free(raw)
        
        // preprocess and filter colors that appear seldomly or close to black or white
        let enumerator = imageColors.objectEnumerator()
        let sortedColors = NSMutableArray(capacity: imageColors.count)
        while let kolor = enumerator.nextObject() as? UIColor {
            let colorCount = imageColors.count(for: kolor)
            if 3 < colorCount && !kolor.isBlackOrWhite {
                sortedColors.add(CountedColor(color: kolor, count: colorCount))
            }
        }
        sortedColors.sort(comparator: sortedColorComparator)
        
        // get the background colour
        var backgroundColor: CountedColor
        if 0 < sortedColors.count {
            backgroundColor = sortedColors.object(at: 0) as! CountedColor
        } else {
            backgroundColor = CountedColor(color: blackColor, count: 1)
        }
        result.backgroundColor = backgroundColor.color
        result.averageColor = UIColor.average(sortedColors.map({ ($0 as! CountedColor).color }))
        
        // create theme colors, contrast theme color with background color in lightness, and select cognizable chromatic aberration among theme colors
        let isDarkBackgound = result.backgroundColor.isDark
        for curContainer in sortedColors {
            let kolor = (curContainer as! CountedColor).color
            if (kolor.isDark && isDarkBackgound) || (!kolor.isDark && !isDarkBackgound) {continue}
            
            if result.primaryColor == nil {
                if kolor.isContrasting(result.backgroundColor) {
                    result.primaryColor = kolor
                }
            } else if result.secondaryColor == nil {
                if result.primaryColor.isDistinct(kolor) && kolor.isContrasting(result.backgroundColor) {
                    result.secondaryColor = kolor
                }
            } else if result.minorColor == nil {
                if result.secondaryColor.isDistinct(kolor) && result.primaryColor.isDistinct(kolor) && kolor.isContrasting(result.backgroundColor) {
                    result.minorColor = kolor
                    break
                }
            }
        }
        
        
        if result.primaryColor == nil {
            result.primaryColor = isDarkBackgound ? whiteColor:blackColor
        }
        
        if result.secondaryColor == nil {
            result.secondaryColor = isDarkBackgound ? whiteColor:blackColor
        }
        
        if result.minorColor == nil {
            result.minorColor = isDarkBackgound ? whiteColor:blackColor
        }
        
        return result
    }
}


// MARK: - CIImage
extension CIImage {
    func gaussianBlur(radius: CGFloat) throws -> UIImage? {
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
