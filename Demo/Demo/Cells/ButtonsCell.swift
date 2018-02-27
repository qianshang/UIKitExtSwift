//
//  ButtonsCell.swift
//  Demo
//
//  Created by mac on 2018/2/26.
//  Copyright © 2018年 程维. All rights reserved.
//

import UIKit
import UIKitExtSwift

class ButtonsCell: UITableViewCell {

    static let cellHeight: CGFloat = 150
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.selectionStyle = .none
        
        let width: CGFloat = 120
        let height: CGFloat = 60
        let size: CGSize = CGSize(width: width, height: height)
        let bg: UIImage = UIImage.init(color: .green, size: size, radius: 10)
        let img: UIImage = UIImage.init(color: .red, size: CGSize(width: 30, height: 30), radius: 5)
        
        let btn1 = addBtn(img: img, title: "图片在左", bg: bg, imageDirection: .left(distance: 5), frame: CGRect(x: 20, y: 10, width: width, height: height))
        let btn2 = addBtn(img: img, title: "图片在右", bg: bg, imageDirection: .right(distance: 5), frame: CGRect(x: kScreenWidth - width - 20, y: 10, width: width, height: height))
        let btn3 = addBtn(img: img, title: "图片在上", bg: bg, imageDirection: .top(distance: 5), frame: CGRect(x: btn1.x, y: btn1.maxY + 10, width: width, height: height))
        let btn4 = addBtn(img: img, title: "图片在下", bg: bg, imageDirection: .bottom(distance: 5), frame: CGRect(x: btn2.x, y: btn3.y, width: width, height: height))
        
        btn3.ex.shadow()
        btn4.ex.shadow()
    }
    
    func addBtn(img: UIImage, title: String, bg: UIImage, imageDirection: ImageDirection, frame: CGRect) -> UIButton {
        let btn: UIButton = UIButton()
        btn.setBackgroundImage(bg, for: .normal)
        btn.setImage(img, for: .normal)
        btn.setTitle(title, for: .normal)
        self.addSubview(btn)
        
        btn.frame = frame
        btn.ex.imageDirection = imageDirection
        
        return btn
    }
    
}