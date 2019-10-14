//
//  Int16+.swift
//  adab
//
//  Created by Daniya on 14/10/2019.
//  Copyright © 2019 nurios. All rights reserved.
//

import Foundation

extension Int16 {
    
    var regularity: String {
        switch self {
        case 1:
           return "Everyday"
        case 2:
            return "Every other day"
        case 3:
            return "Twice a week"
        case 7:
            return "Weekly"
        case 14:
            return "Biweekly"
        case 28:
            return "Monthly"
        default:
            return "Just once"
        }
    }
    
}
