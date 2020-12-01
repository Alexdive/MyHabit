//
//  HabitViewController.swift
//  MyHabits
//
//  Created by Alex Permiakov on 11/5/20.
//  Copyright © 2020 Alex Permiakov. All rights reserved.
//

import UIKit

class HabitViewController: UIViewController {
  
  weak var reloadDelegate: ReloadDataDelegate?
  
  weak var dismissDelegate: DismissDelegate?
  
  weak var titleDelagate: TitleDelegate?
  
  var habit: Habit?
  
  var navTitle: String?
  
  var isInEditMode = false
  
  private lazy var habitName = ""
  
  private lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.text = "НАЗВАНИЕ"
    label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    label.toAutoLayout()
    return label
  }()
  
  private lazy var habitNameField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Бегать по утрам, спать 8 часов и т.п."
    textField.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    textField.textColor = UIColor.AppColor.blue
    textField.returnKeyType = UIReturnKeyType.continue
    textField.addTarget(self, action: #selector(habitNameChanged), for: .editingChanged)
    textField.toAutoLayout()
    return textField
  }()
  
  private lazy var colorLabel: UILabel = {
    let label = UILabel()
    label.text = "ЦВЕТ"
    label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    label.toAutoLayout()
    return label
  }()
  
  private lazy var setColorButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = UIColor.AppColor.orange
    button.addTarget(self, action: #selector(setColorButtonAction), for: .touchUpInside)
    button.toAutoLayout()
    return button
  }()
  
  private lazy var timeLabel: UILabel = {
    let label = UILabel()
    label.text = "ВРЕМЯ"
    label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    label.toAutoLayout()
    return label
  }()
  
  private lazy var everyDayLabel: UILabel = {
    let label = UILabel()
    label.text = "Каждый день в "
    label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    label.toAutoLayout()
    return label
  }()
  
  private lazy var chosenTimeLabel: UILabel = {
    let label = UILabel()
    let currentDateTime = Date()
    label.text = timeFormatter.string(from: currentDateTime)
    label.textColor = UIColor.AppColor.purple
    label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    label.toAutoLayout()
    return label
  }()
  
  private lazy var timePicker: UIDatePicker = {
    let picker = UIDatePicker()
    picker.datePickerMode = UIDatePicker.Mode.time
    picker.preferredDatePickerStyle = .wheels
    picker.addTarget(self, action: #selector(dueDateChanged), for: .valueChanged)
    picker.toAutoLayout()
    return picker
  }()
  
  private lazy var colorPicker: UIColorPickerViewController = {
    let colorPicker = UIColorPickerViewController()
    colorPicker.selectedColor = UIColor.AppColor.orange
    colorPicker.title = "Выберите цвет для привычки"
    return colorPicker
  }()
  
  private lazy var timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter
  }()
  
  private lazy var deleteHabitButton: UIButton = {
    let button = UIButton()
    button.setTitle("Удалить привычку", for: .normal)
    button.setTitleColor(.red, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
    button.addTarget(self, action: #selector(deleteHabit), for: .touchUpInside)
    if !isInEditMode {
      button.isHidden = true
    } else {
      button.isHidden = false
    }
    button.toAutoLayout()
    return button
  }()
  
  //  MARK: ViewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
    setupLayout()
    view.backgroundColor = .white
    
    if isInEditMode {
      loadHabitData(habit: habit!)
    }
    
    habitNameField.delegate = self
    colorPicker.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if !isInEditMode {
      habitNameField.text = ""
      habitName = ""
      timePicker.date = Date()
      chosenTimeLabel.text = timeFormatter.string(from: Date())
      setColorButton.backgroundColor = UIColor.AppColor.orange
    }
  }
  
  //  MARK: Actions
  private func loadHabitData(habit: Habit) {
    habitNameField.text = habit.name
    habitName = habit.name
    timePicker.date = habit.date
    setColorButton.backgroundColor = habit.color
    colorPicker.selectedColor = habit.color
  }
  
  @objc private func dismissEdit(sender: AnyObject) {
    print("Dismissed")
    dismiss(animated: true, completion: nil)
  }
  
  @objc private func saveHabit() {
    let store = HabitsStore.shared
    if !isInEditMode {
      let newHabit = Habit(name: habitName.isEmpty ? "Безымянная привычка" : habitName,
                           date: timePicker.date,
                           color: setColorButton.backgroundColor!)
      store.habits.append(newHabit)
      print("Added new \(newHabit.name)")
    } else {
      if let oldHabit = habit {
        oldHabit.name = habitName
        oldHabit.date = timePicker.date
        oldHabit.color = setColorButton.backgroundColor!
      }
      titleDelagate?.reloadTitle(title: habitName)
    }
    dismiss(animated: true, completion: nil)
    alertHasShown = false
    reloadDelegate?.reloadHabits()
  }
  
  @objc func deleteHabit() {
    
    let alertController = UIAlertController(title: "Удалить привычку", message: "Вы хотите удалить привычку \(habit!.name)?", preferredStyle: .alert)
    
    let cancelAction = UIAlertAction(title: "Отмена", style: .default)
    
    let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
      if let index = HabitsStore.shared.habits.firstIndex(of: self.habit!) {
        HabitsStore.shared.habits.remove(at: index)
        self.dismiss(animated: true, completion: nil)
        self.dismissDelegate?.dismissVC()
      }
    }
    alertController.addAction(cancelAction)
    alertController.addAction(deleteAction)
    self.present(alertController, animated: true, completion: nil)
  }
  
  @objc private func habitNameChanged(sender: AnyObject) {
    habitName = habitNameField.text ?? ""
  }
  
  @objc private func setColorButtonAction(_ sender: Any) {
    self.present(colorPicker, animated: true)
  }
  
  @objc private func dueDateChanged(sender: UIDatePicker){
    chosenTimeLabel.text = timeFormatter.string(from: timePicker.date)
  }
  
  //  MARK: Helpers
  private func setupViews() {
    let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
    let navItem = UINavigationItem(title: navTitle!)
    let dismissItem = UIBarButtonItem(title: "Отменить", style: .done, target: self, action: #selector(dismissEdit))
    let saveItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(saveHabit))
    
    dismissItem.tintColor = UIColor.AppColor.purple
    dismissItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular)], for: .normal)
    saveItem.tintColor = UIColor.AppColor.purple
    navItem.rightBarButtonItem = saveItem
    navItem.leftBarButtonItem = dismissItem
    navBar.setItems([navItem], animated: false)
    
    view.addSubview(navBar)
    view.addSubview(nameLabel)
    view.addSubview(habitNameField)
    view.addSubview(colorLabel)
    view.addSubview(setColorButton)
    view.addSubview(timeLabel)
    view.addSubview(everyDayLabel)
    view.addSubview(timePicker)
    view.addSubview(chosenTimeLabel)
    view.addSubview(deleteHabitButton)
  }
  
  private func setupLayout() {
    
    setColorButton.layer.cornerRadius = 15
    setColorButton.clipsToBounds = true
    
    let baseInset: CGFloat = 16
    
    let constraints = [
      
      nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44 + 22),
      nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: baseInset),
      
      habitNameField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 7),
      habitNameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: baseInset),
      habitNameField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      
      colorLabel.topAnchor.constraint(equalTo: habitNameField.bottomAnchor, constant: 15),
      colorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: baseInset),
      
      setColorButton.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 7),
      setColorButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: baseInset),
      setColorButton.widthAnchor.constraint(equalToConstant: 30),
      setColorButton.heightAnchor.constraint(equalToConstant: 30),
      
      timeLabel.topAnchor.constraint(equalTo: setColorButton.bottomAnchor, constant: 15),
      timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: baseInset),
      
      everyDayLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 7),
      everyDayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: baseInset),
      
      chosenTimeLabel.centerYAnchor.constraint(equalTo: everyDayLabel.centerYAnchor),
      chosenTimeLabel.leadingAnchor.constraint(equalTo: everyDayLabel.trailingAnchor),
      
      timePicker.topAnchor.constraint(equalTo: everyDayLabel.bottomAnchor, constant: 15),
      timePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      timePicker.widthAnchor.constraint(equalToConstant: view.frame.width - baseInset*2),
      
      deleteHabitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      deleteHabitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
      
    ]
    NSLayoutConstraint.activate(constraints)
  }
}


extension HabitViewController: UIColorPickerViewControllerDelegate {
  
  func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
    self.setColorButton.backgroundColor = viewController.selectedColor
    viewController.dismiss(animated: true, completion: nil)
  }
  
  func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
    self.setColorButton.backgroundColor = viewController.selectedColor
  }
}

extension HabitViewController: UITextFieldDelegate {
  /// Keyboard dismiss
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
  }
}
