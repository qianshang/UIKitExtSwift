//
//  ColorsCell.swift
//  Demo
//
//  Created by mac on 2018/2/26.
//  Copyright © 2018年 程维. All rights reserved.
//

import UIKit
import UIKitExtSwift

class ColorsCell: UITableViewCell {

    static let cellHeight: CGFloat = 70
    
    let textFont: UIFont = UIFont.systemFont(ofSize: 16)
    lazy var itemHeight: CGFloat = textFont.lineHeight
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.selectionStyle = .none
        
        let count: CGFloat = CGFloat(floor((ColorsCell.cellHeight - 20) / itemHeight))
        let spec: CGFloat = (ColorsCell.cellHeight - 20 - itemHeight * count) / (count + 1)
        for i in 0..<Int(count) {
            let v = createItem(with: (arc4random() % 0xFFFFFF).ex.color)
            self.addSubview(v)
            v.frame = CGRect(x: 0, y: 10 + (itemHeight + spec) * CGFloat(i), width: kScreenWidth, height: itemHeight)
        }
    }
    
    func createItem(with color:UIColor) -> UIView {
        let size: CGSize = CGSize(width: itemHeight, height: itemHeight)
        let img: UIImage = UIImage.init(color: color, size: size, radius: itemHeight * 0.5)
        
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: kScreenWidth, height: itemHeight)))
        self.contentView.addSubview(view)
        
        let imageView = UIImageView(image: img)
        view.addSubview(imageView)
        imageView.frame = CGRect(x: 20, y: 0, width: itemHeight, height: itemHeight)
        
        if let hex: String = color.ex.hexString {
            let label = UILabel.init(hex, textColor: .darkGray)
            label.font = textFont
            view.addSubview(label)
            
            let line: UIView = UIView()
            line.backgroundColor = .lightGray
            view.addSubview(line)
            
            let labelW: CGFloat = hex.contentWidth(maxHeight: itemHeight, font: textFont)
            let lineW: CGFloat = kScreenWidth - 40 - labelW - 10 - itemHeight
            
            line.frame = CGRect(x: imageView.maxX + 5, y: imageView.midY - 0.25, width: lineW, height: 1)
            label.frame = CGRect(x: line.maxX + 5, y: 0, width: labelW, height: itemHeight)
        }
        
        
        
        return view
    }
}
