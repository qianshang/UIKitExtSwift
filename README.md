# UIKitExtSwift
UIKit extension of swift

- [UIColor](#1)
- [UIImage](#2)
- [UIButton](#3)
- [UIView](#4)
- [UIApplication](#5)
- [UIControl](#6)
- [UIDevice](#7)
- [CocoaPods](#99)
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
UIImage.ex.color(with: .blue, size: size, storkColor: .red, storkWidth: 10, radius: 50)
// 创建线性渐变色图片
UIImage.ex.linerGradient(colors: colors, size: size)
// 生成一张二维码
try! UIImage.ex.qrcode(with: "UIKitExtSwift", size: size)
// 修改图片大小                             
image.ex.resize(size)
// 获取指定区域的图片
image.ex.subImage(rect)
// 两张图片合成
image.ex.add(flagImage)
// 指定半径和边角裁剪
image.ex.clip(5)
// 将图片渲染成指定颜色
image.ex.render(.gray)
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

## <a name="5"></a>UIApplication

```
// 直接通过UIApplication.shared实例获取当前栈顶控制器
UIApplication.shared.ex.currentViewController?
```

## <a name="6"></a>UIControl

使用`closure`为`UIControl`对象添加事件处理
当前支持通过这种方式添加的事件如下：
- `ouchDown`
- `touchDownRepeat`
- `touchDragInside`
- `touchDragOutside`
- `touchDragEnter`
- `touchDragExit`
- `touchUpInside`
- `touchUpOutside`
- `touchCancel`
- `valueChanged`
- `allEvents`

```
// 给按钮添加`touchDown`事件
btn.ex.touchDown { _ in
   print("btn clicked")
}
```

## <a name="7"></a>UIDevice

```
let iPhoneX: Bool = UIDevice.current.ex.deviceType == .iPhoneX
```

## <a name="99"></a>Cocoapods

```
pod 'UIKitExtSwift'
```

## <a name="100"></a>TODO

- ✓ 使用`Int`、`UInt32`创建`UIColor`
- ✓ 获取`UIColor`的16进制描述
- ✓ 使用指定颜色创建图片
- ✓ 重置图片大小
- ✓ 获取指定区域的图片
- ✓ 将图片渲染成指定颜色
- ✓ 生成一张二维码图片
- ✓ 生成线性渐变图片
- ✓ 设置按钮图片位置
- ✓ 使用闭包为按钮添加事件处理 _*此处没有找到特别好的方法,所以直接添加了部分event事件支持*_
- ✓ `UIView`的位置相关信息
- ✓ `UIView`点击区域扩充
- ✓ 当前设备判断
- ✓ `UITextView`添加placeholder


