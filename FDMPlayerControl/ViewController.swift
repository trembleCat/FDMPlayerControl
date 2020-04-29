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
    
    let videoView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.addSubview(videoView)
        videoView.backgroundColor = .black
        videoView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.center.equalToSuperview()
            make.height.equalTo(250)
        }
        
        createControlUI()
    }
}

//MARK: UI
extension ViewController {
    func createControlUI() {
        let playItemSize = CGSize(width: 25, height: 25)
        let playItemImage = UIImage(named: ImageConfig.shared.defaultVideo_all_play)!
        let playItem = FDMControlButtonItem(image: playItemImage, size: playItemSize, target: self, selector: #selector(self.clickPlayItem))
        
        let bottomBar = FDMPlayerBarControl(itemAry: [playItem])
        
        let gestureControl = FDMPlayerGestureControl()
        gestureControl.bottomBarControl = bottomBar
        
        videoView.addSubview(gestureControl)
        gestureControl.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalToSuperview()
        }
    }
    
    @objc func clickPlayItem() {
        
    }
}



