//
//  DataTaskWrapper.swift
//  UrlSessionPlaying
//
//  Created by denis on 13.07.2022.
//

import Foundation
import RxSwift

struct DataTaskObservable {
    var subject: PublishSubject<Data>
    var dataTask: URLSessionDataTask
    
    var single: Single<Data> {
        subject.asSingle()
    }
    
    
}
