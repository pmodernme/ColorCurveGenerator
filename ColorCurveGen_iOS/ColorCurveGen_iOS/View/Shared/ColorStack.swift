//
//  ColorStack.swift
//  ColorCurveGen_iOS
//
//  Created by Zoe Van Brunt on 10/15/21.
//  Copyright © 2021 orgName. All rights reserved.
//

import SwiftUI

struct ColorStack: View {
    let colors: [Color]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<colors.count) { index in
                colors[index]
            }
        }
    }
}

struct ColorStack_Previews: PreviewProvider {
    static var previews: some View {
        ColorStack(colors: [.red, .orange, .yellow, .green, .blue, .purple])
    }
}
