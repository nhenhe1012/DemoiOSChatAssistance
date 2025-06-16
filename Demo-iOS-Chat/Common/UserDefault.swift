//
//  UserDefault.swift
//  Demo-iOS-Chat
//
//  Created by Tien Nguyen on 17/6/25.
//

import Foundation

class UserDefaultManager {
    static let shared = UserDefaultManager()
    
    private let userDefaults = UserDefaults.standard
    private let appSecretKey = "appSecret"
    
    private init() {}
    
    // Currently this is AppSession.
    func getAppSecret() -> String? {
        return userDefaults.string(forKey: appSecretKey)
    }
    
    func removeAppSecret() {
        userDefaults.removeObject(forKey: appSecretKey)
    }
    
    func createAppSecret(_ appSecret: String) {
        userDefaults.set(appSecret, forKey: appSecretKey)
    }
    
    func renewAppSecret(_ appSecret: String) {
        createAppSecret(appSecret)
    }
}
