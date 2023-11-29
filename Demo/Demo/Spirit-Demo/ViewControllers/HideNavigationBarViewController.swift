//
//  HideNavigationBarViewController.swift
//
//  Created by Max on 2023/7/5
//
//  Copyright © 2023 Max. All rights reserved.
//

import SBNavigationController
import UIKit

class HideNavigationBarViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }

    @IBAction
    func tapPopViewController(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction
    func tapPushToBasicTableViewController(_ sender: UIButton) {
        let basicTableViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BasicTableViewController")

        self.navigationController?.pushViewController(basicTableViewController, animated: true)
    }
}
