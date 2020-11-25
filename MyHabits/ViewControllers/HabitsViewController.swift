//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by Alex Permiakov on 11/5/20.
//  Copyright © 2020 Alex Permiakov. All rights reserved.
//

import UIKit

protocol ReloadDataDelegate: class {
  func reloadHabits()
}

class HabitsViewController: UIViewController {
  
  let habitVC = HabitViewController()
  
  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let collectView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectView.backgroundColor = UIColor.AppColor.superLightGray
    collectView.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ProgressCollectionViewCell.self))
    collectView.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: HabitCollectionViewCell.self))
    collectView.dataSource = self
    collectView.delegate = self
    collectView.toAutoLayout()
    return collectView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tappedAddHabit))
    navigationController?.navigationBar.tintColor = UIColor.AppColor.purple
    
    habitVC.reloadDelegate = self
    
    setupViews()
  }
  
  @objc private func tappedAddHabit() {
    habitVC.navTitle = "Создать"
    navigationController?.present(habitVC, animated: true, completion: nil)
  }
//  MARK: Large title
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.prefersLargeTitles = true
    collectionView.reloadData()
  }
  
  private func setupViews() {
    
    view.addSubview(collectionView)
    
    let constraints = [
      collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ]
    NSLayoutConstraint.activate(constraints)
  }
}


// MARK: Extensions
extension HabitsViewController: UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 2
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard section == 0 else { return HabitsStore.shared.habits.count }
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if indexPath.section == 0 {
      let progressCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProgressCollectionViewCell.self), for: indexPath) as! ProgressCollectionViewCell
      let progress = HabitsStore.shared.todayProgress
      progressCell.textLabel.text = HabitsStore.shared.habits.isEmpty ? "Добавьте привычку!" : "Все получится!"
      progressCell.checkProgress(progress: progress)
      return progressCell
    } else {
      let habitCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HabitCollectionViewCell.self), for: indexPath) as! HabitCollectionViewCell
      
      let habit: Habit = HabitsStore.shared.habits[indexPath.item]
      habitCell.configure(habit: habit)
      habitCell.reloadDelegate = self
      return habitCell
    }
  }
}

extension HabitsViewController: UICollectionViewDelegateFlowLayout {
  private var baseInset: CGFloat { return 16 }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let detailsVC = HabitDetailsViewController()
    detailsVC.navigationItem.title = HabitsStore.shared.habits[indexPath.item].name
    detailsVC.habit = HabitsStore.shared.habits[indexPath.item]
    navigationController?.pushViewController(detailsVC, animated: true)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let width: CGFloat = collectionView.frame.width - baseInset * 2
    
    guard indexPath.section == 0 else { return CGSize(width: width, height: 130) }
    return CGSize(width: width, height: 60)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 12
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 12
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    
    return UIEdgeInsets(top: section == 0 ? 22 : 18, left: baseInset, bottom: 0, right: baseInset)
  }
}

extension HabitsViewController: ReloadDataDelegate {
  
  func reloadHabits() {
    print("received")
    collectionView.reloadData()
  }
}

