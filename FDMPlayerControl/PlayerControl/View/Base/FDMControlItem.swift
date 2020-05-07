//
//  FDMControlItem.swift
//  FDMPlayerControl
//
//  Created by 发抖喵 on 2020/4/27.
//  Copyright © 2020 发抖喵. All rights reserved.
//

import UIKit

//MARK: ItemType
enum FDMControlItemType {
    /// 固定宽高
    case FixedItem
    /// 自适应宽高
    case AutoItem
}

//MARK: FDMPlayerItem
class FDMControlItem: NSObject {
    
    /// 自定义的Item
    var customItem: UIView
    /// Item的宽高 - 固定大小时才会调用宽度,默认为10
    var itemSize = CGSize(width: 10, height: 10)
    /// Item的类型 - 自适应宽高/固定宽高
    var itemType: FDMControlItemType
    
    /// 全屏回调
    var fullScreenBlock: ((UIView)->())?
    /// 小屏回调
    var smallScreenBlock: ((UIView)->())?
    
    /// 是否全屏
    var isFullScreen = false
    
    private let fullScreenName = "FDMControlFullScreen"
    private let smallScreenName = "FDMControlSmallScreen"
    
    init(itemType: FDMControlItemType, customItem: UIView) {
        self.itemType = itemType
        self.customItem = customItem
        
        super.init()
        self.createAction()
    }
    
    private func createAction() {
        NotificationCenter.default.addObserver(self, selector: #selector(fullScreenAction), name: NSNotification.Name.init(fullScreenName), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(smallScreenAction), name: NSNotification.Name.init(smallScreenName), object: nil)
    }
    
    /// 全屏时进行的操作
    @objc private func fullScreenAction() {
        isFullScreen = true
        fullScreenBlock?(customItem)
    }
    
    /// 小屏时进行的操作
    @objc private func smallScreenAction() {
        isFullScreen = false
        smallScreenBlock?(customItem)
    }
}
