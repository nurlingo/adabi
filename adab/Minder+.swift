//
//  Minder+.swift
//  adab
//
//  Created by Daniya on 14/10/2019.
//  Copyright © 2019 nurios. All rights reserved.
//

import UIKit

extension Minder {
    
    var isOneTime: Bool {
        return regularity == 0
    }
    
    var howOften: String {
        switch regularity {
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
            return ""
        }
    }
    
    var sortingOrder: Int {
        if isOneTime {
            return 0
        } else if doneDate == nil {
            return 2
        } else {
            return 1
        }
    }
    
    var health: Float {
        
        guard let doneDate = self.doneDate, regularity > 0 else { return 0 }
        
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.hour], from: doneDate, to: Date())
        let hoursPassedSinceDone = Float(components.hour!)
        
        let regularityInHours = Float(self.regularity * 24)
        let onePercent: Float = 1.0 / regularityInHours
        
        let hoursLeftToTakeAction = regularityInHours - hoursPassedSinceDone
        
        let healthPercentage = onePercent * hoursLeftToTakeAction

        return max(healthPercentage,0.05)
    }
    
    var color: UIColor {
        
        if regularity == 0 || doneDate == nil {
            return .clear
        }
        
        switch health {
        case 0.8...1.0:
            let green = UIColor.rgb(70, 156, 115)
            return green
        case 0.45..<0.8:
            let yellow = UIColor.rgb(233,159,64)
            return yellow
        case 0.1..<0.45:
            let orange = UIColor.rgb(245,113,65)
            return orange
        case 0..<0.1:
            return .systemRed
        default:
            return .clear
        }
    }
    
}
