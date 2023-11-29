//
//  BasicCollectionViewController.swift
//
//  Created by Max on 2023/7/5
//
//  Copyright © 2023 Max. All rights reserved.
//

import SBNavigationController
import UIKit

private let reuseIdentifier = "Cell"

class BasicCollectionViewController: UICollectionViewController {
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

        self.navigationItem.title = "Basic Collection"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(self.tapRefresh(_:)))

        self.navigationController?.navigationBar.tintColor = UIColor.systemIndigo
        self.navigationController?.navigationBar.standardAppearance = self.basicAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = self.basicAppearance

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc
    private func tapRefresh(_ sender: UIBarButtonItem) {
        self._cellContentColors.shuffled()

        self.collectionView.reloadData()
    }
}

extension BasicCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self._cellContentColors.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.contentView.backgroundColor = self._cellContentColors[indexPath.item]

        return cell
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
}

extension BasicCollectionViewController: CustomizableBackBarButtonItem {
    func customizableBackBarButtonItem(_ target: Any?, action: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: target, action: action)
    }
}

extension Array {
    func shuffling() -> Self {
        var results = self

        results.shuffled()

        return results
    }

    mutating func shuffled() {
        for i in 1 ..< self.count {
            self.swapAt(i, Int(arc4random_uniform(UInt32(i + 1))))
        }
    }
}
