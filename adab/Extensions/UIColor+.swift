//
//  Colors.swift
//  adab
//
//  Created by Daniya on 04/10/2019.
//  Copyright © 2019 nurios. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static let menuLight = UIColor(red: 254/255, green: 254/255, blue: 225/255, alpha: 1.0)
    static let menuDark = UIColor(red: 58/255, green: 49/255, blue: 49/255, alpha: 1.0)
    static let ocean = UIColor.rgb(65,158,165)
    static let habitGreen = UIColor.rgb(70, 187, 115)
    static let kinOrange = UIColor.rgb(245,113,65)
    
    static var random: UIColor {
        
        let green = UIColor.rgb(70, 156, 115)
        let ocean = UIColor.rgb(65,158,165)
        let pen = UIColor.rgb(89,112,166)
        let blue = UIColor.rgb(41,82,136)
        let salad = UIColor.rgb(169,204,100)
        let purple = UIColor.rgb(128,69,137)
        let cherry = UIColor.rgb(144,44,77)
        let pink = UIColor.rgb(219,74,142)
        let peach = UIColor.rgb(181,80,70)
        let yellow = UIColor.rgb(233,159,64)
        let orange = UIColor.rgb(245,113,65)
        
        let colors = [green,ocean,cherry,peach,yellow,orange,pen,blue,salad,purple,cherry,pink]
        
        return colors[Int(arc4random_uniform(UInt32(colors.count)))]
        
    }
}
