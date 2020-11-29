//
//  ProgressCollectionViewCell.swift
//  MyHabits
//
//  Created by Alex Permiakov on 11/24/20.
//  Copyright © 2020 Alex Permiakov. All rights reserved.
//

import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
  
  var textLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
    label.textColor = .systemGray
    label.toAutoLayout()
    return label
  }()
  
  private lazy var percentLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
    label.textColor = .systemGray
    label.toAutoLayout()
    return label
  }()
  
  private lazy var progressBar: UIProgressView = {
    let progBar = UIProgressView(progressViewStyle: .bar)
    progBar.progressTintColor = UIColor.AppColor.purple
    progBar.backgroundColor = .systemGray2
    progBar.layer.masksToBounds = true
    progBar.layer.cornerRadius = 4
//    Без этой логики скругление применяется только с внешних краев, а на сиреневой линии внутри прогрессбара скругления нет. нашел решение на stackoverflow
    progBar.subviews.forEach { subview in
      subview.layer.masksToBounds = true
      subview.layer.cornerRadius = 4
    }
    progBar.toAutoLayout()
    return progBar
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupViews()
    contentView.backgroundColor = .white
    progressBar.setProgress(HabitsStore.shared.todayProgress, animated: false)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  func checkProgress(progress: Float) {
    progressBar.setProgress(progress, animated: true)
    percentLabel.text = "\(Int(progress * 100))%"
    
  }
  
  // MARK: Layout
  func setupViews() {
    
    contentView.layer.cornerRadius = 8
    
    contentView.addSubview(textLabel)
    contentView.addSubview(percentLabel)
    contentView.addSubview(progressBar)
    
    let constraints = [
      
      textLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
      
      percentLabel.topAnchor.constraint(equalTo: textLabel.topAnchor),
      percentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
      
      progressBar.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 10),
      progressBar.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor),
      progressBar.trailingAnchor.constraint(equalTo: percentLabel.trailingAnchor),
      progressBar.heightAnchor.constraint(equalToConstant: 7),
      progressBar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
      
    ]
    NSLayoutConstraint.activate(constraints)
  }
}
