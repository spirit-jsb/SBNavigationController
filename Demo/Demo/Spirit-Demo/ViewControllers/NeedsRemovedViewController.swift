//
//  NeedsRemovedViewController.swift
//  SBNavigationController-Demo
//
//  Created by Max on 2023/6/25.
//

import SBNavigationController
import UIKit

class NeedsRemovedViewController: UIViewController {
    lazy var needsRemovedAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()

        appearance.backgroundColor = UIColor.systemIndigo

        appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 17.0, weight: .bold), .foregroundColor: UIColor.white]

        return appearance
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Needs Removed"

        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.standardAppearance = self.needsRemovedAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = self.needsRemovedAppearance
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction
    func tapPushToUnwindSegueViewControllerThenRemovedThisViewController(_ sender: UIButton) {
        let unwindSegueViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "UnwindSegueViewController")

        self.sb.navigationController?.pushViewController(unwindSegueViewController, animated: true) { [unowned self] _ in
            self.sb.navigationController?.removeViewController(self)
        }
    }
}

extension NeedsRemovedViewController: CustomizableBackBarButtonItem {
    func customizableBackBarButtonItem(_ target: Any?, action: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: target, action: action)
    }
}
