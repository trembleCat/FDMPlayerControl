//
//  ViewController.swift
//  FDMPlayerControl
//
//  Created by 发抖喵 on 2020/4/27.
//  Copyright © 2020 发抖喵. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let videoView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.addSubview(videoView)
        videoView.backgroundColor = .black
        videoView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.center.equalToSuperview()
            make.height.equalTo(250)
        }
        
        createBottomBarControl()
    }
}

//MARK: UI
extension ViewController: UIDocumentPickerDelegate {
    func createBottomBarControl() {
        /* Play */
        let playItemSize = CGSize(width: 25, height: 25)
        let playItemImage = UIImage(named: ImageConfig.shared.defaultVideo_all_play)!
        let playItem = FDMControlButtonItem(image: playItemImage, size: playItemSize)

        playItem.clickButtonBlock = { sender , isFullScreen in
            if sender.isSelected {
                let imageName = isFullScreen ? ImageConfig.shared.defaultVideo_all_play : ImageConfig.shared.defaultVideo_all_play
                playItem.buttonItem.setImage(UIImage(named: imageName), for: .normal)
            }else{
                let imageName = isFullScreen ? ImageConfig.shared.defaultVideo_all_pause : ImageConfig.shared.defaultVideo_all_pause
                playItem.buttonItem.setImage(UIImage(named: imageName), for: .normal)
            }
            
            sender.isSelected = !sender.isSelected
        }
        
        
        /* progress */
        let thumbImage = UIImage(named: ImageConfig.shared.defaultVideo_mini_slider)
        let progressItem = FDMControlProgressItem(progressHeight: 15)
        progressItem.progressItem.setThumbImage(thumbImage, for: .normal)
        progressItem.progressItem.minimumTrackTintColor = UIColor.Hex(hexString: "#87CEFA")
        progressItem.progressItem.maximumTrackTintColor = UIColor.Hex(hexString: "#F5F5F5")
        
        let space = FDMControlSpaceItem(autoSpaceHeight: 25)
        space.spaceItem.backgroundColor = .orange
        
        /* Time */
        let timeText = "03:20 / 06:24"
        let timeItem = FDMControlLabelItem(text: timeText, color: .white, font: UIFont.systemFont(ofSize: 12))
        
        /* 全屏 */
        let fullItemSize = CGSize(width: 25, height: 25)
        let fullItemImage = UIImage(named: ImageConfig.shared.defaultVideo_all_screen)!
        let fullItem = FDMControlButtonItem(image: fullItemImage, size: fullItemSize)
        
        fullItem.clickButtonBlock = { sender , isFullScreen in
            if sender.isSelected {
                let imageName = isFullScreen ? ImageConfig.shared.defaultVideo_all_screen : ImageConfig.shared.defaultVideo_all_screen
                fullItem.buttonItem.setImage(UIImage(named: imageName), for: .normal)
            }else{
                let imageName = isFullScreen ? ImageConfig.shared.defaultVideo_all_unScreen : ImageConfig.shared.defaultVideo_all_unScreen
                fullItem.buttonItem.setImage(UIImage(named: imageName), for: .normal)
            }
            
            sender.isSelected = !sender.isSelected
        }
        
        /* Bar */
        let bottomBar = FDMPlayerBarControl(itemAry: [playItem,progressItem,timeItem,fullItem])
        bottomBar.backgroundView = UIImageView(image: UIImage(named: ImageConfig.shared.defaultVideo_bottomShadow))
        
        /* 手势控制器 */
        let gestureControl = FDMPlayerGestureControl()
        gestureControl.bottomBarControl = bottomBar
        
        videoView.addSubview(gestureControl)
        gestureControl.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalToSuperview()
        }
    }
}




