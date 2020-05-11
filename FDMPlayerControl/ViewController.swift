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
    let aliplayer = AliPlayer()
    let playerTimer = FDMGcdTimer()
    
    // ControlManager
    let playerControlManager = FDMPlayerControlManager()
    
    // 状态栏
    let playerStatusBar = FDMPlayerBarControl(frame: .zero)
    // topControl
    let playerTopControl = FDMPlayerTopControl(frame: .zero)
    // bottomControl
    let playerBottomControl = FDMPlayerBottomControl(frame: .zero)
    // bottomFullScreenProgressBar
    let playerBottomProgressControl = FDMPlayerBarControl(frame: .zero)
    
    var statusBarHidden = false

    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent}
    override var prefersStatusBarHidden: Bool { return statusBarHidden }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        /* 1.创建视频播放器 */
        self.view.addSubview(playerView)
        aliplayer?.playerView = playerView
        aliplayer?.isLoop = true
        AliPlayer.setEnableLog(false)
        playerView.backgroundColor = .black
        playerView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(0)
            make.height.equalTo(285)
        }
        
        /* 2.视频播放器添加playerControlManager */
        playerView.addSubview(playerControlManager)
        playerControlManager.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalToSuperview()
        }
        
        createTopControl()
        createBottomContro()
        
        let playerSource = AVPUrlSource()
        playerSource.url(with: "http://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4")
        self.aliplayer?.setUrlSource(playerSource)
        self.aliplayer?.prepare()
    }
    
    /// 创建topBarControl
    func createTopControl() {
        // 设置状态栏Bar高度
        playerStatusBar.barHeight = 20
        // 设置manager的topBarControlAry
        playerControlManager.topBarControlAry = [playerStatusBar,playerTopControl]
        
        playerTopControl.delegate = self
        playerTopControl.items.titleItem.item.text = "惊奇队长"
    }
    
    /// 创建bottomBarControl
    func createBottomContro() {
        // 设置manager的bottomBarControlAry
        playerControlManager.bottomBarControlAry = [playerBottomControl]
        playerBottomControl.delegate = self
        
        playerBottomProgressControl.itemSpacing = 5
        playerBottomProgressControl.barHeight = 10
    }

}

//MARK: TopControlDelegate
extension ViewController: FDMPlayerTopControlDelegate {
    func clickBackItem(_ item: UIButton, fullStatus: Bool) {
        if fullStatus {
            setUnFullScreen()
        }else{
            print("返回上一页")
        }
    }
}

//MARK: BottomControlDelegate
extension ViewController: FDMPlayerBottomControlDelegate {
    func clickPlayerItem(_ item: UIButton, fullStatus: Bool) {
        if item.isSelected {
            aliplayer?.start()
        }else{
            aliplayer?.pause()
        }
    }
    
    func clickFullScreenItem(_ item: UIButton, fullStatus: Bool) {
        if item.isSelected {
            setFullScreen()
            
            item.isSelected = !item.isSelected
        }else{
            setUnFullScreen()
        }
    }
    
    func changeProgressItem(_ item: UISlider, value: Float) {
        print("进度条：\(value)")
    }
    
    /// 设置全屏
    func setFullScreen() {
        print("全屏")
        
        playerView.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        playerControlManager.setFullScreenStatus(true)
        playerBottomProgressControl.itemAry = [FDMPlayerItemsManager.shared.progressItem]
        playerControlManager.bottomBarControlAry = [playerBottomControl,playerBottomProgressControl]
        playerBottomControl.onFullScreen()
    }
    
    /// 取消全屏
    func setUnFullScreen() {
        print("取消全屏")
        
        playerView.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(0)
            make.height.equalTo(240)
        }
        
        playerControlManager.setFullScreenStatus(false)
        playerControlManager.bottomBarControlAry = [playerBottomControl]
        playerBottomControl.offFullScreen()
    }
}


