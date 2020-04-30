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
        let playItem = FDMControlButtonItem(image: playItemImage, size: playItemSize, target: self, selector: #selector(self.clickPlayItem(_:)))
//        playItem.fullScreenBlock = { [weak self] sender in
//            
//        }
        
        
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
        let fullItem = FDMControlButtonItem(image: fullItemImage, size: fullItemSize, target: self, selector: #selector(self.clickFullItem(_:)))
        
        /* Bar */
        let bottomBar = FDMPlayerBarControl()
        bottomBar.itemAry = [space]
//        bottomBar.backgroundView = UIImageView(image: UIImage(named: ImageConfig.shared.defaultVideo_bottomShadow))
        
        let gestureControl = FDMPlayerGestureControl()
        gestureControl.bottomBarControl = bottomBar
        
        videoView.addSubview(gestureControl)
        gestureControl.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalToSuperview()
        }
        
    }
    
    /// 点击播放
    @objc func clickPlayItem(_ sender: UIButton) {
        if sender.isSelected {
            sender.setImage(UIImage(named: ImageConfig.shared.defaultVideo_all_play), for: .normal)
        }else{
            sender.setImage(UIImage(named: ImageConfig.shared.defaultVideo_all_pause), for: .normal)
        }
        
        sender.isSelected = !sender.isSelected
    }
    
    /// 点击全屏
    @objc func clickFullItem(_ sender: UIButton) {
        if sender.isSelected {
            sender.setImage(UIImage(named: ImageConfig.shared.defaultVideo_all_screen), for: .normal)
        }else{
            sender.setImage(UIImage(named: ImageConfig.shared.defaultVideo_all_unScreen), for: .normal)
        }
        
        sender.isSelected = !sender.isSelected
    }
}




