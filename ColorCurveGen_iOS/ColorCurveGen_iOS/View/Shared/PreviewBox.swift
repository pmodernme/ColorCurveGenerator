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
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 32) {
            ZStack {
                Rectangle()
                    .frame(width: 200, height: 100)
            }.background(
                LinearGradient(gradient: Gradient(colors: [Color(.systemGray), Color(.systemGray6)]), startPoint: .top, endPoint: .bottom)
            )
            Text(contrastRatio)
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
    
    var contrastRatio: String {
        guard let colorL = color.luminance else {
            return "Unknown Contrast Ratio"
        }
        
        let ratio: CGFloat
        if colorScheme == .light {
            ratio = 1.05 / (colorL + 0.05)
        } else {
            ratio = (colorL + 0.05) / 0.05
        }
        
        return "Contrast Ratio - \(RatioFormatter.string(from: NSNumber(value: ratio)) ?? "?"):1"
    }
}

private let RatioFormatter: NumberFormatter = {
    let f = NumberFormatter()
    f.minimumIntegerDigits = 1
    f.maximumIntegerDigits = 1
    f.minimumFractionDigits = 2
    f.maximumFractionDigits = 2
    return f
}()

struct PreviewBox_Previews: PreviewProvider {
    static var previews: some View {
        PreviewBox(color: .red)
    }
}
