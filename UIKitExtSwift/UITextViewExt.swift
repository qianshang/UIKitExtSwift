//
//  UITextViewExt.swift
//  UIKitExtSwift
//
//  Created by mac on 2018/6/13.
//

import Foundation

private var kObserverKey: Void?
private var kPlaceholderViewKey: Void?

extension UIKitExt where Base: UITextView {
    
    private var textView: UITextView {
        return base as UITextView
    }
    private var observer: TextViewObserver {
        if let obj = objc_getAssociatedObject(textView, &kObserverKey) as? TextViewObserver {
            return obj
        }
        let obj = TextViewObserver(textView)
        objc_setAssociatedObject(textView, &kObserverKey, obj, .OBJC_ASSOCIATION_RETAIN)
        return obj
    }
    
    private var placeholderView: UILabel {
        if let label = objc_getAssociatedObject(textView, &kPlaceholderViewKey) as? UILabel {
            return label
        }
        
        let label: UILabel = UILabel()
        label.numberOfLines = 0
        textView.insertSubview(label, at: 0)
        
        label.textColor = 0xCBCBD0.ex.color
        label.font = textView.font
        
        objc_setAssociatedObject(textView, &kPlaceholderViewKey, label, .OBJC_ASSOCIATION_RETAIN)
        
        return label
    }
    
    fileprivate func layout() {
        guard let text = placeholderView.text, !text.isEmpty else {
            return
        }
        if textView.font == nil {
            textView.font = UIFont.systemFont(ofSize: 14)
        }
        placeholderView.font = textView.font
        
        let left   = textView.textContainerInset.left + 4
        let top    = textView.textContainerInset.top
        let right  = textView.textContainerInset.right + 4
        let bottom = textView.textContainerInset.bottom
        
        let x = left
        let y = top
        let w = textView.width - left - right
        let h = (text as NSString).boundingRect(with: CGSize(width: w, height: textView.height - top - bottom),
                                                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                attributes: [NSAttributedStringKey.font : placeholderView.font],
                                                context: nil).height
        
        placeholderView.frame = CGRect(x: x, y: y, width: w, height: h)
    }
    
    public func set(placeholder: String, textColor: UIColor? = nil) {
        placeholderView.text = placeholder
        if let color = textColor {
            placeholderView.textColor = color
        }
        
        observer.startListen()
    }
    
    public func set(placeholder: NSAttributedString) {
        placeholderView.attributedText = placeholder
        
        observer.startListen()
    }
    
    func textChanged() {
        guard textView.isFirstResponder else { return }
        
        placeholderView.isHidden = !textView.text.isEmpty
    }
}

class TextViewObserver: NSObject {
    private var isListening: Bool = false
    weak var textView: UITextView?
    
    init(_ textView: UITextView) {
        self.textView = textView
    }
    
    func startListen() {
        guard !isListening else {
            return
        }
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(textValueChanged),
                         name: NSNotification.Name.UITextViewTextDidChange,
                         object: nil)
        isListening = true
    }
    
    @objc func textValueChanged() {
        textView?.ex.textChanged()
    }
    
    deinit {
        isListening = false
        NotificationCenter.default
            .removeObserver(self,
                            name: NSNotification.Name.UITextViewTextDidChange,
                            object: nil)
    }
}

extension UITextView {
    @objc func uk_valueChanged() {
        self.ex.textChanged()
    }
    
    @objc func uk_layoutSubviews() {
        self.uk_layoutSubviews()
        
        self.ex.layout()
    }
}
