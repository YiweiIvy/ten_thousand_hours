//
//  ten_thousand_hoursApp.swift
//  ten_thousand_hours
//
//  Created by 余懿炜 on 11/16/23.
//

import SwiftUI
import RealmSwift

let realmApp = RealmSwift.App(id: "10000h-ios-dphkm")

@main
struct ten_thousand_hoursApp: SwiftUI.App {
    @StateObject var userSession = UserSession()
    
    var body: some Scene {
        WindowGroup {
            HomePageView()
                .environmentObject(userSession)
        }
    }
}
