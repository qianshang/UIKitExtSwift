//
//  UIControlExt.swift
//  UIKitExtSwift
//
//  Created by mac on 2018/3/5.
//

import Foundation


final class ControlTarget: NSObject {
    
    typealias Callback = (UIControl) -> Void
    
    fileprivate weak var control: UIControl?
    fileprivate var eventsHandler: [UIControl.Event.RawValue: Callback] = [:]
    
    init(_ control: UIControl) {
        super.init()
        self.control = control
        
        addSupport()
    }
    
    func addEvents(for events: UIControl.Event, handler: @escaping Callback) {
        eventsHandler[events.rawValue] = handler
    }
    
    deinit {
        removeSupport()
    }
    
    
    func addSupport() {
        control?.addTarget(self, action: #selector(touchDown), for: .touchDown)
        control?.addTarget(self, action: #selector(touchDownRepeat), for: .touchDownRepeat)
        control?.addTarget(self, action: #selector(touchDragInside), for: .touchDragInside)
        control?.addTarget(self, action: #selector(touchDragOutside), for: .touchDragOutside)
        control?.addTarget(self, action: #selector(touchDragEnter), for: .touchDragEnter)
        control?.addTarget(self, action: #selector(touchDragExit), for: .touchDragExit)
        control?.addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
        control?.addTarget(self, action: #selector(touchUpOutside), for: .touchUpOutside)
        control?.addTarget(self, action: #selector(touchCancel), for: .touchCancel)
        control?.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        control?.addTarget(self, action: #selector(allEvents), for: .allEvents)
    }
    func removeSupport() {
        control?.removeTarget(self, action: #selector(touchDown), for: .touchDown)
        control?.removeTarget(self, action: #selector(touchDownRepeat), for: .touchDownRepeat)
        control?.removeTarget(self, action: #selector(touchDragInside), for: .touchDragInside)
        control?.removeTarget(self, action: #selector(touchDragOutside), for: .touchDragOutside)
        control?.removeTarget(self, action: #selector(touchDragEnter), for: .touchDragEnter)
        control?.removeTarget(self, action: #selector(touchDragExit), for: .touchDragExit)
        control?.removeTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
        control?.removeTarget(self, action: #selector(touchUpOutside), for: .touchUpOutside)
        control?.removeTarget(self, action: #selector(touchCancel), for: .touchCancel)
        control?.removeTarget(self, action: #selector(valueChanged), for: .valueChanged)
        control?.removeTarget(self, action: #selector(allEvents), for: .allEvents)
    }
    
    
    @objc func touchDown() {
        eventHandler(for: .touchDown)
    }
    @objc func touchDownRepeat() {
        eventHandler(for: .touchDownRepeat)
    }
    @objc func touchDragInside() {
        eventHandler(for: .touchDragInside)
    }
    @objc func touchDragOutside() {
        eventHandler(for: .touchDragOutside)
    }
    @objc func touchDragEnter() {
        eventHandler(for: .touchDragEnter)
    }
    @objc func touchDragExit() {
        eventHandler(for: .touchDragExit)
    }
    @objc func touchUpInside() {
        eventHandler(for: .touchUpInside)
    }
    @objc func touchUpOutside() {
        eventHandler(for: .touchUpOutside)
    }
    @objc func touchCancel() {
        eventHandler(for: .touchCancel)
    }
    @objc func valueChanged() {
        eventHandler(for: .valueChanged)
    }
    @objc func allEvents() {
        eventHandler(for: .allEvents)
    }
    
    
    func eventHandler(for event: UIControl.Event) {
        guard let control = control else { return }
        eventsHandler[event.rawValue]?(control)
    }
}

extension UIKitExt where Base: UIControl {
    private func addEvents(for events: UIControl.Event, handler: @escaping (UIControl) -> Void) {
        self.base.eventsTarget.addEvents(for: events, handler: handler)
    }
    
    public func touchDown(_ handler: @escaping (UIControl) -> Void) {
        addEvents(for: .touchDown, handler: handler)
    }
    public func touchDownRepeat(_ handler: @escaping (UIControl) -> Void) {
        addEvents(for: .touchDownRepeat, handler: handler)
    }
    public func touchDragInside(_ handler: @escaping (UIControl) -> Void) {
        addEvents(for: .touchDragInside, handler: handler)
    }
    public func touchDragOutside(_ handler: @escaping (UIControl) -> Void) {
        addEvents(for: .touchDragOutside, handler: handler)
    }
    public func touchDragEnter(_ handler: @escaping (UIControl) -> Void) {
        addEvents(for: .touchDragEnter, handler: handler)
    }
    public func touchDragExit(_ handler: @escaping (UIControl) -> Void) {
        addEvents(for: .touchDragExit, handler: handler)
    }
    public func touchUpInside(_ handler: @escaping (UIControl) -> Void) {
        addEvents(for: .touchUpInside, handler: handler)
    }
    public func touchUpOutside(_ handler: @escaping (UIControl) -> Void) {
        addEvents(for: .touchUpOutside, handler: handler)
    }
    public func touchCancel(_ handler: @escaping (UIControl) -> Void) {
        addEvents(for: .touchCancel, handler: handler)
    }
    public func valueChanged(_ handler: @escaping (UIControl) -> Void) {
        addEvents(for: .valueChanged, handler: handler)
    }
    public func allEvents(_ handler: @escaping (UIControl) -> Void) {
        addEvents(for: .allEvents, handler: handler)
    }
}

extension UIControl {
    fileprivate static let eventsTarget__ = ObjectAssociation<ControlTarget>()
    fileprivate var eventsTarget: ControlTarget {
        get {
            if let target = UIControl.eventsTarget__[self] {
                return target
            } else {
                let target = ControlTarget(self)
                UIControl.eventsTarget__[self] = target
                return target
            }
        }
        set { UIControl.eventsTarget__[self] = newValue }
    }
}
