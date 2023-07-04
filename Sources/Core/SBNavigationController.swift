//
//  SBNavigationController.swift
//  SBNavigationController
//
//  Created by Max on 2023/6/23.
//

#if canImport(UIKit)

import UIKit

public protocol CustomizableBackBarButtonItem {
    func customizableBackBarButtonItem(_ target: Any?, action: Selector) -> UIBarButtonItem
}

private func SBUnwrapViewController(_ viewController: UIViewController?) -> UIViewController? {
    if viewController is SBContainerViewController {
        return (viewController as! SBContainerViewController).contentViewController
    }
    return viewController
}

private func SBWrapViewController(_ viewController: UIViewController, navigationBarClass: AnyClass?, title: String? = nil, backBarButtonItem: UIBarButtonItem? = nil, hasPlaceholderViewController: Bool = false) -> UIViewController {
    if !(viewController is SBContainerViewController) && !(viewController.parent is SBContainerViewController) {
        return SBContainerViewController(contentViewController: viewController, navigationBarClass: navigationBarClass, title: title, backBarButtonItem: backBarButtonItem, hasPlaceholderViewController: hasPlaceholderViewController)
    }
    return viewController
}

open class SBNavigationController: UINavigationController {
    public typealias CompletionCallback = (Bool) -> Void

    /// 是否使用系统原生样式的返回按钮，默认值为 `false`
    @IBInspectable
    public var useSystemBackBarButtonItem: Bool = false
    /// 是否使用 `root navigation bar` 的样式，默认值为 `false`
    @IBInspectable
    public var useRootNavigationBarAttributes: Bool = false

    public var actualTopViewController: UIViewController? {
        return SBUnwrapViewController(super.topViewController)
    }

    public var actualVisibleViewController: UIViewController? {
        return SBUnwrapViewController(super.visibleViewController)
    }

    public var actualViewControllers: [UIViewController] {
        return super.viewControllers.map { SBUnwrapViewController($0)! }
    }

    override public var shouldAutorotate: Bool {
        return self.topViewController?.shouldAutorotate ?? super.shouldAutorotate
    }

    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.topViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
    }

    override public var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return self.topViewController?.preferredInterfaceOrientationForPresentation ?? super.preferredInterfaceOrientationForPresentation
    }

    override public weak var delegate: UINavigationControllerDelegate? {
        get {
            return super.delegate
        }
        set {
            self._delegate = newValue
        }
    }

    private weak var _delegate: UINavigationControllerDelegate?

    private var _completion: CompletionCallback?

    public init(noWrappingRootViewController: UIViewController) {
        super.init(rootViewController: SBContainerViewController(contentViewController: noWrappingRootViewController))
    }

    override public init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
    }

    override public init(rootViewController: UIViewController) {
        super.init(rootViewController: SBWrapViewController(rootViewController, navigationBarClass: rootViewController.navigationBarClass))
    }

    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override public func awakeFromNib() {
        super.awakeFromNib()

        self.viewControllers = super.viewControllers
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        super.delegate = self

        self.view.backgroundColor = UIColor.white
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        super.setNavigationBarHidden(true, animated: animated)
    }

    override public func responds(to aSelector: Selector!) -> Bool {
        return super.responds(to: aSelector) ? true : self._delegate != nil ? self._delegate!.responds(to: aSelector) : false
    }

    override public func forwardingTarget(for aSelector: Selector!) -> Any? {
        return self._delegate
    }

    override public func allowedChildrenForUnwinding(from source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        let viewControllers = self.viewControllers

        var childViewControllersToSearch = super.allowedChildrenForUnwinding(from: source)

        if childViewControllersToSearch.isEmpty {
            if let searchIndex = viewControllers.firstIndex(of: source.source) {
                for i in (0 ..< searchIndex).reversed() {
                    childViewControllersToSearch = viewControllers[i].allowedChildrenForUnwinding(from: source)

                    if !childViewControllersToSearch.isEmpty {
                        break
                    }
                }
            }
        }

        return childViewControllersToSearch.map { SBUnwrapViewController($0)! }
    }

    override public func pushViewController(_ viewController: UIViewController, animated: Bool) {
        let viewControllers = self.viewControllers

        let wrappedViewController: UIViewController
        if viewControllers.count > 0 {
            let latestActualViewController = SBUnwrapViewController(viewControllers.last)!

            wrappedViewController = SBWrapViewController(viewController, navigationBarClass: viewController.navigationBarClass, title: latestActualViewController.navigationItem.title ?? latestActualViewController.title, backBarButtonItem: latestActualViewController.navigationItem.backBarButtonItem, hasPlaceholderViewController: self.useSystemBackBarButtonItem)
        } else {
            wrappedViewController = SBWrapViewController(viewController, navigationBarClass: viewController.navigationBarClass)
        }

        super.pushViewController(wrappedViewController, animated: animated)
    }

    @discardableResult
    override public func popViewController(animated: Bool) -> UIViewController? {
        let poppedViewController = super.popViewController(animated: animated)

        return SBUnwrapViewController(poppedViewController)
    }

    @discardableResult
    override public func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        let viewControllers = self.viewControllers

        guard let poppedViewController = viewControllers.first(where: { SBUnwrapViewController($0) == viewController }) else {
            return nil
        }

        let poppedViewControllers = super.popToViewController(poppedViewController, animated: animated)

        return poppedViewControllers.flatMap { $0.map { SBUnwrapViewController($0)! } }
    }

    @discardableResult
    override public func popToRootViewController(animated: Bool) -> [UIViewController]? {
        let poppedViewControllers = super.popToRootViewController(animated: animated)

        return poppedViewControllers.flatMap { $0.map { SBUnwrapViewController($0)! } }
    }

    override public func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        let wrappedViewControllers = viewControllers.enumerated().map { index, viewController -> UIViewController in
            if index > 0 {
                let previousActualViewController = SBUnwrapViewController(viewControllers[safe: index - 1])!

                return SBWrapViewController(viewController, navigationBarClass: viewController.navigationBarClass, title: previousActualViewController.navigationItem.title ?? previousActualViewController.title, backBarButtonItem: previousActualViewController.navigationItem.backBarButtonItem, hasPlaceholderViewController: self.useSystemBackBarButtonItem)
            } else {
                return SBWrapViewController(viewController, navigationBarClass: viewController.navigationBarClass)
            }
        }

        super.setViewControllers(wrappedViewControllers, animated: animated)
    }

    public func pushViewController(_ viewController: UIViewController, animated: Bool, completion: @escaping CompletionCallback) {
        if self._completion != nil {
            self._completion!(false)
        }

        self._completion = completion

        self.pushViewController(viewController, animated: animated)
    }

    @discardableResult
    public func popViewController(animated: Bool, completion: @escaping CompletionCallback) -> UIViewController? {
        if self._completion != nil {
            self._completion!(false)
        }

        self._completion = completion

        let poppedViewController = self.popViewController(animated: animated)
        if poppedViewController == nil {
            if self._completion != nil {
                self._completion!(true)
                self._completion = nil
            }
        }

        return poppedViewController
    }

    @discardableResult
    public func popToViewController(_ viewController: UIViewController, animated: Bool, completion: @escaping CompletionCallback) -> [UIViewController]? {
        if self._completion != nil {
            self._completion!(false)
        }

        self._completion = completion

        let poppedViewControllers = self.popToViewController(viewController, animated: animated)
        if let poppedViewControllers = poppedViewControllers, poppedViewControllers.isEmpty {
            if self._completion != nil {
                self._completion!(true)
                self._completion = nil
            }
        }

        return poppedViewControllers
    }

    @discardableResult
    public func popToRootViewController(animated: Bool, completion: @escaping CompletionCallback) -> [UIViewController]? {
        if self._completion != nil {
            self._completion!(false)
        }

        self._completion = completion

        let poppedViewControllers = self.popToRootViewController(animated: animated)
        if let poppedViewControllers = poppedViewControllers, poppedViewControllers.isEmpty {
            if self._completion != nil {
                self._completion!(true)
                self._completion = nil
            }
        }

        return poppedViewControllers
    }

    public func removeViewController(_ viewController: UIViewController, animated: Bool = false) {
        var viewControllers = self.viewControllers

        guard let removedIndex = viewControllers.firstIndex(where: { SBUnwrapViewController($0) == viewController }) else {
            return
        }

        viewControllers.remove(at: removedIndex)

        super.setViewControllers(viewControllers, animated: animated)
    }

    func setLeftBarButtonItem(on viewController: UIViewController?) {
        let viewControllers = self.viewControllers

        if !self.useSystemBackBarButtonItem, viewController != SBUnwrapViewController(viewControllers.first), viewController?.navigationItem.leftBarButtonItem == nil {
            if viewController is CustomizableBackBarButtonItem {
                viewController?.navigationItem.leftBarButtonItem = (viewController as! CustomizableBackBarButtonItem).customizableBackBarButtonItem(self, action: #selector(self.triggerBack(_:)))
            } else {
                viewController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Back", comment: ""), style: .plain, target: self, action: #selector(self.triggerBack(_:)))
            }
        }
    }

    @objc
    private func triggerBack(_ sender: UIBarButtonItem) {
        self.popViewController(animated: true)
    }
}

extension SBNavigationController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let actualViewController = SBUnwrapViewController(viewController)!

        if viewController != navigationController.viewControllers.first, actualViewController.isViewLoaded {
            if actualViewController.sb.disablesInteractivePop == nil {
                actualViewController.sb.disablesInteractivePop = actualViewController.navigationItem.leftBarButtonItem != nil
            }
        }

        if let delegate = self._delegate, delegate.responds(to: #selector(navigationController(_:willShow:animated:))) {
            delegate.navigationController!(navigationController, willShow: actualViewController, animated: animated)
        }
    }

    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        SBNavigationController.attemptRotationToDeviceOrientation()

        let actualViewController = SBUnwrapViewController(viewController)!

        if viewController != navigationController.viewControllers.first, actualViewController.isViewLoaded {
            self.setLeftBarButtonItem(on: actualViewController)
        }

        if let disablesInteractivePop = actualViewController.sb.disablesInteractivePop, disablesInteractivePop {
            self.interactivePopGestureRecognizer?.delegate = nil
            self.interactivePopGestureRecognizer?.isEnabled = false
        } else {
            self.interactivePopGestureRecognizer?.delegate = self
            self.interactivePopGestureRecognizer?.isEnabled = viewController != navigationController.viewControllers.first
        }

        if let delegate = self._delegate, delegate.responds(to: #selector(navigationController(_:didShow:animated:))) {
            delegate.navigationController!(navigationController, didShow: actualViewController, animated: animated)
        }

        if self._completion != nil {
            self._completion!(true)
            self._completion = nil
        }
    }

    public func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        if let delegate = self._delegate, delegate.responds(to: #selector(navigationControllerSupportedInterfaceOrientations(_:))) {
            return delegate.navigationControllerSupportedInterfaceOrientations!(navigationController)
        }
        return .all
    }

    public func navigationControllerPreferredInterfaceOrientationForPresentation(_ navigationController: UINavigationController) -> UIInterfaceOrientation {
        if let delegate = self._delegate, delegate.responds(to: #selector(navigationControllerPreferredInterfaceOrientationForPresentation(_:))) {
            return delegate.navigationControllerPreferredInterfaceOrientationForPresentation!(navigationController)
        }
        return .portrait
    }

    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if let delegate = self._delegate, delegate.responds(to: #selector(navigationController(_:interactionControllerFor:))) {
            return delegate.navigationController!(navigationController, interactionControllerFor: animationController)
        }
        return nil
    }

    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let delegate = self._delegate, delegate.responds(to: #selector(navigationController(_:animationControllerFor:from:to:))) {
            return delegate.navigationController!(navigationController, animationControllerFor: operation, from: SBUnwrapViewController(fromVC)!, to: SBUnwrapViewController(toVC)!)
        }
        return nil
    }
}

extension SBNavigationController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer == self.interactivePopGestureRecognizer
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer == self.interactivePopGestureRecognizer
    }
}

#endif
