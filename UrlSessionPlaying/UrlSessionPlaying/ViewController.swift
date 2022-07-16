//
//  ViewController.swift
//  UrlSessionPlaying
//
//  Created by denis on 11.07.2022.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doRequestButton: UIButton!
        
    private var images: [UIImage] = []
    private lazy var wayOne = getWayOne()
    
    private var urls: [URL] = {
        let url1 = URL(string: "https://kovalut.ru/banklogo/akibank.png?1630431881")!
        let url2 = URL(string: "https://kovalut.ru/banklogo/avtogradbank.png?1630431881")!
        let url3 = URL(string: "https://kovalut.ru/banklogo/aziatsko-tihookeanskij-bank.png?1630431881")!
        return [url1, url2, url3]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // table view delegates
        tableView.dataSource = self
    }

    @IBAction func onDoRequest(_ sender: Any) {
        wayOne.run()
    }
    
    private func getWayOne() -> WayOne {
        let way = WayOne(urls: urls)
        way.updateImages = { [weak self] images in
            self?.images.removeAll()
            self?.images = images
            self?.tableView.reloadData()
        }
        
        return way
    }
    
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath)
                    
        cell.imageView?.image = images[indexPath.item]
        return cell
    }
    
}

