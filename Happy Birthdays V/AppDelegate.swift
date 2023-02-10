//
//  AppDelegate.swift
//  Birthdays_1
//
//  Created by Артём Синявцев on 06.12.2022.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    // MARK: - Авторизация на разрешение уведомления
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        notificationCenter.requestAuthorization(options: [options]) { (didAllow, error) in
            
            if didAllow {
                print("Alloy")
            } else {
                print("Don's Alloy")
            }
            
        }
        
        // MARK: - напомминание пользователю, чтоб включил уведомление
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                //   Напоминание пользователю о приложении, если он запретил доступ
                
            }
        }
        
        return true
    }
    
    // MARK: - UISceneSession Lifecycle
    
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
    
}

