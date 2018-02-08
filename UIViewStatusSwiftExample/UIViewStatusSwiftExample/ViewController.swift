//
//  ViewController.swift
//  UIViewStatusSwiftExample
//
//  Created by mac on 2018/2/8.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit
import UIViewStatusSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.loadingView = LoadingView()
        self.view.emptyView = EmptyView()
        self.view.errorView = ErrorView()
        
        for v in self.view.subviews {
            v.loadingView = LoadingView()
            v.emptyView = EmptyView()
            v.errorView = ErrorView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.status = .loading
        
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            self.view.status = .normal
            
            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { _ in
                let idx: Int = Int(arc4random()) % self.view.subviews.count
                self.view.subviews[idx].status = ViewStatus(rawValue: Int(arc4random() % 4))!
            })
        }
    }

    
}

