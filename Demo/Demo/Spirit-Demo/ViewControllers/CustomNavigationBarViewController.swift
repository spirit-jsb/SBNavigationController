//
//  CustomNavigationBarViewController.swift
//  SBNavigationController-Demo
//
//  Created by Max on 2023/6/25.
//

import SBNavigationController
import UIKit

class CustomNavigationBar: UINavigationBar {
    override func draw(_ rect: CGRect) {
        UIColor.white.setFill()
        UIColor.systemIndigo.setStroke()

        let path = UIBezierPath(rect: rect)
        path.lineWidth = 4.0
        path.fill()
        path.stroke()
    }
}

class CustomNavigationBarViewController: UITableViewController {
    lazy var customNavigationBarAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()

        appearance.backgroundColor = UIColor.white

        appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 17.0, weight: .bold), .foregroundColor: UIColor.systemIndigo]

        return appearance
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Custom Navigation Bar"

        self.navigationController?.navigationBar.tintColor = UIColor.systemIndigo
        self.navigationController?.navigationBar.standardAppearance = self.customNavigationBarAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = self.customNavigationBarAppearance
    }

    override var navigationBarClass: AnyClass? {
        return CustomNavigationBar.self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension CustomNavigationBarViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0, indexPath.row == 0 {
            let basicViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BasicViewController")

            self.navigationController?.pushViewController(basicViewController, animated: true)
        }
    }
}

extension CustomNavigationBarViewController {
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let velocityPoint = scrollView.panGestureRecognizer.velocity(in: scrollView)

        if velocityPoint.y > 120.0 {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        } else if velocityPoint.y < -120.0 {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
}
