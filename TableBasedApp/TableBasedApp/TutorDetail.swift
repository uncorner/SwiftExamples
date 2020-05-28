//
//  TutorDetail.swift
//  TableBasedApp
//
//  Created by denis on 14.03.2020.
//  Copyright © 2020 denis. All rights reserved.
//

import SwiftUI

struct TutorDetail: View {
    var name: String
    var headline: String
    var bio: String
    
    var body: some View {
        VStack {
            Image(name)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color.orange, lineWidth: 4)
            )
            .shadow(radius: 10)
            
            Text(name).font(.title)
            
            Text(headline).font(.subheadline)
            Divider()
            
            Text(bio).font(.headline)
            .multilineTextAlignment(.center)
            .lineLimit(50)
            }.padding().navigationBarTitle(Text(name), displayMode: .inline)
        
    }
}

#if DEBUG
struct TutorDetail_Previews: PreviewProvider {
    static var previews: some View {
        TutorDetail(name: "Simon Ng", headline: "Founder of AppCoda", bio: "Founder of AppCoda. Author of multiple iOS programming books including Beginning iOS 12 Programming with Swift and Intermediate iOS 12 Programming with Swift. iOS Developer and Blogger.")
    }
}
#endif
