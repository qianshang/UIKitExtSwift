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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
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
            
            let imageView = addImageView(with: img, at: CGPoint(x: 20 + col * (itemWH + padding), y: padding + row * (itemWH + padding)))
            if index == 3 {
                imageView.addGradientMask(colors: [.red, .orange, .cyan])
            }
        }
    }
    
    @discardableResult
    func addImageView(with image: UIImage, at point: CGPoint) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.isCouldPreview = true
        imageView.groupId = 0
        imageView.ex.touchEdgeInsets = UIEdgeInsets.init(top: -20, left: -20, bottom: -20, right: -20)
        self.contentView.addSubview(imageView)
        imageView.origin = point
        
        return imageView
    }
}

extension UIImageView {
    func addGradientMask(colors: [UIColor]? = nil,
                         startPoint: CGPoint = CGPoint(x: 0, y: 0),
                         endPoint: CGPoint = CGPoint(x: 0, y: 1)
        ) {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = colors?.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        self.layer.addSublayer(gradientLayer)
        gradientLayer.frame = bounds
        
        let maskLayer = CALayer()
        self.layer.insertSublayer(maskLayer, at: 0)
        
        maskLayer.frame = bounds
        let img = genQRCodeImageMask(grayScaleQRCodeImage: image)
        maskLayer.contents = img
        
        gradientLayer.mask = maskLayer
    }
}

func genQRCodeImageMask(grayScaleQRCodeImage: UIImage?) -> CGImage? {
    if let image = grayScaleQRCodeImage {
        let bitsPerComponent = 8
        let bytesPerPixel = 4
        let width:Int = Int(image.size.width)
        let height:Int = Int(image.size.height)
        let imageData = UnsafeMutableRawPointer.allocate(byteCount: Int(width * height * bytesPerPixel), alignment: 8)
        
        // 将原始黑白二维码图片绘制到像素格式为ARGB的图片上，绘制后的像素数据在imageData中。
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let imageContext = CGContext.init(data: imageData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: bitsPerComponent, bytesPerRow: width * bytesPerPixel, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue )
        UIGraphicsPushContext(imageContext!)
        imageContext?.translateBy(x: 0, y: CGFloat(height))
        imageContext?.scaleBy(x: 1, y: -1)
        image.draw(in: CGRect.init(x: 0, y: 0, width: width, height: height))
        UIGraphicsPopContext()
        
        // 根据每个像素R通道的值修改Alpha通道的值，当Red大于100，则将Alpha置为0，反之置为255
        for row in 0..<height {
            for col in 0..<width {
                let offset = row * width * bytesPerPixel + col * bytesPerPixel
                let r = imageData.load(fromByteOffset: offset + 1, as: UInt8.self)
                let alpha:UInt8 = r > 100 ? 0 : 255
                imageData.storeBytes(of: alpha, toByteOffset: offset, as: UInt8.self)
            }
        }
        
        return imageContext?.makeImage()
    }
    return nil
}


