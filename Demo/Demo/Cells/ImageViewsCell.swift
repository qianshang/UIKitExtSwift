//
//  ImageViewsCell.swift
//  Demo
//
//  Created by mac on 2018/2/26.
//  Copyright © 2018年 程维. All rights reserved.
//

import UIKit

fileprivate let rowCount: Int = 4
fileprivate let padding: CGFloat = 10
fileprivate let itemWH: CGFloat = (kScreenWidth - 40 - padding * CGFloat(rowCount - 1)) / CGFloat(rowCount)

class ImageViewsCell: UITableViewCell {

    static let cellHeight: CGFloat = padding + (itemWH + padding) * 2
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.selectionStyle = .none
        
        var imgs: [UIImage] = []
        
        let size = CGSize(width: itemWH, height: itemWH)
        let rect = CGRect(origin: .zero, size: size)
        let colors: [UIColor] = [.red, .blue, .yellow]
        
        let smallScale: CGFloat = 0.25
        let smallSize: CGSize = CGSize(width: itemWH * smallScale, height: itemWH * smallScale)
        let smallPoint: CGPoint = CGPoint(x: itemWH * (1 - smallScale) * 0.5, y: itemWH * (1 - smallScale) * 0.5)
        
        
        let img1 = UIImage.ex.color(with: .blue, size: size, storkColor: .red, storkWidth: 10, radius: 50)
        imgs.append(img1)
        
        let img2 = UIImage.ex.linerGradient(colors: colors, size: size)
        imgs.append(img2)
        
        let img3: UIImage = UIImage.ex.color(with: UIColor.radialGradientColor(rect, colors: colors)!, size: size)
        imgs.append(img3)
        
        let img4 = try! UIImage.ex.qrcode(with: "UIKitExtSwift", size: size) ?? UIImage.ex.color(with: .black, size: size)
        imgs.append(img4)
        
        let img5 = img3.ex.clips(itemWH * 0.5).ex.add(img4.ex.resize(smallSize), point: smallPoint)
        imgs.append(img5)
        
        let img6 = img4.ex.add(img3.ex.resize(smallSize).ex.clips(5), point: smallPoint)
        imgs.append(img6)
        
        
        for (index, img) in imgs.enumerated() {
            let col = CGFloat( index % rowCount )
            let row = CGFloat( index / rowCount )
            
            addImageView(with: img, at: CGPoint(x: 20 + col * (itemWH + padding), y: padding + row * (itemWH + padding)))
        }
    }
    
    func addImageView(with image: UIImage, at point: CGPoint) {
        let imageView = UIImageView(image: image)
        imageView.isCouldPreview = true
        imageView.groupId = 0
        imageView.ex.touchEdgeInsets = UIEdgeInsetsMake(-20, -20, -20, -20)
        self.contentView.addSubview(imageView)
        imageView.origin = point
    }
}
