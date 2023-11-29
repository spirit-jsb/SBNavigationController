//
//  Spirit.swift
//
//  Created by Max on 2023/7/5
//
//  Copyright © 2023 Max. All rights reserved.
//

#if canImport(UIKit)

import UIKit

private var disablesInteractivePopKey: Void?

public struct SpiritWrapper<Base> {
    public let base: Base

    public init(_ base: Base) {
        self.base = base
    }
}

public protocol SpiritCompatible: AnyObject {}

public extension SpiritCompatible {
    var sb: SpiritWrapper<Self> {
        get {
            return SpiritWrapper(self)
        }
        set {}
    }
}

extension UIViewController: SpiritCompatible {}

public extension SpiritWrapper where Base: UIViewController {
    var disablesInteractivePop: Bool! {
        get {
            return getAssociatedObject(self.base, &disablesInteractivePopKey)
        }
        set {
            setAssociatedObject(self.base, &disablesInteractivePopKey, newValue)
        }
    }

    var navigationController: SBNavigationController? {
        var viewController: UIViewController? = self.base

        while viewController != nil && !(viewController is SBNavigationController) {
            viewController = viewController!.navigationController
        }

        return viewController as? SBNavigationController
    }
}

#endif
