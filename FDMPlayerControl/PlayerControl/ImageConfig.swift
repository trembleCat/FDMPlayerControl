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
    
    /// 播放
    let player_start = "player_start"
    /// 暂停
    let player_suspend = "player_suspend"
    /// 音量
    let player_speak = "player_speak"
    /// 返回
    let player_back = "player_back"
    /// 屏幕中心播放
    let player_fullplay = "player_fullplay"
    /// 更多
    let player_more = "player_more"
    /// 滑块按钮
    let player_thumb = "player_thumb"
    /// min滑块按钮
    let player_thumbMin = "player_thumbMin"
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
}
