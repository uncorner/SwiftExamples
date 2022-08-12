//
//  StringExtension.swift
//  MovieBooster
//
//  Created by denis on 12.08.2022.
//

import Foundation

extension String {
    func caseInsensitiveHasPrefix(_ prefix: String) -> Bool {
        return lowercased().hasPrefix(prefix.lowercased())
    }
    
    func isEmptyOrWhitespace() -> Bool {
        if self.isEmpty {
            return true
        }
        return (self.trimmingCharacters(in: NSCharacterSet.whitespaces) == "")
    }
    
    func trimming() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}
