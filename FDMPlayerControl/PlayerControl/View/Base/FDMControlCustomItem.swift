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
    let buttonItem = UIButton()
    
    /// ButtonItem - 初始化 - 固定Button宽高
    init(size: CGSize) {
        super.init(itemType: .FixedItem, customItem: buttonItem)
        self.itemSize = size
    }
    
    /// ButtonItem - 初始化 - 固定Button宽高
    init(image: UIImage, size: CGSize, target: Any, selector: Selector) {
        super.init(itemType: .FixedItem, customItem: buttonItem)
        
        buttonItem.setImage(image, for: .normal)
        buttonItem.addTarget(target, action: selector, for: .touchUpInside)
        self.itemSize = size
    }
    
    /// ButtonItem - 初始化 - 固定或自适应Button
    init(title: String, size: CGSize?, titleColor: UIColor, target: Any, selector: Selector) {
        super.init(itemType: .FixedItem, customItem: buttonItem)
        
        buttonItem.setTitle(title, for: .normal)
        buttonItem.setTitleColor(titleColor, for: .normal)
        buttonItem.addTarget(target, action: selector, for: .touchUpInside)
        
        if size == nil {
            buttonItem.sizeToFit()
            self.itemSize = buttonItem.bounds.size
        }else{
            self.itemSize = size!
        }
    }
}


//MARK: LabelItem
class FDMControlLabelItem: FDMControlItem {
    let labelItem = UILabel()
    
    init(text: String, color: UIColor?, font: UIFont?) {
        super.init(itemType: .FixedItem, customItem: labelItem)
        
        labelItem.text = text
        labelItem.textColor = color
        labelItem.font = font
        labelItem.sizeToFit()
        self.itemSize = labelItem.bounds.size
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
    }
}
