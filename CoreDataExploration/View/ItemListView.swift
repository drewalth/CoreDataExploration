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
        NavigationStack {
            List {
                ForEach(viewModel.results, id: \.id) { item in
                    VStack(alignment: .leading) {
                        Text(item.title ?? "-").font(.title3)
                        Text(item.subtitle ?? "-").font(.caption).foregroundColor(.secondary)
                    }
                }.onDelete { value in
                    print(value)
                }
                Section {
                    Button {
                        viewModel.refreshItems()
                    } label: {
                        HStack {
                            Label("", systemImage: "arrow.clockwise").labelStyle(.iconOnly)
                            Text("Refresh")
                        }
                    }.listRowBackground(Color.clear)
                        .buttonStyle(.borderedProminent)
                }
            }.navigationTitle("Items")
                .toolbar {
                    #if os(iOS)
                        ToolbarItem(placement: .navigationBarTrailing) {
                            EditButton()
                        }
                    #endif
                    ToolbarItem {
                        Button(action: viewModel.toggleForm) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }.sheet(isPresented: $viewModel.formVisible) {
                    NavigationStack {
                        Form {
                            TextField("Title", text: $viewModel.newItemTitle)
                            TextField("Subtitle", text: $viewModel.newItemSubtitle)
                        }.navigationTitle("New Item")
                            .toolbar {
                                ToolbarItem(placement: .cancellationAction) {
                                    Button {
                                        viewModel.formVisible = false
                                    } label: {
                                        Text("Cancel")
                                    }
                                }
                                ToolbarItem(placement: .confirmationAction) {
                                    Button {
                                        viewModel.createNewItem()
                                    } label: {
                                        Text("Save")
                                    }.disabled(!viewModel.formValid)
                                }
                            }
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
