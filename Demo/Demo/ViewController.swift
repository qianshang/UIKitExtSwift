//
//  ViewController.swift
//  Demo
//
//  Created by mac on 2017/12/20.
//  Copyright © 2017年 程维. All rights reserved.
//

import UIKit
import UIKitExtSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let size = CGSize(width: 100, height: 100)
        let rect = CGRect(origin: .zero, size: size)
        let colors: [UIColor] = [.red, .blue, .yellow]
        
        self.view.backgroundColor = UIColor.gradientColor(.zero, endPoint: CGPoint(x: 1, y: 1), frame: self.view.bounds, colors: [.white, .black])
        
        
        let img1 = UIImage.init(color: .blue, size: size, storkColor: .red, storkWidth: 10, radius: 50)
        let v1 = create(img: img1)
        v1.y = 20

        let img2 = UIImage.linerGradient(colors: colors, size: size)
        let v2 = create(img: img2)
        v2.y = v1.maxY + 10

        let img3 = try! UIImage.qrcode(content: "UIKitExtSwift", size: size)
        let v3 = create(img: img3!)
        v3.y = v2.maxY + 10

        let color = UIColor.radialGradientColor(rect, colors: colors)!
        let img4 = UIImage.init(color: color, size: size)
        let v4 = create(img: img4)
        v4.y = v3.maxY + 10
    }
    
    func create(img: UIImage) -> UIView {
        let size = img.size
        let screenWidth = UIScreen.main.bounds.width
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: screenWidth, height: size.height)))
        self.view.addSubview(view)
        
        let imageView = UIImageView(image: img)
        view.addSubview(imageView)
        imageView.isCouldPreview = true
        imageView.groupId = 0
        imageView.frame = CGRect(origin: .zero, size: size)
        
        imageView.touchAreaInset = UIEdgeInsetsMake(-20, -20, -20, -20)
        
        let validWidth: CGFloat = screenWidth - imageView.maxX - 10
        let validHeight: CGFloat = imageView.height
        let texts: [String] = [
            "背景色:\t",
            "主色调:\t",
            "副色调:\t",
            "少量色:\t"]
        let colors: [UIColor] = [
            img.colors.backgroundColor,
            img.colors.primaryColor,
            img.colors.secondaryColor,
            img.colors.minorColor
        ]
        for i in 0..<4 {
            let text = texts[i]
            let color = colors[i]
            let label = UILabel.init("\(text)\(color.hexString)", textColor: color)
            view.addSubview(label)
            
            label.frame = CGRect(x: imageView.maxX + 10, y: (validHeight / 4) * CGFloat(i), width: validWidth, height: validHeight / 4)
        }
        
//        view.backgroundColor = img.colors.backgroundColor.inverseColor
        
        return view
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension String {
    public func textSize(_ font: UIFont,
                         validWidth: CGFloat = UIScreen.main.bounds.width,
                         maxHeight: CGFloat = CGFloat(Float.greatestFiniteMagnitude)) -> CGSize {
        let validSize = CGSize(width: validWidth, height: maxHeight)
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        let attributes = [NSAttributedStringKey.font: font]
        return (self as NSString).boundingRect(with: validSize,
                                               options: options,
                                               attributes: attributes,
                                               context: nil).size
    }
}
extension UILabel {
    public static func `init`(_ text: String, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.textColor = textColor
        label.text = text
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }
}

