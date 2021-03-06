//
//  Product.swift
//  SampleProducts
//
//  Created by denis on 07.03.2021.
//

import Foundation

struct Product: Decodable {
    var name: String
    var src: String
    
    var detailedData: DetailedData?
    
    private enum DecodingKeys: String, CodingKey {
        case name
        case src
    }
}
