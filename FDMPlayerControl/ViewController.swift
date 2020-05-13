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
    
    let barHeight: CGFloat = 20
    let playerHeight: CGFloat = 285
    
    // ControlManager
    let playerControlManager = FDMPlayerControlManager()
    
    // topStatusBarControl
    let playerStatusBar = FDMPlayerBarControl()
    // topControl
    let playerTopControl = FDMPlayerTopControl()
    // bottomControl
    let playerBottomControl = FDMPlayerBottomControl()
    // bottomFullScreenProgressBar
    let playerBottomProgressControl = FDMPlayerBarControl()
    
    var statusBarHidden = false

    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent}
    override var prefersStatusBarHidden: Bool { return statusBarHidden }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        /* 1.创建视频播放器 */
        self.view.addSubview(playerView)
        aliplayer?.playerView = playerView
        aliplayer?.delegate = self
        AliPlayer.setEnableLog(false)
        playerView.backgroundColor = .black
        playerView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(0)
            make.height.equalTo(playerHeight)
        }
        
        /* 2.视频播放器添加playerControlManager */
        playerView.addSubview(playerControlManager)
        playerControlManager.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalToSuperview()
        }
        
        createTopControl()
        createBottomContro()
        createPlayerBackgroundImage()
        
        let playerSource = AVPUrlSource()
        playerSource.url(with: "http://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4")
        self.aliplayer?.setUrlSource(playerSource)
        self.aliplayer?.prepare()
    }
    
    /// 创建topBarControl
    func createTopControl() {
        // 设置状态栏Bar高度
        playerStatusBar.barHeight = barHeight
        
        playerTopControl.delegate = self
        playerTopControl.items.titleItem.item.text = "惊奇队长"
        
        // 设置manager的topBarControlAry
        playerControlManager.topBarControlAry = [playerStatusBar,playerTopControl]
    }
    
    /// 创建bottomBarControl
    func createBottomContro() {
        // 设置manager的bottomBarControlAry
        playerControlManager.bottomBarControlAry = [playerBottomControl]
        playerBottomControl.delegate = self
        
        playerBottomProgressControl.itemSpacing = 0
        playerBottomProgressControl.barHeight = 15
    }
    
    /// 创建背景
    func createPlayerBackgroundImage() {
        let topImage = UIImage(named: ImageConfig.shared.video_topShadow)
        let bottomImage = UIImage(named: ImageConfig.shared.video_bottomShadow)
        
        playerControlManager.addTopBackgroundView(UIImageView(image: topImage), height: 60)
        playerControlManager.addBottomBackgroundView(UIImageView(image: bottomImage), height: 40)
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
    
    func changeProgressItem(_ item: FDMPlayerProgressView, value: CGFloat, state: UIGestureRecognizer.State) {
        if state == .ended || state == .cancelled {
            let timer = value * CGFloat(aliplayer?.duration ?? 0)
            aliplayer?.seek(toTime: Int64(timer), seekMode: .init(1))
        }
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
            make.height.equalTo(playerHeight)
        }
        
        playerControlManager.setFullScreenStatus(false)
        playerControlManager.bottomBarControlAry = [playerBottomControl]
        playerBottomControl.offFullScreen()
    }
}

//MARK: 
extension ViewController: AVPDelegate {
    /// 播放事件回调
    func onPlayerEvent(_ player: AliPlayer!, eventType: AVPEventType) {
        switch eventType {
        case AVPEventPrepareDone: /**@brief 准备完成事件*/
            let currentTime = FDMTimeConversion.millisecondToTimerString(Int64(0), type: .minute)
            let endTime = FDMTimeConversion.millisecondToTimerString(player.duration , type: .minute)
            
            playerBottomControl.items.timeItem.item.text = currentTime + " / " + endTime
            break
        case AVPEventAutoPlayStart: /**@brief 自动启播事件*/
            playerBottomControl.items.playerItem.item.isSelected = true
            
            break
        case AVPEventFirstRenderedStart: /**@brief 首帧显示时间*/
            break
        case AVPEventCompletion: /**@brief 播放完成事件*/
            playerBottomControl.items.playerItem.item.isSelected = false
            player.seek(toTime: Int64(0), seekMode: .init(0))
            break
        case AVPEventLoadingStart: /**@brief 缓冲开始事件*/
            break
        case AVPEventLoadingEnd: /**@brief 缓冲完成事件*/
            break
        case AVPEventSeekEnd: /**@brief 跳转完成事件*/
            break
        case AVPEventLoopingStart: /**@brief 循环播放开始事件*/
            break
        default:
            break
        }
    }
    
    /// 播放错误回调
    func onError(_ player: AliPlayer!, errorModel: AVPErrorModel!) {
        
    }
    
    /// 当前播放位置
    func onCurrentPositionUpdate(_ player: AliPlayer!, position: Int64) {
        let currentTime = FDMTimeConversion.millisecondToTimerString(position, type: .minute)
        let endTime = FDMTimeConversion.millisecondToTimerString(player.duration , type: .minute)
    
        playerBottomControl.items.timeItem.item.text = currentTime + " / " + endTime
        playerBottomControl.items.progressItem.item.setMiniValue(CGFloat(position) / CGFloat(player.duration))
        
    }
    
    /// 当前缓冲进度
    func onLoadingProgress(_ player: AliPlayer!, progress: Float) {
        playerBottomControl.items.progressItem.item.setLoadValue(CGFloat(progress / 100) / CGFloat(player.duration))
    }
}


