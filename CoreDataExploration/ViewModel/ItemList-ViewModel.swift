//
//  ItemList-ViewModel.swift
//  CoreDataExploration
//
//  Created by Drew Althage on 1/23/23.
//

import CoreData
import Foundation
import SwiftUI

extension ItemListView {
    @MainActor class ViewModel: ObservableObject {
        private let coreDataManager = PersistenceController.shared

        @AppStorage("initial-load") var initialLoad = true
        @Published var results: [ItemEntity] = []
        @Published var formVisible = false

        init() {
            getInitialData()
            loadItems()
        }

        func toggleForm() {
            formVisible.toggle()
        }

        func loadItems() {
            let request = NSFetchRequest<ItemEntity>(entityName: "ItemEntity")
            do {
                let result = try coreDataManager.container.viewContext.fetch(request)
                print(result)
                results = result
            } catch {
                print(error)
            }
        }

        func createNewItem(title _: String, subtitle _: String) {}

        func refreshItems() {
            NetworkManager.instance.get("/items", output: [ItemEntity].self) { result in
                do {
                    let value = try result.get()
                    print(value)
                    try self.coreDataManager.saveContext()
                    self.initialLoad = false
                    self.loadItems()
                } catch {
                    print(error)
                }
            }
        }

        private func getInitialData() {
            if !initialLoad { return }
            refreshItems()
        }
    }
}
