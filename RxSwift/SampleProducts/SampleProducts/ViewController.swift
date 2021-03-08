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

//    func startDownload() {
//       let eoCategories = EONET.categories
//
//       let downloadedEvents = eoCategories
//         .flatMap { categories in
//           return Observable.from(categories.map { category in
//             EONET.events(forLast: 360, category: category)
//           })
//         }
//         .merge(maxConcurrent: 2)
//
//       let updatedCategories = eoCategories.flatMap { categories in
//         downloadedEvents.scan(categories) { updated, events in
//           return updated.map { category in
//             let eventsForCategory = EONET.filteredEvents(events: events, forCategory: category)
//             if !eventsForCategory.isEmpty {
//               var cat = category
//               cat.events = cat.events + eventsForCategory
//               return cat
//             }
//             return category
//           }
//         }
//       }
//
//       // сначала появляются категории с пустыми ивентами, потом просиходит обновление на категории с заполненными ивентами
//       eoCategories
//         .concat(updatedCategories)
//         .bind(to: categories)
//         .disposed(by: disposeBag)
//     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let products = WebService.productsObservable()
            .flatMapLatest({ (products) -> Observable<Product> in
                return Observable.from(products)
            })
            .share()
        
        let details = products
//            WebService.products()
//            .flatMap({ (products) -> Observable<Product> in
//                return Observable.from(products)
//            })
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
            .subscribe { (items) in
                for item in items {
                    print("\(item.0.name) | \(item.1.description) | \(item.1.price)")
                }

            } onError: { (error) in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
            
            
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


}

