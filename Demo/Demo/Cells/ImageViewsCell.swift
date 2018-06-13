//
//  ImageViewsCell.swift
//  Demo
//
//  Created by mac on 2018/2/26.
//  Copyright © 2018年 程维. All rights reserved.
//

import UIKit

fileprivate let itemWH: CGFloat = (kScreenWidth - 40 - 30) / 4

class ImageViewsCell: UITableViewCell {

    static let cellHeight: CGFloat = 10 + (itemWH + 10) * 2
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.selectionStyle = .none
        
        let size = CGSize(width: itemWH, height: itemWH)
        let rect = CGRect(origin: .zero, size: size)
        let colors: [UIColor] = [.red, .blue, .yellow]
        
        
        let img1 = UIImage.ex.color(with: .blue, size: size, storkColor: .red, storkWidth: 10, radius: 50)
        let v1 = create(img: img1)
        v1.origin = CGPoint(x: 20, y: 10)
        
        let img2 = UIImage.ex.linerGradient(colors: colors, size: size)
        let v2 = create(img: img2)
        v2.origin = CGPoint(x: v1.maxX + 10, y: v1.y)
        
        let img3 = try! UIImage.ex.qrcode(with: "UIKitExtSwift", size: size)
        let v3 = create(img: img3 ?? img2)
        v3.origin = CGPoint(x: v2.maxX + 10, y: v1.y)
        
        let color = UIColor.radialGradientColor(rect, colors: colors)!
        let img4 = UIImage.ex.color(with: color, size: size)
        let v4 = create(img: img4)
        v4.origin = CGPoint(x: v3.maxX + 10, y: v1.y)
        
        
        let scale: CGFloat = 0.25
        let smallSize: CGSize = CGSize(width: itemWH * scale, height: itemWH * scale)
        let smallPoint: CGPoint = CGPoint(x: itemWH * (1 - scale) * 0.5, y: itemWH * (1 - scale) * 0.5)
        
        let img5 = img4.ex.clips(itemWH * 0.5)
                       .ex.add(img3!.ex.resize(smallSize), point: smallPoint)
        let v5 = create(img: img5)
        v5.origin = CGPoint(x: v1.x, y: v1.maxY + 10)
        
        let img6 = img3!.ex.add(img4.ex.resize(smallSize).ex.clips(5), point: smallPoint)
        let v6 = create(img: img6)
        v6.origin = CGPoint(x: v5.maxX + 10, y: v5.y)
    }
    
    func create(img: UIImage) -> UIView {
        let imageView = UIImageView(image: img)
        imageView.isCouldPreview = true
        imageView.groupId = 0
        imageView.ex.touchEdgeInsets = UIEdgeInsetsMake(-20, -20, -20, -20)
        self.contentView.addSubview(imageView)
        
        return imageView
    }
}
