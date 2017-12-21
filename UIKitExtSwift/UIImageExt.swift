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
    
    
    /// 创建一个线性渐变图片
    ///
    /// - Parameters:
    ///   - colors: 渐变色数组
    ///   - size: 图片大小
    ///   - startPoint: 开始位置
    ///   - endPoint: 结束位置
    /// - Returns: 渐变图片
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

extension UIImage {
    /*
    func blur(radius: CGFloat,
              tintColor: UIColor,
              tintMode: CGBlendMode,
              saturation: CGFloat,
              maskImage: UIImage? = nil) -> UIImage {
        guard self.size.width >= 1,
            self.size.height >= 1,
            let imageRef = self.cgImage else {
                return self
        }
        if let mask = maskImage, let _ = mask.cgImage {
            return self
        }
        
        let hasBlur = radius > CGFloat(Float.ulpOfOne)
        let hasSaturation = fabs(saturation - 1.0) > CGFloat(Float.ulpOfOne)
        let size = self.size
        let rect = CGRect(origin: .zero, size: size)
        let scale = self.scale
        let opaque = false
        
        if (!hasBlur && !hasSaturation) {
            return [self _yy_mergeImageRef:imageRef tintColor:tintColor tintBlendMode:tintBlendMode maskImage:maskImage opaque:opaque];
        }
        
        vImage_Buffer effect = { 0 }, scratch = { 0 };
        vImage_Buffer *input = NULL, *output = NULL;
        
        vImage_CGImageFormat format = {
            .bitsPerComponent = 8,
            .bitsPerPixel = 32,
            .colorSpace = NULL,
            .bitmapInfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little, //requests a BGRA buffer.
            .version = 0,
            .decode = NULL,
            .renderingIntent = kCGRenderingIntentDefault
        };
        
        if (hasNewFunc) {
            vImage_Error err;
            err = vImageBuffer_InitWithCGImage(&effect, &format, NULL, imageRef, kvImagePrintDiagnosticsToConsole);
            if (err != kvImageNoError) {
                NSLog(@"UIImage+YYAdd error: vImageBuffer_InitWithCGImage returned error code %zi for inputImage: %@", err, self);
                return nil;
            }
            err = vImageBuffer_Init(&scratch, effect.height, effect.width, format.bitsPerPixel, kvImageNoFlags);
            if (err != kvImageNoError) {
                NSLog(@"UIImage+YYAdd error: vImageBuffer_Init returned error code %zi for inputImage: %@", err, self);
                return nil;
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
            CGContextRef effectCtx = UIGraphicsGetCurrentContext();
            CGContextScaleCTM(effectCtx, 1.0, -1.0);
            CGContextTranslateCTM(effectCtx, 0, -size.height);
            CGContextDrawImage(effectCtx, rect, imageRef);
            effect.data     = CGBitmapContextGetData(effectCtx);
            effect.width    = CGBitmapContextGetWidth(effectCtx);
            effect.height   = CGBitmapContextGetHeight(effectCtx);
            effect.rowBytes = CGBitmapContextGetBytesPerRow(effectCtx);
            
            UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
            CGContextRef scratchCtx = UIGraphicsGetCurrentContext();
            scratch.data     = CGBitmapContextGetData(scratchCtx);
            scratch.width    = CGBitmapContextGetWidth(scratchCtx);
            scratch.height   = CGBitmapContextGetHeight(scratchCtx);
            scratch.rowBytes = CGBitmapContextGetBytesPerRow(scratchCtx);
        }
        
        input = &effect;
        output = &scratch;
        
        if (hasBlur) {
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = blurRadius * scale;
            if (inputRadius - 2.0 < __FLT_EPSILON__) inputRadius = 2.0;
            uint32_t radius = floor((inputRadius * 3.0 * sqrt(2 * M_PI) / 4 + 0.5) / 2);
            radius |= 1; // force radius to be odd so that the three box-blur methodology works.
            int iterations;
            if (blurRadius * scale < 0.5) iterations = 1;
            else if (blurRadius * scale < 1.5) iterations = 2;
            else iterations = 3;
            NSInteger tempSize = vImageBoxConvolve_ARGB8888(input, output, NULL, 0, 0, radius, radius, NULL, kvImageGetTempBufferSize | kvImageEdgeExtend);
            void *temp = malloc(tempSize);
            for (int i = 0; i < iterations; i++) {
                vImageBoxConvolve_ARGB8888(input, output, temp, 0, 0, radius, radius, NULL, kvImageEdgeExtend);
                YY_SWAP(input, output);
            }
            free(temp);
        }
        
        
        if (hasSaturation) {
            // These values appear in the W3C Filter Effects spec:
            // https://dvcs.w3.org/hg/FXTF/raw-file/default/filters/Publish.html#grayscaleEquivalent
            CGFloat s = saturation;
            CGFloat matrixFloat[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                0,                    0,                    0,                    1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(matrixFloat) / sizeof(matrixFloat[0]);
            int16_t matrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                matrix[i] = (int16_t)roundf(matrixFloat[i] * divisor);
            }
            vImageMatrixMultiply_ARGB8888(input, output, matrix, divisor, NULL, NULL, kvImageNoFlags);
            YY_SWAP(input, output);
        }
        
        UIImage *outputImage = nil;
        if (hasNewFunc) {
            CGImageRef effectCGImage = NULL;
            effectCGImage = vImageCreateCGImageFromBuffer(input, &format, &_yy_cleanupBuffer, NULL, kvImageNoAllocate, NULL);
            if (effectCGImage == NULL) {
                effectCGImage = vImageCreateCGImageFromBuffer(input, &format, NULL, NULL, kvImageNoFlags, NULL);
                free(input->data);
            }
            free(output->data);
            outputImage = [self _yy_mergeImageRef:effectCGImage tintColor:tintColor tintBlendMode:tintBlendMode maskImage:maskImage opaque:opaque];
            CGImageRelease(effectCGImage);
        } else {
            CGImageRef effectCGImage;
            UIImage *effectImage;
            if (input != &effect) effectImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            if (input == &effect) effectImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            effectCGImage = effectImage.CGImage;
            outputImage = [self _yy_mergeImageRef:effectCGImage tintColor:tintColor tintBlendMode:tintBlendMode maskImage:maskImage opaque:opaque];
        }
        return outputImage;
        
    }
    
    func merge(imageRef: CGImage,
               tintColor: UIColor? = nil,
               tintBlendMode: CGBlendMode,
               maskImage: UIImage? = nil,
               opaque: Bool = false) -> UIImage {
        guard tintColor == nil, maskImage == nil else {
            return UIImage(cgImage: imageRef)
        }
        let size = self.size
        let rect = CGRect(origin: .zero, size: size)
        let scale = self.scale
        
        return self.draw { context in
            context?.ctm = CGAffineTransform(scaleX: 1.0, y: -1.0)
            
        }
    }
    */
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
