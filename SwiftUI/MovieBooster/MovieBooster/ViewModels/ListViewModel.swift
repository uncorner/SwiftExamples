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
    @Published var screenData = ScreenData()
    
    private let repository: Repository
    private let disposeBag = DisposeBag()
    private let screenDataSeq = BehaviorRelay(value: ScreenData())
    private let searchTextSeq = BehaviorRelay(value: "")
    private var allDataItems = [String]()
    
    init(repository: Repository) {
        self.repository = repository
        setRepositoryBinding()
        
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
                let items = self.allDataItems.filter { value in
                    value.caseInsensitiveHasPrefix(text)
                }
                self.screenData.items = items
            })
            .disposed(by: disposeBag)
        
    }
    
    private func setRepositoryBinding() {
        self.repository.getListData().subscribe { [weak self] data in
            self?.allDataItems = data
        } onFailure: { error in
            print(error.localizedDescription)
        } onDisposed: {
            print("onDisposed")
        }
        .disposed(by: disposeBag)
    }
    
    func onAppear() {
        screenDataSeq.accept(ScreenData(items: self.allDataItems))
    }
    
    func onChangeSearchText(text: String) {
        print(#function + ": \(text)")
        var copyData = screenData
        copyData.searchText = text
        screenDataSeq.accept(copyData)
        searchTextSeq.accept(text)
    }
    
}
