//
//  FDMPlayerBottomBarControl.swift
//  FDMPlayerControl
//
//  Created by 发抖喵 on 2020/4/28.
//  Copyright © 2020 发抖喵. All rights reserved.
//

import UIKit

/// 底部控制器类型
enum FDMPlayerBottomBarStyle {
    /// 普通视频(进度条)
    case DefaultVideo
    /// 短视频(只有进度条)
    case ShortVideo
    /// 直播视频(输入框)
    case LiveVideo
}

//MARK: 底部控制器
class FDMPlayerBottomBarControl: FDMPlayerBarControl {
    let gradientLayer = CAGradientLayer()
    var barStyle: FDMPlayerBottomBarStyle = .DefaultVideo
    
    init() {
        super.init(frame: CGRect.zero)
        createBaseStyle()
    }
    
    /// 初始化 - 底部控制器类型
    init(barStyle: FDMPlayerBottomBarStyle) {
        self.barStyle = barStyle
        super.init(frame: CGRect.zero)
        
        createBaseStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: UI
extension FDMPlayerBottomBarControl {
    func createBaseStyle() {
        self.layer.addSublayer(gradientLayer)
        
        /* 渐变背景 */
        gradientLayer.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor,UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5,y: 1)
        gradientLayer.endPoint = CGPoint(x: 0.5,y: 0)
        gradientLayer.locations = [0,1]
        
        switch barStyle {
        case .DefaultVideo:
            createDefaultVideoUI()
            break
        case .ShortVideo:
            createShortVideoUI()
            break
        case .LiveVideo:
            createLiveVideoUI()
            break
        }
    }
    
    /// 普通视频
    func createDefaultVideoUI() {
        
    }
    
    /// 短视频
    func createShortVideoUI() {
        /* 播放Item */
        let playSize = CGSize(width: 25, height: 25)
        let playImage = UIImage(named: ImageConfig.shared.player_start)
        let playItem = FDMControlButtonItem(image: playImage!, size: playSize, target: self, selector: #selector(self.clickPlayItem(sender:)))
        
        /* 进度条 */
        let progressItem = FDMControlProgressItem(progressHeight: 25)
        progressItem.progressItem.setThumbImage(UIImage(named: ImageConfig.shared.player_thumbMin), for: .normal)
        
        self.itemAry = [playItem,progressItem]
        self.refreshLayoutItems()
    }
    
    /// 直播视频
    func createLiveVideoUI() {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
    }
}

//MARK: Action
extension FDMPlayerBottomBarControl {
    @objc func clickPlayItem(sender: UIButton) {
        print("!1111111")
    }
}
