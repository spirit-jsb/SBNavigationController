//
//  Array+Spirit.swift
//  SBNavigationController
//
//  Created by Max on 2023/6/25.
//

#if canImport(UIKit)

import UIKit

extension Array where Element: UIViewController {
    subscript(safe index: Int) -> Element? {
        return self.indices ~= index ? self[index] : nil
    }
}

#endif
