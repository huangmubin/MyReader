//
//  AutoScorll.swift
//  MyReader
//
//  Created by Myron on 2018/1/19.
//  Copyright © 2018年 myron. All rights reserved.
//

import UIKit

class AutoScroll: NSObject, TimerDelegate {
    
    weak var controller: ReaderController?
    weak var view: UITextView?
    var timer: Timer = Timer()
    var speed: CGFloat = 30
    
    override init() {
        super.init()
        timer.delegate = self
    }
    
    func run() {
        timer.run()
    }
    
    func stop() {
        timer.stop()
    }
    
    func timer_loop() {
        if let y = view?.contentOffset.y {
            view?.setContentOffset(
                CGPoint(x: 0, y: y + speed),
                animated: true
            )
            if (view?.contentOffset.y ?? 0) + (view?.bounds.height ?? 0) >= (view?.contentSize.height ?? 0) {
                self.controller?.play_control_cancel_action()
            }
        }
    }
}
