//
//  ContentView.swift
//  SwiftUIFirstView
//
//  Created by denis on 02.03.2020.
//  Copyright © 2020 denis. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var tapCount = 0
    //let a = 1
    
    var body: some View {
        VStack {
            HStack {
                Text("Привет!")
                    .foregroundColor(Color.red)
                Text("Хабр!")
                    .foregroundColor(Color.green)
            }
            Button(action: {
                self.tapCount += 1
            })
            {
            Text("Tap count \(tapCount)").font(.title)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
