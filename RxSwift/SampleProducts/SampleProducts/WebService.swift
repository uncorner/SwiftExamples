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
    
    static func request<T: Decodable>(endpoint: String) -> Observable<T> {
        
        do {
            guard let url = URL(string: endpoint) else {
                throw ProductError.invalidUrl(endpoint: endpoint)
            }
            
            let request = URLRequest(url: url)
            
            return URLSession.shared.rx.response(request: request)
                .map { (result: (response: HTTPURLResponse, data: Data)) -> T in
                    let decoder = self.jsonDecoder(contentIdentifier: contentIdentifier)
                    let envelope = try decoder.decode(EOEnvelope<T>.self, from: result.data)
                    return envelope.content
                }
        } catch {
            return Observable.empty()
        }
    }
    
    
}
