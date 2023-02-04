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
        private let repo = CoreDataRepository<ItemEntity>(context: PersistenceController.shared.container.viewContext)

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
        }

        func toggleForm() {
            formVisible.toggle()
        }

        func loadItems() {
            do {
                results.removeAll()
                results = try repo.fetch().get()
            } catch {
                print(error)
            }
        }

        func createNewItem() {
            let result = repo.create { item in
                item.id = UUID()
                item.title = self.newItemTitle
                item.subtitle = self.newItemSubtitle
            }

            do {
                let newItem = try result.get()
                NetworkManager.instance.post("/items", input: newItem, output: NetworkManager.ResponseMessage.self) { result in
                    do {
                        _ = try result.get()
                        self.formVisible = false
                        self.loadItems()
                    } catch {
                        print(error)
                    }
                }
            } catch {
                print(error)
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

        func delete(at offsets: IndexSet) {
            guard let index = offsets.first
            else { return }
            let el = results[index]
            let result = repo.delete(el)
            switch result {
            case .success:
                loadItems()
            case let .failure(error):
                print(error)
            }
        }

        private func getInitialData() {
            if !initialLoad { return }
            refreshItems()
        }
    }
}
