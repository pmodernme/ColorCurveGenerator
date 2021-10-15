//
//  ClearSlider.swift
//  ColorCurveGen_iOS
//
//  Created by Zoe Van Brunt on 10/15/21.
//  Copyright © 2021 orgName. All rights reserved.
//

import SwiftUI

struct ClearSlider: UIViewRepresentable {
    
    final class Coordinator: NSObject {
        // The class property value is a binding: It’s a reference to the SwiftUISlider
        // value, which receives a reference to a @State variable value in ContentView.
        var value: Double
        var onEditingChanged: (Double) -> Void
        
        // Create the binding when you initialize the Coordinator
        init(value: Double, onEditingChanged: @escaping (Double) -> Void) {
            self.value = value
            self.onEditingChanged = onEditingChanged
        }
        
        // Create a valueChanged(_:) action
        @objc func valueChanged(_ sender: UISlider) {
            let value = Double(sender.value)
            self.value = value
            onEditingChanged(value)
        }
    }
    
    var value: Double
    var range: ClosedRange<Double>
    var onEditingChanged: (Double) -> Void
    
    init(value: Double, in range: ClosedRange<Double>, onEditingChanged: @escaping (Double) -> Void) {
        self.range = range
        self.onEditingChanged = onEditingChanged
        self.value = value
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
        Coordinator(value: value, onEditingChanged: onEditingChanged)
    }
}

struct ClearSliderPreviewContainer: View {
    @State var value: Double = 0.0
    var body: some View {
        ClearSlider(value: value, in: 0...1, onEditingChanged: { value = $0 })
    }
}

struct ClearSlider_Previews: PreviewProvider {
    static var previews: some View {
        ClearSliderPreviewContainer()
    }
}
