//
//  WayOne.swift
//  UrlSessionPlaying
//
//  Created by denis on 16.07.2022.
//

import Foundation
import RxSwift

class WayOne : SomeWayType {
    private let disposeBag = DisposeBag()
    
    var updateImages: (([UIImage])->Void)?
    var urls: [URL] = []
    
    func run() {
        print("WayOne run")
        let session = URLSession(configuration: .default)
        let taskObs1 = getDataTaskObservable(session: session, url: urls[0])
        let taskObs2 = getDataTaskObservable(session: session, url: urls[1])
        let taskObs3 = getDataTaskObservable(session: session, url: urls[2])
        
        Single.zip(taskObs1.single, taskObs2.single, taskObs3.single)
            .subscribe { [weak self] (data1, data2, data3) in
                guard let self = self else {
                    return
                }
                print("onSuccess")
                
                var images = [UIImage]()
                let datas = [data1, data2, data3]
                for data in datas {
                    if let img = UIImage(data: data) {
                        images.append(img)
                    }
                }
                DispatchQueue.main.async { [weak self] in
                    self?.updateImages?(images)
                    print("reload table view")
                }
                
            } onFailure: { error in
                print("Error found: \(error.localizedDescription)")
            } onDisposed: {
                print("onDisposed")
            }
            .disposed(by: disposeBag)
        
        
        taskObs1.dataTask.resume()
        taskObs2.dataTask.resume()
        taskObs3.dataTask.resume()
    }
    
    private func getDataTaskObservable(session: URLSession, url: URL) -> DataTaskObservable {
        let subject = PublishSubject<Data>()
        
        let dataTask = session.dataTask(with: url) { data, response, error in
            if let error = error {
                subject.onError(error)
                return
            }
            if let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) == false {
                subject.onError(NetworkError.httpResponseCodeError(code: response.statusCode))
                return
            }
            
            if let data = data {
                subject.onNext(data)
                subject.onCompleted()
            }
        }
        
        let dataTaskWrapper = DataTaskObservable(subject: subject, dataTask: dataTask)
        return dataTaskWrapper
    }
    
    //MARK: inner classes
    enum NetworkError : Error {
        case httpResponseCodeError(code: Int)
    }
    
    struct DataTaskObservable {
        var subject: PublishSubject<Data>
        var dataTask: URLSessionDataTask
        
        var single: Single<Data> {
            subject.asSingle()
        }
    }
    
}
