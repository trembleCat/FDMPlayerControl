//
//  FDMPlayerControlManager.swift
//  FDMPlayerControl
//
//  Created by 发抖喵 on 2020/5/8.
//  Copyright © 2020 发抖喵. All rights reserved.
//

import UIKit

// 屏幕高度
let FScreenH = UIScreen.main.bounds.height
// 屏幕宽度
let FScreenW = UIScreen.main.bounds.width

let fullScreenNotificationName = "FDMPlayerFullScreen"
let miniScreenNotificationName = "FDMPlayerMiniScreen"

class FDMPlayerControlManager: UIView {
    private(set) var fullScreenStatus = false
    
    let gestureControl = FDMPlayerGestureControl()
    
    var topBarControlAry: [FDMPlayerBarControl]? { didSet { addTopBarControl() } }
    var bottomBarControlAry: [FDMPlayerBarControl]? { didSet { addBottomBarControl() } }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: PublicAction
extension FDMPlayerControlManager {
    /// 设置全屏状态
    func setFullScreenStatus(_ status: Bool) {
        fullScreenStatus = status
        if status {
            setScreenOrientation(.landscapeLeft)
            NotificationCenter.default.post(name: NSNotification.Name.init(fullScreenNotificationName), object: nil)
        }else{
            setScreenOrientation(.portrait)
            NotificationCenter.default.post(name: NSNotification.Name.init(miniScreenNotificationName), object: nil)
        }
    }
    
    /// 隐藏或隐藏边缘控制器
    func sethiddenControls(_ state: Bool) {
        gestureControl.setHiddenControls(state)
    }
    
    /// 添加顶部背景view
    func addTopBackgroundView(_ bgView: UIView, height: CGFloat) {
        gestureControl.addTopBackgroundView(bgView, height: height)
    }
    
    /// 移除顶部背景view
    func removeTopBackgroundView() {
        gestureControl.removeTopBackgroundView()
    }
    
    /// 添加底部背景View
    func addBottomBackgroundView(_ bgView: UIView, height: CGFloat) {
        gestureControl.addBottomBackgroundView(bgView, height: height)
    }
    
    /// 移除底部背景View
    func removeBottomBackgroundView() {
        gestureControl.removeBottomBackgroundView()
    }
}

//MARK: UI + Action
extension FDMPlayerControlManager {
    private func createUI() {
        self.addSubview(gestureControl)
        
        gestureControl.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func addTopBarControl() {
        gestureControl.topBarControlAry = topBarControlAry
    }
    
    private func addBottomBarControl() {
        gestureControl.bottomBarControlAry = bottomBarControlAry
    }
    
    /// 设置屏幕方向
    private func setScreenOrientation(_ orientation: UIDeviceOrientation) {
        let orientation = orientation.rawValue
        UIDevice.current.setValue(orientation, forKey: "orientation")
    }
}
