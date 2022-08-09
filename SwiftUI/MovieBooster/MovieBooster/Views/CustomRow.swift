//
//  CustomRow.swift
//  MovieBooster
//
//  Created by denis on 09.08.2022.
//

import SwiftUI

struct CustomRow: View {
    var content: String
    
    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill")
            Text(content)
            Spacer()
        }
        .foregroundColor(content == "John" ? Color.green : Color.primary)
        .padding([.top, .bottom])
    }
    
}
