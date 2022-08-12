//
//  Repository.swift
//  MovieBooster
//
//  Created by denis on 12.08.2022.
//

import Foundation
import RxSwift

class DataRepository : Repository {
    private static let textItems: [String] = ["First", "Second", "Alex", "John", "Jack", "Travolta", "Tommy"]
    
    func getListData() -> Single<[String]> {
        Single<[String]>.just(Self.textItems)
    }
    
}
