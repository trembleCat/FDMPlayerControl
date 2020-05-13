//
//  FDMPlayerTopControl.swift
//  FDMPlayerControl
//
//  Created by 发抖喵 on 2020/5/8.
//  Copyright © 2020 发抖喵. All rights reserved.
//

import UIKit

@objc protocol FDMPlayerTopControlDelegate: NSObjectProtocol {
    /// 点击返回
    @objc optional func clickBackItem(_ item: UIButton, fullStatus: Bool)
    
    /// 改变 返回的全屏状态
    @objc optional func changeScreenStatusInBackItem(_ item: UIButton, fullStatus: Bool)
}

class FDMPlayerTopControl: FDMPlayerBarControl {
    let items = FDMPlayerItemsManager.shared
    var delegate:FDMPlayerTopControlDelegate?
    
    /// 添加取消全屏时的监听(只添加一次)
    private lazy var addOffFullScreenAction: Void = {
        offFullScreenAction()
    }()
    
    /// 添加开启全屏时的监听(只添加一次)
    private lazy var addOnFullScreenAction: Void = {
        onFullScreenAction()
    }()
    
    override init() {
        super.init()
        
        offFullScreen()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: PublicAction
extension FDMPlayerTopControl {
    /// 开启全屏
    func onFullScreen() {
        self.itemAry = [items.backItem,items.titleItem,items.autoSpaceItem,items.moreItem]
        _ = addOnFullScreenAction
    }
    
    /// 取消全屏
    func offFullScreen() {
        self.itemAry = [items.backItem,items.titleItem]
        _ = addOffFullScreenAction
    }
}

//MARK: UI + Action
extension FDMPlayerTopControl {
    
    /// 添加开启全屏时的监听
    private func onFullScreenAction() {
        
    }
    
    /// 添加取消全屏时的监听
    private func offFullScreenAction() {
        /* 监听返回手势 与屏幕状态改变 */
        items.backItem.clickItemBlock = {[weak self] sender, fullStatus in
            let isResponds = self?.delegate?.responds(to: #selector(self?.delegate?.clickBackItem(_:fullStatus:)))
            guard self?.delegate != nil && isResponds != false else { return }
            
            self?.delegate?.clickBackItem?(sender, fullStatus: fullStatus)
        }
        
        items.backItem.changeScreenBlock = {[weak self] sender, fullStatus in
            let isResponds = self?.delegate?.responds(to: #selector(self?.delegate?.changeScreenStatusInBackItem(_:fullStatus:)))
            guard self?.delegate != nil && isResponds != false else { return }
            
            self?.delegate?.changeScreenStatusInBackItem?(sender as! UIButton, fullStatus: fullStatus)
        }
    }
}
