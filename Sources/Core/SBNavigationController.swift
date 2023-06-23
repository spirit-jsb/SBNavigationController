//
//  SBNavigationController.swift
//  SBNavigationController
//
//  Created by Max on 2023/6/23.
//

#if canImport(UIKit)

import UIKit

open class SBNavigationController: UINavigationController {
    var useRootNavigationBarAttributes: Bool = false
    var actualViewControllers: [UIViewController] = []

    func setBackBarButtonItem(on viewController: UIViewController?) {}
}

#endif
