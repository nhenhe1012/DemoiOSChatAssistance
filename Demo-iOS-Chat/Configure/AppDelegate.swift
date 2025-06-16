//
//  AppDelegate.swift
//  Demo-iOS-Chat
//
//  Created by Tien Nguyen on 16/6/25.
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        configureFirebase()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func configureFirebase() {
        if let options = createFirebaseOptions(from: firebaseConfig) {
            FirebaseApp.configure(options: options)
        }
    }
    
    func createFirebaseOptions(from dict: [String: Any]) -> FirebaseOptions? {
        guard
            let apiKey = dict["apiKey"] as? String,
            let projectID = dict["projectId"] as? String,
            let appID = dict["appId"] as? String,
            let gcmSenderID = dict["gcmSenderId"] as? String
        else {
            print("Missing required Firebase options.")
            return nil
        }

        let options = FirebaseOptions(googleAppID: appID, gcmSenderID: gcmSenderID)
        options.apiKey = apiKey
        options.projectID = projectID
        options.bundleID = Bundle.main.bundleIdentifier ?? ""
        options.storageBucket = dict["storageBucket"] as? String

        return options
    }

}

