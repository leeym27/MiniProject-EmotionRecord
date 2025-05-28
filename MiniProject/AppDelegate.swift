//
//  AppDelegate.swift
//  MiniProject
//
//  Created by 이용민 on 5/15/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // CalendarViewController 혹은 AppDelegate의 didFinishLaunching에 임시로 추가
        let dummyEntries = [
            MoodEntry(date: "2025.05.01", mood: "🙂", memo: "무난"),
            MoodEntry(date: "2025.05.02", mood: "😢", memo: "조금 슬펐음"),
            MoodEntry(date: "2025.05.03", mood: "😆", memo: "신남"),
            MoodEntry(date: "2025.05.04", mood: "😐", memo: "그저 그럼"),
            MoodEntry(date: "2025.05.05", mood: "😡", memo: "화났음"),
            MoodEntry(date: "2025.05.06", mood: "🙂", memo: "괜찮음"),
            MoodEntry(date: "2025.05.07", mood: "😢", memo: "눈물남"),
            MoodEntry(date: "2025.05.08", mood: "😢", memo: "이별함"),
            MoodEntry(date: "2025.05.09", mood: "😢", memo: "싸웠음"),
            MoodEntry(date: "2025.05.10", mood: "😆", memo: "친구랑 놀았음"),
            MoodEntry(date: "2025.05.11", mood: "😐", memo: "별일 없었음"),
            MoodEntry(date: "2025.05.12", mood: "🙂", memo: "괜찮은 하루"),
            MoodEntry(date: "2025.05.13", mood: "😡", memo: "짜증나는 일 발생"),
            MoodEntry(date: "2025.05.14", mood: "😆", memo: "좋은 소식 들음"),
            MoodEntry(date: "2025.05.15", mood: "😐", memo: "하루종일 공부"),
            MoodEntry(date: "2025.05.16", mood: "🙂", memo: "햇빛이 좋았음"),
            MoodEntry(date: "2025.05.17", mood: "😢", memo: "기분이 가라앉음"),
            MoodEntry(date: "2025.05.18", mood: "😐", memo: "지루했음"),
            MoodEntry(date: "2025.05.19", mood: "😡", memo: "실수로 혼남")
        ]
        UserDefaultsManager.saveEntries(dummyEntries)

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
    


}

