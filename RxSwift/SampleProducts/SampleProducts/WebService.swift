//
//  WebService.swift
//  SampleProducts
//
//  Created by denis on 07.03.2021.
//

import Foundation
import RxSwift
import RxCocoa

class WebService {
    
    static private func request<T: Decodable>(endpoint: String) -> Observable<T> {
        
        do {
            guard let url = URL(string: endpoint) else {
                throw ProductError.invalidUrl(endpoint: endpoint)
            }
            
            let request = URLRequest(url: url)
            let decoder = JSONDecoder()
            
            return URLSession.shared.rx.response(request: request)
                .map { (result: (response: HTTPURLResponse, data: Data)) -> T in
                    return try decoder.decode(T.self, from: result.data)
                }
        } catch {
            return Observable.empty()
        }
    }
    
    static func productsObservable() -> Observable<[Product]> {
        return request(endpoint: "https://raw.githubusercontent.com/poetofcode/RxProducts/master/products/products.json")
    }
    
    static func detailedDataObservable(endpoint: String) -> Observable<DetailedData> {
        return request(endpoint: endpoint)
    }
    
    
}
