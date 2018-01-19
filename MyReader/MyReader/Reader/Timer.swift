//
//  Timer.swift
//  MyReader
//
//  Created by Myron on 2018/1/19.
//  Copyright © 2018年 myron. All rights reserved.
//

import Foundation

protocol TimerDelegate: NSObjectProtocol {
    func timer_loop()
}

class Timer {
    
    var timer: DispatchSourceTimer?
    weak var delegate: TimerDelegate?
    
    func run() {
        timer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags.init(rawValue: 1), queue: DispatchQueue.main)
        timer?.schedule(wallDeadline: DispatchWallTime.now(), repeating: DispatchTimeInterval.milliseconds(60))
        timer?.setEventHandler(handler: { [weak self] in
            DispatchQueue.main.async {
                self?.delegate?.timer_loop()
            }
        })
        timer?.resume()
    }
    
    func stop() {
        timer?.cancel()
        timer = nil
    }
    
}