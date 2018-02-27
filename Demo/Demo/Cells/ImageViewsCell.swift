//
//  ImageViewsCell.swift
//  Demo
//
//  Created by mac on 2018/2/26.
//  Copyright © 2018年 程维. All rights reserved.
//

import UIKit

class ImageViewsCell: UITableViewCell {

    static let cellHeight: CGFloat = 230
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.selectionStyle = .none
        
        let size = CGSize(width: 100, height: 100)
        let rect = CGRect(origin: .zero, size: size)
        let colors: [UIColor] = [.red, .blue, .yellow]
        
        
        let img1 = UIImage.init(color: .blue, size: size, storkColor: .red, storkWidth: 10, radius: 50)
        let v1 = create(img: img1)
        v1.origin = CGPoint(x: 20, y: 10)
        
        let img2 = UIImage.linerGradient(colors: colors, size: size)
        let v2 = create(img: img2)
        v2.origin = CGPoint(x: kScreenWidth - 120, y: v1.y)
        
        let img3 = try! UIImage.qrcode(content: "UIKitExtSwift", size: size)
        let v3 = create(img: img3!)
        v3.origin = CGPoint(x: v1.x, y: v1.maxY + 10)
        
        let color = UIColor.radialGradientColor(rect, colors: colors)!
        let img4 = UIImage.init(color: color, size: size)
        let v4 = create(img: img4)
        v4.origin = CGPoint(x: v2.x, y: v3.y)
    }
    
    func create(img: UIImage) -> UIView {
        let imageView = UIImageView(image: img)
        imageView.isCouldPreview = true
        imageView.groupId = 0
        imageView.ex.touchEdgeInsets = UIEdgeInsetsMake(-20, -20, -20, -20)
        self.addSubview(imageView)
        
        return imageView
    }
}
