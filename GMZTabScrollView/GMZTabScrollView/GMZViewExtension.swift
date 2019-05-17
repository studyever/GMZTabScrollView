//
//  GMZViewExtension.swift
//  GMZTabScrollView
//
//  Created by meizhen on 2019/2/26.
//  Copyright © 2019 meizhen. All rights reserved.
//

import Foundation

extension UIView {
    var width: CGFloat {
        set {
            frame.size.width = newValue
        }
        get {
            return frame.size.width
        }
    }
    
    var height: CGFloat {
        set {
            frame.size.height = newValue
        }
        
        get {
            return frame.size.height
        }
    }
    
    var left: CGFloat {
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
        
        get {
            return frame.origin.x
        }
    }
    
    var right: CGFloat {
        set {
            var newFrame = frame
            newFrame.origin.x = newValue - frame.size.width
            frame = newFrame
            
        }
        
        get {
            return frame.origin.x + frame.size.width
        }
    }
    
    var top: CGFloat {
        set {
            var newFrame = frame
            newFrame.origin.y = newValue
            frame = newFrame
            
        }
        
        get {
            return frame.origin.y
        }
    }
    
    var bottom: CGFloat {
        set {
            var newFrame = frame
            newFrame.origin.y = newValue - frame.size.height
            frame = newFrame
        }
        
        get {
            return frame.origin.y + frame.size.height
        }
    }
    
    var size: CGSize {
        set {
            var newFrame = frame
            newFrame.size = newValue
            frame = newFrame
        }
        get {
            return frame.size
        }
    }
    
}
