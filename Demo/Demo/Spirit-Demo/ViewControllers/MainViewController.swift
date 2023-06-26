//
//  MainViewController.swift
//  SBNavigationController-Demo
//
//  Created by Max on 2023/6/25.
//

import SBNavigationController
import UIKit

class MainViewController: UITableViewController {
    lazy var mainAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()

        appearance.backgroundColor = UIColor.white

        appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 17.0, weight: .bold), .foregroundColor: UIColor.systemIndigo]
        appearance.largeTitleTextAttributes = [.font: UIFont.systemFont(ofSize: 34.0, weight: .bold), .foregroundColor: UIColor.systemIndigo]

        return appearance
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Spirit"

        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.standardAppearance = self.mainAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = self.mainAppearance
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction
    func tapUnwindSegue(_ segue: UIStoryboardSegue) {}
}

extension MainViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tabBarController = UITabBarController()

        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()

        appearance.backgroundColor = UIColor.white

        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 14.0, weight: .regular), .foregroundColor: UIColor.systemIndigo.withAlphaComponent(0.7)]
        itemAppearance.normal.titlePositionAdjustment = .init(horizontal: 0.0, vertical: 2.0)
        itemAppearance.normal.iconColor = UIColor.systemIndigo.withAlphaComponent(0.7)
        itemAppearance.selected.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 14.0, weight: .semibold), .foregroundColor: UIColor.systemIndigo]
        itemAppearance.selected.titlePositionAdjustment = .init(horizontal: 0.0, vertical: 2.0)
        itemAppearance.selected.iconColor = UIColor.systemIndigo

        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance

        tabBarController.tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBarController.tabBar.scrollEdgeAppearance = appearance
        }

        if indexPath.section == 1, indexPath.row == 0 {
            let basicViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BasicViewController")
            basicViewController.tabBarItem = UITabBarItem(title: "Basic", image: UIImage(systemName: "cloud"), selectedImage: UIImage(systemName: "cloud.fill"))

            let basicCollectionViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BasicCollectionViewController")
            basicCollectionViewController.tabBarItem = UITabBarItem(title: "Basic Collection", image: UIImage(systemName: "cloud.bolt"), selectedImage: UIImage(systemName: "cloud.bolt.fill"))

            let basicTableViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BasicTableViewController")
            basicTableViewController.tabBarItem = UITabBarItem(title: "Basic Table", image: UIImage(systemName: "moon.stars"), selectedImage: UIImage(systemName: "moon.stars.fill"))

            let basicBrowserViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BasicBrowserViewController")
            basicBrowserViewController.tabBarItem = UITabBarItem(title: "Basic Browser", image: UIImage(systemName: "sun.haze"), selectedImage: UIImage(systemName: "sun.haze.fill"))

            tabBarController.viewControllers = [
                SBContainerNavigationController(rootViewController: basicViewController),
                SBContainerNavigationController(rootViewController: basicCollectionViewController),
                SBContainerNavigationController(rootViewController: basicTableViewController),
                SBContainerNavigationController(rootViewController: basicBrowserViewController),
            ]

            let navigationController = SBNavigationController(noWrappingRootViewController: tabBarController)

            self.present(navigationController, animated: true, completion: nil)
        } else if indexPath.section == 1, indexPath.row == 1 {
            let basicViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BasicViewController")
            basicViewController.tabBarItem = UITabBarItem(title: "Basic", image: UIImage(systemName: "cloud"), selectedImage: UIImage(systemName: "cloud.fill"))

            let basicCollectionViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BasicCollectionViewController")
            basicCollectionViewController.tabBarItem = UITabBarItem(title: "Basic Collection", image: UIImage(systemName: "cloud.bolt"), selectedImage: UIImage(systemName: "cloud.bolt.fill"))

            let basicTableViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BasicTableViewController")
            basicTableViewController.tabBarItem = UITabBarItem(title: "Basic Table", image: UIImage(systemName: "moon.stars"), selectedImage: UIImage(systemName: "moon.stars.fill"))

            let basicBrowserViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BasicBrowserViewController")
            basicBrowserViewController.tabBarItem = UITabBarItem(title: "Basic Browser", image: UIImage(systemName: "sun.haze"), selectedImage: UIImage(systemName: "sun.haze.fill"))

            tabBarController.viewControllers = [
                SBNavigationController(rootViewController: basicViewController),
                SBNavigationController(rootViewController: basicCollectionViewController),
                SBNavigationController(rootViewController: basicTableViewController),
                SBNavigationController(rootViewController: basicBrowserViewController),
            ]

            self.present(tabBarController, animated: true, completion: nil)
        }
    }
}
