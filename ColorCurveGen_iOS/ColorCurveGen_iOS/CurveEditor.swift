//
//  CurveEditor.swift
//  ColorCurveGen_iOS
//
//  Created by Zoe Van Brunt on 9/28/21.
//  Copyright © 2021 orgName. All rights reserved.
//

import SwiftUI

struct CurveEditor: View {
    @Binding var hue: Double
    @Binding var saturation: Double
    @Binding var brightness: Double
    @Binding var alpha: Double
    
    @Binding var previousEnabled: Bool
    @Binding var nextEnabled: Bool
    @Binding var deleteEnabled: Bool
    
    @State var darkMode: Bool = false
    
    var colorAtHue: (Double) -> Color
    
    var onHueChange: () -> Void
    var onValueChange: () -> Void
    
    var previousPressed: () -> Void
    var nextPressed: () -> Void
    var deletePressed: () -> Void
    
    private let hueFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.minimumIntegerDigits = 3
        return f
    }()
    
    private let nodeFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.minimumIntegerDigits = 1
        f.maximumIntegerDigits = 1
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        return f
    }()
    
    var body: some View {
        let color = colorAtHue(hue)
        VStack(spacing: 64) {
            VStack {
                Spacer()
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
                hueSlider
                HStack(spacing: 64) {
                    Button(action: previousPressed) {
                        Image(systemName: "chevron.left")
                    }
                    Button(action: previousPressed) {
                        Image(systemName: "chevron.right")
                    }
                    Button(action: previousPressed) {
                        Image(systemName: "trash")
                    }
                }
                nodeSlider(value: $saturation, title: "s") { step in
                    Color(hue: hue/360, saturation: step, brightness: brightness, opacity: alpha)
                }
                nodeSlider(value: $brightness, title: "b") { step in
                    Color(hue: hue/360, saturation: saturation, brightness: step, opacity: alpha)
                }
                nodeSlider(value: $alpha, title: "a") { step in
                    Color(hue: hue/360, saturation: saturation, brightness: brightness, opacity: step)
                }
            }
            Toggle("Dark Mode", isOn: $darkMode)
        }
        .padding()
        .background(
            Color(.systemBackground)
                .ignoresSafeArea()
        )
        .colorScheme(darkMode ? .dark : .light)
    }
    
    var hueSlider: some View {
        nodeSlider(
            value: $hue,
            in: 0.0...359.0,
            title: "h",
            numberFormatter: hueFormatter,
            colorAtStep: { step in
                colorAtHue(step * 360.0)
            }) { hueChanged() }
    }
    
    func nodeSlider(
        value: Binding<Double>,
        in range: ClosedRange<Double> = 0.0...1.0,
        title: String,
        numberFormatter: NumberFormatter? = nil,
        colorAtStep: @escaping (Double) -> Color,
        onEditingChanged: (() -> Void)? = nil)
    -> some View {
        HStack {
            Text(title)
            ClearSlider(
                value: value,
                in: range,
                onEditingChanged: onEditingChanged ?? { valueChanged() }
            )
                .background(
                    ComputedColorStack(count: 32, colorAtStep: colorAtStep)
                        .padding(.horizontal, 4)
                        .frame(height: 8)
                )
            formattedNodeDimension(value: value.wrappedValue, formatter: numberFormatter ?? nodeFormatter)
        }
    }
    
    func formattedNodeDimension(
        value: Double,
        formatter: NumberFormatter)
    -> some View {
        Text("\(formatter.string(from: NSNumber(value: value)) ?? "-")")
            .font(.system(.caption, design: .monospaced))
    }
    
    func hueChanged() { onHueChange() }
    
    func valueChanged() { onValueChange() }
}

struct ComputedColorStack: View {
    let count: Int
    let colorAtStep: (Double) -> Color
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<count) { index in
                colorAtStep(Double(index) * (1.0/Double(count)))
            }
        }
    }
}

struct ClearSlider: UIViewRepresentable {
    
    final class Coordinator: NSObject {
        // The class property value is a binding: It’s a reference to the SwiftUISlider
        // value, which receives a reference to a @State variable value in ContentView.
        var value: Binding<Double>
        var onEditingChanged: () -> Void
        
        // Create the binding when you initialize the Coordinator
        init(value: Binding<Double>, onEditingChanged: @escaping () -> Void) {
            self.value = value
            self.onEditingChanged = onEditingChanged
        }
        
        // Create a valueChanged(_:) action
        @objc func valueChanged(_ sender: UISlider) {
            self.value.wrappedValue = Double(sender.value)
            onEditingChanged()
        }
    }
    
    @Binding var value: Double
    var range: ClosedRange<Double>
    var onEditingChanged: () -> Void
    
    init(value: Binding<Double>, in range: ClosedRange<Double>, onEditingChanged: @escaping () -> Void = { }) {
        self.range = range
        self.onEditingChanged = onEditingChanged
        _value = value
    }
    
    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider(frame: .zero)
        slider.minimumTrackTintColor = .clear
        slider.maximumTrackTintColor = .clear
        slider.minimumValue = Float(range.lowerBound)
        slider.maximumValue = Float(range.upperBound)
        slider.value = Float(value)
        
        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged(_:)),
            for: .valueChanged
        )
        
        return slider
    }
    
    func updateUIView(_ uiView: UISlider, context: Context) {
        // Coordinating data between UIView and SwiftUI view
        uiView.value = Float(self.value)
    }
    
    func makeCoordinator() -> ClearSlider.Coordinator {
        Coordinator(value: $value, onEditingChanged: onEditingChanged)
    }
}

struct CurveEditorPreviewContainer: View {
    @State private(set) var hue: Double = 0.0
    @State var saturation: Double = 1.0
    @State var brightness: Double = 1.0
    @State var alpha: Double = 1.0
    
    var body: some View {
        CurveEditor(
            hue: $hue,
            saturation: $saturation,
            brightness: $brightness,
            alpha: $alpha,
            previousEnabled: .constant(true),
            nextEnabled: .constant(true),
            deleteEnabled: .constant(true),
            colorAtHue: { (hue) -> Color in
                Color(hue: hue/360.0, saturation: saturation, brightness: brightness, opacity: alpha)
            },
            onHueChange: {},
            onValueChange: {},
            previousPressed: {},
            nextPressed: {},
            deletePressed: {})
    }
}

struct CurveEditor_Previews: PreviewProvider {
    static var previews: some View {
        CurveEditorPreviewContainer()
            .previewLayout(.sizeThatFits)
    }
}
