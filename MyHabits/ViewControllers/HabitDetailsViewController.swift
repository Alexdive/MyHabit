//
//  HabitDetailsViewController.swift
//  MyHabits
//
//  Created by Alex Permiakov on 11/25/20.
//  Copyright © 2020 Alex Permiakov. All rights reserved.
//

import UIKit

protocol DismissDelegate: class {
  func dismissVC()
}

protocol TitleDelegate: class {
  func reloadTitle(title: String)
}

class HabitDetailsViewController: UITableViewController {
  
  var habit: Habit?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Date")
    tableView.tintColor = UIColor.AppColor.purple
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Править", style: .plain, target: self, action: #selector(tappedEditHabit))
    
  }
  //  MARK: Small title
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
    navigationController?.navigationBar.prefersLargeTitles = false
  }
  
  @objc private func tappedEditHabit() {
    let editHabitVC = HabitViewController()
    editHabitVC.isInEditMode = true
    editHabitVC.habit = self.habit
    editHabitVC.dismissDelegate = self
    editHabitVC.titleDelegate = self
    present(editHabitVC, animated: true, completion: nil)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return HabitsStore.shared.dates.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let reversedDates: [Date] = HabitsStore.shared.dates.reversed()
    
    let cell = self.tableView.dequeueReusableCell(withIdentifier: "Date", for: indexPath)
    cell.textLabel?.text = dateFormatter.string(from: reversedDates[indexPath.item])

    let date = reversedDates[indexPath.item]
    if let habit = habit {
      if HabitsStore.shared.habit(habit, isTrackedIn: date) {
        cell.accessoryType = .checkmark
      } else {
        cell.accessoryType = .none
      }
    }
    return cell
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "АКТИВНОСТЬ"
  }
}

extension HabitDetailsViewController: DismissDelegate {
  func dismissVC() {
    navigationController?.popViewController(animated: false)
  }
}

extension HabitDetailsViewController: TitleDelegate {
  func reloadTitle(title: String) {
    navigationItem.title = title
  }
}

