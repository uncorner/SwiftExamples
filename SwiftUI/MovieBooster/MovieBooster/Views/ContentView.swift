//
//  ContentView.swift
//  MovieBooster
//
//  Created by denis on 03.08.2022.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = ListViewModel(repository: DataRepository())
    
    var body: some View {
        List {
            ForEach(viewModel.screenData.items, id: \.self) { str in
                CustomRow(content: str)
            }
        }
        .navigationTitle("Names")
        .searchable(text: $viewModel.screenData.searchText, placement: .navigationBarDrawer(displayMode: .always))
        .onSubmit(of: .search, {
            print("onSubmit: \(viewModel.screenData.searchText)")
        })
        .onChange(of: viewModel.screenData.searchText, perform: viewModel.onChangeSearchText)
        .onAppear(perform: viewModel.onAppear)
        
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
