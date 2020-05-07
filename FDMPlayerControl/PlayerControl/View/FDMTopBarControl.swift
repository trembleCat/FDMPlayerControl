//
//  FDMTopBarControl.swift
//  FDMPlayerControl
//
//  Created by 发抖喵 on 2020/5/7.
//  Copyright © 2020 发抖喵. All rights reserved.
//

import UIKit

@objc protocol FDMTopBarControlDelegate: NSObjectProtocol {
    /// 点击返回
    func clickBackItem(item: UIButton, screenState: Bool)
    /// 点击更多
    func clickMoreItem(item: UIButton, screenState: Bool)
}

class FDMTopBarControl: FDMPlayerBarControl {
    
    var backItem: FDMControlButtonItem!
    var titleItem: FDMControlLabelItem!
    var spacItem: FDMControlSpaceItem!
    var moreItem: FDMControlButtonItem!
    
    var delegate: FDMTopBarControlDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createBarItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: UI
extension FDMTopBarControl {
    func createBarItem() {
        /* 返回 */
        let backItemSize = CGSize(width: 25, height: 25)
        let backItemImage = UIImage(named: ImageConfig.shared.video_mini_back)
        backItem = FDMControlButtonItem(image: backItemImage, size: backItemSize)
        backItem.clickItemBlock = {[weak self] sender, isFullScreen in
            let resp = self?.delegate?.responds(to: #selector(self?.delegate?.clickBackItem(item:screenState:)))
            guard (resp ?? false && self?.delegate != nil) else { return }
            
            self?.delegate?.clickBackItem(item: sender, screenState: isFullScreen)
        }
        
        /* 标题 */
        titleItem = FDMControlLabelItem(size: CGSize(width: 150, height: 25))
        titleItem.item.text = "中华小当家"
        titleItem.item.font = UIFont.systemFont(ofSize: 15)
        titleItem.item.textColor = .white
        
        /* 间距 */
        spacItem = FDMControlSpaceItem(autoSpaceHeight: 20)
        
        /* 更多 */
        let moreItemSize = CGSize(width: 25, height: 25)
        let moreItemImage = UIImage(named: ImageConfig.shared.player_more)
        moreItem = FDMControlButtonItem(image: moreItemImage, size: moreItemSize)
        moreItem.clickItemBlock = {[weak self] sender, isFullScreen in
            let resp = self?.delegate?.responds(to: #selector(self?.delegate?.clickMoreItem(item:screenState:)))
            guard (resp ?? false && self?.delegate != nil) else { return }
            
            self?.delegate?.clickMoreItem(item: sender, screenState: isFullScreen)
        }
        
        self.backgroundView = UIImageView(image: UIImage(named: ImageConfig.shared.video_topShadow))
        self.itemAry = [backItem,titleItem,spacItem,moreItem]
    }
}
