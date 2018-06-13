//
//  TextViewCell.swift
//  Demo
//
//  Created by mac on 2018/6/13.
//  Copyright © 2018年 程维. All rights reserved.
//

import UIKit

class TextViewCell: UITableViewCell {

    static let cellHeight: CGFloat = 200
    
    private var textView: UITextView = UITextView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        selectionStyle = .none
        
        self.contentView.addSubview(textView)
        textView.frame = CGRect(x: 10, y: 10, width: kScreenWidth - 20, height: TextViewCell.cellHeight - 20)
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 0.5
        
        textView.ex.set(placeholder: "请输入。。。You are running into the old problem with floating point numbers that all numbers cannot be represented. The command line is just showing you the full floating point form from memory.In floating point your rounded version is the same number. Since computers are binary, they store floating point numbers as an integer and then divide it by a power of two so 13.95 will be represented in a similar fashion to 125650429603636838/(2**53).Double precision numbers have 53 bits (16 digits) of precision and regular floats have 24 bits (8 digits) of precision. The floating point in Python uses double precision to store the values.For example,")
        
        let btn: UIButton = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 60, height: 40)
        btn.setTitle("👇", for: .normal)
        textView.inputAccessoryView = btn
        
        btn.ex.touchUpInside { _ in
            self.textView.resignFirstResponder()
        }
    }
    
}
