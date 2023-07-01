//
//  ItemDetailView.swift
//  CoreDataExploration
//
//  Created by Andrew Althage on 2/4/23.
//

import SwiftUI

struct ItemDetailView: View {
    private let repo = CoreDataRepository<ItemEntity>(context: PersistenceController.shared.container.viewContext)
    private let network = NetworkManager()
    var item: ItemEntity

    @State var requestStatus: RequestStatus = .success

    init(item: ItemEntity) {
        self.item = item
    }

    func fetchRemote() {
        guard let itemId = item.id else { return }

        let url = "/items?id=\(itemId)"
        requestStatus = .loading
        network.get(url, output: ItemEntity.self) { result in
            do {
                let val = try result.get()
                _ = try self.repo.update(val).get()
                self.requestStatus = .success
            } catch {
                print(error)
                self.requestStatus = .failure
            }
        }
    }

    var body: some View {
        VStack {
            Text(item.title ?? "-").font(.title)
            Text(item.subtitle ?? "-").font(.callout)
            switch requestStatus {
            case .loading:
                ProgressView()
            case .success:
                Text("Success")
            case .failure:
                Text("Failed")
            }
        }.navigationTitle(item.title ?? "")
            .onAppear {
                fetchRemote()
            }
    }
}

struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetailView(item: {
            let dummyItem = ItemEntity(context: PersistenceController.preview.container.viewContext)
            dummyItem.title = "Dummy"
            dummyItem.subtitle = "Sub"
            return dummyItem
        }())
    }
}
