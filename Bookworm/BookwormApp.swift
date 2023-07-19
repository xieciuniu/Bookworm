//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Hubert Wojtowicz on 19/07/2023.
//

import SwiftUI

@main
struct BookwormApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
//            Adding connection with CoreData to whole app
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
