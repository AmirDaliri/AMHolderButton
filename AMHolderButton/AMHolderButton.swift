//
//  AMHolderButton.swift
//  AMHolderButton
//
//  Created by Amir Daliri on 12/13/17.
//  Copyright © 2017 Amir Daliri. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


@IBDesignable
open class AMHolderButton: UIButton {
    
    @IBInspectable open var textColor: UIColor = UIColor.black
    @IBInspectable open var slideColor: UIColor = UIColor.red
    @IBInspectable open var slideTextColor: UIColor = UIColor.white
    @IBInspectable open var borderColor: UIColor = UIColor.red
    @IBInspectable open var borderWidth: CGFloat = 0
    @IBInspectable open var cornerRadius: CGFloat = 0
    @IBInspectable open var slideDuration: TimeInterval = 2
    @IBInspectable open var resetDuration: TimeInterval = 0.5
    
    open var holdButtonCompletion: (() -> Void) = { () -> Void in }
    
    fileprivate var slideLayer: CALayer?
    fileprivate var slideLabel: UILabel!
    
    fileprivate var isAnimating: Bool = false
    
    var timePeriodTimer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public init(frame: CGRect, slideColor: UIColor, slideTextColor: UIColor, slideDuration: TimeInterval) {
        super.init(frame: frame)
        
        self.slideColor = slideColor
        self.slideTextColor = slideTextColor
        self.slideDuration = slideDuration
        
        self.addTargets()
    }
    
        
    open override func prepareForInterfaceBuilder()
    {
        if let context = UIGraphicsGetCurrentContext() {
            drawBackground(context, frame: self.bounds)
            self.layer.borderColor = self.borderColor.cgColor
            self.layer.borderWidth = self.borderWidth
            self.layer.cornerRadius = self.cornerRadius
            self.clipsToBounds = true
        }
    }
    
    open override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.addTargets()
        
    }
    
    fileprivate func addTargets() {
        addTarget(self, action: #selector(AMHolderButton.start(_:forEvent:)), for: .touchDown)
        addTarget(self, action: #selector(AMHolderButton.cancel(_:forEvent:)), for: .touchUpInside)
        addTarget(self, action: #selector(AMHolderButton.cancel(_:forEvent:)), for: .touchCancel)
        addTarget(self, action: #selector(AMHolderButton.cancel(_:forEvent:)), for: .touchDragExit)
        addTarget(self, action: #selector(AMHolderButton.cancel(_:forEvent:)), for: .touchDragOutside)
    }
    
    open override func draw(_ rect: CGRect)
    {
        super.draw(rect)
        
        if let context = UIGraphicsGetCurrentContext() {
            context.clear(rect)
            drawBackground(context, frame: self.bounds)
            self.layer.borderColor = self.borderColor.cgColor
            self.layer.borderWidth = self.borderWidth
            self.layer.cornerRadius = self.cornerRadius
            self.clipsToBounds = true
            
            self.setTitleColor(self.textColor, for: UIControlState())
            
        }
        
    }
    
    
    @objc func start(_ sender: AnyObject, forEvent event: UIEvent)
    {
        
        timePeriodTimer = Timer.schedule(delay: slideDuration, handler: { (timer) in
            self.timePeriodTimer?.invalidate()
            self.timePeriodTimer = nil

            self.holdButtonCompletion()
            
            self.isAnimating = false
            
        })
        
        if !isAnimating {
            
            isAnimating = true
            
            self.slideLayer = CALayer()
            self.slideLayer?.masksToBounds = true
            self.slideLayer!.anchorPoint = CGPoint(x: 0, y: 0)
            self.slideLayer!.bounds = CGRect(x: 0, y: 0, width: 0, height: self.bounds.height)
            self.slideLayer!.backgroundColor = self.slideColor.cgColor
            self.layer.insertSublayer(self.slideLayer!, above: self.layer)
            
            let textLayer = CATextLayer()
            textLayer.anchorPoint = CGPoint(x: 0, y: 0)
            textLayer.frame = (self.titleLabel?.frame)!
            textLayer.font = self.titleLabel?.font
            textLayer.fontSize = (self.titleLabel?.font.pointSize)!
            textLayer.foregroundColor = self.slideTextColor.cgColor
            textLayer.string = self.titleLabel?.text
            textLayer.alignmentMode = kCAAlignmentCenter
            textLayer.contentsScale = UIScreen.main.scale
            self.slideLayer!.addSublayer(textLayer)
            
            let animation = CABasicAnimation(keyPath: "bounds.size.width")
            animation.duration = slideDuration
            animation.fillMode = kCAFillModeForwards
            animation.isRemovedOnCompletion = false
            if self.slideLayer!.animationKeys()?.count > 0 {
                if let temp = self.slideLayer!.presentation() {
                    animation.fromValue = temp.bounds.width
                }
            }
            animation.toValue = self.bounds.width
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            self.slideLayer!.add(animation, forKey: "drawSlideAnimation")
            self.layer.addSublayer(self.slideLayer!)
        }
    }
    
    @objc func cancel(_ sender: AnyObject, forEvent event: UIEvent)
    {
        reset()
    }
    
    func reset()
    {
        
        self.timePeriodTimer?.invalidate()
        self.timePeriodTimer = nil
        
        timePeriodTimer = Timer.schedule(delay: resetDuration, handler: { (timer) in
            self.timePeriodTimer?.invalidate()
            self.timePeriodTimer = nil
            
            self.slideLayer?.removeAllAnimations()
            self.slideLayer?.removeFromSuperlayer()
            self.slideLayer = nil
            
            self.isAnimating = false
        })
        
        let animation = CABasicAnimation(keyPath: "bounds.size.width")
        animation.duration = resetDuration
        animation.isRemovedOnCompletion = true
        if self.slideLayer?.animationKeys()?.count > 0 {
            if let temp = self.slideLayer?.presentation() {
                animation.fromValue = temp.bounds.width
            }
        }
        animation.toValue = 0
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        self.slideLayer?.add(animation, forKey: "drawSlideAnimation")
        
    }
    
    
    func drawBackground(_ context: CGContext, frame: CGRect)
    {
        if let backgroundColor = self.backgroundColor {
            context.setFillColor(backgroundColor.cgColor);
            context.fill(bounds)
        }
    }

    open func setText(_ text: String) {
        self.setTitle(text, for: UIControlState())
    }
    
    open func setTextFont(_ font: UIFont) {
        self.titleLabel!.font = font
    }

}
