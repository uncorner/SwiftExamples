//
//  ViewController.swift
//  UrlSessionPlaying
//
//  Created by denis on 11.07.2022.
//

import UIKit
import RxSwift


enum NetworkError : Error {
    case httpResponseCodeError(code: Int)
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doRequestButton: UIButton!
    var disposeBag = DisposeBag()
    
    private var images: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // table view delegates
        tableView.dataSource = self
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

    @IBAction func onDoRequest(_ sender: Any) {
        images.removeAll()
        
        let session = URLSession(configuration: .default)
        let url1 = URL(string: "https://kovalut.ru/banklogo/akibank.png?1630431881")!
        let taskObs1 = getDataTaskObservable(session: session, url: url1)
        
        let url2 = URL(string: "https://kovalut.ru/banklogo/avtogradbank.png?1630431881")!
        let taskObs2 = getDataTaskObservable(session: session, url: url2)
        
        let url3 = URL(string: "https://kovalut.ru/banklogo/aziatsko-tihookeanskij-bank.png?1630431881")!
        let taskObs3 = getDataTaskObservable(session: session, url: url3)
        
        Single.zip(taskObs1.single, taskObs2.single, taskObs3.single)
            .subscribe { [weak self] (data1, data2, data3) in
                guard let self = self else {
                    return
                }
                print("onSuccess")
                
                let datas = [data1, data2, data3]
                DispatchQueue.main.async {
                    for data in datas {
                        if let img = UIImage(data: data) {
                            self.images.append(img)
                        }
                    }
                    self.tableView.reloadData()
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

