//
//  MinderController.swift
//  adab
//
//  Created by Daniya on 03/10/2019.
//  Copyright © 2019 nurios. All rights reserved.
//

import UIKit
import AVFoundation

class MinderController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var player: AVAudioPlayer?
    fileprivate let minderCellId = "minderCellId"
    fileprivate let reminderCellId = "reminderCellId"
    fileprivate var minders = [Minder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 63
        tableView.rowHeight = UITableView.automaticDimension
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        minders = CoreDataHelper.retrieveMinders()
        sortMinders()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable), name: UIApplication.willEnterForegroundNotification, object: nil)
        
    }
    
    @objc func strengthenButtonPressed(sender : UIButton){
        
        let minder = minders[sender.tag]
        minder.doneDate = Date()
        CoreDataHelper.save()
        
        let indexPath = IndexPath(row: sender.tag, section: 1)
        let cell = tableView.cellForRow(at: indexPath) as! MinderCell
        
        if minder.regularity > 0 {
            cell.setHealthBar(to: 1.0, animated: true, color: minder.color)
        } else {
            cell.setHealthBar(to: 1.0, animated: true, color: .ocean)
        }
        
        
        // play mashaAllah sound
        let doneSounds = ["mashaAllah", "ahsant"]
        let newRandom = returnRandomNumber(doneSounds.count)
        
        let generator = UIImpactFeedbackGenerator(style:  .medium)
        generator.impactOccurred()
        letterSound(doneSounds[newRandom])
        
        if minder.regularity == 0 {
            
            cell.isUserInteractionEnabled = false
            
            // it's done so remove
            CoreDataHelper.delete(minder: minder)
            minders.remove(at: sender.tag)
            
            DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        
    }
    
    func returnRandomNumber(_ range: Int) -> Int {
           let random = Int(arc4random_uniform(UInt32(range)))
           return random
       }
       
       
    func letterSound(_ letter: String) {
        let path = Bundle.main.path(forResource: letter, ofType: "mp3")
        let url = URL(fileURLWithPath: path!)
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error as NSError {
            print(error.description)
        }
        
    }
    
    func sortMinders() {
        minders.sort(by: { $0.title! < $1.title! })
        minders.sort(by: { $0.health < $1.health })
        minders.sort(by: { $0.sortingOrder < $1.sortingOrder })
    }
    
    @objc func reloadTable() {
        sortMinders()
        tableView.reloadData()
    }
    
    func setupMinder(at indexPath: IndexPath? = nil) {
        
        let newMinder = (indexPath == nil)
        
        let minder: Minder
        var regularity: Int16 = 0
        var doneDate: Date?
        
        let alertTitle: String
        let alertMessage: String
        
        if newMinder {
            
            minder = CoreDataHelper.newMinder()
            
            alertTitle = "Create a minder"
            alertMessage = "Choose title and regularity in days"
            
        } else {
            minder = minders[indexPath!.row]
            regularity = minder.regularity
            doneDate = minder.doneDate
            
            alertTitle = "Edit the minder"
            alertMessage = "You can change title and regularity"
        }
        
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Title"
            textField.text = minder.title
            textField.autocapitalizationType = .sentences
        })
        
        let regularityInts: [Int16] = [0,1,2,3,7,14,28]
        let regularityStrings: [String] = regularityInts.map {
            switch $0 {
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
            
        let regularitySelectedValue: PickerViewViewController.Index = (column: 0, row: regularityInts.firstIndex(of: regularity) ?? 0)
        
        alert.addPickerView(values: [regularityStrings], initialSelections: [regularitySelectedValue]) { vc, picker, index, values in
            
            regularity = regularityInts[index.row]
            
        }
        
        alert.addAction(UIAlertAction(title: "Bismillah", style: .default, handler: { [weak self] action in

            if let title = alert.textFields?.first?.text {
                
                minder.title = title
                minder.regularity = regularity
                minder.doneDate = doneDate

                CoreDataHelper.save()
                
                if newMinder {
                    self?.minders.append(minder)
                    let indexPath = IndexPath(row: (self?.minders.count ?? 1)-1, section: 1)
                    self?.tableView.insertRows(at: [indexPath], with: .automatic)
                    self?.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                } else {
                    self?.tableView.reloadRows(at: [indexPath!], with: .automatic)
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true)
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        setupMinder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    

}

extension MinderController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : minders.count
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let cell =  tableView.cellForRow(at: indexPath)!
            print(cell.tag)
            cell.tag = abs(cell.tag - 1)
            print(cell.tag)
        } else {
            setupMinder(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            return tableView.dequeueReusableCell(withIdentifier: reminderCellId, for: indexPath) as! ReminderCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: minderCellId, for: indexPath) as! MinderCell
        
        cell.isUserInteractionEnabled = true
        let minder = minders[indexPath.row]
        
        
        cell.titleLabel.text = minder.title!
        cell.regularityLabel.text = minder.howOften
        cell.setHealthBar(to: minder.health, color: minder.color)
        
        cell.strengthenButton.tag = indexPath.row
        cell.strengthenButton.addTarget(self,
               action: #selector(strengthenButtonPressed),
               for: .touchUpInside)
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section > 0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let minderToDelete = minders[indexPath.row]
            CoreDataHelper.delete(minder: minderToDelete)
            self.minders.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
