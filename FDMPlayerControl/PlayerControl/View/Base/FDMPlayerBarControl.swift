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
    
    private let contentView = UIView()
    
    /// Bar高度
    var barHeight: CGFloat = 40
    
    /// 背景View
    var backgroundView: UIView? {
        didSet{
            guard backgroundView != nil else { return }
            self.insertSubview(backgroundView!, at: 0)
        }
    }
    
    /// item间距
    var itemSpacing: CGFloat = 10 {
        didSet{
            super.setNeedsLayout()
            super.layoutIfNeeded()
        }
    }
    
    /// items
    var itemAry: [FDMPlayerItemControl]? {
        didSet{
            refreshLayoutItems()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(contentView)
    }
    
    /// 初始化
    init(itemAry: [FDMPlayerItemControl]) {
        self.itemAry = itemAry
        super.init(frame: CGRect.zero)
        
        self.addSubview(contentView)
        
        refreshLayoutItems()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 刷新Items布局
    func refreshLayoutItems() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        layoutUI()
    }
    
    /// 移除背景View
    func removeBackgroundView() {
        guard backgroundView != nil else { return }
        backgroundView?.removeFromSuperview()
    }
}

//MARK: UI
extension FDMPlayerBarControl {
    private func layoutUI() {
        for subview in contentView.subviews {
            subview.removeFromSuperview()
        }
        
        for item in itemAry ?? [] {
            contentView.addSubview(item.customItem)
        }
        
        var i = 0
        var isAutoItem = false
        var previousItem: FDMPlayerItemControl?
        
        for item in itemAry ?? [] {
            isAutoItem = item.itemType == .AutoItem ? true : isAutoItem
            layoutItems(item: item, previousItem: previousItem, count: i, isAutoItem: isAutoItem)
            previousItem = item
            
            i += 1
        }
    }
    
    /// 布局Item
    private func layoutItems(item: FDMPlayerItemControl,previousItem: FDMPlayerItemControl?, count: Int, isAutoItem: Bool) {
        let currentItem = item.customItem  // 当前item.view
        let currentItemSize = item.itemSize    // 当前Size
        
        let isEndItem = itemAry?.count ?? 0 > (count + 1)   // 是否最后一个item 默认不是
        let previousView = previousItem?.customItem // 上一个item.view
        
        let markRight = isEndItem ? itemAry![count + 1].customItem.snp.left : contentView.snp.right    // 当前view对于下一个item.view的布局
        
        if count == 0 {
            if !isEndItem { // 是最后一个
                if item.itemType == .AutoItem {  //第一个 - 自适应
                    currentItem.snp.makeConstraints { (make) in
                        make.left.equalToSuperview().offset(itemSpacing)
                        make.centerY.equalToSuperview()
                        make.right.equalToSuperview().offset(-itemSpacing)
                        make.height.equalTo(currentItemSize.height)
                    }
                }else { //第一个 - 固定
                    currentItem.snp.makeConstraints { (make) in
                        make.left.equalToSuperview().offset(itemSpacing)
                        make.centerY.equalToSuperview()
                        make.height.equalTo(currentItemSize.height)
                        make.width.equalTo(currentItemSize.width)
                    }
                }
            }else{
                if item.itemType == .AutoItem {  //第一个 - 自适应
                    currentItem.snp.makeConstraints { (make) in
                        make.left.equalToSuperview().offset(itemSpacing)
                        make.centerY.equalToSuperview()
                        make.right.equalTo(markRight).offset(-itemSpacing)
                        make.height.equalTo(currentItemSize.height)
                    }
                }else { //第一个 - 固定
                    currentItem.snp.makeConstraints { (make) in
                        make.left.equalToSuperview().offset(itemSpacing)
                        make.centerY.equalToSuperview()
                        make.height.equalTo(currentItemSize.height)
                        make.width.equalTo(currentItemSize.width)
                    }
                }
            }
        }else if !isEndItem {
            if item.itemType == .AutoItem { // 最后一个 - 自适应
                currentItem.snp.makeConstraints { (make) in
                    make.left.equalTo(previousView!.snp.right).offset(itemSpacing)
                    make.right.equalToSuperview().offset(-itemSpacing)
                    make.centerY.equalToSuperview()
                    make.height.equalTo(currentItemSize.height)
                }
            }else { // 最后一个 - 固定
                currentItem.snp.makeConstraints { (make) in
                    make.left.equalTo(previousView!.snp.right).offset(itemSpacing)
                    make.centerY.equalToSuperview()
                    make.height.equalTo(currentItemSize.height)
                    make.width.equalTo(currentItemSize.width)
                    
                    if isAutoItem {
                        make.right.equalToSuperview().offset(-itemSpacing)
                    }
                }
            }
        }else {
            if item.itemType == .AutoItem { // 中间 - 自适应
                currentItem.snp.makeConstraints { (make) in
                    make.left.equalTo(previousView!.snp.right).offset(itemSpacing)
                    make.centerY.equalToSuperview()
                    make.right.equalTo(markRight).offset(-itemSpacing)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.snp.remakeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
        
        guard backgroundView != nil else {return}
        backgroundView?.snp.remakeConstraints({ (make) in
            make.left.right.bottom.top.equalToSuperview()
        })
    }
}
