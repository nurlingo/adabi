//
//  UIButton+.swift
//  adab
//
//  Created by Daniya on 09/07/2019.
//  Copyright © 2019 Nursultan Askarbekuly. All rights reserved.
//

import UIKit

public extension UIButton {
    
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable var borderColorFromUIColor: UIColor {
        
        get {
            if let cgBorder = layer.borderColor {
                return UIColor(cgColor: cgBorder)
            } else {
                return UIColor.clear
            }
        }
        set {
            layer.borderColor = newValue.cgColor
        }
        
  
    }
}
