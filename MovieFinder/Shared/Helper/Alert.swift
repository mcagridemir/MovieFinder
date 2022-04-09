//
//  Alert.swift
//  MovieFinder
//
//  Created by Çağrı Demir on 9.04.2022.
//

import Foundation
import SwiftMessages
import UIKit

class Alert {
    
    class func success(title: String?, text: String?) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(.success)
        view.configureTheme(backgroundColor: Assets.Colors.MainColors.mainGreen.color, foregroundColor: .white)
        view.button?.isHidden = true
        view.configureDropShadow()
        view.configureContent(title: title ?? "", body: text ?? LocalizationKeys.successful.localized, iconImage: Assets.Assets.Icons.checkmark.image)
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        view.backgroundView.cornerRadius = 10
        SwiftMessages.show(view: view)
    }
    
    class func error(title: String?, text: String?) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(.error)
        view.configureTheme(backgroundColor: Assets.Colors.MainColors.mainRed.color, foregroundColor: .white)
        view.button?.isHidden = true
        view.configureDropShadow()
        view.configureContent(title: title ?? "", body: text ?? LocalizationKeys.error.localized, iconImage: Assets.Assets.Icons.error.image)
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        view.backgroundView.cornerRadius = 10
        SwiftMessages.show(view: view)
    }

    class func warning(title: String?, text: String?) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(.error)
        view.configureTheme(backgroundColor: Assets.Colors.MainColors.darkYellowColor.color, foregroundColor: Assets.Colors.ForegroundColors.warningForegroundColor.color)
        view.button?.isHidden = true
        view.configureDropShadow()
        view.configureContent(title: title ?? "", body: text ?? LocalizationKeys.warning.localized, iconImage: Assets.Assets.Icons.infoWarning.image)
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        view.backgroundView.cornerRadius = 10
        SwiftMessages.show(view: view)
    }
}
