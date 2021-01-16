//
//  ContentView.swift
//  PR Log
//
//  Created by Allen Davis-Swing on 11/27/20.
//

import SwiftUI
import CoreData


struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) //NSSortDescriptor(key: "date", ascending: true)
    var entries: FetchedResults<Entry>
    
    var body: some View {
        
        TabView{
            RecordView().tabItem{
                Image(systemName: "book")
                Text("Records")
            }.environment(\.managedObjectContext, viewContext)
            GraphView().tabItem {
                Image(systemName: "chart.bar")
                Text("Progression")
            }
        }
        
        
    }
    
    private func saveContext(){
        do {
            try viewContext.save()
        } catch  {
            let error = error as NSError
            fatalError("Unresolved Error: \(error)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
