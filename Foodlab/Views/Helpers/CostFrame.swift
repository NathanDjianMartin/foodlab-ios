import SwiftUI

struct CostFrame: View {
    
    var text: String
    var value: Double
    
    var body: some View {
        HStack {
            Text("\(self.text)")
            Spacer()
            Text("\(self.value.roundTo(2))")
                .bold()
            Text("$")
        }
        .frame(height: 60)
        .padding()
        .background(Color("BackgroundColor"))
        .cornerRadius(10)
        .shadow(radius: 5)
        .overlay(
            RoundedRectangle(cornerRadius: 10).fill(Color.foodlabRed).mask(    // << here !!
                HStack {
                    Rectangle().frame(width: 10)
                    Spacer()
                })
                .allowsHitTesting(false))   // << make click-through
        //.fixedSize()
        
        
        //        HStack {
        //            Text("\(self.text)")
        //                .foregroundColor(.primary)
        //            Text("\(self.value.roundTo(2))")
        //                .foregroundColor(.primary)
        //                .bold()
        //            Text("$")
        //            Spacer()
        //        }
        //        .padding()
        //        .background {
        //            RoundedRectangle(cornerRadius: 5)
        //                .stroke(Color.foodlabRed)
        //                .foregroundColor(Color("BackgroundColor"))
        //
        //        }
        //.shadow(radius: 5)
    }
    
}

struct CostFrame_Previews: PreviewProvider {
    static var previews: some View {
        CostFrame(text: "Charges cost", value: 3)
    }
}
