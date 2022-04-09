//
//  Globals.swift
//  MovieFinder
//
//  Created by Çağrı Demir on 9.04.2022.
//

import Foundation
import UIKit

class Globals {
    static let shared = Globals()
    var LanguageCode = LangCode.en.rawValue
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    let BaseWebserviceUrl = "https://\(Bundle.main.infoDictionary?["ApiBase"] as? String ?? "")"
    let apiKey = Bundle.main.infoDictionary?["ApiKey"] as? String ?? ""
    let imageBaseUrl =  "https://\(Bundle.main.infoDictionary?["ImageBaseUrl"] as? String ?? "")"
    let imdbBaseUrl = "https://www.imdb.com/title/"
}

