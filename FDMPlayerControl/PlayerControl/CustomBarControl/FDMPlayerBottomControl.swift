//
//  FDMPlayerBottomControl.swift
//  FDMPlayerControl
//
//  Created by 发抖喵 on 2020/5/8.
//  Copyright © 2020 发抖喵. All rights reserved.
//

import UIKit

@objc protocol FDMPlayerBottomControlDelegate: NSObjectProtocol {
    /// 点击播放
    @objc optional func clickPlayerItem(_ item: UIButton, fullStatus: Bool)
    /// 点击全屏
    @objc optional func clickFullScreenItem(_ item: UIButton, fullStatus: Bool)
    /// 滑动进度条
    @objc optional func changeProgressItem(_ item: UISlider, value: Float)
    
    /// 改变 播放的全屏状态
    @objc optional func changeScreenStatusInPlayerItem(_ item: UIButton, fullStatus: Bool)
    /// 改变 全屏的全屏状态
    @objc optional func changeScreenStatusInFullScreenItem(_ item: UIButton, fullStatus: Bool)
    /// 改变 进度条的全屏状态
    @objc optional func changeScreenStatusInProgressItem(_ item: UISlider, fullStatus: Bool)
}

class FDMPlayerBottomControl: FDMPlayerBarControl {
    let items = FDMPlayerItemsManager.shared
    var delegate: FDMPlayerBottomControlDelegate?
    
    /// 添加取消全屏时的监听(只添加一次)
    private lazy var addOffFullScreenAction: Void = {
        offFullScreenAction()
    }()
    
    /// 添加开启全屏时的监听(只添加一次)
    private lazy var addOnFullScreenAction: Void = {
        onFullScreenAction()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createUI()
        offFullScreen()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: PublicAction
extension FDMPlayerBottomControl {
    /// 开启全屏
    func onFullScreen() {
        self.itemAry = [items.playerItem,items.timeItem,items.barrageItem,items.settingItem,items.textItem,items.speedItem,items.qualityItem]
        _ = addOnFullScreenAction
    }
    
    /// 取消全屏
    func offFullScreen() {
        self.itemAry = [items.playerItem,items.progressItem,items.timeItem,items.fullScreenItem]
        _ = addOffFullScreenAction
    }
}

//MARK: UI + Action
extension FDMPlayerBottomControl {
    private func createUI() {
        /* 添加item */
        let backgroundImage = UIImage(named: ImageConfig.shared.video_bottomShadow)
        self.backgroundView = UIImageView(image: backgroundImage)
    }
    
    /// 添加开启全屏时的监听
    private func onFullScreenAction() {
        
    }
    
    /// 添加取消全屏时的监听
    private func offFullScreenAction() {
        /* 监听播放手势 与屏幕状态改变 */
        items.playerItem.clickItemBlock = {[weak self] sender, fullStatus in
            sender.isSelected = !sender.isSelected
            
            let isResponds = self?.delegate?.responds(to: #selector(self?.delegate?.clickPlayerItem(_:fullStatus:)))
            guard self?.delegate != nil && isResponds != false else { return }
            
            self?.delegate?.clickPlayerItem?(sender, fullStatus: fullStatus)
        }
        
        items.playerItem.changeScreenBlock = {[weak self] sender, fullStatus in
            let isResponds = self?.delegate?.responds(to: #selector(self?.delegate?.changeScreenStatusInPlayerItem(_:fullStatus:)))
            guard self?.delegate != nil && isResponds != false else { return }
            
            self?.delegate?.changeScreenStatusInPlayerItem?(sender as! UIButton, fullStatus: fullStatus)
        }
        
        /* 监听进度条 与屏幕状态改变 */
        items.progressItem.itemChangeValueBlock = {[weak self] sender, value in
            let isResponds = self?.delegate?.responds(to: #selector(self?.delegate?.changeProgressItem(_:value:)))
            guard self?.delegate != nil && isResponds != false else { return }
            
            self?.delegate?.changeProgressItem?(sender, value: value)
        }
        
        items.progressItem.changeScreenBlock = { [weak self] sender, fullStatus in
            let isResponds = self?.delegate?.responds(to: #selector(self?.delegate?.changeScreenStatusInProgressItem(_:fullStatus:)))
            guard self?.delegate != nil && isResponds != false else { return }
            
            self?.delegate?.changeScreenStatusInProgressItem?(sender as! UISlider, fullStatus: fullStatus)
        }
        
        /* 监听全屏手势 与屏幕状态改变 */
        items.fullScreenItem.clickItemBlock = {[weak self] sender, fullStatus in
            sender.isSelected = !sender.isSelected
            
            let isResponds = self?.delegate?.responds(to: #selector(self?.delegate?.clickFullScreenItem(_:fullStatus:)))
            guard self?.delegate != nil && isResponds != false else { return }
            
            self?.delegate?.clickFullScreenItem?(sender, fullStatus: fullStatus)
        }
        
        items.fullScreenItem.changeScreenBlock = {[weak self] sender, fullStatus in
            let isResponds = self?.delegate?.responds(to: #selector(self?.delegate?.changeScreenStatusInFullScreenItem(_:fullStatus:)))
            guard self?.delegate != nil && isResponds != false else { return }
            
            self?.delegate?.changeScreenStatusInFullScreenItem?(sender as! UIButton, fullStatus: fullStatus)
        }
    }
}
