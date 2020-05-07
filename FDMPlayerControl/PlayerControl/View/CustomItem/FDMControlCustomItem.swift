//
//  FDMControlCustomItem.swift
//  FDMPlayerControl
//
//  Created by 发抖喵 on 2020/4/30.
//  Copyright © 2020 发抖喵. All rights reserved.
//

import UIKit

//MARK: ButtonItem

class FDMControlButtonItem: FDMControlItem {
    let item = UIButton(type: .custom)
    
    /// 点击返回Button 与 全屏状态
    var clickItemBlock: ((UIButton, Bool)->())?
    
    /// ButtonItem - 初始化 - 固定Button宽高
    init(size: CGSize) {
        super.init(itemType: .FixedItem, customItem: item)
        self.itemSize = size
        
        item.addTarget(self, action: #selector(self.clickItem), for: .touchUpInside)
    }
    
    /// ButtonItem - 初始化 - 自适应宽度
    init(autoSpaceHeight height: CGFloat) {
        super.init(itemType: .AutoItem, customItem: item)
        self.itemSize = CGSize(width: 0, height: height)
        
        item.addTarget(self, action: #selector(self.clickItem), for: .touchUpInside)
    }
    
    /// ButtonItem - 初始化 - 固定Button宽高
    init(image: UIImage?, size: CGSize) {
        super.init(itemType: .FixedItem, customItem: item)
        self.itemSize = size
        
        item.setImage(image, for: .normal)
        item.addTarget(self, action: #selector(self.clickItem), for: .touchUpInside)
    }
    
    /// ButtonItem - 初始化 - 固定Button
    init(title: String?, size: CGSize?, titleColor: UIColor) {
        super.init(itemType: .FixedItem, customItem: item)
        
        item.setTitle(title, for: .normal)
        item.setTitleColor(titleColor, for: .normal)
        item.addTarget(self, action: #selector(self.clickItem), for: .touchUpInside)
        
        if size == nil {
            item.sizeToFit()
            self.itemSize = item.bounds.size
        }else{
            self.itemSize = size!
        }
    }
    
    /// 点击Item
    @objc func clickItem() {
        clickItemBlock?(item,isFullScreen)
    }
}


//MARK: LabelItem
class FDMControlLabelItem: FDMControlItem {
    let item = UILabel()
    
    /// LabelItem - 初始化 - 固定宽高
    init(size: CGSize) {
        super.init(itemType: .FixedItem, customItem: item)
        self.itemSize = size
    }
    
    /// LabelItem - 初始化 - 自适应宽度
    init(autoSpaceHeight height: CGFloat) {
        super.init(itemType: .AutoItem, customItem: item)
        self.itemSize = CGSize(width: 0, height: height)
    }
    
    /// LabelItem - 初始化 - 固定宽高
    init(text: String, color: UIColor?, font: UIFont?) {
        super.init(itemType: .FixedItem, customItem: item)
        
        item.text = text
        item.textColor = color
        item.font = font
        item.sizeToFit()
        self.itemSize = item.bounds.size
    }
}


//MARK: SpaceItem
class FDMControlSpaceItem: FDMControlItem {
    let item = UIView()
    
    /// SpaceItem - 初始化 - 固定间距宽高
    init(size: CGSize) {
        super.init(itemType: .FixedItem, customItem: item)
        self.itemSize = size
    }
    
    /// SpaceItem - 初始化 - 自适应间距宽度
    init(autoSpaceHeight height: CGFloat) {
        super.init(itemType: .AutoItem, customItem: item)
        self.itemSize = CGSize(width: 0, height: height)
    }
}


//MARK: ProgressItem
class FDMControlProgressItem: FDMControlItem {
    let item = UISlider()
    
    var itemChangeValueBlock: ((UISlider,Float)->())?
    
    /// ProgressItem - 初始化 - 固定Progress宽度
    init(size: CGSize) {
        super.init(itemType: .FixedItem, customItem: item)
        self.itemSize = size
        
        item.addTarget(self, action: #selector(self.itemChangeValue(sender:)), for: .valueChanged)
    }
    
    /// ProgressItem - 初始化 - 自适应Progress宽度
    init(progressHeight height: CGFloat) {
        super.init(itemType: .AutoItem, customItem: item)
        self.itemSize = CGSize(width: 0, height: height)
        
        item.addTarget(self, action: #selector(self.itemChangeValue(sender:)), for: .valueChanged)
    }
    
    /// ProgressItem - 初始化 - 自适应Progress宽度
    init(_ thumbImage: UIImage?,_ miniColor: UIColor?,_ maxColor: UIColor?,_ height: CGFloat) {
        super.init(itemType: .AutoItem, customItem: item)
        self.itemSize = CGSize(width: 0, height: height)
        
        item.setThumbImage(thumbImage, for: .normal)
        item.minimumTrackTintColor = miniColor
        item.maximumTrackTintColor = maxColor
        item.addTarget(self, action: #selector(self.itemChangeValue(sender:)), for: .valueChanged)
    }
    
    /// 滑动Item
    @objc func itemChangeValue(sender: UISlider) {
        itemChangeValueBlock?(sender,sender.value)
    }
}
