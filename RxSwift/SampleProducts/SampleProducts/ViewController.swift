//
//  ViewController.swift
//  SampleProducts
//
//  Created by denis on 07.03.2021.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let products = WebService.productsObservable()
            .flatMapLatest({ (products) -> Observable<Product> in
                return Observable.from(products)
            })
            .share()
        
        let details = products
            .flatMap { (product) -> Observable<DetailedData> in
                let detailed = WebService.detailedDataObservable(endpoint: product.src)
                return detailed
            }
        
        Observable.zip(products, details)
            .reduce([]) { (acc, currentItem) -> [(Product, DetailedData)] in
                var copyAcc: [(Product, DetailedData)] = acc
                copyAcc.append(currentItem)
                return copyAcc
            }
            .subscribe { (combinedItems) in
                for item in combinedItems {
                    print("\(item.0.name) | \(item.1.description) | \(item.1.price)")
                }
                
            } onError: { (error) in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    //            .flatMap({ (products:[Product]) -> Observable<[Product]> in
    //                return Observable.just(products)
    //            })
    //            .subscribe { (products) in
    //            for p in products {
    //                print("\(p.name); \(p.src)")
    //            }
    
    //        } onError: { (error) in
    //            print(error.localizedDescription)
    //        }
    
    
    
}

