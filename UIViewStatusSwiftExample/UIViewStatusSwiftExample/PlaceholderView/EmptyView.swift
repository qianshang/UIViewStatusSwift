//
//  EmptyView.swift
//  UIViewStatusSwiftExample
//
//  Created by mac on 2018/2/8.
//  Copyright © 2018年 mac. All rights reserved.
//

import Foundation
import UIKit

class EmptyView: UIView {
    private var label: UILabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        label.textAlignment = .center
        label.text = "没有内容"
        self.addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = self.bounds
    }
}
