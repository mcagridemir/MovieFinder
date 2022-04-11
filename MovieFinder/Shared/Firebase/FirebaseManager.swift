//
//  FirebaseManager.swift
//  MovieFinder
//
//  Created by Çağrı Demir on 10.04.2022.
//

import Firebase
import FirebaseRemoteConfig

class FirebaseManager {
    static let shared = FirebaseManager()
    private init() {}
    var remoteConfig = RemoteConfig.remoteConfig()
    
    func setupRemoteConfigDefaults() {
        let defaultValue = ["label_text": "Hello :]" as NSObject]
        remoteConfig.setDefaults(defaultValue)
    }
    
    func fetchRemoteConfig(success: @escaping(_ text: String?) -> Void) {
        Loader.show()
        remoteConfig.fetch(withExpirationDuration: 0) { [weak self] (status, error) in
            guard let self = self else { return }
            Loader.hide()
            if status == .success {
                self.remoteConfig.activate()
                let text = self.remoteConfig.configValue(forKey: "label_text").stringValue ?? ""
                success(text)
            } else {
                Alert.error(title: "", text: error.debugDescription)
            }
        }
    }
    
    func trackScreen(viewController: String, params: [String: Any]) {
        Analytics.logEvent(viewController, parameters: params)
    }
}
