//
//  FDMPlayerTopControl.swift
//  FDMPlayerControl
//
//  Created by 发抖喵 on 2020/5/8.
//  Copyright © 2020 发抖喵. All rights reserved.
//

import UIKit

class FDMPlayerTopControl: FDMPlayerBarControl {
    let itemManager = FDMTopItemManager()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: UI
extension FDMPlayerTopControl {
    func createUI() {
        let backgroundImage = UIImage(named: ImageConfig.shared.video_topShadow)
        self.itemAry = [itemManager.backItem,itemManager.titleItem]
        self.backgroundView = UIImageView(image: backgroundImage)
    }
}
