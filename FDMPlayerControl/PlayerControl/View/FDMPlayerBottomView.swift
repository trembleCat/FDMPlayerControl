//
//  FDMPlayerBottomView.swift
//  FDMPlayerControl
//
//  Created by 发抖喵 on 2020/4/27.
//  Copyright © 2020 发抖喵. All rights reserved.
//

import UIKit

class FDMPlayerBottomView: UIView {
    
    var itemSpacing: CGFloat = 10
    var itemAry: [FDMPlayerItem]? {
        didSet{
            createUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(itemAry: [FDMPlayerItem]) {
        self.itemAry = itemAry
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: UI
extension FDMPlayerBottomView {
    func createUI() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
        
        var i = 0
        for item in itemAry ?? [] {
            let itemView = item.customItem
            self.addSubview(itemView)
            
            itemView.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(20)
                make.centerY.equalToSuperview()
                make.width.equalTo(item.itemSize!.width)
                make.height.equalTo(item.itemSize!.height)
            }
            
            i += 1
        }
    }
    
    /// 布局控件
    func layoutItems() {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
}
