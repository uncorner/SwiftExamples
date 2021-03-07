//
//  ProductError.swift
//  SampleProducts
//
//  Created by denis on 07.03.2021.
//

import Foundation

enum ProductError : Error {
    case invalidUrl(endpoint: String)
}
