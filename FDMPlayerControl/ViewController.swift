//
//  ViewController.swift
//  FDMPlayerControl
//
//  Created by 发抖喵 on 2020/4/27.
//  Copyright © 2020 发抖喵. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let item = FDMPlayerButtonItem(image: UIImage(named: "avcPromptWarning")!, target: self, selector: #selector(self.clickItem))
        let v = FDMPlayerBottomView(itemAry: [])
        v.backgroundColor = .cyan
        self.view.addSubview(v)
        v.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(49)
        }
        
        v.itemAry = [item]
    }
    
    @objc func clickItem() {
        print("1111111")
    }
}



