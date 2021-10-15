//
//  NodeSlider.swift
//  ColorCurveGen_iOS
//
//  Created by Zoe Van Brunt on 10/15/21.
//  Copyright © 2021 orgName. All rights reserved.
//

import SwiftUI

struct NodeSlider: View {
    
    init(
        value: Double,
        range: ClosedRange<Double> = 0.0...1.0,
        title: String,
        numberFormatter: NumberFormatter = DefaultNumberFormatter,
        colors: [Color],
        onEditingChanged: @escaping (Double) -> Void)
    {
        self.value = value
        self.range = range
        self.title = title
        self.numberFormatter = numberFormatter
        self.colors = colors
        self.onEditingChanged = onEditingChanged
    }
    
    let value: Double
    let range: ClosedRange<Double>
    let title: String
    let numberFormatter: NumberFormatter
    let colors: [Color]
    let onEditingChanged: (Double) -> Void
    
    var body: some View {
        HStack {
            Text(title)
            ClearSlider(
                value: value,
                in: range,
                onEditingChanged: onEditingChanged
            )
                .background(
                    ColorStack(colors: colors)
                        .padding(.horizontal, 4)
                        .frame(height: 8)
                )
            Text("\(numberFormatter.string(from: NSNumber(value: value)) ?? "-")")
                .font(.system(.caption, design: .monospaced))
        }
    }
}

struct NodeSliderPreviewContainer: View {
    @State var value: Double = 0.0
    
    var body: some View {
        NodeSlider(value: value, title: "Preview", colors: [.red, .orange, .yellow, .green, .blue, .purple]) { value = $0 }
    }
}

struct NodeSlider_Previews: PreviewProvider {
    static var previews: some View {
        NodeSliderPreviewContainer()
    }
}

private let DefaultNumberFormatter: NumberFormatter = {
    let f = NumberFormatter()
    f.minimumIntegerDigits = 1
    f.maximumIntegerDigits = 1
    f.minimumFractionDigits = 2
    f.maximumFractionDigits = 2
    return f
}()
