//
//  SomeWay.swift
//  UrlSessionPlaying
//
//  Created by denis on 17.07.2022.
//

import Foundation
import UIKit

protocol SomeWayType {
    var urls: [URL] {get set}
    var updateImages: (([UIImage])->Void)? { get set }
    func run()
}
