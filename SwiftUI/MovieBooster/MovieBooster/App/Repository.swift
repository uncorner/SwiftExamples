//
//  Repository.swift
//  MovieBooster
//
//  Created by denis on 12.08.2022.
//

import Foundation
import RxSwift

protocol Repository {
    
    func getListData() -> Single<[String]>
    
}
