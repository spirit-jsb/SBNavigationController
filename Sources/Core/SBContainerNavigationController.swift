//
//  SBContainerNavigationController.swift
//  SBNavigationController
//
//  Created by Max on 2023/6/23.
//

#if canImport(UIKit)

import UIKit

public class SBContainerNavigationController: UINavigationController {
    override public var viewControllers: [UIViewController] {
        get {
            if self.navigationController != nil {
                if self.navigationController is SBNavigationController {
                    return self.sb.navigationController!.actualViewControllers
                }
            }
            return super.viewControllers
        }
        set {
            super.viewControllers = newValue
        }
    }

    override public weak var delegate: UINavigationControllerDelegate? {
        get {
            return super.delegate
        }
        set {
            if self.navigationController != nil {
                self.navigationController!.delegate = newValue
            } else {
                super.delegate = newValue
            }
        }
    }

    override public var tabBarController: UITabBarController? {
        guard let tabBarController = super.tabBarController else {
            return nil
        }

        let navigationController = self.sb.navigationController

        guard navigationController?.tabBarController == tabBarController else {
            return tabBarController
        }

        let containsHidesBottomBarWhenPushed = navigationController.flatMap { $0.actualViewControllers.contains(where: { $0.hidesBottomBarWhenPushed }) } ?? false

        return containsHidesBottomBarWhenPushed ? nil : tabBarController
    }

    override public var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }

    override public var childForStatusBarHidden: UIViewController? {
        return self.topViewController
    }

    override public var childForScreenEdgesDeferringSystemGestures: UIViewController? {
        return self.topViewController
    }

    override public var childForHomeIndicatorAutoHidden: UIViewController? {
        return self.topViewController
    }

    @available(iOS 14.0, *)
    override public var childViewControllerForPointerLock: UIViewController? {
        return self.topViewController
    }

    override public init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
    }

    override public init(rootViewController: UIViewController) {
        super.init(navigationBarClass: rootViewController.navigationBarClass, toolbarClass: nil)

        self.pushViewController(rootViewController, animated: false)
    }

    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        self.interactivePopGestureRecognizer?.delegate = nil
        self.interactivePopGestureRecognizer?.isEnabled = false

        if let navigationController = self.sb.navigationController, navigationController.useRootNavigationBarAttributes {
            self.navigationBar.backgroundColor = self.navigationController!.navigationBar.backgroundColor

            self.navigationBar.barStyle = self.navigationController!.navigationBar.barStyle

            self.navigationBar.isTranslucent = self.navigationController!.navigationBar.isTranslucent

            self.navigationBar.prefersLargeTitles = self.navigationController!.navigationBar.prefersLargeTitles

            self.navigationBar.tintColor = self.navigationController!.navigationBar.tintColor
            self.navigationBar.barTintColor = self.navigationController!.navigationBar.barTintColor

            self.navigationBar.setBackgroundImage(self.navigationController!.navigationBar.backgroundImage(for: .default), for: .default)

            self.navigationBar.shadowImage = self.navigationController!.navigationBar.shadowImage

            self.navigationBar.titleTextAttributes = self.navigationController!.navigationBar.titleTextAttributes
            self.navigationBar.largeTitleTextAttributes = self.navigationController!.navigationBar.largeTitleTextAttributes

            self.navigationBar.setTitleVerticalPositionAdjustment(self.navigationController!.navigationBar.titleVerticalPositionAdjustment(for: .default), for: .default)

            self.navigationBar.backIndicatorImage = self.navigationController!.navigationBar.backIndicatorImage
            self.navigationBar.backIndicatorTransitionMaskImage = self.navigationController!.navigationBar.backIndicatorTransitionMaskImage

            if #available(iOS 13.0, *) {
                self.navigationBar.standardAppearance = self.navigationController!.navigationBar.standardAppearance
                self.navigationBar.compactAppearance = self.navigationController!.navigationBar.compactAppearance
                self.navigationBar.scrollEdgeAppearance = self.navigationController!.navigationBar.scrollEdgeAppearance
                self.navigationBar.scrollEdgeAppearance = self.navigationController!.navigationBar.scrollEdgeAppearance
            }

            if #available(iOS 15.0, *) {
                self.navigationBar.compactScrollEdgeAppearance = self.navigationController!.navigationBar.compactScrollEdgeAppearance
            }
        }
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if self.topViewController?.sb.disablesInteractivePop == nil {
            self.topViewController?.sb.disablesInteractivePop = self.isNavigationBarHidden || self.topViewController?.navigationItem.leftBarButtonItem != nil
        }

        if self.parent is SBContainerViewController, self.parent?.parent is SBNavigationController {
            self.sb.navigationController?.setLeftBarButtonItem(on: self.topViewController)
        }
    }

    override public func forwardingTarget(for aSelector: Selector!) -> Any? {
        if self.navigationController != nil, self.navigationController!.responds(to: aSelector) {
            return self.navigationController
        }
        return nil
    }

    override public func allowedChildrenForUnwinding(from source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        if self.navigationController != nil {
            return self.navigationController!.allowedChildrenForUnwinding(from: source)
        }
        return super.allowedChildrenForUnwinding(from: source)
    }

    override public func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.navigationController != nil {
            self.navigationController!.pushViewController(viewController, animated: animated)
        } else {
            super.pushViewController(viewController, animated: animated)
        }
    }

    override public func popViewController(animated: Bool) -> UIViewController? {
        if self.navigationController != nil {
            return self.navigationController!.popViewController(animated: animated)
        }
        return super.popViewController(animated: animated)
    }

    override public func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        if self.navigationController != nil {
            return self.navigationController!.popToViewController(viewController, animated: animated)
        }
        return super.popToViewController(viewController, animated: animated)
    }

    override public func popToRootViewController(animated: Bool) -> [UIViewController]? {
        if self.navigationController != nil {
            return self.navigationController!.popToRootViewController(animated: animated)
        }
        return super.popToRootViewController(animated: animated)
    }

    override public func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        if self.navigationController != nil {
            self.navigationController!.setViewControllers(viewControllers, animated: animated)
        } else {
            super.setViewControllers(viewControllers, animated: animated)
        }
    }

    override public func setNavigationBarHidden(_ hidden: Bool, animated: Bool) {
        super.setNavigationBarHidden(hidden, animated: animated)

        if self.topViewController?.sb.disablesInteractivePop == nil {
            self.topViewController?.sb.disablesInteractivePop = hidden
        }
    }
}

#endif
