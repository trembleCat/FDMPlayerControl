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
    
    var isFullScreen: Bool = false
    var smallBarHeight: CGFloat = 35
    var fullBarHeight: CGFloat = 45
    
    var topBarControl: FDMPlayerBarControl? {
        didSet {
            self.addSubview(topBarControl!)
        }
    }
    var bottomBarControl: FDMPlayerBarControl? {
        didSet {
            self.addSubview(bottomBarControl!)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Action
extension FDMPlayerGestureControl {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bottomBarControl?.snp.makeConstraints({ (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(isFullScreen ? fullBarHeight : smallBarHeight)
        })
        
        topBarControl?.snp.makeConstraints({ (make) in
            make.left.right.top.equalTo(self)
            make.height.equalTo(isFullScreen ? fullBarHeight + 20 : smallBarHeight)
        })
    }
}
