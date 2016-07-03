//
//  ViewController.swift
//  StackSplit
//
//  Created by Mark Aufflick on 3/07/2016.
//  Copyright © 2016 The High Technology Bureau. All rights reserved.
//

import Cocoa

let dragSnapPoints: CGFloat = 200

class ViewController: NSViewController, NSGestureRecognizerDelegate {

    @IBOutlet weak var leftViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackView: ResizeCursorStackView!
    
    var leftViewWidthAtDragStart: CGFloat = 0
    var lastXVelocity: CGFloat = 0
    
    @IBAction func pan(sender: NSPanGestureRecognizer) {
        
        if sender.state == .Began {
            leftViewWidthAtDragStart = leftViewWidthConstraint.constant
            stackView.splitDragging = true
        }
        
        if sender.state == .Cancelled {
            leftViewWidthConstraint.constant = leftViewWidthAtDragStart
            
        } else {
            var dragWidth = max(0, sender.translationInView(self.view).x + leftViewWidthAtDragStart)
            
            if sender.state == .Ended {
                
                // ensure we never leave the view in a state in between collapsed and min snap width
                
                if lastXVelocity < 0 && dragWidth < dragSnapPoints {
                    dragWidth = 0
                } else if lastXVelocity > 0 && dragWidth < dragSnapPoints {
                    dragWidth = dragSnapPoints
                }

            } else {
                lastXVelocity = sender.velocityInView(self.view).x
                
                // don't make user feel they need to drag precisely to the left
                
                if lastXVelocity < 0 && dragWidth < 20 {
                    dragWidth = 0
                }
            }
            
            leftViewWidthConstraint.constant = dragWidth
        }
        
        // handle common end-state things
        if sender.state == .Ended || sender.state == .Cancelled {

            stackView.splitDragging = false
        }
    }

    func gestureRecognizerShouldBegin(gestureRecognizer: NSGestureRecognizer) -> Bool {
        let p = gestureRecognizer.locationInView(self.stackView)
        return stackView.resizeGrabRect.contains(p)
    }
}

class ResizeCursorStackView: NSStackView {
    
    var resizeGrabRect: CGRect {
        
        guard self.views.count >= 2  else {
            return CGRectZero
        }

        var rect = self.bounds
        rect.origin.x = self.views[0].frame.maxX
        rect.size.width = self.views[1].frame.minX - rect.origin.x
        return rect
    }
    
    var splitDragging = false {
        didSet {
            self.window?.invalidateCursorRectsForView(self)
        }
    }
    
    override func resetCursorRects() {
        super.resetCursorRects()
        
        guard self.views.count >= 2  else {
            return
        }

        let cursor = self.views[0].bounds.size.width > 0 ? NSCursor.resizeLeftRightCursor() : NSCursor.resizeRightCursor()

        if splitDragging {
            self.addCursorRect(self.bounds, cursor: cursor)
        } else {
            self.addCursorRect(self.resizeGrabRect, cursor: cursor)
        }
    }
}

class WhiteView: NSView {
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        NSColor.whiteColor().setFill()
        NSBezierPath(rect: dirtyRect).fill()
    }
    
}
