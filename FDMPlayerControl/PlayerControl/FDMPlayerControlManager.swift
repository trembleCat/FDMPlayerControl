//
//  FDMPlayerControlManager.swift
//  FDMPlayerControl
//
//  Created by 发抖喵 on 2020/5/8.
//  Copyright © 2020 发抖喵. All rights reserved.
//

import UIKit

let fullScreenNotificationName = "FDMPlayerFullScreen"
let miniScreenNotificationName = "FDMPlayerMiniScreen"

class FDMPlayerControlManager: UIView {
    
    private(set) var fullScreenState = false

    let gestureControl = FDMPlayerGestureControl()
    var topBarControlAry: [FDMPlayerBarControl]? {
        didSet {
            addBarControl()

        }
    }
    
    var bottomBarControlAry: [FDMPlayerBarControl]? {
        didSet {
            addBarControl()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FDMPlayerControlManager {
    func createUI() {
        self.addSubview(gestureControl)
        
        /* 手势控制器 */
        gestureControl.translatesAutoresizingMaskIntoConstraints = false
        gestureControl.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalToSuperview()
        }
    }
    
    func addBarControl() {
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
    
    func layoutTopBarControl(_ topControl: FDMPlayerBarControl, topHeight: CGFloat) {
        topControl.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(topHeight)
            make.height.equalTo(topControl.barHeight)
        }
    }
    
    func layoutBottomBarControl(_ bottomControl: FDMPlayerBarControl, bottomHeight: CGFloat) {
        bottomControl.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-bottomHeight)
            make.height.equalTo(bottomControl.barHeight)
        }
    }
}
