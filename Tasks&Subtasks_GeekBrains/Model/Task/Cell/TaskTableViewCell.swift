//
//  TaskTableViewCell.swift
//  Tasks&Subtasks_GeekBrains
//
//  Created by Роман Шичкин on 25.08.2021.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    public static let reuseIdentifier = "TaskTableViewCell"
    
    private var task: Task?
    
    enum ButtonState {
        case off
        case on
    }
    
    private var buttonState: ButtonState = .off {
        didSet {
            switch buttonState {
            case .off:
                checkButton.setImage(.circle, for: .normal)
                checkButton.tintColor = .systemRed
            case .on:
                checkButton.setImage(.circleFill, for: .normal)
                checkButton.tintColor = .systemGreen
            }
        }
    }
    
    private func switchCheckButton() {
        switch buttonState {
        case .off:
            buttonState = .on
            task?.isCompleted = true
        case .on:
            buttonState = .off
            task?.isCompleted = false
        }
    }
    
    public func configure(with task: Task) {
        
        self.task = task
        taskNameLabel.text = task.text
        
        if task.isCompleted {
            buttonState = .on
        } else {
            buttonState = .off
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    @IBAction func checkButtonTapped(_ sender: UIButton) {
        guard let task = task else { return }
        switchCheckButton()
        
        TaskStorage.shared.modifyTask(with: task)
    }
}
