//
//  BaseViewController.swift
//  MovieFinder
//
//  Created by Çağrı Demir on 9.04.2022.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    lazy var hideNavbar = false
    var callbackBackButton: Callback?
    var callbackCloseButton: Callback?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(hideNavbar, animated: false)
    }
    
    func setHeaderOnlyTitle(title: String) {
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .black
        let titleLabel = UILabel()
        titleLabel.text = title.uppercased()
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = .black
        self.navigationItem.titleView = titleLabel
    }
    
    func setHeaderNativeBackTitleWhite(title: String) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.itemWith(colorfulImage: Assets.Assets.Icons.backArrow.image, target: self, action: #selector(btnBackClicked))
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        let titleLabel = UILabel()
        titleLabel.text = title.uppercased()
        titleLabel.textColor = Assets.Colors.ForegroundColors._2B2D42.color
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        self.navigationItem.titleView = titleLabel
    }
    
    @objc func btnBackClicked() {
        self.navigationController?.popViewController(animated: true)
        self.callbackBackButton?()
    }
    
    func onReturn(callback: Callback?) {
        self.callbackBackButton = callback
    }
    
    func onClose(callback: Callback?) {
        self.callbackCloseButton = callback
    }
}

