//
//  GradientNavigationBarViewController.swift
//  SBNavigationController-Demo
//
//  Created by Max on 2023/6/25.
//

import SBNavigationController
import UIKit

private let reuseIdentifier = "Cell"

class GradientNavigationBarViewController: UITableViewController {
    lazy var gradientNavigationBarAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()

        appearance.backgroundColor = UIColor.clear

        appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 17.0, weight: .bold), .foregroundColor: UIColor.systemIndigo]

        return appearance
    }()

    private var _cellContentColors: [UIColor] = [.systemTeal, .systemRed, .systemBlue, .systemGray, .systemPink, .systemGreen, .systemOrange, .systemPurple]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Gradient Navigation Bar"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .plain, target: self, action: #selector(self.tapQuestion(_:)))

        self.navigationController?.navigationBar.tintColor = UIColor.systemIndigo
        self.navigationController?.navigationBar.standardAppearance = self.gradientNavigationBarAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = self.gradientNavigationBarAppearance

        // Register cell classes
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
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

    @IBAction
    func tapPushToBasicCollectionViewController(_ sender: UITapGestureRecognizer) {
        let basicCollectionViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BasicCollectionViewController")

        self.navigationController?.pushViewController(basicCollectionViewController, animated: true)
    }
}

extension GradientNavigationBarViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self._cellContentColors.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.contentView.backgroundColor = self._cellContentColors[indexPath.row]

        return cell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section-\(section)"
    }
}

extension GradientNavigationBarViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y / 288.0

        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()

        appearance.backgroundColor = UIColor.systemIndigo.withAlphaComponent(offset > 1.0 ? 1.0 : offset < 0.0 ? 0.0 : offset)

        appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 17.0, weight: .bold), .foregroundColor: UIColor(hue: 253.0 / 360.0, saturation: (1.0 - (offset > 1.0 ? 1.0 : offset < 0.0 ? 0.0 : offset)) * 0.79, brightness: 1.0, alpha: 1.0)]

        self.navigationController?.navigationBar.tintColor = UIColor(hue: 253.0 / 360.0, saturation: (1.0 - (offset > 1.0 ? 1.0 : offset < 0.0 ? 0.0 : offset)) * 0.79, brightness: 1.0, alpha: 1.0)
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}

extension GradientNavigationBarViewController: CustomizableBackBarButtonItem {
    func customizableBackBarButtonItem(_ target: Any?, action: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: target, action: action)
    }
}
