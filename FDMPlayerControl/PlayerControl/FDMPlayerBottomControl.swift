//
//  FDMPlayerBottomControl.swift
//  FDMPlayerControl
//
//  Created by 发抖喵 on 2020/5/8.
//  Copyright © 2020 发抖喵. All rights reserved.
//

import UIKit

class FDMPlayerBottomControl: FDMPlayerBarControl {
    
    let itemManager = FDMBottomItemManager()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: UI
extension FDMPlayerBottomControl {
    func createUI() {
        let backgroundImage = UIImage(named: ImageConfig.shared.video_bottomShadow)
        self.itemAry = [itemManager.playerItem,itemManager.progressItem,itemManager.timeItem,itemManager.fullScreenItem]
        self.backgroundView = UIImageView(image: backgroundImage)
    }
}
