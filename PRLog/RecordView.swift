//
//  RecordView.swift
//  PRLog
//
//  Created by Allen Davis-Swing on 11/27/20.
//

import SwiftUI

extension String {
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
}

struct RecordView: View {
    
    @State var isShowingAdd: Bool = false
    @State var isShowingEdit: Bool = false
    @State var isShowingCalculator: Bool = false
    @State var editTarget = Entry()
    var exercises = ["Bench Press", "Squat", "Deadlift"]
    var colors = [Color.blue, Color.purple, Color.red]
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Entry.date, ascending: false)]) var entries: FetchedResults<Entry>
    
    var body: some View {
        
        NavigationView{
            List{
                ForEach(entries){ entry in
                    VStack{
                        HStack{
                            Text(exercises[Int(entry.exercise)])
                                .font(.headline)
                                .foregroundColor(colors[Int(entry.exercise)])
                            Spacer()
                        }
                        HStack{
                            Text("\(entry.weight) lbs for \(entry.reps) reps on \(entry.date ?? Date(), formatter: dateFormatter)")
                            Spacer()
                        }
                    }
                    .onTapGesture {
                        //editing
                        editTarget = entry
                        isShowingEdit = true
                    }
                    .sheet(isPresented: $isShowingEdit, content: {
                        EditAddView(editorPointer: $editTarget, isPresented: $isShowingEdit, editing: true)
                    }).padding()
                }
                .onDelete(perform: deleteEntry)
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Records")
            .navigationBarItems(leading: Button("Calculator"){
                self.isShowingCalculator = true
            }, trailing: Button("Add Entry"){
                self.isShowingAdd = true
            })
            .sheet(isPresented: $isShowingCalculator) {
                CalculatorView()
            }
        }
        .sheet(isPresented: $isShowingAdd, content: {
            EditAddView(editorPointer: $editTarget, isPresented: $isShowingAdd, editing: false)
        })
        
    }
    
    private func saveContext(){
        do {
            try viewContext.save()
        } catch  {
            let error = error as NSError
            fatalError("Unresolved Error: \(error)")
        }
    }
    
    private func deleteEntry(offsets: IndexSet){
        withAnimation{
            offsets.map{entries[$0]}.forEach(viewContext.delete)
            saveContext()
        }
    }
    
}



struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView()
    }
}
