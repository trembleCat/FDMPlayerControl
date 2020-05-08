//
//  FDMTopItemManager.swift
//  FDMPlayerControl
//
//  Created by 发抖喵 on 2020/5/8.
//  Copyright © 2020 发抖喵. All rights reserved.
//

import UIKit

class FDMTopItemManager: NSObject {
    /// 返回
    var backItem: FDMButtonItemControl!
    /// 标题
    var titleItem: FDMLabelItemControl!
    
    override init() {
        super.init()
        
        createUI()
    }
    
    func createUI() {
        createBackItem()
        createTitleItem()
    }
}

//MARK: UI
extension FDMTopItemManager {
    /// 创建返回
    func createBackItem() {
        let itemSize = CGSize(width: 25, height: 25)
        let backImage = UIImage(named: ImageConfig.shared.video_mini_back)
        backItem = FDMButtonItemControl(image: backImage, size: itemSize)
    }
    
    /// 创建标题
    func createTitleItem() {
        let itemSize = CGSize(width: 150, height: 25)
        titleItem = FDMLabelItemControl(size: itemSize)
        titleItem.item.font = UIFont.systemFont(ofSize: 15)
        titleItem.item.textColor = .white
    }
}
