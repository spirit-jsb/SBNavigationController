//
//  BasicViewController.swift
//
//  Created by Max on 2023/7/5
//
//  Copyright © 2023 Max. All rights reserved.
//

import SBNavigationController
import UIKit

class BasicViewController: UIViewController {
    lazy var basicAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()

        appearance.backgroundColor = UIColor.systemIndigo

        appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 17.0, weight: .bold), .foregroundColor: UIColor.white]

        return appearance
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Basic"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .plain, target: self, action: #selector(self.tapQuestion(_:)))

        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.standardAppearance = self.basicAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = self.basicAppearance
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc
    private func tapQuestion(_ sender: UIBarButtonItem) {
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        let alertController = UIAlertController(title: "Question", message: nil, preferredStyle: .alert)
        alertController.popoverPresentationController?.barButtonItem = sender
        alertController.popoverPresentationController?.permittedArrowDirections = .any
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
}

extension BasicViewController: CustomizableBackBarButtonItem {
    func customizableBackBarButtonItem(_ target: Any?, action: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: target, action: action)
    }
}
