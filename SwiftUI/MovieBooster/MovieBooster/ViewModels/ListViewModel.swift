//
//  MyViewModel.swift
//  MovieBooster
//
//  Created by denis on 08.08.2022.
//


import Foundation
import SwiftUI

class ListViewModel : ObservableObject {
    private let textItems: [String] = ["First", "Second", "Alex", "John", "Travolta"]
        
    @Published var dataItems = [String]()
    
    
    func fillData() {
        dataItems = textItems
    }
    
}
