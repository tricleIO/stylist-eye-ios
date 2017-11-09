//
//  PrivacyViewController.swift
//  StylistEye
//
//  Created by Michal Severín on 17.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import UIKit
import WebKit

class PrivacyViewController: AbstractViewController {

    // MARK: - Properties
    // MARK: > private
    fileprivate lazy var backButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow_icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backButtonTapped))

    
    fileprivate let coverImageView = ImageView()
    fileprivate let webView = WKWebView()

    // MARK: - <Initializable>
    internal override func addElements() {
        super.addElements()

        view.addSubviews(views:
            [
                coverImageView,
                webView,
            ]
        )
    }

    internal override func initializeElements() {
        super.initializeElements()

        coverImageView.image = #imageLiteral(resourceName: "purpleBg_image")
        navigationItem.leftBarButtonItem = backButton
        
        let request = URLRequest(url: URL(string: "http://stylisteye.com/mprivacy")!)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.load(request)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            let progress = CGFloat(webView.estimatedProgress)
            if progress < 1.0 {
                ProgressHUD.show(progress)
            } else {
                ProgressHUD.dismiss()
            }
        }
    }

    internal override func setupView() {
        super.setupView()

        title = StringContainer[.privacy]
    }

    internal override func setupConstraints() {
        super.setupConstraints()
        
        coverImageView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        webView.snp.makeConstraints { make in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }

    override func customInit() {
    }

    // MARK: - User Action
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
