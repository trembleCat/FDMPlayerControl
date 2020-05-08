//
//  FDMBottomItemManager.swift
//  FDMPlayerControl
//
//  Created by 发抖喵 on 2020/5/8.
//  Copyright © 2020 发抖喵. All rights reserved.
//

import UIKit

class FDMBottomItemManager: NSObject {
    
    /// 播放
    var playerItem: FDMButtonItemControl!
    /// 进度条
    var progressItem: FDMProgressItemControl!
    /// 时间
    var timeItem: FDMLabelItemControl!
    /// 全屏
    var fullScreenItem: FDMButtonItemControl!
    
    /// 弹幕
//    var barrageItem: FDMButtonItemControl!
    /// 设置
//    var settingItem: FDMButtonItemControl!
    /// 输入框(临时)
//    var textItem: FDMButtonItemControl!
    /// 倍速
//    var speedItem: FDMButtonItemControl!
    
    override init() {
        super.init()
        
        createUI()
    }
    
    func createUI() {
        createPlayerItem()
        createProgressItem()
        createTimeItem()
        createFullScreenItem()
    }
}

//MARK: UI
extension FDMBottomItemManager {
    /// 创建播放
    func createPlayerItem() {
        let itemSize = CGSize(width: 25, height: 25)
        let playImage = UIImage(named: ImageConfig.shared.video_mini_play)
        let pauseImage = UIImage(named: ImageConfig.shared.video_mini_pause)
        playerItem = FDMButtonItemControl(size: itemSize)
        playerItem.item.setImage(playImage, for: .normal)
        playerItem.item.setImage(pauseImage, for: .selected)
        playerItem.clickItemBlock = { sender, fullState in
            sender.isSelected = !sender.isSelected
        }
    }
    
    /// 创建进度条
    func createProgressItem() {
        let thumbImage = UIImage(named: ImageConfig.shared.player_mini_thumb)
        progressItem = FDMProgressItemControl(thumbImage, .purple, .gray, 15)
    }
    
    /// 创建时间
    func createTimeItem() {
        timeItem = FDMLabelItemControl(text: "00:00 / 00:00", color: .white, font: UIFont.systemFont(ofSize: 13))
    }
    
    /// 创建全屏
    func createFullScreenItem() {
        let itemSize = CGSize(width: 25, height: 25)
        let screenImage = UIImage(named: ImageConfig.shared.video_screen)
        let unScreenImage = UIImage(named: ImageConfig.shared.video_unScreen)
        fullScreenItem = FDMButtonItemControl(size: itemSize)
        fullScreenItem.item.setImage(screenImage, for: .normal)
        fullScreenItem.item.setImage(unScreenImage, for: .selected)
        fullScreenItem.clickItemBlock = { sender, fullState in
            sender.isSelected = !sender.isSelected
        }
    }
}
