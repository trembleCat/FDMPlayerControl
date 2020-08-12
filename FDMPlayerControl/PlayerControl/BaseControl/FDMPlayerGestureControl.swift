//
//  FDMPlayerGestureControl.swift
//  FDMPlayerControl
//
//  Created by 发抖喵 on 2020/4/29.
//  Copyright © 2020 发抖喵. All rights reserved.
//

import UIKit

/* 手势控制器 */
class FDMPlayerGestureControl: UIView {
    private let contentView = UIView()
    private var topBackgroundView: UIView?
    private var bottomBackgroundView: UIView?
    
    var topBarControlAry: [FDMPlayerBarControl]? { didSet { refreshLayoutBars() } }
    var bottomBarControlAry: [FDMPlayerBarControl]? { didSet { refreshLayoutBars() } }
    var controlHidden = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 隐藏或隐藏边缘控制器  -- 增加回调
    func setHiddenControls(_ state: Bool) {
        for control in topBarControlAry ?? [] {
            hiddenBarControl(control: control, state: state)
        }
        
        for control in bottomBarControlAry ?? [] {
            hiddenBarControl(control: control, state: state)
        }
        
        controlHidden = state
    }
    
    /// 添加顶部背景view
    func addTopBackgroundView(_ bgView: UIView, height: CGFloat) {
        if topBackgroundView == nil {
            topBackgroundView = bgView
            self.insertSubview(bgView, at: 0)
            
            topBackgroundView?.snp.makeConstraints({ (make) in
                make.left.right.top.equalToSuperview()
                make.height.equalTo(height)
            })
        }else{
            removeTopBackgroundView()
            addTopBackgroundView(bgView, height: height)
        }
    }
    
    /// 移除顶部背景view
    func removeTopBackgroundView() {
        guard topBackgroundView != nil else { return }
        topBackgroundView?.removeFromSuperview()
        topBackgroundView = nil
    }
    
    /// 添加底部背景View
    func addBottomBackgroundView(_ bgView: UIView, height: CGFloat) {
        if bottomBackgroundView == nil {
            bottomBackgroundView = bgView
            self.insertSubview(bgView, at: 0)
            
            bottomBackgroundView?.snp.makeConstraints({ (make) in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(height)
            })
        }else{
            removeBottomBackgroundView()
            addBottomBackgroundView(bgView, height: height)
        }
    }
    
    /// 移除底部背景View
    func removeBottomBackgroundView() {
        guard bottomBackgroundView != nil else { return }
        bottomBackgroundView?.removeFromSuperview()
        bottomBackgroundView = nil
    }
}

//MARK: Action
extension FDMPlayerGestureControl {
    private func createAction() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureAction(gesture:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    private func refreshLayoutBars() {
        for barControl in contentView.subviews {
            barControl.removeFromSuperview()
        }
        
        var topHeight: CGFloat = 0
        for topControl in topBarControlAry ?? [] {
            contentView.addSubview(topControl)
            
            layoutTopBarControl(topControl, topHeight: topHeight)
            topHeight += topControl.barHeight
        }
        
        var bottomHeight: CGFloat = 0
        for bottomControl in bottomBarControlAry ?? [] {
            contentView.addSubview(bottomControl)
            
            layoutBottomBarControl(bottomControl, bottomHeight: bottomHeight)
            bottomHeight += bottomControl.barHeight
        }
    }
    
    private func hiddenBarControl(control: UIView, state: Bool) {
        let value: CGFloat = state ? 0 : 1
        if !state { control.isHidden = state }
        
        UIView.animate(withDuration: 0.2, animations: {
            control.alpha = value
        }) { (end) in
            control.isHidden = state
        }
    }
    
    private func layoutTopBarControl(_ topControl: FDMPlayerBarControl, topHeight: CGFloat) {
        topControl.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(topHeight)
            make.height.equalTo(topControl.barHeight)
        }
    }
    
    private func layoutBottomBarControl(_ bottomControl: FDMPlayerBarControl, bottomHeight: CGFloat) {
        bottomControl.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-bottomHeight)
            make.height.equalTo(bottomControl.barHeight)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

//MARK: Gesture
extension FDMPlayerGestureControl {
    @objc private func tapGestureAction(gesture: UITapGestureRecognizer) {
        setHiddenControls(!controlHidden)
    }
}
