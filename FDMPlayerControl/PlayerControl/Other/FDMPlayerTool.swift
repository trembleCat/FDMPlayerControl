//
//  FDMGcdTimer.swift
//  教务系统
//
//  Created by 发抖喵 on 2020/5/7.
//  Copyright © 2020 发抖喵. All rights reserved.
//

import UIKit

//MARK: 定时器
class FDMGcdTimer: NSObject {
    
    var gcdTimer: DispatchSourceTimer?
    var timeCount: Int = 0
    
    func createTimer(deadline: DispatchTime = .now(), repeating: DispatchTimeInterval = .seconds(1), leeway: DispatchTimeInterval = .seconds(0), calltime: Int = 1 , endOfTime:@escaping (Int) -> (), timeInProgress timeElse:@escaping (Int) -> ()) {
        
        gcdTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        gcdTimer?.schedule(deadline: deadline, repeating: repeating, leeway: leeway)
        gcdTimer?.setEventHandler(handler: { [weak self] in
            if self!.timeCount <= 0{
                endOfTime(self!.timeCount)
            }else{
                timeElse(self!.timeCount)
                self!.timeCount -= calltime
            }
        })
    }
    
    func resume() {
        gcdTimer?.resume()
    }
    
    func suspend() {
        gcdTimer?.suspend()
    }
    
    func cancel() {
        gcdTimer?.cancel()
        gcdTimer = nil
    }
}

//MARK: 时间转换
class FDMTimeConversion: NSObject {
    
    /// 时间单位
    enum TimerStringType {
        case second
        case minute
        case hour
    }
    
    /// 毫秒转换为视频时间字符串 type: 返回单位
    class func millisecondToTimerString(_ millisecond: Int64, type: TimerStringType) -> String {
        var second = millisecond / 1000
        var minute = second / 60
        let hour = minute / 60
        
        if type == .second {
            return String(format: "%02ld",lroundf(Float(second)))
        }else if type == .minute {
            if minute > 0 {
                second = second % 60
            }
            
            return String(format: "%02ld:%02ld",minute,lroundf(Float(second)))
        }else {
            if minute > 0 {
                second = second % 60
            }
            
            if hour > 0 {
                minute = minute % 60
            }
            
            return String(format: "%02ld:%02ld:%02ld",hour,minute,lroundf(Float(second)))
        }
    }
}
