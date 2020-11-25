//
//  HabitDetailsViewController.swift
//  MyHabits
//
//  Created by Alex Permiakov on 11/25/20.
//  Copyright © 2020 Alex Permiakov. All rights reserved.
//

import UIKit

class HabitDetailsViewController: UITableViewController {
  
  var habit: Habit?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    tableView.register(TableViewCell.self, forCellReuseIdentifier: "Date")
    tableView.tintColor = UIColor.AppColor.purple
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Править", style: .plain, target: self, action: #selector(tappedEditHabit))
    
    navigationController?.navigationBar.tintColor = UIColor.AppColor.purple
    navigationController?.navigationBar.backgroundColor = UIColor.AppColor.superLightGray
    
  }
  //  MARK: Small title
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.prefersLargeTitles = false
  }
  
  @objc private func tappedEditHabit() {
    let editHabitVC = HabitViewController()
    editHabitVC.navTitle = "Править"
    editHabitVC.habit = self.habit
    present(editHabitVC, animated: true, completion: nil)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return HabitsStore.shared.dates.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = self.tableView.dequeueReusableCell(withIdentifier: "Date", for: indexPath)
    cell.textLabel?.text = HabitsStore.shared.trackDateString(forIndex: indexPath.row)
    
    let date = HabitsStore.shared.dates[indexPath.row]
    if HabitsStore.shared.habit(habit!, isTrackedIn: date) {
      cell.accessoryType = .checkmark
    } else {
      cell.accessoryType = .none
    }
    return cell
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "АКТИВНОСТЬ"
  }
}

class TableViewCell: UITableViewCell {
}
