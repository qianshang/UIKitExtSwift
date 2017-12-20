//
//  ViewController.swift
//  UIKitExtSwiftDemo
//
//  Created by mac on 2017/12/20.
//  Copyright © 2017年 程维. All rights reserved.
//

import UIKit
import UIKitExtSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let img = UIImage.init(color: .red, size: CGSize(width: 100, height: 100))
        let imgView = UIImageView(image: img)
        self.view.addSubview(imgView)
        imgView.center = self.view.center
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

