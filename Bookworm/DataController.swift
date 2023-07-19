//
//  DataController.swift
//  Bookworm
//
//  Created by Hubert Wojtowicz on 19/07/2023.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    // reference to CoreData class
    let container = NSPersistentContainer(name: "Bookworm")
    
    init(){
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
