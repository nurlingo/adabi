//
//  Todo+.swift
//  adab
//
//  Created by Daniya on 04/11/2019.
//  Copyright © 2019 nurios. All rights reserved.
//

import UIKit

extension Todo {
    

    var when: String {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd"
        return dueDate == nil ? "" : dateFormatterPrint.string(from: dueDate!)
    }
    
    
    var color: UIColor {
        return .systemTeal
    }
    
}
