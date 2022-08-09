//
//  MyViewModel.swift
//  MovieBooster
//
//  Created by denis on 08.08.2022.
//


import Foundation
import SwiftUI
import RxSwift
import RxRelay

class ListViewModel : ObservableObject {
    private static let textItems: [String] = ["First", "Second", "Alex", "John", "Travolta"]
        
    @Published var data = ScreenData()
    
    private var disposeBag = DisposeBag()
    private let rxData: BehaviorRelay<ScreenData> = BehaviorRelay(value: ScreenData())
    
    init() {
        rxData.subscribe { [weak self] value in
            self?.data = value
        }
        .disposed(by: disposeBag)
    }
    
    func fillData() {
        rxData.accept(ScreenData(items: Self.textItems))
    }
    
}
