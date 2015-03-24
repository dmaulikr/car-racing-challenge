//
//  GameStatusView.swift
//  Car Racing Challenge
//
//  Created by Alex Ongarato on 21/03/15.
//  Copyright (c) 2015 Alex Ongarato. All rights reserved.
//

import Foundation
import UIKit
class GameStatusView:AbstractView
{
    private var scoreField:UILabel!;
    private var statusField:UILabel!;
    
    override func didMoveToSuperview()
    {
        super.didMoveToSuperview();
        self.alpha = 0;
        self.height = 22;
        self.y = -self.height;
        self.backgroundColor = UIColor.whiteColor().alpha(0.3);
        
        self.statusField = UILabel();
        self.addSubview(self.statusField);
        self.statusField.y = 5
        self.statusField.font = Fonts.Digital7Italic(FontSize.Small);
        self.statusField.textColor = UIColor.blackColor();
        self.statusField.textAlignment = NSTextAlignment.Center;
    }
    
    func show()
    {
        UIView.animateWithDuration(AnimationTime.VerySlow, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.y = 0;
            self.alpha = 1;
            }, completion: nil);
    }
    
    func hide()
    {
        UIView.animateWithDuration(AnimationTime.Default, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.y = -self.height;
            self.alpha = 0;
            }, completion: nil);
    }
    
    func update(level:Int, score:Int, nextScore:Int, lifes:Int, scoreNextLife:Int)
    {
        self.statusField.text = "LEVEL:\(level)  LIFES:\(lifes)  SCORE:\(score)/\(nextScore * level)";
        self.statusField.sizeToFit();
        self.statusField.center.x = self.center.x;
    }
}