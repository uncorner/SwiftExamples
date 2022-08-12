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
    // todo: move to repository
    private static let textItems: [String] = ["First", "Second", "Alex", "John", "Travolta", "Tommy"]
    
    @Published var screenData = ScreenData()
    
    private let disposeBag = DisposeBag()
    private let screenDataSeq = BehaviorRelay(value: ScreenData())
    private let searchTextSeq = BehaviorRelay(value: "")
    
    init() {
        screenDataSeq.subscribe { [weak self] value in
            self?.screenData = value
        }
        .disposed(by: disposeBag)
        
        searchTextSeq
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map({ queryText in
                queryText.trimming()
            })
            .subscribe(onNext: { [weak self] text in
                guard let self = self else {return}
                let items = Self.textItems.filter { value in
                    value.caseInsensitiveHasPrefix(text)
                }
                self.screenData.items = items
            })
            .disposed(by: disposeBag)
        
    }
    
    func onAppear() {
        screenDataSeq.accept(ScreenData(items: Self.textItems))
    }
    
    func onChangeSearchText(text: String) {
        print(#function + ": \(text)")
        var copyData = copyScreenData()
        copyData.searchText = text
        screenDataSeq.accept(copyData)
        searchTextSeq.accept(text)
    }
    
    private func copyScreenData() -> ScreenData {
        screenData
    }
    
}
