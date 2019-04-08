//
//  CGRect+Extension.swift
//  KL IoT
//
//  Created by 陈旭珂 on 2019/4/7.
//  Copyright © 2019 陈旭珂. All rights reserved.
//

// https://github.com/vcxk/CGRectLayout

#if os(iOS)
import UIKit
#elseif os(macOS)
import Foundation
#endif

public extension CGRect {
    enum CalculateType {
        typealias FloatLiteralType = CGFloat
        init(floatLiteral value: CalculateType.FloatLiteralType) {
            if value > 1 || value < -1 {
                self = .length(CGFloat(value))
            } else {
                self = .ratio(CGFloat(value))
            }
        }
        case length(CGFloat)
        case ratio(CGFloat)
    }
}

fileprivate extension CGFloat {
    func calculate(_ cal: CGRect.CalculateType) -> CGFloat {
        switch cal {
        case .length(let len):
            return len
        case .ratio(let rat):
            return self * rat
        }
    }
    var calculateType: CGRect.CalculateType {
        return CGRect.CalculateType(floatLiteral: self)
    }
}

public extension CGRect {
    // property x,y,width,height
    var x: CGFloat {
        get{ return self.origin.x }
        set { self.origin.x = newValue }
    }
    var y: CGFloat {
        get { return self.origin.y }
        set { self.origin.y = newValue }
    }
    
    var width: CGFloat {
        get { return self.size.width }
        set { self.size.width = newValue }
    }
    var height: CGFloat {
        get { return self.size.height }
        set { self.size.height = newValue }
    }
    
    // property left,right,top,bottom
    var top:CGFloat {
        set{
            #if os(iOS)
            self.origin.y = newValue
            #elseif os(macOS)
            self.origin.y = newValue - self.height
            #endif
            
        }
        get {
            #if os(iOS)
            return self.origin.y
            #elseif os(macOS)
            return self.origin.y + self.height
            #endif
        }
    }
    var bottom:CGFloat {
        get {
            #if os(iOS)
            return self.origin.y + self.height
            #elseif os(macOS)
            return self.origin.y
            #endif
        }
        set {
            #if os(iOS)
            self.origin.y = newValue - self.height
            #elseif os(macOS)
            self.origin.y  = newValue
            #endif
        }
    }
    var left:CGFloat {
        set { self.x = newValue }
        get { return self.x }
    }
    var right:CGFloat {
        get { return self.x + self.width }
        set { self.x = newValue - self.width }
    }
    
    // property center
    var midX : CGFloat {
        get { return self.x + self.width/2 }
        set { self.x = newValue - self.width/2 }
    }
    var midY : CGFloat {
        get { return self.y + self.height/2 }
        set { self.y = newValue - self.height/2 }
    }
    var center:CGPoint {
        get { return CGPoint(x: self.midX, y: self.midY) }
        set {
            self.midY = newValue.y
            self.midX = newValue.x
        }
    }
    
    mutating func set(top:CGFloat,bottom:CGFloat) {
        self.top = top
        #if os(iOS)
        self.height = bottom - top
        #elseif os(macOS)
        self.height = top - bottom
        #endif
    }
    mutating func set(left:CGFloat,right:CGFloat) {
        self.x = left
        self.width = right - left
    }
}

public extension CGRect {
    func width(_ w:CGFloat) -> CGRect {
        var new = self
        new.width = w
        return new
    }
    
    func height(_ h:CGFloat) -> CGRect {
        var new = self
        new.height = h
        return new
    }
    
    func x(_ x:CGFloat) -> CGRect {
        var new = self
        new.x = x
        return new
    }
    
    func y(_ y:CGFloat) -> CGRect {
        var new = self
        new.y = y
        return new
    }
}

//Rect inside
public extension CGRect {
    #if os(iOS)
    func top(_ ratio:CGRect.CalculateType) -> CGRect {
        var new = self
        let h = new.height.calculate(ratio)
        if h >= 0 {
            new.height = h
        } else {
            let height = self.height + h
            new.height = height >= 0 ? height : 0
        }
        return new
    }
    func top(_ ratio:CGRect.CalculateType,offset:CGRect.CalculateType) ->CGRect {
        var new = self.top(ratio)
        new.y += self.height.calculate(offset)
        return new
    }
    func bottom(_ ratio:CGRect.CalculateType) -> CGRect {
        var new = self.top(ratio)
        new.bottom = self.bottom
        return new
    }
    func bottom(_ ratio:CGRect.CalculateType,offset:CGRect.CalculateType) -> CGRect {
        var new = self.top(ratio)
        new.bottom = self.bottom - self.height.calculate(offset)
        return new
    }
    
    #elseif os(macOS)
    func top(_ ratio:CGRect.CalculateType) -> CGRect {
        var new = self.bottom(ratio)
        new.top = self.top
        return new
    }
    func top(_ ratio:CGRect.CalculateType,offset:CGRect.CalculateType) ->CGRect {
        var new = self.top(ratio)
        new.top = self.top - self.height.calculate(offset)
        return new
    }
    func bottom(_ ratio:CGRect.CalculateType) -> CGRect {
        var new = self
        let h = new.height.calculate(ratio)
        if h >= 0 {
            new.height = h
        } else {
            let height = self.height + h
            new.height = height >= 0 ? height : 0
        }
        return new
    }
    func bottom(_ ratio:CGRect.CalculateType,offset:CGRect.CalculateType) -> CGRect {
        var new = self.bottom(ratio)
        new.bottom = self.bottom + self.height.calculate(offset)
        return new
    }
    
    #endif
    
    func left(_ ratio:CGRect.CalculateType) -> CGRect {
        var new = self
        let w = self.width.calculate(ratio)
        if w >= 0 {
            new.width = w
        } else {
            let width = self.width + w
            new.width = width >= 0 ? width : 0
        }
        return new
    }
    func left(_ ratio:CGRect.CalculateType,offset:CGRect.CalculateType) -> CGRect {
        var new = self.left(ratio)
        new.x += self.width.calculate(offset)
        return new
    }
    func right(_ ratio:CGRect.CalculateType) -> CGRect {
        var new = self.left(ratio)
        new.right = self.right
        return new
    }
    func right(_ ratio:CGRect.CalculateType,offset:CGRect.CalculateType) -> CGRect {
        var new = self.left(ratio)
        new.right = self.right - self.width.calculate(offset)
        return new
    }
    
    func center(xs:CGRect.CalculateType,ys:CGRect.CalculateType) -> CGRect {
        var new = self.left(xs).top(ys)
        new.center = self.center
        return new
    }
}

//Rect margin outside
public extension CGRect {
    func mLeft(_ v:CalculateType, offset: CalculateType) -> CGRect {
        var new  = self.left(v)
        let o = self.width.calculate(offset)
        new.right = self.left - o
        return new
    }
    func mTop(_ v:CalculateType, offset: CalculateType) -> CGRect {
        var new = self.top(v)
        #if os(iOS)
        new.bottom = self.top - self.height.calculate(offset)
        #elseif os(macOS)
        new.bottom = self.top + self.height.calculate(offset)
        #endif
        return new
    }
    func mRight(_ v:CalculateType, offset: CalculateType) -> CGRect {
        var new = self.left(v)
        new.left = self.right + self.width.calculate(offset)
        return new
    }
    func mBottom(_ v:CalculateType, offset: CalculateType) -> CGRect {
        var new = self.top(v)
        #if os(iOS)
        new.top = self.bottom + self.height.calculate(offset)
        #elseif os(macOS)
        new.top = self.bottom - self.height.calculate(offset)
        #endif
        return new
    }
    func mLeft(_ v:CalculateType) -> CGRect {
        var new = self.left(v)
        new.right = self.left
        return new
    }
    func mTop(_ v:CalculateType) -> CGRect {
        var new = self.top(v)
        new.bottom = self.top
        return new
    }
    func mRight(_ v:CalculateType) -> CGRect {
        var new = self.left(v)
        new.left = self.right
        return new
    }
    func mBottom(_ v:CalculateType) -> CGRect {
        var new = self.top(v)
        new.top = self.bottom
        return new
    }
}

//Rect inside
public extension CGRect {
    func top(_ v:CGFloat = 0.5) -> CGRect {
        return self.top(CalculateType(floatLiteral: v))
    }
    func top(_ v:CGFloat = 0.5, offset:CGFloat) ->CGRect {
        return self.top(CalculateType(floatLiteral: v), offset: CalculateType(floatLiteral: offset))
    }
    func bottom(_ v:CGFloat = 0.5) -> CGRect {
        return self.bottom(CalculateType(floatLiteral: v))
    }
    func bottom(_ v:CGFloat = 0.5, offset:CGFloat) -> CGRect {
        return self.bottom(CalculateType(floatLiteral: v), offset: CalculateType(floatLiteral: offset))
    }
    
    func left(_ v:CGFloat = 0.5) -> CGRect {
        return self.left(CalculateType(floatLiteral: v))
    }
    func left(_ v:CGFloat = 0.5, offset:CGFloat) -> CGRect {
        return self.left(CalculateType(floatLiteral: v), offset: CalculateType(floatLiteral: offset))
    }
    func right(_ v:CGFloat = 0.5) -> CGRect {
        return self.right(CalculateType(floatLiteral: v))
    }
    func right(_ v:CGFloat = 0.5, offset:CGFloat) -> CGRect {
        return self.right(CalculateType(floatLiteral: v), offset: CalculateType(floatLiteral: offset))
    }
    func center(xs:CGFloat = 0.5, ys:CGFloat = 0.5) -> CGRect {
        return self.center(xs: CalculateType(floatLiteral: xs), ys: CalculateType(floatLiteral: ys))
    }
}

//Rect margin outside
public extension CGRect {
    func mTop(_ v:CGFloat = 1.0) -> CGRect {
        return self.mTop(CalculateType(floatLiteral: v))
    }
    func mTop(_ v:CGFloat = 1.0,offset:CGFloat) ->CGRect {
        return self.mTop(CalculateType(floatLiteral: v), offset: CalculateType(floatLiteral: offset))
    }
    func mBottom(_ v:CGFloat = 1.0) -> CGRect {
        return self.mBottom(CalculateType(floatLiteral: v))
    }
    func mBottom(_ v:CGFloat = 1.0,offset:CGFloat) -> CGRect {
        return self.mBottom(CalculateType(floatLiteral: v), offset: CalculateType(floatLiteral: offset))
    }
    
    func mLeft(_ v:CGFloat = 1.0) -> CGRect {
        return self.mLeft(CalculateType(floatLiteral: v))
    }
    func mLeft(_ v:CGFloat = 1.0,offset:CGFloat) -> CGRect {
        return self.mLeft(CalculateType(floatLiteral: v), offset: CalculateType(floatLiteral: offset))
    }
    func mRight(_ v:CGFloat = 1.0) -> CGRect {
        return self.mRight(CalculateType(floatLiteral: v))
    }
    func mRight(_ v:CGFloat = 1.0,offset:CGFloat) -> CGRect {
        return self.mRight(CalculateType(floatLiteral: v), offset: CalculateType(floatLiteral: offset))
    }
}
