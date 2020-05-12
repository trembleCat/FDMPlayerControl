//
//  FDMPlayerItemsManager.swift
//  FDMPlayerControl
//
//  Created by 发抖喵 on 2020/5/9.
//  Copyright © 2020 发抖喵. All rights reserved.
//

import UIKit

class FDMPlayerItemsManager: NSObject {
    
    static let shared = FDMPlayerItemsManager()

//MARK: TopBar
    /// 返回
    lazy var backItem: FDMButtonItemControl = { return createBackItem() }()
    /// 标题
    lazy var titleItem: FDMLabelItemControl = { return createTitleItem() }()
    /// 自动宽度间距
    lazy var autoSpaceItem: FDMSpaceItemControl = { return createAutoSpaceItem() }()
    /// 更多
    lazy var moreItem: FDMButtonItemControl = { return createMoreItem() }()
    
    
//MARK: BottomBar
    /// 播放
    lazy var playerItem: FDMButtonItemControl = { return createPlayerItem() }()
    /// 进度条
    lazy var progressItem: FDMProgressItemControl = { return createProgressItem() }()
    /// 时间
    lazy var timeItem: FDMLabelItemControl = { return createTimeItem() }()
    /// 全屏
    lazy var fullScreenItem: FDMButtonItemControl = { return createFullScreenItem() }()
    
    /// 弹幕
    lazy var barrageItem: FDMButtonItemControl = { return createBarrageItem() }()
    /// 设置
    lazy var settingItem: FDMButtonItemControl = { return createSettingItem() }()
    /// 输入框(临时)
    lazy var textItem: FDMButtonItemControl = { return createTextItem() }()
    /// 倍速
    lazy var speedItem: FDMButtonItemControl = { return createSpeedItem() }()
    /// 画质
    lazy var qualityItem: FDMButtonItemControl = {return createQualityItem() }()
}
