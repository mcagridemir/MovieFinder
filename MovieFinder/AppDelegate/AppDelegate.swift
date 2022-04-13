//
//  AppDelegate.swift
//  MovieFinder
//
//  Created by Çağrı Demir on 9.04.2022.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseMessaging
import IQKeyboardManagerSwift

// FIREBASE ACCOUNT CREDENTIALS
// email: cagri.case@gmail.com
// password: !Aa12345.

// I did what I should do but unfortunately, I have no Apple Developer account so I could not complete the Push Notification journey.

// 1- After Firebase integration reaching console and importing Google-Service-Info.plist to project etc. and conforming UNUserNotificationCenterDelegate to AppDelegate and adding these methods below in line 41, we should Push Notification as a Capability from main project folder(MovieFinder) Signing & Capabilities from target of project.

// 2- We should register a new key for APN(Apple Push Notification) download p8 certificate from developer.apple.com/account/overview

// 3- After we register a new key and download the p8 certificate, we should upload p8 certificate as APNs auth key and enter Key ID and team ID(all of them are must) in Firebase console project settings of Cloud Messaging part.

// 4- Add FirebaseAppDelegateProxyEnabled key to default Info.plist with 0(false) value.

// 5- In console, click hamburger menu on left and in engage part click Cloud Messaging and New notification. Enter notification title, text and maybe image, select target app, schedule it, set the sound and badge and done! we are all set :)

// I benefited from https://www.raywenderlich.com/20201639-firebase-cloud-messaging-for-ios-push-notifications and https://www.youtube.com/watch?v=Tjg5X30XhMw

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions) { _, _ in }
        application.registerForRemoteNotifications()
        FirebaseManager.shared.setupRemoteConfigDefaults()
        SplashRouter.showSplash()
        IQKeyboardManager.shared.enable = true
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register with push")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Will gets called when app is in foreground and we want to show banner")
        completionHandler([.alert, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Will gets called when user tap on notification")
        completionHandler()
    }
}
