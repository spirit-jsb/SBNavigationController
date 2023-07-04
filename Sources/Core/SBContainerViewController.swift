//
//  SBContainerViewController.swift
//  SBNavigationController
//
//  Created by Max on 2023/6/23.
//

#if canImport(UIKit)

import UIKit

public class SBContainerViewController: UIViewController {
    public private(set) var contentViewController: UIViewController!
    public private(set) var contentNavigationController: UINavigationController?

    override public var canBecomeFirstResponder: Bool {
        return self.contentViewController.canBecomeFirstResponder
    }

    override public var title: String? {
        get {
            return self.contentViewController.title
        }
        set {
            super.title = newValue
        }
    }

    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return self.contentViewController.preferredStatusBarStyle
    }

    override public var prefersStatusBarHidden: Bool {
        return self.contentViewController.prefersStatusBarHidden
    }

    override public var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return self.contentViewController.preferredStatusBarUpdateAnimation
    }

    override public var shouldAutorotate: Bool {
        return self.contentViewController.shouldAutorotate
    }

    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.contentViewController.supportedInterfaceOrientations
    }

    override public var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return self.contentViewController.preferredInterfaceOrientationForPresentation
    }

    override public var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return self.contentViewController.preferredScreenEdgesDeferringSystemGestures
    }

    override public var prefersHomeIndicatorAutoHidden: Bool {
        return self.contentViewController.prefersHomeIndicatorAutoHidden
    }

    @available(iOS 14.0, *)
    override public var prefersPointerLocked: Bool {
        return self.contentViewController.prefersPointerLocked
    }

    override public var hidesBottomBarWhenPushed: Bool {
        get {
            return self.contentViewController.hidesBottomBarWhenPushed
        }
        set {
            super.hidesBottomBarWhenPushed = newValue
        }
    }

    override public var tabBarItem: UITabBarItem! {
        get {
            return self.contentViewController.tabBarItem
        }
        set {
            super.tabBarItem = newValue
        }
    }

    public init(contentViewController: UIViewController) {
        super.init(nibName: nil, bundle: nil)

        self.contentViewController = contentViewController

        self.addChild(self.contentViewController)
        self.contentViewController.didMove(toParent: self)
    }

    public init(contentViewController: UIViewController, navigationBarClass: AnyClass? = nil, title: String? = nil, backBarButtonItem: UIBarButtonItem? = nil, hasPlaceholderViewController: Bool = false) {
        super.init(nibName: nil, bundle: nil)

        self.contentViewController = contentViewController
        self.contentNavigationController = SBContainerNavigationController(navigationBarClass: navigationBarClass, toolbarClass: nil)

        if hasPlaceholderViewController {
            let placeholderViewController = UIViewController()
            placeholderViewController.title = title
            placeholderViewController.navigationItem.backBarButtonItem = backBarButtonItem

            self.contentNavigationController!.viewControllers = [placeholderViewController, contentViewController]
        } else {
            self.contentNavigationController!.viewControllers = [contentViewController]
        }

        self.addChild(self.contentNavigationController!)
        self.contentNavigationController!.didMove(toParent: self)
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

        if self.contentNavigationController != nil {
            self.contentNavigationController!.view.frame = self.view.bounds
            self.contentNavigationController!.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            self.view.addSubview(self.contentNavigationController!.view)
        } else {
            self.contentViewController.view.frame = self.view.bounds
            self.contentViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            self.view.addSubview(self.contentViewController.view)
        }
    }

    override public func becomeFirstResponder() -> Bool {
        return self.contentViewController.becomeFirstResponder()
    }

    override public func allowedChildrenForUnwinding(from source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        return self.contentViewController.allowedChildrenForUnwinding(from: source)
    }
}

#endif
