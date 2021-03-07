//
//  ViewController.swift
//  SampleProducts
//
//  Created by denis on 07.03.2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        _ = WebService.products().subscribe { (products) in
            for p in products {
                print("\(p.name)")
            }
            
        } onError: { (error) in
            print(error.localizedDescription)
        }

        
        
    }


}

