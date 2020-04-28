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
    /// Item的宽高 - 固定大小时才会调用宽度,默认为0
    var itemSize = CGSize(width: 10, height: 10)
    /// Item的类型 - 自适应宽高/固定宽高
    var itemType: FDMControlItemType
    
    init(itemType: FDMControlItemType, customItem: UIView) {
        self.itemType = itemType
        self.customItem = customItem
    }
}

//MARK: ButtonItem
class FDMControlButtonItem: FDMControlItem {
    let buttonItem = UIButton()
    
    /// ButtonItem - 初始化 - 固定Button宽高
    init(image: UIImage, size: CGSize, target: Any, selector: Selector) {
        super.init(itemType: .FixedItem, customItem: buttonItem)
        
        buttonItem.setImage(image, for: .normal)
        buttonItem.addTarget(target, action: selector, for: .touchUpInside)
        self.itemSize = size
    }
    
    /// ButtonItem - 初始化 - 自适应文字宽高
    init(autoSizeTitle title: String, titleColor: UIColor, target: Any, selector: Selector) {
        super.init(itemType: .FixedItem, customItem: buttonItem)
        
        buttonItem.setTitle(title, for: .normal)
        buttonItem.setTitleColor(titleColor, for: .normal)
        buttonItem.addTarget(target, action: selector, for: .touchUpInside)
        buttonItem.sizeToFit()
        self.itemSize = buttonItem.bounds.size
    }
    
    /// ButtonItem - 初始化 - 固定Button宽高
    init(title: String, size: CGSize, titleColor: UIColor, target: Any, selector: Selector) {
        super.init(itemType: .FixedItem, customItem: buttonItem)
        
        buttonItem.setTitle(title, for: .normal)
        buttonItem.setTitleColor(titleColor, for: .normal)
        buttonItem.addTarget(target, action: selector, for: .touchUpInside)
        self.itemSize = size
    }
}

//MARK: SpaceItem
class FDMControlSpaceItem: FDMControlItem {
    let spaceItem = UIView()
    
    /// SpaceItem - 初始化 - 固定间距宽高
    init(size: CGSize) {
        super.init(itemType: .FixedItem, customItem: spaceItem)
        
        self.itemSize = size
    }
    
    /// SpaceItem - 初始化 - 自适应间距宽度
    init(autoSpaceHeight height: CGFloat) {
        super.init(itemType: .AutoItem, customItem: spaceItem)
        
        self.itemSize = CGSize(width: 0, height: height)
    }
}

//MARK: ProgressItem
class FDMControlProgressItem: FDMControlItem {
    let progressItem = UISlider()
    
    /// ProgressItem - 初始化 - 自适应Progress宽度
    init(progressHeight height: CGFloat) {
        super.init(itemType: .AutoItem, customItem: progressItem)
    
        self.itemSize = CGSize(width: 0, height: height)
        progressItem.setThumbImage(UIImage(named: ImageConfig.shared.player_thumb), for: .normal)
        progressItem.maximumTrackTintColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        progressItem.minimumTrackTintColor = UIColor(red: 72/255, green: 209/255, blue: 204/255, alpha: 1)
    }
}
