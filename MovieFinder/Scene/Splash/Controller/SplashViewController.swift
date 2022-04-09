//
//  SplashViewController.swift
//  MovieFinder
//
//  Created by Çağrı Demir on 9.04.2022.
//

import UIKit

class SplashViewController: UIViewController {
    @IBOutlet weak var splashLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkInternetConnection {
            setSplashLabelText()
        }
    }
    
    private func checkInternetConnection(success: () -> Void) {
        if ServiceConnector.shared.isConnectedToInternet {
            success()
        } else {
            Alert.error(title: "", text: LocalizationKeys.connectionError.localized)
        }
    }
    
    private func setSplashLabelText() {
        FirebaseManager.shared.fetchRemoteConfig { [weak self] text in
            guard let self = self else { return }
            self.splashLabel.text = text
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                SplashRouter.showHomepage(nav: self.navigationController)
            }
        }
    }
}
