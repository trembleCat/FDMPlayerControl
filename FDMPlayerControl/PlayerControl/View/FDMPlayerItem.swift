//
//  FDMPlayerItem.swift
//  FDMPlayerControl
//
//  Created by 发抖喵 on 2020/4/27.
//  Copyright © 2020 发抖喵. All rights reserved.
//

import UIKit

/// Item类型
enum FDMPlayerItemType {
    case FixedItem // 固定宽度
    case AutoItem  // 自适应宽度
}

class FDMPlayerItem: NSObject {
    
    var customItem: UIView
    var itemSize: CGSize?
    var itemType: FDMPlayerItemType?
    
    init(type: FDMPlayerItemType, item: UIView) {
        self.itemType = type
        self.customItem = item
    }
}

/// ButtonItem
class FDMPlayerButtonItem: FDMPlayerItem {
    
    let customButton = UIButton()
    
    init(image: UIImage, target: Any, selector: Selector) {
        super.init(type: .FixedItem, item: customButton)
        
        customButton.setImage(image, for: .normal)
        customButton.addTarget(target, action: selector, for: .touchUpInside)
        self.itemSize = CGSize(width: 30, height: 30)
    }
    
    init(title: String, titleColor: UIColor, target: Any, selector: Selector) {
        super.init(type: .FixedItem, item: customButton)
        
        customButton.setTitle(title, for: .normal)
        customButton.setTitleColor(titleColor, for: .normal)
        customButton.addTarget(target, action: selector, for: .touchUpInside)
        customButton.sizeToFit()
        self.itemSize = customButton.bounds.size
    }
}
