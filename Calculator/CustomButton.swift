//
//  CustomButton.swift
//  Calculator
//
//  Created by Björn Kaczmarek on 21/3/20.
//  Copyright © 2020 Björn Kaczmarek. All rights reserved.
//

import UIKit

@IBDesignable class CustomButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet { self.layer.cornerRadius = cornerRadius }
    }
}


