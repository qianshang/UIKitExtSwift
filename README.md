# UIKitExtSwift
UIKit extension of swift

<img src="/Users/mac/Documents/Swift/UIKitExtSwift/preview.jpeg" width = "320" alt="预览图片" align=center />

[TOC]


## UIColor

```
// 使用UInt32创建颜色
UIColor(0xFF0000)
UIColor(0xFF0000, 1)
0xFF0000.ex.color

// 获取颜色的16进制描述
UIColor.red.hexString
```

## UIImage
```
// 使用指定颜色创建图片
public static func `init`(color: UIColor,
                              size: CGSize = CGSize(width: 1, height: 1),
                              storkColor: UIColor? = nil,
                              storkWidth: CGFloat = 0,
                              radius: CGFloat = 0,
                              corners: UIRectCorner = .allCorners) -> UIImage
// 修改图片大小                             
public func resize(_ size: CGSize) -> UIImage
// 获取指定区域的图片
public func subImage(_ rect: CGRect) -> UIImage
// 两张图片合成
public func add(_ image: UIImage, point: CGPoint? = nil) -> UIImage
// 指定半径和边角裁剪
public func clips(_ radius: CGFloat, corners: UIRectCorner = .allCorners) -> UIImage
// 将图片渲染成指定颜色
public func render(_ color: UIColor) -> UIImage
// 生成一张二维码
public static func qrcode(content: String, size: CGSize) throws -> UIImage?
// 创建线性渐变色图片
public static func linerGradient(colors: [UIColor],
                                     size: CGSize,
                                     startPoint: CGPoint? = nil,
                                     endPoint: CGPoint? = nil) -> UIImage
```

## UIButton

```
public enum ImageDirection {
    case left(distance: CGFloat)
    case right(distance: CGFloat)
    case top(distance: CGFloat)
    case bottom(distance: CGFloat)
}
```
指定`UIButton`图片方向以及和文字间的间距
```
btn.ex.imageDirection = .top(distance: 5)
```

## UIView

```
public var x: CGFloat
public var midX: CGFloat
public var maxX: CGFloat
public var y: CGFloat
public var midY: CGFloat
public var maxY: CGFloat
public var origin: CGPoint
public var size: CGSize
public var width: CGFloat
public var height: CGFloat
```

```
public var touchEdgeInsets: UIEdgeInsets
public func snapshot() -> UIImage?
public func shadow(color: UIColor = .gray,
                       offsetX: CGFloat = 3,
                       offsetY: CGFloat = 3,
                       radius: CGFloat = 1,
                       opacity: Float = 1) -> UIView

let v: UIView = UIView()
v.ex.touchEdgeInsets = UIEdgeInsetsMake(-20, -20, -20, -20)
v.ex.shadow()
v.ex.snapshot()
```

## Cocoapods

```
pod 'UIKitExtSwift'
```

