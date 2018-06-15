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

    struct CellType {
        let type: UITableViewCell.Type
        let title: String
        let reuseId: String
        let cellHeight: CGFloat
        
        init(_ cellType: UITableViewCell.Type, _ sectionTitle: String, _ id: String, _ height: CGFloat = 44) {
            type = cellType
            title = sectionTitle
            reuseId = id
            cellHeight = height
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    private var cells: [CellType] {
        var arr: [CellType] = []
        arr.append(CellType(ColorsCell.self,     "颜色",  "ColorsCell",     ColorsCell.cellHeight))
        arr.append(CellType(ImageViewsCell.self, "图片",  "ImageViewsCell", ImageViewsCell.cellHeight))
        arr.append(CellType(ButtonsCell.self,    "按钮",  "ButtonsCell",    ButtonsCell.cellHeight))
        arr.append(CellType(ViewCell.self,       "试图",  "ViewsCell",      ViewCell.cellHeight))
        arr.append(CellType(TextViewCell.self,   "文本框", "TextViewCell",   TextViewCell.cellHeight))
        return arr
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        if UIDevice.current.ex.deviceType == .iPhoneX {
            print("iPhoneX")
        }
        
        tableView.backgroundView = UIImageView(image: UIImage.ex.color(with: 0xF0F0F0.ex.color))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDismiss), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func setupUI() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        cells.forEach { item in
            tableView.register(item.type, forCellReuseIdentifier: item.reuseId)
        }
        tableView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .automatic
        } else {
            self.automaticallyAdjustsScrollViewInsets = true
        }
    }
    
    @objc func snapshot() {
        guard let img: UIImage = tableView.ex.snapshot() else {
            return
        }
        let activity: UIActivityViewController = UIActivityViewController(activityItems: [img], applicationActivities: nil)
        self.showDetailViewController(activity, sender: nil)
    }
    
    @objc func keyboardWillShow(_ note: Notification) {
        guard let frame = note.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        bottomConstraint.constant = -frame.height
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: self.cells.count-1), at: .top, animated: true)
        }
    }
    @objc func keyboardWillDismiss() {
        bottomConstraint.constant = 0
    }
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cells[indexPath.section].reuseId) else {
            return tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return cells[section].title
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cells[indexPath.section].cellHeight
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        view.endEditing(true)
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
    convenience init(_ text: String, textColor: UIColor) {
        defer {
            self.textColor = textColor
            self.text = text
            self.font = UIFont.systemFont(ofSize: 18)
            self.numberOfLines = 0
        }
        self.init()
    }
}
