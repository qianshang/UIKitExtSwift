# UIKitExtSwift
UIKit extension of swift

- [UIColor](#1)
- [UIImage](#2)
- [UIButton](#3)
- [UIView](#4)
- [CocoaPods](#5)
- [TODO](#100)


<img src="https://github.com/qianshang/UIKitExtSwift/blob/dev/preview.jpeg" width = "320" alt="预览图片" align=center />


## <a name="1"></a>UIColor

```
// 使用UInt32创建颜色
UIColor(0xFF0000)
UIColor(0xFF0000, 1)
0xFF0000.ex.color

// 获取颜色的16进制描述
UIColor.red.hexString
```

## <a name="2"></a>UIImage
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

## <a name="3"></a>UIButton

```
public enum ImageDirection {
    case left(distance: CGFloat)
    case right(distance: CGFloat)
    case top(distance: CGFloat)
    case bottom(distance: CGFloat)
}

// 指定`UIButton`图片方向以及和文字间的间距
btn.ex.imageDirection = .top(distance: 5)

// 给按钮添加`touchDown`事件
btn.ex.touchDown { _ in
    print("btn clicked")
}
```

## <a name="4"></a>UIView

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

## <a name="5"></a>Cocoapods

```
pod 'UIKitExtSwift'
```

## <a name="100"></a>TODO

- [x]使用`Int``UInt32`创建`UIColor`
- [x]获取`UIColor`的16进制描述
- [x]使用指定颜色创建图片
- [x]重置图片大小
- [x]获取指定区域的图片
- [x]将图片渲染成指定颜色
- [x]生成一张二维码图片
- [x]生成线性渐变图片
- [x]设置按钮图片位置
- [x]使用闭包为按钮添加事件处理 _*此处没有找到特别好的方法,所以直接添加了部分event事件支持*_
- [x]`UIView`的位置相关信息
- [x]`UIView`点击区域扩充
- [ ]加载网络图片
- [ ]图片缓存


