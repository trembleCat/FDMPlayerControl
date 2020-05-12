//
//  FDMPlayerProgressView.swift
//  FDMPlayerControl
//
//  Created by 发抖喵 on 2020/5/12.
//  Copyright © 2020 发抖喵. All rights reserved.
//

import UIKit

class FDMPlayerProgressView: UIView {
    
    let thumbView = UIView()
    let miniView = UIView()
    let maxView = UIView()
    let loadingView = UIView()
    
    var progressHeight: CGFloat = 3
    var maxColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
    var minColor = UIColor(red: 255/255, green: 105/255, blue: 180/255, alpha: 1.0)
    var loadColor = UIColor(red: 169/255, green: 169/255, blue: 169/255, alpha: 1.0)
    var thumbSize = CGSize(width: 10, height: 13)
    
    /// 修改进度回调
    var changeValueBlock: ((CGFloat,UIGestureRecognizer.State)->())?
    
    private(set) var loadValue: CGFloat = 0
    private(set) var miniValue: CGFloat = 0
    
    private var progressWidth: CGFloat = 0
    private var beganMiniWidth: CGFloat = 0
    private var beganPoint = CGPoint.zero
    private var isGesture = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 设置加载进度
    func setLoadValue(_ value: CGFloat) {
        
        if value > 1 {
            loadValue = 1
        }else if value < 0 {
            loadValue = 0
        }else {
            loadValue = value
        }
        
        loadingView.snp.updateConstraints { (make) in
            make.width.equalTo(loadValue * progressWidth)
        }
    }
    
    /// 设置播放进度
    func setMiniValue(_ value: CGFloat) {
        guard isGesture == false else { return }
        
        if value > 1 {
            miniValue = 1
        }else if value < 0 {
            miniValue = 0
        }else {
            miniValue = value
        }
        
        miniView.snp.updateConstraints { (make) in
            make.width.equalTo(miniValue * progressWidth)
        }
    }
}

//MARK: UI
extension FDMPlayerProgressView {
    private func createUI() {
        self.addSubview(maxView)
        maxView.addSubview(loadingView)
        maxView.addSubview(miniView)
        self.addSubview(thumbView)
        
        /* 最大进度 */
        maxView.backgroundColor = maxColor
        maxView.layer.cornerRadius = progressHeight * 0.5
        maxView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(progressHeight)
        }
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.thumbViewPanGesture(_:)))
        thumbView.isUserInteractionEnabled = true
        thumbView.addGestureRecognizer(panGesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        maxView.setNeedsLayout()
        maxView.layoutIfNeeded()
        
        progressWidth = maxView.bounds.width
        
        /* 加载进度 */
        loadingView.backgroundColor = loadColor
        loadingView.layer.cornerRadius = progressHeight * 0.5
        loadingView.snp.remakeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(loadValue * progressWidth)
        }
        
        /* 已完成进度 */
        miniView.backgroundColor = minColor
        miniView.layer.cornerRadius = progressHeight * 0.5
        miniView.snp.remakeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(miniValue * progressWidth)
        }
        
        /* 滑块 */
        thumbView.layer.cornerRadius = 2
        thumbView.backgroundColor = .white
        thumbView.snp.remakeConstraints { (make) in
            make.centerX.equalTo(miniView.snp.right)
            make.centerY.equalToSuperview()
            make.width.equalTo(thumbSize.width)
            make.height.equalTo(thumbSize.height)
        }
    }
}

//MARK: PanGesture
extension FDMPlayerProgressView {
    @objc private func thumbViewPanGesture(_ gesture: UIPanGestureRecognizer) {
        let point = gesture.location(in: self)
        
        switch gesture.state {
        case .began:
            isGesture = true
            beganPoint = point
            beganMiniWidth = miniView.bounds.width
            
            changeValueBlock?(miniValue,.began)
            break
        case .changed:
            isGesture = true
            
            let PointX = point.x - beganPoint.x
            var value = (PointX + beganMiniWidth) / progressWidth

            if value < 0 {
                value = 0
            }else if value > 1 {
                value = 1
            }

            miniValue = value
            miniView.snp.updateConstraints { (make) in
                make.width.equalTo(miniValue * progressWidth)
            }
            
            changeValueBlock?(miniValue,.changed)
            
            break
        case .ended:
            isGesture = false
            beganPoint = CGPoint.zero
            beganMiniWidth = 0
            
            changeValueBlock?(miniValue,.ended)
            break
        case .cancelled:
            isGesture = false
            beganPoint = CGPoint.zero
            beganMiniWidth = 0
            
            changeValueBlock?(miniValue,.cancelled)
            break
        default:
            isGesture = false
            beganPoint = CGPoint.zero
            beganMiniWidth = 0
            break
        }
    }
}