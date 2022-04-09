//
//  SplashRouter.swift
//  MovieFinder
//
//  Created by Çağrı Demir on 9.04.2022.
//

import UIKit

class SplashRouter {
    class func showSplash() {
        guard let vc = StoryboardRedirect.Splash.instance.instantiateViewController(withIdentifier: "SplashViewController") as? SplashViewController else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let window = appDelegate.window else { return }
        window.rootViewController = UINavigationController(rootViewController: vc)
        window.makeKeyAndVisible()
    }
}
