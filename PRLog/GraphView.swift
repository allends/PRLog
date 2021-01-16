//
//  GraphView.swift
//  PRLog
//
//  Created by Allen Davis-Swing on 11/27/20.
//

import SwiftUI
import SwiftUICharts

struct GraphView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Entry.date, ascending: true)])
    var entriesBench: FetchedResults<Entry>
    let exercises = ["Bench Press", "Squat", "Deadlift"]
    
    var weightVals:[[Double]]{
        var temp: [[Double]] = [[]]
        for _ in exercises {
            temp.append([])
        }
        for entry in entriesBench {
            temp[Int(entry.exercise)].append(Double(entry.weight))
        }
        return temp
    }
    var showChart: [Bool] {
        var temp:[Bool] = []
        for index in 0..<exercises.count {
            if weightVals[index].count > 1 {
                temp.append(true)
            }else{
                temp.append(false)
            }
        }
        return temp
    }
    var noCharts: Bool {
        for index in 0..<showChart.count {
            if showChart[index] == true{
                return false
            }
        }
        return true
    }
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    ForEach (0..<showChart.count, id: \.self){ index in
                        if(showChart[index]){
                            LineChartView(data: weightVals[index], title: "\(exercises[index])", form: ChartForm.extraLarge, dropShadow: false)
                        }
                    }
                }.padding()
                if(noCharts){
                    Text("You need at least 2 Lift Entries for a Graph!")
                        .font(.largeTitle)
                }
            }.navigationTitle("Progress Charts")
            .background(grayBG())
            
        }
    }
}

struct grayBG: View {
    
    var body: some View {
        Color.gray
            .opacity(0.15)
            .ignoresSafeArea(.all)
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView()
    }
}
