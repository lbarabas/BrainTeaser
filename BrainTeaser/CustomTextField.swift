//
//  CustomText.swift
//  BrainTeaser
//
//  Created by Laszlo Barabas on 3/19/16.
//  Copyright © 2016 Laszlo Barabas. All rights reserved.
//

import UIKit

@IBDesignable
class CustomTextField: UITextField {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    @IBInspectable var inset: CGFloat = 0
    
    @IBInspectable var cornerRadius : CGFloat = 5.0 {
        didSet {
            setupView()
        }
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        //set the rectangle for the text filed when the text field is NOT being edited
        return CGRectInset(bounds, inset, inset)
    }
    
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        //set the rectangle for the text filed when the text field is being edited

        return textRectForBounds(bounds)
    }
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 5.0
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    func setupView() {
        //just a function for code that is being repeated / reused
        self.layer.cornerRadius = cornerRadius
    }
    
}
