//
//  FDMBottomBarControl.swift
//  FDMPlayerControl
//
//  Created by 发抖喵 on 2020/5/7.
//  Copyright © 2020 发抖喵. All rights reserved.
//

import UIKit

@objc protocol FDMBottomBarControlDelegate: NSObjectProtocol {
    /// 点击播放
    func clickPlayItem(item: UIButton, screenState: Bool)
    /// 点击全屏
    func clickFullItem(item: UIButton, screenState: Bool)
    /// 修改进度条值
    func progressItemValueChange(item: UISlider, value: Float)
}

class FDMBottomBarControl: FDMPlayerBarControl {
    
    var playItem: FDMControlButtonItem!
    var progressItem: FDMControlProgressItem!
    var timeItem: FDMControlLabelItem!
    var fullItem: FDMControlButtonItem!
    
    var delegate: FDMBottomBarControlDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createBarItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: UI
extension FDMBottomBarControl {
    func createBarItem() {
        /* 播放 */
        let playItemSize = CGSize(width: 25, height: 25)
        let playItemImage = UIImage(named: ImageConfig.shared.video_mini_play)
        playItem = FDMControlButtonItem(image: playItemImage, size: playItemSize)

        playItem.clickItemBlock = {[weak self] sender, isFullScreen in
            let resp = self?.delegate?.responds(to: #selector(self?.delegate?.clickFullItem(item:screenState:)))
            guard (resp ?? false && self?.delegate != nil) else { return }
            
            self?.delegate?.clickPlayItem(item: sender, screenState: isFullScreen)
        }
                
        /* 进度 */
        let thumbImage = UIImage(named: ImageConfig.shared.video_mini_slider)
        progressItem = FDMControlProgressItem(thumbImage, UIColor.Hex("#87CEFA"), UIColor.Hex("#F5F5F5"), 15)
                
        progressItem.itemChangeValueBlock = {[weak self] sender, value in
            let resp = self?.delegate?.responds(to: #selector(self?.delegate?.progressItemValueChange(item:value:)))
            guard (resp ?? false && self?.delegate != nil) else { return }
            
            self?.delegate?.progressItemValueChange(item: sender, value: value)
        }
                
        /* 时间 */
        let timeText = "00:00 / 00:00"
        timeItem = FDMControlLabelItem(text: timeText, color: .white, font: UIFont.systemFont(ofSize: 12))
        timeItem.item.textAlignment = .right
        
        /* 全屏 */
        let fullItemSize = CGSize(width: 25, height: 25)
        let fullItemImage = UIImage(named: ImageConfig.shared.video_screen)
        fullItem = FDMControlButtonItem(image: fullItemImage, size: fullItemSize)
        
        fullItem.clickItemBlock = {[weak self] sender, isFullScreen in
            let resp = self?.delegate?.responds(to: #selector(self?.delegate?.clickFullItem(item:screenState:)))
            guard (resp ?? false && self?.delegate != nil) else { return }
            
            self?.delegate?.clickFullItem(item: sender, screenState: isFullScreen)
        }
        
        self.backgroundView = UIImageView(image: UIImage(named: ImageConfig.shared.video_bottomShadow))
        self.itemAry = [playItem,progressItem,timeItem,fullItem]
    }
}
