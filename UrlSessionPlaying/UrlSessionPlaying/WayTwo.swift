//
//  WayTwo.swift
//  UrlSessionPlaying
//
//  Created by denis on 17.07.2022.
//

import Foundation
import RxSwift
import RxCocoa

class WayTwo : SomeWayType {
    private let disposeBag = DisposeBag()
    
    var urls: [URL] = []
    var updateImages: (([UIImage]) -> Void)?
    
    func run() {
        print("WayTwo run")
        //URLSession.shared.rx.response(request: req)
        let session = URLSession(configuration: .default)
        let req1 = URLRequest(url: urls[0])
        let obs1 = getObservableRequest(session: session, request: req1)
        
        let req2 = URLRequest(url: urls[1])
        let obs2 = getObservableRequest(session: session, request: req2)
        
        let req3 = URLRequest(url: urls[2])
        let obs3 = getObservableRequest(session: session, request: req3)
        
        Single.zip(obs1, obs2, obs3)
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
    }
    
    private func getObservableRequest(session: URLSession, request: URLRequest) -> Single<Data> {
        session.rx.response(request: request)
            .map { (response: HTTPURLResponse, data: Data) -> Data in
                guard (200...299).contains(response.statusCode) else {
                    throw NetworkError.invalidResponse(statusCode: response.statusCode)
                }
                return data
            }
            .asSingle()
    }
    
    //MARK: inner classes
    enum NetworkError: Error {
        case invalidResponse(statusCode: Int)
    }
    
    
}
