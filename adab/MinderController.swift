//
//  MinderController.swift
//  adab
//
//  Created by Daniya on 03/10/2019.
//  Copyright © 2019 nurios. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class MinderController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var player: AVAudioPlayer?
    fileprivate let minderCellId = "minderCellId"
    fileprivate let reminderCellId = "reminderCellId"
    
    fileprivate var todos = [Todo]()
    fileprivate var minders = [Minder]()
    fileprivate var ideas = [Idea]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 63
        tableView.rowHeight = UITableView.automaticDimension
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        todos = CoreDataHelper.retrieve(.Todo)
        minders = CoreDataHelper.retrieve(.Minder)
        ideas = CoreDataHelper.retrieve(.Idea)
        sortMinders()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable), name: UIApplication.willEnterForegroundNotification, object: nil)
        
    }
    
    func praise() {
        // play mashaAllah sound
        let doneSounds = ["mashaAllah", "ahsant"]
        let newRandom = returnRandomNumber(doneSounds.count)
        
        let generator = UIImpactFeedbackGenerator(style:  .medium)
        generator.impactOccurred()
        letterSound(doneSounds[newRandom])
    }
    
    func accomplish(at indexPath: IndexPath){
        
        let color: UIColor
        
        switch indexPath.section {
        case 1:
            let todo = todos[indexPath.row]
            todo.dueDate = Date()
            color = .systemTeal
            CoreDataHelper.delete(todo)
            todos.remove(at: indexPath.row)
        case 2:
            let minder = minders[indexPath.row]
            minder.doneDate = Date()
            color = minder.color
            CoreDataHelper.delete(minder)
            minders.remove(at: indexPath.row)
        default:
            return
        }
        
        
        let cell = tableView.cellForRow(at: indexPath) as! MinderCell
        cell.setHealthBar(to: 1.0, animated: true, color: color)
        cell.isUserInteractionEnabled = false

        praise()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
            self.tableView.deleteRows(at: [indexPath], with: .fade)
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
        minders.sort(by: { $0.title!.lowercased() < $1.title!.lowercased() })
        minders.sort(by: { $0.doneDate ?? Date() < $1.doneDate ?? Date()})
        minders.sort(by: { $0.health < $1.health })
        minders.sort(by: { $0.sortingOrder < $1.sortingOrder })
    }
    
    @objc func reloadTable() {
        sortMinders()
        tableView.reloadData()
    }
    
    
    func setupIdea(at indexPath: IndexPath? = nil) {
        
        let isNewIdea = (indexPath == nil)
        
        let idea: Idea
        
        let alertTitle: String
        
        if isNewIdea {
            
            idea = CoreDataHelper.newObject(.Idea)
            alertTitle = "What's your Idea?"
            
        } else {
            idea = ideas[indexPath!.row]
            alertTitle = "Edit the Idea"
        }

        let alert = UIAlertController(title: alertTitle, message: "", preferredStyle: .alert)
    
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Idea"
            textField.text = idea.title
            textField.autocapitalizationType = .sentences
        })
        
        alert.addAction(UIAlertAction(title: "Bismillah", style: .default, handler: { [weak self] action in

            if let title = alert.textFields?.first?.text {
                
                idea.title = title
                CoreDataHelper.save()
                
                if isNewIdea {
                    self?.ideas.insert(idea, at: 0)
                    let indexPath = IndexPath(row: 0, section: 3)
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
    
    func setupTodo(at indexPath: IndexPath? = nil) {
        
        let isNewTodo = (indexPath == nil)
        
        let todo: Todo
        
        let alertTitle: String
        let alertMessage: String
        
        if isNewTodo {
            
            todo = CoreDataHelper.newObject(.Todo)
            alertTitle = "Create a To Do"
            alertMessage = "Choose a title and due date"
            
        } else {
            todo = todos[indexPath!.row]
            alertTitle = "Edit the To Do"
            alertMessage = "You can change the title and due date"
        }

        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        var newDate = todo.dueDate
        
        alert.addDatePicker(date: todo.dueDate, minimumDate: min(Date(),todo.dueDate ?? Date()), maximumDate: nil) { date in
            print(date)
            newDate = date
        }
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Title"
            textField.text = todo.title
            textField.autocapitalizationType = .sentences
        })
        
        alert.addAction(UIAlertAction(title: "Bismillah", style: .default, handler: { [weak self] action in

            if let title = alert.textFields?.first?.text {
                
                todo.title = title
                todo.dueDate = newDate
                CoreDataHelper.save()
                
                if isNewTodo {
                    self?.todos.insert(todo, at: 0)
                    let indexPath = IndexPath(row: 0, section: 1)
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
    
    func editItem(at indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            setupTodo(at: indexPath)
        case 2:
            setupHabit(at: indexPath)
        case 3:
            setupIdea(at: indexPath)
        default:
            break
        }
    }
    
    func setupHabit(at indexPath: IndexPath? = nil) {
        
        let isNewHabit = (indexPath == nil)
        
        let habit: Minder
        var regularity: Int16 = 1
        var doneDate: Date?
        
        let alertTitle: String
        let alertMessage: String
        
        if isNewHabit {
            
            habit = CoreDataHelper.newObject(.Minder)
            alertTitle = "Create a Habit"
            alertMessage = "Choose a title and regularity in days"
            
        } else {
            habit = minders[indexPath!.row]
            regularity = habit.regularity
            doneDate = habit.doneDate
            
            alertTitle = "Edit the Habit"
            alertMessage = "You can change the title and regularity"
        }
        
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Title"
            textField.text = habit.title
            textField.autocapitalizationType = .sentences
        })
        
        let regularityInts: [Int16] = [1,2,3,7,14,28]
        let regularityStrings: [String] = regularityInts.map {
            $0.regularity
        }
            
        let regularitySelectedValue: PickerViewViewController.Index = (column: 0, row: regularityInts.firstIndex(of: regularity) ?? 1)
        
        alert.addPickerView(values: [regularityStrings], initialSelections: [regularitySelectedValue]) { vc, picker, index, values in
            
            regularity = regularityInts[index.row]
            
        }
        
        alert.addAction(UIAlertAction(title: "Bismillah", style: .default, handler: { [weak self] action in

            if let title = alert.textFields?.first?.text {
                
                habit.title = title
                habit.regularity = regularity
                habit.doneDate = doneDate
                CoreDataHelper.save()
                
                if isNewHabit {
                    let indexPath = IndexPath(row: self?.minders.count ?? 0, section: 2)
                    self?.minders.append(habit)
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
    
    @IBAction func ideaButtonPressed(_ sender: Any) {
        setupIdea()
    }
    
    @IBAction func todoButtonPressed(_ sender: Any) {
        setupTodo()
    }
    
    @IBAction func minderButtonPressed(_ sender: Any) {
        setupHabit()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    

}

extension MinderController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return todos.count
        case 2:
            return minders.count
        case 3:
            return ideas.count
        default:
            return 0
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            let cell =  tableView.cellForRow(at: indexPath)!
            cell.tag = abs(cell.tag - 1)
        case 1:
            accomplish(at: indexPath)
        case 2:
            accomplish(at: indexPath)
        case 3:
            break
        default:
            break
        }
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            return tableView.dequeueReusableCell(withIdentifier: reminderCellId, for: indexPath) as! ReminderCell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: minderCellId, for: indexPath) as! MinderCell
            let todo = todos[indexPath.row]
            cell.titleLabel.text = todo.title ?? ""
            cell.regularityLabel.text = todo.when
            cell.setHealthBar(to: 0, color: .systemTeal)
            cell.isUserInteractionEnabled = true
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: minderCellId, for: indexPath) as! MinderCell
            let minder = minders[indexPath.row]
            cell.titleLabel.text = minder.title!
            cell.regularityLabel.text = minder.when
            cell.setHealthBar(to: minder.health, color: minder.color)
            cell.isUserInteractionEnabled = true
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: minderCellId, for: indexPath) as! MinderCell
            let idea = ideas[indexPath.row]
            cell.titleLabel.text = idea.title ?? ""
            cell.regularityLabel.text = "💡"
            cell.setHealthBar(to: 0, color: .clear)
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section > 0
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
                
        if editingStyle == .delete {
            
            let objectToDelete: NSManagedObject
            
            switch indexPath.section {
            case 1:
                objectToDelete = self.todos.remove(at: indexPath.row)
            case 2:
                objectToDelete = self.minders.remove(at: indexPath.row)
            case 3:
                objectToDelete = self.ideas.remove(at: indexPath.row)
            default:
                objectToDelete = NSManagedObject()
            }
            CoreDataHelper.delete(objectToDelete)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editTitle = NSLocalizedString("Edit", comment: "Edit action")
        let editAction = UIContextualAction(style: .normal,
        title: editTitle) { (action, view, completionHandler) in
          self.editItem(at: indexPath)
          completionHandler(true)
        }
        
        editAction.backgroundColor = .lightGray
        let configuration = UISwipeActionsConfiguration(actions: [editAction])
        return configuration
    }
}
