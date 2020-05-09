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
    let gestureControl = FDMPlayerGestureControl()
    
    var topBarControlAry: [FDMPlayerBarControl]? { didSet { addBarControl() } }
    var bottomBarControlAry: [FDMPlayerBarControl]? { didSet { addBarControl() } }
    
    private(set) var fullScreenStatus = false
    
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
            NotificationCenter.default.post(name: NSNotification.Name.init(fullScreenNotificationName), object: nil)
        }else{
            NotificationCenter.default.post(name: NSNotification.Name.init(miniScreenNotificationName), object: nil)
        }
    }
}

//MARK: UI + Action
extension FDMPlayerControlManager {
    private func createUI() {
        self.addSubview(gestureControl)
        
        /* 手势控制器 */
        gestureControl.translatesAutoresizingMaskIntoConstraints = false
        gestureControl.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalToSuperview()
        }
    }
    
    private func addBarControl() {
        for barControl in gestureControl.subviews {
            barControl.removeFromSuperview()
        }
        
        var topHeight: CGFloat = 0
        for topControl in topBarControlAry ?? [] {
            gestureControl.addSubview(topControl)
            
            layoutTopBarControl(topControl, topHeight: topHeight)
            topHeight += topControl.barHeight
        }
        
        var bottomHeight: CGFloat = 0
        for bottomControl in bottomBarControlAry ?? [] {
            gestureControl.addSubview(bottomControl)
            
            layoutBottomBarControl(bottomControl, bottomHeight: bottomHeight)
            bottomHeight += bottomControl.barHeight
        }
    }
    
    private func layoutTopBarControl(_ topControl: FDMPlayerBarControl, topHeight: CGFloat) {
        topControl.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(topHeight)
            make.height.equalTo(topControl.barHeight)
        }
    }
    
    private func layoutBottomBarControl(_ bottomControl: FDMPlayerBarControl, bottomHeight: CGFloat) {
        bottomControl.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-bottomHeight)
            make.height.equalTo(bottomControl.barHeight)
        }
    }
}
