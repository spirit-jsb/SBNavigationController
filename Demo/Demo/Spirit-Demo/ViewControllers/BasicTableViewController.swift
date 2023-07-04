//
//  BasicTableViewController.swift
//  SBNavigationController-Demo
//
//  Created by Max on 2023/6/25.
//

import SBNavigationController
import UIKit

private let reuseIdentifier = "Cell"

class BasicTableViewController: UITableViewController {
    lazy var basicAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()

        appearance.backgroundColor = UIColor.white

        appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 17.0, weight: .bold), .foregroundColor: UIColor.systemIndigo]

        return appearance
    }()

    private var _cellContentColors: [UIColor] = [.systemTeal, .systemRed, .systemBlue, .systemGray, .systemPink, .systemGreen, .systemOrange, .systemPurple]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Basic Table"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(self.tapRefresh(_:)))

        self.navigationController?.navigationBar.tintColor = UIColor.systemIndigo
        self.navigationController?.navigationBar.standardAppearance = self.basicAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = self.basicAppearance

        // Register cell classes
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc
    private func tapRefresh(_ sender: UIBarButtonItem) {
        self._cellContentColors.shuffled()

        self.tableView.reloadData()
    }
}

extension BasicTableViewController {
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

extension BasicTableViewController: CustomizableBackBarButtonItem {
    func customizableBackBarButtonItem(_ target: Any?, action: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: target, action: action)
    }
}
