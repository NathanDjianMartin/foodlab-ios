//
//  StepForm.swift
//  Foodlab
//
//  Created by m1 on 20/02/2022.
//

import SwiftUI

struct StepForm: View {
    
    //TODO: changer par SimpleStepVM
    @ObservedObject var step: SimpleStep
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.isPresented = false
                }) {
                    Text("Cancel")
                }
            }
            .padding()
            
            HStack {
                Text(step.id == nil ? "Step creation" : "Step modification")
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
            .padding()
            
            List {
                TextField("Step title", text: $step.title)
                TextEditor(text: $step.description)
                Stepper(value: $step.duration) {
                    Text(" \(step.duration) minute\(step.duration > 1 ? "s" : "")")
                }
            }
            .listStyle(.plain)
        }
    }
}

struct StepForm_Previews: PreviewProvider {
    static var previews: some View {
        StepForm(step: MockData.step, isPresented: .constant(true))
    }
}
