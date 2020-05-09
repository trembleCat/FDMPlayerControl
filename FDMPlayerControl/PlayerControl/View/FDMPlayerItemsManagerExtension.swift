//
//  FDMPlayerItemsManagerExtension.swift
//  FDMPlayerControl
//
//  Created by 发抖喵 on 2020/5/9.
//  Copyright © 2020 发抖喵. All rights reserved.
//

import UIKit

//MARK: TopBarUI
extension FDMPlayerItemsManager {
    /// 创建返回
    func createBackItem() -> FDMButtonItemControl {
        let itemSize = CGSize(width: 30, height: 30)
        let backImage = UIImage(named: ImageConfig.shared.video_mini_back)
        let playerBackItem = FDMButtonItemControl(image: backImage, size: itemSize)
        
        return playerBackItem
    }
    
    /// 创建标题
    func createTitleItem() -> FDMLabelItemControl {
        let itemSize = CGSize(width: 150, height: 30)
        let playerTitleItem = FDMLabelItemControl(size: itemSize)
        playerTitleItem.item.font = UIFont.systemFont(ofSize: 15)
        playerTitleItem.item.textColor = .white
        
        return playerTitleItem
    }
    
    /// 创建自动宽度间距
    func createAutoSpaceItem() -> FDMSpaceItemControl {
        let playerAutoSpaceItem = FDMSpaceItemControl(autoSpaceHeight: 15)
        
        return playerAutoSpaceItem
    }
    
    /// 创建更多
    func createMoreItem() -> FDMButtonItemControl {
        let itemSize = CGSize(width: 30, height: 30)
        let moreImage = UIImage(named: ImageConfig.shared.player_more)
        let playerMoreItem = FDMButtonItemControl(image: moreImage, size: itemSize)
        
        return playerMoreItem
    }
}

//MARK: BottomBarUI
extension FDMPlayerItemsManager {
    /// 创建播放
    func createPlayerItem() -> FDMButtonItemControl {
        let itemSize = CGSize(width: 30, height: 30)
        let playImage = UIImage(named: ImageConfig.shared.video_mini_play)
        let pauseImage = UIImage(named: ImageConfig.shared.video_mini_pause)
        let playerButtonItem = FDMButtonItemControl(size: itemSize)
        playerButtonItem.item.setImage(playImage, for: .normal)
        playerButtonItem.item.setImage(pauseImage, for: .selected)
        
        return playerButtonItem
    }
    
    /// 创建进度条
    func createProgressItem() -> FDMProgressItemControl {
        let thumbImage = UIImage(named: ImageConfig.shared.player_mini_thumb)
        let playerProgressItem = FDMProgressItemControl(thumbImage, .purple, .gray, 20)
        
        return playerProgressItem
    }
    
    /// 创建时间
    func createTimeItem() -> FDMLabelItemControl {
        let playerTimeItem = FDMLabelItemControl(text: "00:00 / 00:00", color: .white, font: UIFont.systemFont(ofSize: 13))
        
        return playerTimeItem
    }
    
    /// 创建全屏
    func createFullScreenItem() -> FDMButtonItemControl {
        let itemSize = CGSize(width: 30, height: 30)
        let screenImage = UIImage(named: ImageConfig.shared.video_screen)
        let unScreenImage = UIImage(named: ImageConfig.shared.video_unScreen)
        let playerFullScreenItem = FDMButtonItemControl(size: itemSize)
        playerFullScreenItem.item.setImage(screenImage, for: .normal)
        playerFullScreenItem.item.setImage(unScreenImage, for: .selected)
        
        return playerFullScreenItem
    }
    
    /// 创建弹幕
    func createBarrageItem() -> FDMButtonItemControl {
        let itemSize = CGSize(width: 30, height: 30)
        let barrageImage = UIImage(named: ImageConfig.shared.player_barrage)
        let playerBarrageItem = FDMButtonItemControl(size: itemSize)
        playerBarrageItem.item.setImage(barrageImage, for: .normal)
        
        return playerBarrageItem
    }
    
    /// 创建设置
    func createSettingItem() -> FDMButtonItemControl {
        let itemSize = CGSize(width: 30, height: 30)
        let settingImage = UIImage(named: ImageConfig.shared.player_full_settings)
        let playerSettingItem = FDMButtonItemControl(size: itemSize)
        playerSettingItem.item.setImage(settingImage, for: .normal)
        
        return playerSettingItem
    }
    
    /// 创建输入框
    func createTextItem() -> FDMButtonItemControl {
        let playerTextItem = FDMButtonItemControl(autoSpaceHeight: 25)
        playerTextItem.item.setTitle("发个友善的弹幕见证当下", for: .normal)
        playerTextItem.item.setTitleColor(.darkGray, for: .normal)
        playerTextItem.item.backgroundColor = .gray
        playerTextItem.item.layer.cornerRadius = 4
        playerTextItem.item.titleLabel?.textAlignment = .left
        playerTextItem.item.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        playerTextItem.item.alpha = 0.65
        
        return playerTextItem
    }
    
    /// 创建倍速
    func createSpeedItem() -> FDMButtonItemControl {
        let playerSpeedItem = FDMButtonItemControl(title: "倍速", size: nil, titleColor: .gray)
        playerSpeedItem.item.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        return playerSpeedItem
    }
    
    /// 创建画质
    func createQualityItem() -> FDMButtonItemControl {
        let playerQualityItem = FDMButtonItemControl(title: "1080P", size: nil, titleColor: .gray)
        playerQualityItem.item.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        return playerQualityItem
    }
}
