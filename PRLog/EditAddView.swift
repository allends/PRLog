//
//  EditAddView.swift
//  PRLog
//
//  Created by Allen Davis-Swing on 11/27/20.
//

import SwiftUI

struct EditAddView: View {
    
    @State var dateSelected: Date = Date()
    @State var weightSelected: String = ""
    @State var repsSelected: String = ""
    @State var exerciseSelected: Int = 1
    @State var showingAlert = false
    @Binding  var editorPointer: FetchedResults<Entry>.Element
    @Binding var isPresented: Bool
    var exercises = ["Bench Press", "Squat", "Deadlift"]
    var colors = [Color.blue, Color.purple, Color.red]
    var editing: Bool
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Entry.date, ascending: false)])
    var entries: FetchedResults<Entry>
    
    var body: some View {
        NavigationView{
            Form{
                Picker(selection: $exerciseSelected, label: Text("Choose Exercise")){
                    ForEach(0..<exercises.count){ index in
                        Text(self.exercises[index])
                    }
                }
                TextField("Enter Weight Lifted", text: $weightSelected)
                    .multilineTextAlignment(.trailing)
                    .lineLimit(1)
                    .keyboardType(.numberPad)
                TextField("Enter Reps Perfromed", text: $repsSelected)
                    .multilineTextAlignment(.trailing)
                    .lineLimit(1)
                    .keyboardType(.numberPad)
                DatePicker(selection: $dateSelected, in: ...Date(), displayedComponents: .date){
                    Text("Done on")
                }
                HStack{
                    Spacer()
                    Button("\(editing ? "Save" : "Add") Lift"){
                        
                        if weightSelected.isNumeric && repsSelected.isNumeric {
                            
                            if editing {
                                editEntry()
                            } else {
                                addEntry()
                            }
                            isPresented = false
                        } else {
                            showingAlert = true
                        }
                        
                        
                    }.alert(isPresented: $showingAlert){
                        Alert(title: Text("Invalid"), message: Text("Enter some actual data please"), dismissButton: .default(Text("Yessir!")))
                    }
                }
            }
            .navigationTitle(editing ? "Edit" : "Add")
        }.onAppear(perform: setup)
    }
    
    private func setup(){
        if editing {
            weightSelected = String(editorPointer.weight)
            repsSelected = String(editorPointer.reps)
            exerciseSelected = Int(editorPointer.exercise)
            dateSelected = editorPointer.date ?? Date()
        } else {
            weightSelected = ""
            repsSelected = ""
            exerciseSelected = 0
            dateSelected = Date()
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
    
    private func deleteEntry(offsets: IndexSet){
        withAnimation{
            offsets.map{entries[$0]}.forEach(viewContext.delete)
            saveContext()
        }
    }
    
    private func editEntry(){
        withAnimation{
            editorPointer.weight = Int16(weightSelected) ?? 0
            editorPointer.reps = Int16(repsSelected) ?? 0
            editorPointer.exercise = Int16(exerciseSelected) ?? 0
            editorPointer.date = dateSelected
            saveContext()
            clearText()
        }
    }
    
    private func addEntry(){
        withAnimation{
            let temp = Entry(context: viewContext)
            temp.weight = Int16(weightSelected) ?? 0
            temp.exercise = Int16(exerciseSelected) ?? 0
            temp.reps = Int16(repsSelected) ?? 0
            temp.date = dateSelected
            saveContext()
            clearText()
        }
    }
    
    private func clearText(){
        self.dateSelected = Date()
        self.weightSelected = ""
        self.repsSelected = ""
    }
    
}
