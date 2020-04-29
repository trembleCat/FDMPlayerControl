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
    
    private let fullScreenName = "FDMControlFullScreen"
    private let smallScreenName = "FDMControlSmallScreen"
    
    init(itemType: FDMControlItemType, customItem: UIView) {
        self.itemType = itemType
        self.customItem = customItem
        
        super.init()
        self.createAction()
    }
    
    func createAction() {
        NotificationCenter.default.addObserver(self, selector: #selector(fullScreenAction), name: NSNotification.Name.init(fullScreenName), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(smallScreenAction), name: NSNotification.Name.init(smallScreenName), object: nil)
    }
    
    /// 全屏时进行的操作
    @objc func fullScreenAction() {
        
    }
    
    /// 小屏时进行的操作
    @objc func smallScreenAction() {
        
    }
}

//MARK: ButtonItem

class FDMControlButtonItem: FDMControlItem {
    let buttonItem = UIButton()
    
    var fullScreenBlock: ((UIButton)->())?
    var smallScreenBlock: ((UIButton)->())?
    
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
    
    override func fullScreenAction() {
        fullScreenBlock?(buttonItem)
    }
    
    override func smallScreenAction() {
        smallScreenBlock?(buttonItem)
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
    
    var fullScreenBlock: ((UISlider)->())?
    var smallScreenBlock: ((UISlider)->())?
    
    enum ProgressType {
        case DefaultVideo
        case ShortVideo
    }
    
    /// ProgressItem - 初始化 - 自适应Progress宽度
    init(progressHeight height: CGFloat) {
        super.init(itemType: .AutoItem, customItem: progressItem)
        self.itemSize = CGSize(width: 0, height: height)
    }
    
    override func fullScreenAction() {
        fullScreenBlock?(progressItem)
    }
    
    override func smallScreenAction() {
        smallScreenBlock?(progressItem)
    }
}
