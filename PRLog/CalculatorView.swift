//
//  CalculatorView.swift
//  PRLog
//
//  Created by Allen Davis-Swing on 11/27/20.
//

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct InputMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.trailing)
            .keyboardType(.numberPad)
            .lineLimit(1)
        
    }
}

struct CalculatorView: View {
    
    @State var weight: String = ""
    @State var reps: String = ""
    @State var mult: Double = 0
    @State var output: String = "0"

        var body: some View {
            NavigationView{
                Form{
                    Section{
                        TextField("Enter Weight", text: $weight)
                            .modifier(InputMod())
                        
                        TextField("Enter Reps", text: $reps)
                            .modifier(InputMod())
                    }
                    Section{
                        Button(action: {
                            let r = Double(reps) ?? 0.0
                            let w = Double(weight) ?? 0.0
                            self.mult = w * ( 1 + r/30)
                            output = String(format: "%.2f", mult)
                            UIApplication.shared.endEditing()
                        }){
                            HStack{
                                Spacer()
                                Text("So Whats My Max?")
                                    .bold()
                                Spacer()
                            }
                        }
                        HStack{
                            Spacer()
                            Text("Theoretical Max: \(output) lbs for 1 rep")
                            Spacer()
                        }
                    }
                    
                }
                .navigationTitle("1 Rep Max Calculator")
            }
            
        }
}
struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
    }
}
