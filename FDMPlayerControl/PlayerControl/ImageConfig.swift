//
//  ImageConfig.swift
//  FDMPlayerControl
//
//  Created by 发抖喵 on 2020/4/28.
//  Copyright © 2020 发抖喵. All rights reserved.
//

import UIKit

//MARK: 保存图片名称
class ImageConfig: NSObject {
    static let shared = ImageConfig()
    
    //MARK: DefaultVideo
    
    /// 暂停
    let defaultVideo_all_pause = "defaultVideo_all_pause"
    /// 播放
    let defaultVideo_all_play = "defaultVideo_all_play"
    /// 全屏
    let defaultVideo_all_screen = "defaultVideo_all_screen"
    /// 取消全屏
    let defaultVideo_all_unScreen = "defaultVideo_all_unScreen"
    /// 底部阴影
    let defaultVideo_bottomShadow = "defaultVideo_bottomShadow"
    /// 亮度标识
    let defaultVideo_bright = "defaultVideo_bright"
    /// 中心亮度标识
    let defaultVideo_center_bright = "defaultVideo_center_bright"
    /// 全屏状态返回
    let defaultVideo_full_back = "defaultVideo_full_back"
    /// 全屏状态滑块
    let defaultVideo_full_slider = "defaultVideo_full_slider"
    /// 缩小状态返回
    let defaultVideo_mini_back = "defaultVideo_mini_back"
    /// 缩小状态滑块
    let defaultVideo_mini_slider = "defaultVideo_mini_slider"
    /// 全屏中心暂停
    let defaultVideo_center_pause = "defaultVideo_center_pause"
    /// 全屏中心播放
    let defaultVideo_center_play = "defaultVideo_center_play"
    /// 顶部阴影
    let defaultVideo_topShadow = "defaultVideo_topShadow"
    /// 关闭
    let defaultVideo_close = "defaultVideo_close"
    
    
    //MARK: PublicVideo
    
    /// Thumb
    let player_thumb = "player_thumb"
    /// 信号量1
    let player_volum1 = "player_volum1"
    /// 信号量2
    let player_volum2 = "player_volum2"
    /// 信号量3
    let player_volum3 = "player_volum3"
    /// 信号量4
    let player_volum4 = "player_volum4"
    /// 信号量5
    let player_volum5 = "player_volum5"
    /// WiFi标识
    let player_statusBar_WIFI = "player_statusBar_WIFI"
}
