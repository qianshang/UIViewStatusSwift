//
//  UIViewStatusExtension.swift
//  UIViewStatusSwift
//
//  Created by mac on 2018/2/8.
//  Copyright © 2018年 mac. All rights reserved.
//

import Foundation
import UIKit

public enum ViewStatus: Int {
    case normal     = 0
    case loading    = 1
    case empty      = 2
    case error      = 3
}

private var kUIViewStatusContentKey: Void?
private var kUIViewLoadingViewKey: Void?
private var kUIViewEmptyViewKey: Void?
private var kUIViewErrorViewKey: Void?
private var kUIViewStatusKey: Void?

extension UIView {
    fileprivate var statusContentView: UIView {
        if let v: UIView = objc_getAssociatedObject(self, &kUIViewStatusContentKey) as? UIView {
            return v
        }
        let view: UIView = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        objc_setAssociatedObject(self, &kUIViewStatusContentKey, view, .OBJC_ASSOCIATION_RETAIN)
        return view
    }
    
    public var loadingView: UIView? {
        get { return objc_getAssociatedObject(self, &kUIViewLoadingViewKey) as? UIView }
        set { objc_setAssociatedObject(self, &kUIViewLoadingViewKey, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
    public var emptyView: UIView? {
        get { return objc_getAssociatedObject(self, &kUIViewEmptyViewKey) as? UIView }
        set { objc_setAssociatedObject(self, &kUIViewEmptyViewKey, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
    public var errorView: UIView? {
        get { return objc_getAssociatedObject(self, &kUIViewErrorViewKey) as? UIView }
        set { objc_setAssociatedObject(self, &kUIViewErrorViewKey, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
    
    public var status: ViewStatus {
        get {
            let value: Int = objc_getAssociatedObject(self, &kUIViewStatusKey) as? Int ?? 0
            return ViewStatus(rawValue: value) ?? .normal
        }
        set(newValue) {
            objc_sync_enter(self)
            let value: Int = objc_getAssociatedObject(self, &kUIViewStatusKey) as? Int ?? 0
            let st: ViewStatus = ViewStatus(rawValue: value) ?? .normal
            guard st != newValue else { return }
            
            objc_setAssociatedObject(self, &kUIViewStatusKey, newValue.rawValue, .OBJC_ASSOCIATION_RETAIN)
            viewStatusDidChanged(newValue)
            objc_sync_exit(self)
        }
    }
    
    
    private func viewStatusDidChanged(_ status: ViewStatus) {
        removeStatusView {
            status == .normal ?removeStatusContentIfNeeded():insertStatusView(with: status)
        }
    }
    
    private func removeStatusContentIfNeeded() {
        if let _ = statusContentView.superview {
            self.statusContentView.removeFromSuperview()
        }
    }
    private func insertStatusContentIfNeeded() {
        if statusContentView.superview == nil {
            if (self is UITableView || self is UICollectionView) && subviews.count > 1 {
                insertSubview(statusContentView, at: 0)
            } else {
                addSubview(statusContentView)
            }
            setConstraints(with: statusContentView, superView: self)
        }
    }
    private func removeStatusView(complete: ()->Void) {
        for v in statusContentView.subviews { v.removeFromSuperview() }
        complete()
    }
    private func insertStatusView(with status: ViewStatus) {
        insertStatusContentIfNeeded()
        
        var statusView: UIView? = nil
        switch status {
        case .loading:
            statusView = loadingView
        case .empty:
            statusView = emptyView
        case .error:
            statusView = errorView
        default:
            break
        }
        if !statusContentView.subviews.isEmpty {
            removeStatusView {
                
            }
        }
        guard let stView: UIView = statusView, stView.superview == nil else {
            return
        }
        statusContentView.addSubview(stView)
        setConstraints(with: stView, superView: statusContentView)
    }
    
    private func setConstraints(with subView: UIView, superView: UIView) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        let left: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: .left, relatedBy: .equal, toItem: superView, attribute: .left, multiplier: 1, constant: 0)
        let top: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: .top, relatedBy: .equal, toItem: superView, attribute: .top, multiplier: 1, constant: 0)
        let right: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: .right, relatedBy: .equal, toItem: superView, attribute: .right, multiplier: 1, constant: 0)
        let bottom: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: .bottom, relatedBy: .equal, toItem: superView, attribute: .bottom, multiplier: 1, constant: 0)
        let width: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: .width, relatedBy: .equal, toItem: superView, attribute: .width, multiplier: 1, constant: 0)
        let height: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: .height, relatedBy: .equal, toItem: superView, attribute: .height, multiplier: 1, constant: 0)
        
        superView.addConstraints([left, top, right, bottom, width, height])
        superView.layoutIfNeeded()
    }
}


