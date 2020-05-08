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
    
    let playerView = UIView()
    
    let playerControlManager = FDMPlayerControlManager()
    
    let playerStatusBar = FDMPlayerBarControl(frame: .zero)
    let playerTopControl = FDMPlayerTopControl(frame: .zero)
    let playerBottomControl = FDMPlayerBottomControl(frame: .zero)
    
    override var preferredStatusBarStyle: UIStatusBarStyle {.lightContent}

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.addSubview(playerView)
        playerView.backgroundColor = .black
        playerView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(0)
            make.height.equalTo(240)
        }
        
        playerView.addSubview(playerControlManager)
        playerControlManager.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalToSuperview()
        }
        
        createTopControl()
        createBottomContro()
    }
    
    func createTopControl() {
        playerStatusBar.barHeight = 20
        playerControlManager.topBarControlAry = [playerStatusBar,playerTopControl]
        
        playerTopControl.itemManager.titleItem.item.text = "中华小当家"
    }
    
    func createBottomContro() {
        playerControlManager.bottomBarControlAry = [playerBottomControl]
    }

}




