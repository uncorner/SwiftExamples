//
//  ContentView.swift
//  MovieBooster
//
//  Created by denis on 03.08.2022.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = ListViewModel()
    //@State var searchQuery = ""
    
    var body: some View {
        List {
            ForEach(viewModel.data.items, id: \.self) { str in
                CustomRow(content: str)
            }
        }
        .navigationTitle("Names")
        .searchable(text: $viewModel.searchQuery, placement: .navigationBarDrawer(displayMode: .always))
        .onSubmit(of: .search, {
            print("onSubmit: \(viewModel.searchQuery)")
        })
        .onChange(of: viewModel.searchQuery, perform: { newValue in
            print("onChange: \(newValue)")
        })
        .onAppear(perform: viewModel.fillData)
        
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
