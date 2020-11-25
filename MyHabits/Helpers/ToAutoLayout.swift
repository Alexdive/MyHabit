//
//  ToAutoLayout.swift
//  MyHabits
//
//  Created by Alex Permiakov on 11/24/20.
//  Copyright © 2020 Alex Permiakov. All rights reserved.
//

import UIKit

// switch to auto layout
extension UIView {
  func toAutoLayout() {
    self.translatesAutoresizingMaskIntoConstraints = false
  }
}
