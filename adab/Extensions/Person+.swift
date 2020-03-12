//
//  Relative.swift
//  adab
//
//  Created by Daniya on 02/02/2020.
//  Copyright © 2020 nurios. All rights reserved.
//

import UIKit

extension Person {
    
    var when: String {
        switch regularity {
        case 1:
           return "Daily"
        case 2:
            return "Every\nother day"
        case 3:
            return "Twice\na week"
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
        return doneDate == nil ? 2 : 1
    }
    
    var health: Float {
        
        guard let doneDate = self.doneDate else { return 0 }
        
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
        switch health {
        case 0.1..<0.5:
            let yellow = UIColor.rgb(233,159,64)
            return yellow
        case 0.05..<0.1:
            return .gray
        default:
            return UIColor.habitGreen
        }
    }
    
}
