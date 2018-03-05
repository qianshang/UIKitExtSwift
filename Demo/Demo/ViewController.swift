//
//  ViewController.swift
//  Demo
//
//  Created by mac on 2017/12/20.
//  Copyright © 2017年 程维. All rights reserved.
//

import UIKit
import UIKitExtSwift


let kScreenWidth: CGFloat = UIScreen.main.bounds.width
let kScreenHeight: CGFloat = UIScreen.main.bounds.height

class ViewController: UIViewController {

    private let kColorsCellResuseId: String     = "ColorsCell"
    private let kImageViewsCellResuseId: String = "ImageViewsCell"
    private let kButtonsCellResuseId: String    = "ButtonsCell"
    private let kViewsCellResuseId: String      = "ViewsCell"
    private var tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(ColorsCell.self, forCellReuseIdentifier: kColorsCellResuseId)
        tableView.register(ImageViewsCell.self, forCellReuseIdentifier: kImageViewsCellResuseId)
        tableView.register(ButtonsCell.self, forCellReuseIdentifier: kButtonsCellResuseId)
        tableView.register(ViewCell.self, forCellReuseIdentifier: kViewsCellResuseId)
        self.view.addSubview(tableView)
        tableView.frame = self.view.bounds
        tableView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0)
        
        tableView.dataSource = self
        tableView.delegate = self
        
//        tableView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(snapshot)))
    }
    
    @objc func snapshot() {
        guard let img: UIImage = tableView.ex.snapshot() else {
            return
        }
        let activity: UIActivityViewController = UIActivityViewController(activityItems: [img], applicationActivities: nil)
        self.showDetailViewController(activity, sender: nil)
    }
    
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = cellForRow(at: indexPath) else {
            return tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleForHeader(in: section)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRow(at: indexPath)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func titleForHeader(in section: Int) -> String? {
        switch section {
        case 0:
            return "颜色"
        case 1:
            return "图片"
        case 2:
            return "按钮"
        case 3:
            return "视图"
        default:
            return nil
        }
    }
    func heightForRow(at indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (0, _):
            return ColorsCell.cellHeight
        case (1, _):
            return ImageViewsCell.cellHeight
        case (2, _):
            return ButtonsCell.cellHeight
        case (3, _):
            return ViewCell.cellHeight
        default:
            return 0
        }
    }
    func cellForRow(at indexPath: IndexPath) -> UITableViewCell? {
        switch (indexPath.section, indexPath.row) {
        case (0, let row):
            return colorsCell(in: row)
        case (1, let row):
            return imageViewCell(in: row)
        case (2, let row):
            return buttonCell(in: row)
        case (3, let row):
            return viewCell(in: row)
        default:
            return nil
        }
    }
    func colorsCell(in row: Int) -> UITableViewCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: kColorsCellResuseId)
        
        return cell
    }
    func imageViewCell(in row: Int) -> UITableViewCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: kImageViewsCellResuseId)
        
        return cell
    }
    func buttonCell(in row: Int) -> UITableViewCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: kButtonsCellResuseId)
        
        return cell
    }
    func viewCell(in row: Int) -> UITableViewCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: kViewsCellResuseId)
        
        return cell
    }
}


extension String {
    public func contentHeight(maxWidth: CGFloat, font: UIFont) -> CGFloat {
        let size: CGSize = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let attribute = [NSAttributedStringKey.font: font]
        return (self as NSString).boundingRect(with: size,
                                               options: [.usesLineFragmentOrigin],
                                               attributes: attribute,
                                               context: nil).size.height
    }
    public func contentWidth(maxHeight: CGFloat, font: UIFont) -> CGFloat {
        let size: CGSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: maxHeight)
        let attribute = [NSAttributedStringKey.font: font]
        return (self as NSString).boundingRect(with: size,
                                               options: [.usesLineFragmentOrigin],
                                               attributes: attribute,
                                               context: nil).size.width
    }
    public func contentSize(maxWidth: CGFloat, font: UIFont) -> CGSize {
        let size: CGSize = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let attribute = [NSAttributedStringKey.font: font]
        return (self as NSString).boundingRect(with: size,
                                               options: [.usesLineFragmentOrigin],
                                               attributes: attribute,
                                               context: nil).size
    }
}
extension UILabel {
    public static func `init`(_ text: String, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.textColor = textColor
        label.text = text
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }
}

