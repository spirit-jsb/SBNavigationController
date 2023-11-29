//
//  Array+Spirit.swift
//
//  Created by Max on 2023/7/5
//
//  Copyright © 2023 Max. All rights reserved.
//

#if canImport(UIKit)

import UIKit

extension Array where Element: UIViewController {
    subscript(safe index: Int) -> Element? {
        return self.indices ~= index ? self[index] : nil
    }
}

#endif
