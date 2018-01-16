//
//  ReaderController.swift
//  MyReader
//
//  Created by 黄穆斌 on 2018/1/16.
//  Copyright © 2018年 myron. All rights reserved.
//

import UIKit

class ReaderController: ViewController {

    @IBOutlet weak var text_view: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Data
        let path = Bundle.main.path(forResource: "test", ofType: "txt")!
        let data = try! String(contentsOfFile: path, encoding: .utf8)
        text_view.text = data
        
        // User
        text_view.font = User.font
        view.backgroundColor = User.color_background
        text_view.textColor = User.color_text
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        read.load(text: text_view.text)
    }
    
    // MARK: - Read
    
    var read = TextReader()
    
    // MARK: - Font
    
    @IBAction func font_bigger_action(_ sender: Button) {
        User.font_size = User.font_size + 2
        text_view.font = UIFont.systemFont(ofSize: User.font_size)
    }
    
    @IBAction func font_smaller_action(_ sender: Button) {
        User.font_size = User.font_size - 2
        text_view.font = UIFont.systemFont(ofSize: User.font_size)
    }
    
    // MARK: - Color
    
    @IBAction func color_change_action(_ sender: Button) {
        User.color_number = sender.tag
        view.backgroundColor = User.color_background
        text_view.textColor = User.color_text
    }
    
    // MARK: - Tap Action
    
    @IBAction func text_view_tap_action(_ sender: UITapGestureRecognizer) {
        if bottom_control_layout.constant == 0 {
            layout_animation(show: false)
        } else {
            let touch = sender.location(in: view)
            switch touch.y {
            case 0 ..< text_view.bounds.height / 4:
                if text_view.contentOffset.y > 0 {
                    text_view.scrollRectToVisible(
                        CGRect(
                            x: 0,
                            y: text_view.contentOffset.y - text_view.bounds.height > 0 ? text_view.contentOffset.y - text_view.bounds.height : 0,
                            width: text_view.bounds.width,
                            height: text_view.bounds.height),
                        animated: true
                    )
                }
            case text_view.bounds.height / 4 ..< text_view.bounds.height / 4 * 3:
                layout_animation(show: true)
            default:
                if text_view.contentOffset.y + text_view.bounds.height < text_view.contentSize.height {
                    text_view.scrollRectToVisible(
                        CGRect(
                            x: 0,
                            y: text_view.contentOffset.y + text_view.bounds.height < text_view.contentSize.height ? text_view.contentOffset.y + text_view.bounds.height : text_view.contentSize.height - text_view.bounds.height,
                            width: text_view.bounds.width,
                            height: text_view.bounds.height),
                        animated: true
                    )
                }
            }
        }
    }
    
    // MARK: - Control View Layout and Animation
    
    @IBOutlet weak var bottom_control_layout: NSLayoutConstraint!
    
    func layout_animation(show: Bool) {
        UIView.animate(withDuration: 0.25, animations: {
            self.bottom_control_layout.constant = show ? 0 : 200
            self.view.layoutIfNeeded()
        })
    }
    

}
