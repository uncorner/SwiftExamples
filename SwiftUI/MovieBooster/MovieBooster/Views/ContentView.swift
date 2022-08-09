//
//  ContentView.swift
//  MovieBooster
//
//  Created by denis on 03.08.2022.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = ListViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.data.items, id: \.self) { str in
                CustomRow(content: str)
            }
        }
        .navigationTitle("Names")
        .onAppear(perform: viewModel.fillData)
        
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
