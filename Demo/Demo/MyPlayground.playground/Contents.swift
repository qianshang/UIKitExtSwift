//: A UIKit based Playground for presenting user interface
  
import UIKit
import UIKitExtSwift


let img = UIImage.init(color: .blue, size: CGSize(width: 100, height: 100))
let img_1 = img.clips(5)


let c1 = UIColor(0xFF0000)
c1.inverseColor
UIColor(0x0000FF)
let c2 = UIColor(0x0000FF, 0.5)
c1 ++ UIColor(0x0000FF)
let c3 = c1 ++ c2


c3 ~ 50%

c3 ~ Int(0)

c3 ~ Float(0.3)
