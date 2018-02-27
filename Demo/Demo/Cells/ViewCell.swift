//
//  ViewCell.swift
//  Demo
//
//  Created by mac on 2018/2/27.
//  Copyright © 2018年 程维. All rights reserved.
//

import UIKit

class ViewCell: UITableViewCell {

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
        
        let content: UIView = UIView()
        self.contentView.addSubview(content)
        content.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: ViewCell.cellHeight)
        content.ex.shadow()
        
        let topView: UIView = UIView()
        topView.backgroundColor = .orange
        content.addSubview(topView)
        topView.frame = CGRect(x: 10, y: 10, width: kScreenWidth - 20, height: 80)
        topView.ex.mask(with: rectangleTopPath)
        
        let count: CGFloat = CGFloat(floor((kScreenWidth - 20) / 50))
        let spec: CGFloat = (kScreenWidth - 20 - 50 * count) / (count - 1)
        
        for i in 0..<Int(count) {
            let starView: UIView = UIView()
            starView.backgroundColor = (arc4random() % 0xFFFFFF).ex.color
            content.addSubview(starView)
            starView.frame = CGRect(x: topView.x + (50 + spec) * CGFloat(i), y: topView.maxY, width: 50, height: 50)
            starView.ex.mask(with: starPath)
        }
        
        let bottomView: UIView = UIView()
        bottomView.backgroundColor = .orange
        content.addSubview(bottomView)
        bottomView.frame = CGRect(x: topView.x, y: topView.maxY + 50, width: topView.width, height: topView.height)
        bottomView.ex.mask(with: rectangleBottomPath)
    }

    var starPath: UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 14.641, y: 12.427))
        path.addCurve(to: CGPoint(x: 8.311, y: 32.632), controlPoint1:CGPoint(x: 3.189, y: 14.152), controlPoint2:CGPoint(x: -8.263, y: 15.878))
        path.addCurve(to: CGPoint(x: 24.884, y: 45.119), controlPoint1:CGPoint(x: 6.354, y: 44.46), controlPoint2:CGPoint(x: 4.398, y: 56.288))
        path.addCurve(to: CGPoint(x: 41.457, y: 32.632), controlPoint1:CGPoint(x: 35.127, y: 50.703), controlPoint2:CGPoint(x: 45.37, y: 56.288))
        path.addCurve(to: CGPoint(x: 35.127, y: 12.427), controlPoint1:CGPoint(x: 49.744, y: 24.255), controlPoint2:CGPoint(x: 58.031, y: 15.878))
        path.addCurve(to: CGPoint(x: 14.641, y: 12.427), controlPoint1:CGPoint(x: 30.005, y: 1.665), controlPoint2:CGPoint(x: 24.884, y: -9.097))
        path.close()
        
        return path
    }
    
    var rectangleTopPath: UIBezierPath {
        let w: CGFloat = kScreenWidth - 20
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 60))
        path.addQuadCurve(to: CGPoint(x: w / 2, y: 60), controlPoint: CGPoint(x: w / 4, y: 30))
        path.addQuadCurve(to: CGPoint(x: w, y: 60), controlPoint: CGPoint(x: w / 4 * 3, y: 90))
        path.addLine(to: CGPoint(x: w, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.close()
        
        return path
    }
    
    var rectangleBottomPath: UIBezierPath {
        let w: CGFloat = kScreenWidth - 20
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 20))
        path.addQuadCurve(to: CGPoint(x: w / 2, y: 20), controlPoint: CGPoint(x: w / 4, y: -10))
        path.addQuadCurve(to: CGPoint(x: w, y: 20), controlPoint: CGPoint(x: w / 4 * 3, y: 50))
        path.addLine(to: CGPoint(x: w, y: 80))
        path.addLine(to: CGPoint(x: 0, y: 80))
        path.close()
        
        return path
    }
    
}
