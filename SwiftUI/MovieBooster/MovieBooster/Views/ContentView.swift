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
            ForEach(viewModel.dataItems, id: \.self) { str in
                CustomRow(content: str)
            }
        }
        .navigationTitle("Names")
        .onAppear(perform: viewModel.fillData)
        
    }
}

struct CustomRow: View {
    var content: String
    
    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill")
            Text(content)
            Spacer()
        }
        .foregroundColor(content == "John" ? Color.green : Color.primary)
        //.font(.headline)
        .padding([.top, .bottom])
    }
    
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
