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
        let colors: [UIColor] = [.red, .blue, .yellow]
        
        
        let img = UIImage.init(color: .blue, size: size, storkColor: .red, storkWidth: 10, radius: 50)
        let imageView = UIImageView(image: img)
        self.view.addSubview(imageView)
        imageView.center = CGPoint(x: 60, y: 70)
        imageView.isCouldPreview = true
        imageView.touchAreaInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        let img1 = UIImage.linerGradient(colors: colors, size: size)
        let imageView1 = UIImageView(image: img1)
        self.view.addSubview(imageView1)
        imageView1.origin = CGPoint(x: imageView.x, y: imageView.maxY)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

