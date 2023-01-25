//
//  ContentView.swift
//  CoreDataExploration
//
//  Created by Drew Althage on 1/21/23.
//

import CoreData
import SwiftUI

struct ContentView: View {
    var body: some View {
        ItemListView()
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
