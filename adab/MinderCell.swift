//
//  MinderCell.swift
//  adab
//
//  Created by Daniya on 03/10/2019.
//  Copyright © 2019 nurios. All rights reserved.
//

import UIKit

class ReminderCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reminderLabel: UILabel!
    
    override var tag: Int {
        didSet {
            if tag == 1 {
                reminderLabel.textAlignment = .right
                reminderLabel.text = Hadith.consistentAr.rawValue
            } else {
                reminderLabel.textAlignment = .left
                reminderLabel.text = Hadith.consistentEn.rawValue
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class MinderCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var strengthenButton: UIButton!
    @IBOutlet weak var healthBar: UIProgressView!
    @IBOutlet weak var healthContainerView: UIView!
    @IBOutlet weak var regularityLabel: UILabel!
    
    
    func setHealthBar(to progress: Float, animated: Bool = false, color: UIColor) {
        
        healthBar.setProgress(progress, animated: animated)
        healthBar.progressTintColor = color
        healthContainerView.layer.borderColor = color.cgColor
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        healthBar.transform = healthBar.transform.scaledBy(x: 1, y: 100)
        healthBar.trackTintColor = .clear
        
        healthContainerView.clipsToBounds = true
        healthContainerView.layer.borderWidth = 2
        healthContainerView.layer.cornerRadius = 5
        
    }

}
