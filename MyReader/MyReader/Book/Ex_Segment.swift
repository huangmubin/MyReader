//
//  Ex_Segment.swift
//  MyReader
//
//  Created by Myron on 2018/1/18.
//  Copyright © 2018年 myron. All rights reserved.
//

import Foundation

extension Book {
    
    /** return the segment location */
    class func segment(text: String) -> String.Index? {
        let chars: [Character] = ["。", ".", "；", ";"]
        for sign in chars {
            if let index = text.index(of: sign) {
                return index
            }
        }
        return nil
    }
    
}
