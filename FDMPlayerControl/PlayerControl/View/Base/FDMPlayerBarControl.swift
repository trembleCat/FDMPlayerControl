//
//  FDMPlayerBarControl.swift
//  FDMPlayerControl
//
//  Created by 发抖喵 on 2020/4/27.
//  Copyright © 2020 发抖喵. All rights reserved.
//

import UIKit

//MARK: Bar控制器 一排最多支持一个自适应Item
class FDMPlayerBarControl: UIView {
    
    /// item间距
    var itemSpacing: CGFloat = 10 {
        didSet{
            super.setNeedsLayout()
            super.layoutIfNeeded()
        }
    }
    
    /// items
    var itemAry: [FDMControlItem]? {
        didSet{
            refreshLayoutItems()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    /// 初始化
    init(itemAry: [FDMControlItem]) {
        self.itemAry = itemAry
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 刷新Items布局
    func refreshLayoutItems() {
        createUI()
    }
}

//MARK: UI
extension FDMPlayerBarControl {
    final func createUI() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
        
        for item in itemAry ?? [] {
            self.addSubview(item.customItem)
        }
        
        var i = 0
        var isAutoItem = false
        var previousItem: FDMControlItem?
        
        for item in itemAry ?? [] {
            layoutItems(item: item, previousItem: previousItem, count: i, isAutoItem: isAutoItem)
            previousItem = item
            isAutoItem = item.itemType == .AutoItem ? true : isAutoItem
            
            i += 1
        }
    }
    
    /// 布局Item
    final func layoutItems(item: FDMControlItem,previousItem: FDMControlItem?, count: Int, isAutoItem: Bool) {
        let currentItem = item.customItem  // 当前item.view
        let currentItemSize = item.itemSize    // 当前Size
        
        let isEndItem = itemAry?.count ?? 0 > (count + 1)   // 是否最后一个item
        let previousView = previousItem?.customItem // 上一个item.view
        
        let markRight = isEndItem ? itemAry![count + 1].customItem.snp.left : self.snp.right    // 当前view对于下一个item.view的布局
        let markRightOffset = isEndItem ? -itemSpacing : -itemSpacing * 2 // 相对于下一个item的间距
        
        if count == 0 {
            if item.itemType == .AutoItem {  //第一个 - 自适应
                currentItem.snp.makeConstraints { (make) in
                    make.left.equalToSuperview().offset(itemSpacing * 2)
                    make.centerY.equalToSuperview()
                    make.right.equalTo(markRight).offset(markRightOffset)
                    make.height.equalTo(currentItemSize.height)
                }
            }else { //第一个 - 固定
                currentItem.snp.makeConstraints { (make) in
                    make.left.equalToSuperview().offset(itemSpacing * 2)
                    make.centerY.equalToSuperview()
                    make.height.equalTo(currentItemSize.height)
                    make.width.equalTo(currentItemSize.width)
                }
            }
        }else if !isEndItem {
            if item.itemType == .AutoItem { // 最后一个 - 自适应
                currentItem.snp.makeConstraints { (make) in
                    make.left.equalTo(previousView!.snp.right).offset(itemSpacing)
                    make.centerY.equalToSuperview()
                    make.right.equalToSuperview().offset(-itemSpacing * 2)
                    make.height.equalTo(currentItemSize.height)
                }
            }else { // 最后一个 - 固定
                currentItem.snp.makeConstraints { (make) in
                    make.left.equalTo(previousView!.snp.right).offset(itemSpacing)
                    make.centerY.equalToSuperview()
                    make.height.equalTo(currentItemSize.height)
                    make.width.equalTo(currentItemSize.width)
                    
                    if isAutoItem {
                        make.right.equalToSuperview().offset(-itemSpacing * 2)
                    }
                }
            }
        }else {
            if item.itemType == .AutoItem { // 中间 - 自适应
                currentItem.snp.makeConstraints { (make) in
                    make.left.equalTo(previousView!.snp.right).offset(itemSpacing)
                    make.centerY.equalToSuperview()
                    make.right.equalTo(markRight).offset(markRightOffset)
                    make.height.equalTo(currentItemSize.height)
                }
            }else { // 中间 - 固定
                currentItem.snp.makeConstraints { (make) in
                    make.left.equalTo(previousView!.snp.right).offset(itemSpacing)
                    make.centerY.equalToSuperview()
                    make.height.equalTo(currentItemSize.height)
                    make.width.equalTo(currentItemSize.width)
                }
            }
        }
    }
}
