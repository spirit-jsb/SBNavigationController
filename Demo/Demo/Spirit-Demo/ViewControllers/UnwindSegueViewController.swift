//
//  UnwindSegueViewController.swift
//  SBNavigationController-Demo
//
//  Created by Max on 2023/6/25.
//

import SBNavigationController
import UIKit

class UnwindSegueViewController: UIViewController {
    lazy var unwindSegueAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()

        appearance.backgroundColor = UIColor.white

        appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 17.0, weight: .bold), .foregroundColor: UIColor.systemIndigo]

        return appearance
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Unwind Segue"

        self.navigationController?.navigationBar.tintColor = UIColor.systemIndigo
        self.navigationController?.navigationBar.standardAppearance = self.unwindSegueAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = self.unwindSegueAppearance
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension UnwindSegueViewController: CustomizableBackBarButtonItem {
    func customizableBackBarButtonItem(_ target: Any?, action: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: target, action: action)
    }
}
