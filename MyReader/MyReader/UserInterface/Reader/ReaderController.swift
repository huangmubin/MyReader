//
//  ReaderController.swift
//  MyReader
//
//  Created by 黄穆斌 on 2018/1/16.
//  Copyright © 2018年 myron. All rights reserved.
//

import UIKit

class ReaderController: ViewController, UITextViewDelegate {

    // MARK: - View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layoutIfNeeded()
        
        let path = Bundle.main.path(forResource: "Test", ofType: "md")!
        bookView.text = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        bookView.font = User.font
        bookView.backgroundColor = User.color_background
        bookView.textColor = User.color_text
        view.backgroundColor = User.color_background
        
        self.navigation_layout_top.constant = -120
        self.menu_layout_bottom.constant = -220
        self.play_control_layout_bottom.constant = -160
        
        if User.auto_read_speed == 0 {
            User.auto_read_speed = 0.4
        }
        if User.auto_scroll_speed == 0 {
            User.auto_read_speed = 20
        }
        autor.speed = User.auto_scroll_speed
        reader.rate = User.auto_read_speed
        
        
        self.bookView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.bookView.layoutSubviews()
            self.bookView.layoutIfNeeded()
            self.bookView.setNeedsDisplay()
            if let position = self.bookView.position(from: self.bookView.beginningOfDocument, offset: User.scroll) {
                let rect = self.bookView.caretRect(for: position)
                print("\(self.bookView.contentSize) rect = \(rect) y = \(rect.origin.y); \(User.scroll)")
                self.bookView.setContentOffset(CGPoint(x: 0, y: rect.origin.y), animated: true)
            }
        }
        
//        DispatchQueue.main.async {
//            if let position = self.bookView.position(from: self.bookView.beginningOfDocument, offset: User.scroll) {
//                let rect = self.bookView.caretRect(for: position)
//                print("\(self.bookView.contentSize) rect = \(rect); \(User.scroll)")
//                //self.bookView.contentOffset.y = rect.origin.y
//                self.bookView.setContentOffset(rect.origin, animated: true)
//                DispatchQueue.main.async {
//                }
//            }
//        }
    }
    
    // MARK: - Data
    
    var book_path: String = ""
    
    // MARK: - Book View
    
    @IBOutlet weak var bookView: UITextView!
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll \(scrollView.contentSize) \(scrollView.contentOffset)")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollViewDidEndDecelerating(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let position = bookView.closestPosition(to: scrollView.contentOffset) {
            let offset = bookView.offset(from: bookView.beginningOfDocument, to: position)
            User.scroll = offset
        }
        print("scrollViewDidEndDecelerating \(scrollView.contentOffset) \(User.scroll)")
    }
    
    // MARK: - Navigation
    
    @IBOutlet weak var navigation: UIView!
    @IBOutlet weak var navigation_layout_top: NSLayoutConstraint!
    @IBOutlet weak var navigation_name: UILabel!
    
    // MARK: - Control
    
    @IBOutlet weak var menu: UIView!
    @IBOutlet weak var menu_layout_bottom: NSLayoutConstraint!
    
    // MARK: Size
    
    @IBOutlet weak var menu_size_smaller: Button!
    @IBOutlet weak var menu_size_bigger: Button!
    @IBAction func menu_size_smaller_action(_ sender: Button) {
        User.font_size -= 1
        bookView.font = User.font
    }
    @IBAction func menu_size_bigger_action(_ sender: Button) {
        User.font_size += 1
        bookView.font = User.font
    }
    
    // MARK: Color
    
    @IBAction func menu_color_action(_ sender: UIButton) {
        User.color_number = sender.tag
        bookView.backgroundColor = User.color_background
        view.backgroundColor = User.color_background
        bookView.textColor = User.color_text
    }
    
    // MARK: Other
    
    @IBAction func menu_auto_scroll_action(_ sender: UIButton) {
        is_auto = true
        animation(show: true)
        autor.view = bookView
        autor.controller = self
        DispatchQueue.delay(1, execute: {
            self.autor.run()
            self.animation(show: false)
        })
    }
    
    @IBAction func menu_auto_read_action(_ sender: UIButton) {
        is_read = true
        animation(show: true)
    }
    
    // MARK: - Play Control
    
    @IBOutlet weak var play_control: View!
    @IBOutlet weak var play_control_layout_bottom: NSLayoutConstraint!
    
    var is_auto: Bool = false
    var is_read: Bool = false
    
    var autor = AutoScroll()
    var reader = Reader()
    
    // MARK: Play
    
    @IBOutlet weak var play_control_play: UIButton!
    @IBAction func play_control_play_action(_ sender: UIButton) {
        if is_auto {
            if sender.isSelected {
                autor.run()
            } else {
                autor.stop()
            }
        }
        if is_read {
            if sender.isSelected {
                
            } else {
                
            }
        }
        sender.isSelected = !sender.isSelected
        self.scrollViewDidEndDecelerating(self.bookView)
    }
    
    // MARK: Speed
    
    @IBOutlet weak var play_control_slow: UIButton!
    @IBOutlet weak var play_control_quick: UIButton!
    @IBAction func play_controll_slow_action(_ sender: UIButton) {
        if is_auto {
            User.auto_scroll_speed = max(User.auto_scroll_speed - 5, 10)
            autor.speed = User.auto_scroll_speed
            print("autor speed = \(autor.speed)")
        }
        if is_read {
            User.auto_read_speed = max(User.auto_read_speed - 0.1, 0.1)
            reader.rate = User.auto_read_speed
        }
    }
    @IBAction func play_controll_quick_action(_ sender: UIButton) {
        if is_auto {
            User.auto_scroll_speed = min(User.auto_scroll_speed + 5, 100)
            autor.speed = User.auto_scroll_speed
        }
        if is_read {
            User.auto_read_speed = min(User.auto_read_speed + 0.1, 10)
            reader.rate = User.auto_read_speed
        }
    }
    
    // MARK: Time
    
    @IBAction func auto_close_action(_ sender: UIButton) {
        
    }
    
    // MARK: Cancel
    
    @IBAction func play_control_cancel_action() {
        if is_read {
            is_read = false
            
        }
        if is_auto {
            is_auto = false
            autor.stop()
        }
        animation(show: true)
        self.scrollViewDidEndDecelerating(self.bookView)
        self.play_control_play.isSelected = false
    }
    
    // MARK: - Touch
    
    @IBOutlet var tap_bookView_gesture: UITapGestureRecognizer!
    @IBAction func tap_bookView_action(_ sender: UITapGestureRecognizer) {
        let touch = sender.location(in: view)
        switch touch.y {
        case 0 ..< view.bounds.height / 4:
            bookView.scrollRectToVisible(
                CGRect(x: 0,
                       y: max(bookView.contentOffset.y - bookView.bounds.height, 0),
                       width: bookView.bounds.width,
                       height: bookView.bounds.height
                ),
                animated: true
            )
        case view.bounds.height / 4 ..< view.bounds.height * 3:
            animation(show: self.navigation_layout_top.constant < -50)
        default:
            bookView.scrollRectToVisible(
                CGRect(x: 0,
                       y: min(bookView.contentOffset.y + bookView.bounds.height, bookView.contentSize.height - bookView.bounds.height),
                       width: bookView.bounds.width,
                       height: bookView.bounds.height
                ),
                animated: true
            )
        }
    }
    
    // MARK: - Animation
    
    func animation(show: Bool) {
        UIView.animate(withDuration: 0.25, animations: {
            self.navigation_layout_top.constant = show ? -40 : -220
            if self.is_read || self.is_auto {
                self.play_control_layout_bottom.constant = show ? -10 : -160
                self.menu_layout_bottom.constant = -220
            } else {
                self.play_control_layout_bottom.constant = -160
                self.menu_layout_bottom.constant = show ? -10 : -220
            }
            self.view.layoutIfNeeded()
        })
    }
}
