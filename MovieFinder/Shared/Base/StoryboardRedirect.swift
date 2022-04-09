//
//  StoryboardRedirect.swift
//  MovieFinder
//
//  Created by Çağrı Demir on 9.04.2022.
//

import Foundation
import UIKit

enum StoryboardRedirect: String {
    case Splash
    case Home
    case Detail
    
    var instance: UIStoryboard {
      return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
}

