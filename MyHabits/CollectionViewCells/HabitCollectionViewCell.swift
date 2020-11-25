//
//  HabitCollectionViewCell.swift
//  MyHabits
//
//  Created by Alex Permiakov on 11/24/20.
//  Copyright © 2020 Alex Permiakov. All rights reserved.
//

import UIKit

class HabitCollectionViewCell: UICollectionViewCell {
  
  weak var reloadDelegate: ReloadDataDelegate?
  
  private lazy var habitNameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    label.numberOfLines = 2
    label.toAutoLayout()
    return label
  }()
  
  private lazy var dailyTimeLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
    label.textColor = .systemGray2
    label.toAutoLayout()
    return label
  }()
  
  private lazy var timesInRowLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    label.textColor = .systemGray2
    label.toAutoLayout()
    return label
  }()
  
  private lazy var checkMarkLabel: UIButton = {
    let button = UIButton(primaryAction: UIAction { _ in
      self.checkHabit()
    })
    button.contentMode = .scaleAspectFit
    button.toAutoLayout()
    return button
  }()
  
  private var habit: Habit?
  
  internal func configure(habit: Habit) {
    habitNameLabel.text = habit.name
    habitNameLabel.textColor = habit.color
    dailyTimeLabel.text = habit.dateString
    timesInRowLabel.text = "Подряд: \(habit.trackDates.count)"
    checkMarkLabel.tintColor = habit.color
    if habit.isAlreadyTakenToday {
      checkMarkLabel.setImage(UIImage(systemName: "checkmark.circle.fill")!, for: .normal)
    } else {
      checkMarkLabel.setImage(UIImage(systemName: "circle")!, for: .normal)
    }
    self.habit = habit
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupViews()
    contentView.backgroundColor = .white
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
//  MARK: Actions
  func checkHabit() {
    print("CheckMark tapped")
    
    if habit!.isAlreadyTakenToday {
      print("Taken")
      return
    }
    checkMarkLabel.setImage(UIImage(systemName: "checkmark.circle.fill")!, for: .normal)
    checkMarkLabel.imageView?.alpha = 0
    
    HabitsStore.shared.track(habit!)
    reloadDelegate?.reloadHabits()
    
    let indexPath = IndexPath(row: 0, section: 0)
    UIView.animate(withDuration: 0.5, animations: {
      (self.superview as! UICollectionView).reloadItems(at: [indexPath])
      self.checkMarkLabel.imageView?.alpha = 1
    })
  }
  
  // MARK: Layout
  func setupViews() {
    
    contentView.layer.cornerRadius = 8
    let checkMarkWidth: CGFloat = 36
    
    contentView.addSubview(habitNameLabel)
    contentView.addSubview(dailyTimeLabel)
    contentView.addSubview(timesInRowLabel)
    contentView.addSubview(checkMarkLabel)
    
    let constraints = [
      
      habitNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
      habitNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      habitNameLabel.trailingAnchor.constraint(equalTo: checkMarkLabel.leadingAnchor, constant: -26),
      
      dailyTimeLabel.topAnchor.constraint(equalTo: habitNameLabel.bottomAnchor, constant: 4),
      dailyTimeLabel.leadingAnchor.constraint(equalTo: habitNameLabel.leadingAnchor),
      
      timesInRowLabel.leadingAnchor.constraint(equalTo: habitNameLabel.leadingAnchor),
      timesInRowLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
      
      checkMarkLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 47),
      checkMarkLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -47),
      checkMarkLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -26),
      checkMarkLabel.widthAnchor.constraint(equalToConstant: checkMarkWidth)
      
    ]
    NSLayoutConstraint.activate(constraints)
  }
}
