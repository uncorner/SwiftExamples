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
        
        let manager = Manager()
        manager.run()
    }
    
    /*
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        _ = WebService.productsObservable()
            .flatMapLatest({ (products) -> Observable<Product> in
                return Observable.from(products)
            })
            .flatMap { (product) -> Observable<(Product, DetailedData)> in
                let detailed = WebService.detailedDataObservable(endpoint: product.src)
                let pObs = Observable.just(product)
                return Observable.zip(pObs, detailed)
            }
            .reduce([]) { (acc, currentItem) -> [Product] in
                var copyAcc: [Product] = acc
                var product = currentItem.0
                product.detailedData = currentItem.1
                copyAcc.append(product)
                
                return copyAcc
            }
            .map({ (products) -> [Product] in
                return products.sorted(by: { (p1, p2) -> Bool in
                    guard let d1 = p1.detailedData, let d2 = p2.detailedData else {return false}
                    return d1.price < d2.price
                })
            })
            .subscribe { (products) in
                for product in products {
                    print("\(product.name) | \(product.detailedData?.description ?? "") | \(product.detailedData?.price ?? 0) ")
                }
                
            } onError: { (error) in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
     */
    
    
}

