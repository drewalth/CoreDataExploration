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
        @Published var newItemTitle = ""
        @Published var newItemSubtitle = ""

        var formValid: Bool {
            !newItemTitle.isEmpty && !newItemSubtitle.isEmpty
        }

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
                results = try coreDataManager.container.viewContext.fetch(request)
            } catch {
                print(error)
            }
        }

        func createNewItem() {
            let newItem = ItemEntity(context: coreDataManager.container.viewContext)
            newItem.id = UUID()
            newItem.title = newItemTitle
            newItem.subtitle = newItemSubtitle
            NetworkManager.instance.post("/items", input: newItem, output: ItemEntity.self) { result in
                do {
                    _ = try result.get()
                    self.formVisible = false
                    try self.coreDataManager.saveContext()
                    self.loadItems()
                } catch {
                    print(error)
                    self.coreDataManager.container.viewContext.reset()
                }
            }
        }

        func refreshItems() {
            NetworkManager.instance.get("/items", output: [ItemEntity].self) { result in
                do {
                    _ = try result.get()
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
