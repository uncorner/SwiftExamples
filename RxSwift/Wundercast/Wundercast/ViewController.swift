/// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    @IBOutlet private var searchCityName: UITextField!
    @IBOutlet private var tempLabel: UILabel!
    @IBOutlet private var humidityLabel: UILabel!
    @IBOutlet private var iconLabel: UILabel!
    @IBOutlet private var cityNameLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let bag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
//    ApiController.shared.currentWeather(for: "RxSwift")
//        .observeOn(MainScheduler.instance)
//        .subscribe(onNext: { data in
//            self.tempLabel.text = "\(data.temperature)° C"
//            self.iconLabel.text = data.icon
//            self.humidityLabel.text = "\(data.humidity)%"
//            self.cityNameLabel.text = data.cityName
//        })
//        .disposed(by: bag)
    
//    let search = searchCityName.rx.text.orEmpty
//        .filter { !$0.isEmpty }
//        .flatMapLatest { text in
//            ApiController.shared
//                .currentWeather(for: text)
//                .catchErrorJustReturn(.empty)
//        }
//        .share(replay: 1)
//        .observeOn(MainScheduler.instance)
    
    
    let searchInput = searchCityName.rx
        .controlEvent(.editingDidEndOnExit)
        .map { self.searchCityName.text ?? "" }
        .filter { !$0.isEmpty }
    
//    let search = searchCityName.rx
//        .controlEvent(.editingDidEndOnExit)
//        .map { self.searchCityName.text ?? "" }
//        .filter { !$0.isEmpty }
//        .flatMapLatest { text in
//            ApiController.shared
//                .currentWeather(for: text)
//                .catchErrorJustReturn(.empty)
//        }
//        .asDriver(onErrorJustReturn: .empty)
    
    let search = searchInput
        .flatMapLatest { text in
            ApiController.shared
                .currentWeather(for: text)
                .catchErrorJustReturn(.empty)
        }
        .asDriver(onErrorJustReturn: .empty)
    
    let running = Observable.merge(
        searchInput.map { _ in true },
        search.map { _ in false }.asObservable()
    )
    .startWith(true)
    .asDriver(onErrorJustReturn: false)
    
    running
        .skip(1)
        .drive(activityIndicator.rx.isAnimating)
        .disposed(by: bag)
    running
      .drive(tempLabel.rx.isHidden)
      .disposed(by: bag)
    running
      .drive(iconLabel.rx.isHidden)
      .disposed(by: bag)
    running
      .drive(humidityLabel.rx.isHidden)
      .disposed(by: bag)
    running
      .drive(cityNameLabel.rx.isHidden)
      .disposed(by: bag)
    
    search.map { "\($0.temperature)° C" }
        //.bind(to: tempLabel.rx.text)
        .drive(tempLabel.rx.text)
        .disposed(by: bag)

    search.map(\.icon)
        //.bind(to: iconLabel.rx.text)
        .drive(iconLabel.rx.text)
        .disposed(by: bag)

    search.map { "\($0.humidity)%" }
        //.bind(to: humidityLabel.rx.text)
        .drive(humidityLabel.rx.text)
        .disposed(by: bag)

    search.map(\.cityName)
        //.bind(to: cityNameLabel.rx.text)
        .drive(cityNameLabel.rx.text)
        .disposed(by: bag)

    style()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    Appearance.applyBottomLine(to: searchCityName)
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: - Style

  private func style() {
    view.backgroundColor = UIColor.aztec
    searchCityName.attributedPlaceholder = NSAttributedString(string: "City's Name",
                                                              attributes: [.foregroundColor: UIColor.textGrey])
    searchCityName.textColor = UIColor.ufoGreen
    tempLabel.textColor = UIColor.cream
    humidityLabel.textColor = UIColor.cream
    iconLabel.textColor = UIColor.cream
    cityNameLabel.textColor = UIColor.cream
  }
}
