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
    let playerGestureControl = FDMPlayerGestureControl()
    let bottomBarControl = FDMBottomBarControl(frame: .zero)
    let topBarControl = FDMTopBarControl(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.addSubview(videoView)
        videoView.backgroundColor = .black
        videoView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(250)
        }
        
        bottomBarControl.delegate = self
        playerGestureControl.bottomBarControl = bottomBarControl
        
        topBarControl.delegate = self
        playerGestureControl.topBarControl = topBarControl
        
        videoView.addSubview(playerGestureControl)
        playerGestureControl.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        bottomBarControl.itemAry?.removeFirst()
    }
}

//MARK: BottomBarDelegate
extension ViewController: FDMBottomBarControlDelegate {
    func clickPlayItem(item: UIButton, screenState: Bool) {
        if item.isSelected {
            let imageName = screenState ? ImageConfig.shared.video_full_play : ImageConfig.shared.video_mini_play
            item.setImage(UIImage(named: imageName), for: .normal)
        }else{
            let imageName = screenState ? ImageConfig.shared.video_full_pause : ImageConfig.shared.video_mini_pause
            item.setImage(UIImage(named: imageName), for: .normal)
        }
        
        item.isSelected = !item.isSelected
    }
    
    func clickFullItem(item: UIButton, screenState: Bool) {
        if item.isSelected {
            let imageName = ImageConfig.shared.video_screen
            item.setImage(UIImage(named: imageName), for: .normal)
        }else{
            let imageName = ImageConfig.shared.video_unScreen
            item.setImage(UIImage(named: imageName), for: .normal)
        }
        
        item.isSelected = !item.isSelected
    }
    
    func progressItemValueChange(item: UISlider, value: Float) {
        bottomBarControl.timeItem.item.text = String(format: "%.3lf", value) + " : 01.00"
    }
}

//MARK: TopBarDelegate
extension ViewController: FDMTopBarControlDelegate {
    func clickBackItem(item: UIButton, screenState: Bool) {
        if screenState {
            print("小屏")
        }else{
            print("返回上一页")
        }
    }
    
    func clickMoreItem(item: UIButton, screenState: Bool) {
        
    }
}




