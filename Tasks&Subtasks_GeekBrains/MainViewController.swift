//
//  MainViewController.swift
//  Tasks&Subtasks_GeekBrains
//
//  Created by Роман Шичкин on 25.08.2021.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var taskTableView: UITableView!
    
    var currentTask: Task?
    
    var tableTasks: [Task] = [] {
        didSet {
            taskTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        loadTasks()
    }
    
    private func loadTasks() {
        if currentTask == nil { currentTask = TaskStorage.shared.getMainTask() }
        
        if let currentTask = currentTask {
            tableTasks = currentTask.openSubtasks()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func setupView() {
        setupBarButton()
        setupTableView()
    }
    
    private func setupBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: .plus,
            landscapeImagePhone: nil, style: .plain,
            target: self, action: #selector(addTapped)
        )
    }
    
    @objc func addTapped() {
        self.showNewTaskAlert()
    }
}

// MARK: - taskTableView

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    private func setupTableView() {
        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.register(UINib(nibName: TaskTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: TaskTableViewCell.reuseIdentifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.reuseIdentifier, for: indexPath) as! TaskTableViewCell
        
        cell.configure(with: tableTasks[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else { return }

        vc.currentTask = tableTasks[indexPath.row]
        vc.title = "\(tableTasks[indexPath.row].text)"
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            TaskStorage.shared.removeTask(by: tableTasks[indexPath.row].id)
            tableTasks.remove(at: indexPath.row)
        }
    }
}

