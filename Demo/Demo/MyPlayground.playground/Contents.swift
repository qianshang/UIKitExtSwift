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

let c4 = UIColor(hue: 0.3, saturation: 0.18, brightness: 0.18, alpha: 1)
(c3 ++ c4).hexString

c1.hexString
c2.hexString
c3.hexString
UIColor.average([c1, c2]).hexString

UIColor.average([])

//UIColor.average([c1, c2])

c3 ~ 50%

c3 ~ Int(0)

c3 ~ Float(0.3)

let array =  ["Objective-C", "HTML", "CSS"]
array.reduce("", +)
