//
//  PreviewBox.swift
//  ColorCurveGen_iOS
//
//  Created by Zoe Van Brunt on 10/15/21.
//  Copyright © 2021 orgName. All rights reserved.
//

import SwiftUI

struct PreviewBox: View {
    var color: Color
    
    var body: some View {
        VStack(spacing: 64) {
            ZStack {
                Rectangle()
                    .frame(width: 200, height: 100)
            }.background(
                LinearGradient(gradient: Gradient(colors: [Color(.systemGray), Color(.systemGray6)]), startPoint: .top, endPoint: .bottom)
            )
            ZStack {
                Text("Lorem ipsum sum")
                    .foregroundColor(Color(.label))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Color(.systemBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    )
            }
            .padding(.horizontal, 64)
            .padding(.vertical, 16)
            .background(
                Rectangle()
            )
            HStack(spacing: 32.0) {
                Capsule()
                    .frame(width: 8, height: 28)
                Text("A")
                    .font(.title)
                    .fontWeight(.bold)
                Text("A")
                Text("A")
                    .font(.caption)
                Text("A")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(.systemBackground))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8.0)
                    )
                ZStack {
                    Text("A")
                    Text("0").foregroundColor(.clear)
                }
                .font(.caption)
                .padding(.vertical, 3.0)
                .padding(.horizontal, 6.0)
                .foregroundColor(Color(.label))
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color, lineWidth: 2)
                )
            }
        }
        .foregroundColor(color)
        .accentColor(color)
    }
}

struct PreviewBox_Previews: PreviewProvider {
    static var previews: some View {
        PreviewBox(color: .red)
    }
}
