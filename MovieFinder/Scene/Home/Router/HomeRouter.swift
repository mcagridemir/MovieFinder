//
//  HomeRouter.swift
//  MovieFinder
//
//  Created by Çağrı Demir on 9.04.2022.
//

import UIKit

class HomeRouter {
    class func showDetail(id: String?, nav: UINavigationController?) {
        guard let vc = StoryboardRedirect.Detail.instance.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController else { return }
        nav?.show(vc, sender: nav?.parent)
    }
}
