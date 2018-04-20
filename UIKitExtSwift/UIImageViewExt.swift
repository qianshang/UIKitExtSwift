//
//  UIImageViewExt.swift
//  UIKitExtSwift
//
//  Created by mac on 2017/12/21.
//

import Foundation
import UIKit

extension UIImageView {
    private static let previewPointer = ObjectAssociation<Bool>()
    private static let groupPointer  = ObjectAssociation<Int>()
    private static let indexPointer  = ObjectAssociation<Int>()
    private static let originPointer = ObjectAssociation<URL>()
    
    public var isCouldPreview: Bool {
        get { return UIImageView.previewPointer[self] ?? false }
        set {
            UIImageView.previewPointer[self] = newValue
            if newValue {
                self.isUserInteractionEnabled = true
                self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPreview)))
            }
        }
    }
    public var groupId: Int? {
        get { return UIImageView.groupPointer[self] }
        set { UIImageView.groupPointer[self] = newValue }
    }
    public var index: Int? {
        get { return UIImageView.indexPointer[self] }
        set { UIImageView.indexPointer[self] = newValue }
    }
    public var originURL: URL? {
        get { return UIImageView.originPointer[self] }
        set { UIImageView.originPointer[self] = newValue }
    }
    
    @objc func showPreview() {
        if self.isCouldPreview {
            PhotoGroupView.show(self)
        }
    }
    
}

class PhotoGroupView: UIView, UIScrollViewDelegate {
    private var contentView: UIView!
    private var backgroundImageView: UIImageView!
    private var scrollView: UIScrollView!
    private var cells: [PhotoGroupCell] = []
    private var imageViews: [UIImageView]!
    private var snapshotImage: UIImage? {
        didSet {
            DispatchQueue.main.async {
                self.backgroundImageView.image = self.snapshotImage
            }
        }
    }
    var totalPage: Int = 0
    var currentPage: Int = 0
    
    static func show(_ imageView: UIImageView) {
        guard let image = imageView.image else {
            return
        }
        let view = PhotoGroupView(frame: UIScreen.main.bounds)
        
        if let id = imageView.groupId {
            // 找出同层级可预览的imageview
            let images: [UIImageView] = imageView.superview?
                .subviews
                .filter({
                    $0.isKind(of: UIImageView.self) &&
                        ($0 as! UIImageView).isCouldPreview &&
                        ($0 as! UIImageView).groupId == id
                }) as! [UIImageView]
            view.totalPage = images.count
            // 如果只有一个则直接预览
            if view.totalPage <= 1 {
                view.previewOne(image)
            } else {
                // 配置
                if let idx = imageView.index {
                    // 按照index进行排序
                    let imgs = images.sorted(by: { $0.index! < $1.index! })
                    view.config(imgs, index: idx)
                } else {
                    // 按照位置进行排序
                    let imgs = images.sorted(by: {(imageView1, imageView2) in
                        (imageView1.y == imageView2.y) ?(imageView1.x < imageView2.x):(imageView1.y < imageView2.y)
                    })
                    // 找出当前选中imageview的位置
                    var idx = 0
                    while (imageView != imgs[idx]) {
                        idx += 1
                    }
                    view.config(imgs, index: idx)
                }
            }
        } else {
            view.previewOne(image)
        }
        
        if let container: UIView = UIApplication.shared.ex.currentViewController?.view {
            view.snapshotImage = container.ex.snapshot()
            view.alpha = 0
            container.addSubview(view)
            
            UIView.setAnimationsEnabled(true)
            view.showWithAnimate()
        } else {
            print("The keyWindow need a rootViewController.")
        }
    }
    
    func previewOne(_ image: UIImage) {
        let cell = PhotoGroupCell(image)
        self.cells = [cell]
        self.scrollView.addSubview(cell)
        cell.x = 10
    }
    
    func config(_ imageViews: [UIImageView], index: Int) {
        self.imageViews = imageViews
        
        scrollView.contentSize = CGSize(width: scrollView.width * CGFloat(imageViews.count), height: scrollView.height)
        
        let rect = CGRect(x: scrollView.width * CGFloat(index), y: 0, width: scrollView.width, height: scrollView.height)
        scrollView.scrollRectToVisible(rect, animated: false)
        
        scrollViewDidScroll(scrollView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    func setupUI() {
        contentView = UIView(frame: self.bounds)
        backgroundImageView = UIImageView()
        contentView.insertSubview(backgroundImageView, at: 0)
        backgroundImageView.frame = contentView.bounds
        
        let effect = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: effect)
        contentView.addSubview(effectView)
        effectView.frame = contentView.bounds
        
        scrollView = UIScrollView(frame: CGRect(x: -10, y: 0, width: self.width + 20, height: self.height))
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        self.addSubview(contentView)
        self.addSubview(scrollView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss(_:)))
        self.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(doubleTap(_:)))
        tap2.numberOfTapsRequired = 2
        tap.require(toFail: tap2)
        self.addGestureRecognizer(tap2)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        self.addGestureRecognizer(longPress)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        self.addGestureRecognizer(pan)
    }
    
    // MARK: 手势处理
    @objc func dismiss(_ sender: UITapGestureRecognizer) {
        self.dismisswithAnimate()
    }
    @objc func doubleTap(_ sender: UITapGestureRecognizer) {
        if let cell = cell(currentPage) {
            if (cell.zoomScale > 1) {
                cell.setZoomScale(1, animated: true)
            } else {
                let point = sender.location(in: cell.imageView)
                let scale = cell.maximumZoomScale
                let xsize = self.width / scale
                let ysize = self.height / scale
                let rect = CGRect(x: point.x - xsize * 0.5, y: point.y - ysize * 0.5, width: xsize, height: ysize)
                cell.zoom(to: rect, animated: true)
            }
        }
    }
    @objc func longPress(_ sender: UILongPressGestureRecognizer) {
        
    }
    @objc func pan(_ sender: UIPanGestureRecognizer) {
        
    }
    
    func showWithAnimate() {
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
    func dismisswithAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCellsForReuse()
        
        let page: NSInteger = NSInteger(self.scrollView.contentOffset.x / self.scrollView.width + 0.5)
        currentPage = page
        for i in max(page-1, 0)...min(page+1, imageViews.count-1) {
            var cell_: PhotoGroupCell!
            
            if let cell = cell(i) {
                cell.config(imageViews[i].image!)
                cell_ = cell
            } else {
                cell_ = dequeueCell()
                cell_.page = i
                let img = imageViews[i].image
                cell_.config(img)
            }
            
            if cell_.superview == nil {
                self.scrollView.addSubview(cell_)
                cell_.x = (scrollView.width) * CGFloat(i) + 10
            }
        }
    }
    
    
    func updateCellsForReuse() {
        for cell in cells {
            if let _ = cell.superview {
                if (cell.x > scrollView.contentOffset.x + scrollView.width * 2) ||
                    (cell.maxX < scrollView.contentOffset.x - scrollView.width) {
                    cell.removeFromSuperview()
                }
            }
        }
    }
    func dequeueCell() -> PhotoGroupCell {
        for cell in cells {
            guard let _ = cell.superview else {
                return cell
            }
        }
        
        let cell = PhotoGroupCell()
        cell.page = -1
        cells.append(cell)
        return cell
    }
    func cell(_ page: Int) -> PhotoGroupCell? {
        for cell in cells {
            if cell.page == page {
                return cell
            }
        }
        return nil
    }
}

class PhotoGroupCell: UIScrollView, UIScrollViewDelegate {
    var containerView: UIView!
    var imageView: UIImageView!
    var page: Int = 0
    
    convenience init(_ image: UIImage) {
        self.init(frame: .zero)
        
        config(image)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    func setupUI() {
        self.delegate = self
        self.bouncesZoom = true
        self.maximumZoomScale = 3
        self.isMultipleTouchEnabled = true
        self.alwaysBounceVertical = false
        self.frame = UIScreen.main.bounds
        
        containerView = UIView()
        containerView.clipsToBounds = true
        self.addSubview(containerView)
        
        imageView = UIImageView()
        imageView.clipsToBounds = true
        containerView.addSubview(imageView)
    }
    
    func config(_ image: UIImage?) {
        if image != imageView.image {
            imageView.image = image
            self.setZoomScale(1, animated: false)
            self.maximumZoomScale = 3
            
            resizeSubViewSize()
        }
    }
    
    func resizeSubViewSize() {
        guard let image = self.imageView.image else {
            return
        }
        let imageW = image.size.width
        let imageH = image.size.height
        var h = imageH / imageW * self.bounds.width
        
        if imageH / imageW > self.bounds.height / self.bounds.width {
            containerView.frame = CGRect(origin: .zero, size: CGSize(width: self.bounds.width, height: floor(h)))
        } else {
            if h < 1 || h.isNaN {
                h = floor(h)
            }
            
            containerView.bounds = CGRect(origin: .zero, size: CGSize(width: self.bounds.width, height: h))
            containerView.center = self.center
        }
        
        self.contentSize = CGSize(width: self.bounds.width, height: max(containerView.bounds.height, self.bounds.height))
        self.scrollRectToVisible(self.bounds, animated: false)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        imageView.frame = containerView.bounds
        CATransaction.commit()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return containerView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let subView = containerView
        
        let offsetX: CGFloat = (scrollView.bounds.width > scrollView.contentSize.width) ?
            (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
        
        let offsetY: CGFloat = (scrollView.bounds.size.height > scrollView.contentSize.height) ?
            (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
        
        subView?.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY)
    }
}



