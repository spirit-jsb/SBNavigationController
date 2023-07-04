//
//  DisableInteractivePopViewController.swift
//  SBNavigationController-Demo
//
//  Created by Max on 2023/6/25.
//

import SBNavigationController
import UIKit

class DisableInteractivePopViewController: UITableViewController {
    lazy var disableInteractivePopAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()

        appearance.backgroundColor = UIColor.white

        appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 17.0, weight: .bold), .foregroundColor: UIColor.systemIndigo]
        appearance.largeTitleTextAttributes = [.font: UIFont.systemFont(ofSize: 28.0, weight: .bold), .foregroundColor: UIColor.systemIndigo]

        return appearance
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.sb.disablesInteractivePop = true

        self.navigationItem.title = "Disable Interactive Pop"

        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.tintColor = UIColor.systemIndigo
        self.navigationController?.navigationBar.standardAppearance = self.disableInteractivePopAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = self.disableInteractivePopAppearance
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension DisableInteractivePopViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0, indexPath.row == 0 {
            let basicBrowserViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BasicBrowserViewController")

            self.navigationController?.pushViewController(basicBrowserViewController, animated: true)
        }
    }
}

extension DisableInteractivePopViewController: CustomizableBackBarButtonItem {
    func customizableBackBarButtonItem(_ target: Any?, action: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: target, action: action)
    }
}
