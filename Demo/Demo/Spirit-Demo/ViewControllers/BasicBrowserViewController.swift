//
//  BasicBrowserViewController.swift
//
//  Created by Max on 2023/7/5
//
//  Copyright © 2023 Max. All rights reserved.
//

import UIKit
import WebKit

class BasicBrowserViewController: UIViewController {
    lazy var basicAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()

        appearance.backgroundColor = UIColor.white

        appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 17.0, weight: .bold), .foregroundColor: UIColor.systemIndigo]

        return appearance
    }()

    lazy var browserRefreshButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: [.normal, .highlighted])
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .highlighted)

        button.addTarget(self, action: #selector(self.tapBrowserRefresh(_:)), for: .touchUpInside)

        return button
    }()

    lazy var browserActivityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = UIColor.systemIndigo

        return activityIndicatorView
    }()

    lazy var rightBarButtonItemCustomContainerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.browserRefreshButton, self.browserActivityIndicatorView])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill

        return stackView
    }()

    @IBOutlet
    var browserProgressBar: UIProgressView!
    @IBOutlet
    var browserContainerView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(self.tapBack(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.rightBarButtonItemCustomContainerStackView)

        self.navigationController?.navigationBar.tintColor = UIColor.systemIndigo
        self.navigationController?.navigationBar.standardAppearance = self.basicAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = self.basicAppearance

        self.browserProgressBar.transform = self.browserProgressBar.transform.scaledBy(x: 1.0, y: 4.0)

        self.browserContainerView.navigationDelegate = self

        self.browserContainerView.load(URLRequest(url: URL(string: "https://github.com/spirit-jsb/SBNavigationController")!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 15.0))

        self.browserContainerView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
        self.browserContainerView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)

        self.browserRefreshButton.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        self.browserRefreshButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
    }

    deinit {
        if self.browserContainerView != nil {
            self.browserContainerView.removeObserver(self, forKeyPath: #keyPath(WKWebView.title), context: nil)
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        switch object {
            case is WKWebView where (object as! WKWebView) == self.browserContainerView:
                if keyPath == #keyPath(WKWebView.title) {
                    self.navigationItem.title = self.browserContainerView.title
                }
                if keyPath == #keyPath(WKWebView.estimatedProgress) {
                    let newProgress = Float(self.browserContainerView.estimatedProgress)

                    self.browserProgressBar.setProgress(newProgress, animated: newProgress > self.browserProgressBar.progress)
                }
            default:
                super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc
    private func tapBack(_ sender: UIBarButtonItem) {
        if self.browserContainerView.backForwardList.backList.isEmpty {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.browserContainerView.goBack()
        }
    }

    @objc
    private func tapBrowserRefresh(_ sender: UIBarButtonItem) {
        self.browserContainerView.reload()
    }
}

extension BasicBrowserViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.browserRefreshButton.isEnabled = false
        self.browserActivityIndicatorView.startAnimating()

        self.browserProgressBar.alpha = 0.0
        UIView.animate(withDuration: 0.25) {
            self.browserProgressBar.alpha = 1.0
            self.browserProgressBar.isHidden = false
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.browserRefreshButton.isEnabled = true
        self.browserActivityIndicatorView.stopAnimating()

        self.browserProgressBar.alpha = 1.0
        UIView.animate(withDuration: 0.25) {
            self.browserProgressBar.alpha = 0.0
            self.browserProgressBar.isHidden = false
        }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.browserRefreshButton.isEnabled = true
        self.browserActivityIndicatorView.stopAnimating()

        self.browserProgressBar.alpha = 0.0
        UIView.animate(withDuration: 0.25) {
            self.browserProgressBar.alpha = 1.0
            self.browserProgressBar.isHidden = false
        }
    }
}
