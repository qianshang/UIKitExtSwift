//
//  UIColorExt.swift
//  UIKitExtSwift
//
//  Created by mac on 2017/12/20.
//

import Foundation
import UIKit

extension UIColor {
    public convenience init(_ hex: UInt32, _ alpha: CGFloat = 1) {
        let r = CGFloat(hex >> 16 & 0xFF) / 255.0
        let g = CGFloat(hex >> 8 & 0xFF) / 255.0
        let b = CGFloat(hex & 0xFF) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    
    /**
     Hex string of a UIColor instance, throws error.
     
     - parameter includeAlpha: Whether the alpha should be included.
     */
    public func hexStringThrows(_ includeAlpha: Bool = true) throws -> String  {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        guard r >= 0 && r <= 1 && g >= 0 && g <= 1 && b >= 0 && b <= 1 else {
            throw NSError(domain: "unableToOutputHexStringForWideDisplayColor", code: 1000, userInfo: nil)
        }
        
        if (includeAlpha) {
            return String(format: "#%02X%02X%02X_%.2f", Int(r * 255), Int(g * 255), Int(b * 255), a)
        } else {
            return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
        }
    }
    
    /**
     Hex string of a UIColor instance, fails to empty string.
     
     - parameter includeAlpha: Whether the alpha should be included.
     */
    public var hexString: String  {
        guard let hexString = try? hexStringThrows(true) else {
            return ""
        }
        return hexString
    }
    
    public static func average(_ colors: [UIColor]) -> UIColor {
        let count = colors.count
        if count >= 1 {
            var rawCount: CGFloat = 0
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            for i in 0..<count {
                let color = colors[i]
                let RGB = color.cgColor.components
                if let rgb = RGB, rgb.count >= 4 {
                    rawCount += 1
                    r += rgb[0]
                    g += rgb[1]
                    b += rgb[2]
                    a += rgb[3]
                }
            }
            if rawCount > 0 {
                return UIColor(red: r / rawCount, green: g / rawCount, blue: b / rawCount, alpha: a / rawCount)
            } else {
                return colors.first!
            }
        } else {
            return UIColor(0xFFFFFF)
        }
    }
}

extension Int {
    public var color: UIColor {
        return UIColor(UInt32(self))
    }
}

/**
 let c1 = UIColor(0xFF0000)
 c1.inverseColor
 UIColor(0x0000FF)
 let c2 = UIColor(0x0000FF, 0.5)
 c1 ++ UIColor(0x0000FF)
 let c3 = c1 ++ c2

 */
infix operator ++
public func ++(lhs: UIColor, rhs: UIColor) -> UIColor {
    let lhsRGB = lhs.cgColor.components ?? [0,0,0,1]
    let rhsRGB = rhs.cgColor.components ?? [0,0,0,1]
    if lhsRGB.count >= 4, rhsRGB.count >= 4 {
        return UIColor(red: lhsRGB[0] + rhsRGB[0], green: lhsRGB[1] + rhsRGB[1], blue: lhsRGB[2] + rhsRGB[2], alpha: (lhsRGB[3] + rhsRGB[3]) / 2)
    } else {
        return UIColor.white
    }
}

// MARK: - SwiftyColor
// https://github.com/devxoul/SwiftyColor
/**:
 
    let color = 0x123456.color
 
    let transparent = 0x123456.color ~ 50%
    let red = UIColor.red ~ 10%
    let float = UIColor.blue ~ 0.5 // == 50%
 
    let view = UIView()
    view.alpha = 30% // == 0.3
 
 */
precedencegroup AlphaPrecedence {
    associativity: left
    higherThan: RangeFormationPrecedence
    lowerThan: AdditionPrecedence
}

infix operator ~ : AlphaPrecedence

public func ~ (color: UIColor, alpha: Int) -> UIColor {
    return color ~ CGFloat(alpha)
}
public func ~ (color: UIColor, alpha: Float) -> UIColor {
    return color ~ CGFloat(alpha)
}
public func ~ (color: UIColor, alpha: CGFloat) -> UIColor {
    return color.withAlphaComponent(alpha)
}

/// e.g. `50%`
postfix operator %
public postfix func % (percent: Int) -> CGFloat {
    return CGFloat(percent)%
}
public postfix func % (percent: Float) -> CGFloat {
    return CGFloat(percent)%
}
public postfix func % (percent: CGFloat) -> CGFloat {
    return percent / 100
}

// MARK: - BCColor
// https://github.com/boycechang/BCColor/tree/master/BCColor/BCColor
extension UIColor {
    
    /// Boolean value indicating if the color `isDark`.
    public var isDark: Bool {
        // get the rgba values of the color
        let RGB = self.cgColor.components
        
        // this algorithm uses the the constants (0.299,0.587,0.114) to determine the brightness of the color and if it is less than half (0.5) than it is considered dark
        let b1 = 0.299 * RGB![0]
        let b2 = 0.587 * RGB![1]
        let b3 = 0.114 * RGB![2]
        let brightness = b1 + b2 + b3
        return brightness < 0.5
    }
    
    /// Boolean value indicating if the color `isGray`.
    public var isGray: Bool {
        // get the rgba values of the color
        let RGB = self.cgColor.components
        
        // compute color values that help us determine if the color is gray
        let U1 = -0.147 * RGB![0]
        let U2 = 0.289 * RGB![1]
        let U3 = 0.436 * RGB![2]
        let U = U1 - U2 + U3
        
        let V1 = 0.615 * RGB![0]
        let V2 = 0.515 * RGB![1]
        let V3 = 0.100 * RGB![2]
        let V = V1 - V2 - V3
        
        // check if the U and V values we computed are equivalent to that of gray
        return (abs(U) <= 0.002 && abs(V) <= 0.002)
    }
    
    /// Boolean value indicating if the color `isBlackOrWhite`.
    public var isBlackOrWhite: Bool {
        // get the rgba values of the color
        let RGB = self.cgColor.components
        
        // check if the color values match that of white or black
        return (RGB![0] > 0.91 && RGB![1] > 0.91 && RGB![2] > 0.91) || (RGB![0] < 0.09 && RGB![1] < 0.09 && RGB![2] < 0.09)
    }
    
    /**
     Checks if the color `isDisctinct` from another.
     - Parameter compareColor: The `UIColor` that `self` will be compared with.
     - Returns: A boolean value inidcating if the color is different than the other. `true = distinct` | `false = not distinct`.
     */
    public func isDistinct(_ compareColor: UIColor) -> Bool {
        // get the rgba values for our self
        let bg = self.cgColor.components
        
        // get the rgba values for the color we are comparing to
        let fg = compareColor.cgColor.components
        
        // set a constant threshold
        let threshold: CGFloat = 0.25
        
        // check if they are distinct
        if (abs((bg?[0])!-(fg?[0])!) > threshold) || (abs((bg?[1])!-(fg?[1])!) > threshold) || (abs((bg?[2])!-(fg?[2])!) > threshold) {
            return !(isGray && compareColor.isGray)
        }
        
        // return that they are not distinct
        return false
    }
    
    /**
     Checks if the color `isContrasting` with another color.
     - Parameter compareColor: The `UIColor` that is being compared to `self`.
     - Returns: A boolean value indicating the if the two colors contrast.
     */
    public func isContrasting(_ compareColor: UIColor) -> Bool {
        // get the rgba values for self
        let bg = self.cgColor.components
        
        // get the rgba values for the color we are comparing with
        let fg = compareColor.cgColor.components
        
        // compute the brightness of both colors
        let bgLum1 = 0.299 * bg![0]
        let bgLum2 = 0.587 * bg![1]
        let bgLum3 = 0.114 * bg![2]
        let bgLum = bgLum1 + bgLum2 + bgLum3
        
        let fgLum1 = 0.299 * fg![0]
        let fgLum2 = 0.587 * fg![1]
        let fgLum3 = 0.114 * fg![2]
        let fgLum = fgLum1 + fgLum2 + fgLum3
        
        // calculate the contrast using the values we just computed
        let contrast = (bgLum > fgLum) ? (bgLum+0.05)/(fgLum+0.05) : (fgLum+0.05)/(bgLum+0.05)
        
        // check if they contrast
        return 1.4 < contrast
    }
    
    
    // MARK: Color Processing
    
    /// `UIColor` value that represents the inverse of `self`.
    public var inverseColor: UIColor {
        // get the rgba values of self
        let RGB = self.cgColor.components
        
        // calculate the inverse color
        return UIColor(red: 1 - RGB![0], green: 1 - RGB![1], blue: 1 - RGB![2], alpha: RGB![3])
    }
    
    /**
     Lightens the color by a given `percentage`.
     - Parameter percentage: The `percentage` to lighten by. Values between 0–1.0 are accepted.
     - Returns: A new `UIColor` lightened by a given `percentage`.
     */
    public func lightenByPercentage(_ percentage: CGFloat) -> UIColor {
        // get the hue, sat, brightness, and alpha values
        var h : CGFloat = 0.0
        var s : CGFloat = 0.0
        var b : CGFloat = 0.0
        var a : CGFloat = 0.0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        // increase the brightness value, max makes sure brightness does not go below 0 and min ensures that the brightness value does not go above 1.0
        b = max(min(b + percentage, 1.0), 0.0)
        
        // return a new UIColor with the new values
        return UIColor(hue: h, saturation: s, brightness: b, alpha: a)
    }
    
    /**
     Darkens the color by a given `percentage`.
     - Parameter percentage: The `percentage` to darken by. Values between 0–1.0 are accepted.
     - Returns: A new `UIColor` darkened by a given `percentage`.
     */
    public func darkenByPercentage(_ percentage: CGFloat) -> UIColor {
        return self.lightenByPercentage(-percentage)
    }
    
    
    // MARK: Gradient Methods
    
    /* startPoint / endPoint : (0, 0) is the left top corner, (1, 1) is the right botttom corner
     */
    
    /**
     Creates a gradient color.
     - Parameter startPoint: The `CGPoint` to start the gradient at. _Note: (0,0) is the top left corner._
     - Parameter endPoint: The `CGPoint` to start the gradient at. _Note: (1,1) is the bottom right corner._
     - Parameter frame: The frame of the gradient.
     - Parameter colors: An array of `UIColor`'s that will be included in the gradient.
     - Returns: A new gradient `UIColor`.
     */
    public class func gradientColor(_ startPoint: CGPoint, endPoint: CGPoint, frame: CGRect, colors: [UIColor]) -> UIColor? {
        // init a CAGradientLayer and set its frame
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        
        // turn the array of UIColor's into an array of CGColor's
        let cgColors = colors.map({$0.cgColor})
        
        // set the colors of the gradient
        gradientLayer.colors = cgColors
        
        // set the start and end points of the gradient
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        // start an image context
        UIGraphicsBeginImageContextWithOptions(gradientLayer.bounds.size, false, UIScreen.main.scale)
        
        // draw the gradient layer in the context
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        
        // get the image of the gradient from the current image context
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // end the context
        UIGraphicsEndImageContext()
        
        // return a new UIColor using the gradient image we made
        return UIColor(patternImage: gradientImage!)
    }
    
    /**
     Creates a radial gradient color.
     - Parameter frame: The frame of the gradient.
     - Parameter colors: An array of `UIColor`'s that will be included in the gradient.
     - Returns: A new radially gradient `UIColor`.
     */
    public class func radialGradientColor(_ frame: CGRect, colors: [UIColor]) -> UIColor? {
        // start the image context
        UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.main.scale)
        
        // get an array of CGColor's from the UIColor's
        let cgColors = colors.map({$0.cgColor})
        
        // init a color space
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // get a CFArrayRef from our array of CGColor's
        let arrayRef = cgColors as CFArray
        
        // init the gradient
        let gradient = CGGradient(colorsSpace: colorSpace, colors: arrayRef, locations: nil)
        
        // make the center point in the center
        let centrePoint = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        
        // calculate the radius from the frame
        let radius = max(frame.size.width, frame.size.height)/2
        
        // draw the radial gradient
        UIGraphicsGetCurrentContext()?.drawRadialGradient(gradient!,
                                                          startCenter: centrePoint,
                                                          startRadius: 0,
                                                          endCenter: centrePoint,
                                                          endRadius: radius,
                                                          options: .drawsAfterEndLocation)
        
        // get a UIImage from the current context
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // return a new UIColor from the radial gradient we just made
        return UIColor(patternImage: gradientImage!)
    }
}
