//
//  ItemListView.swift
//  CoreDataExploration
//
//  Created by Drew Althage on 1/23/23.
//

import SwiftUI

struct ItemListView: View {
    @StateObject var viewModel = ViewModel()
    var body: some View {
        List {
            Section {
                Button("Refresh") {
                    viewModel.refreshItems()
                }
            }
            ForEach(viewModel.results, id: \.id) { item in
                VStack {
                    Text(item.title ?? "-").font(.title3)
                    Text(item.subtitle ?? "-").font(.caption).foregroundColor(.secondary)
                }
            }
        }
    }
}

struct ItemListView_Previews: PreviewProvider {
    static var previews: some View {
        ItemListView()
    }
}
