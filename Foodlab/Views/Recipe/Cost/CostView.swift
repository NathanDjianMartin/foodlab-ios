//
//  CostView.swift
//  Foodlab
//
//  Created by m1 on 04/03/2022.
//

import SwiftUI

struct CostView: View {
    
    @ObservedObject var viewModel: CostDataViewModel
    
    var gridItems = [GridItem(.adaptive(minimum: 100))]
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItems,spacing: 0){
                VStack {
                    Text("Material cost")
                    Text("")
                }
            }
        }
    }
}

struct CostView_Previews: PreviewProvider {
    static var previews: some View {
        CostView(viewModel: CostDataViewModel(model: MockData.costData))
    }
}
