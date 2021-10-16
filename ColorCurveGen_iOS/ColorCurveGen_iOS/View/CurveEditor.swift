//
//  CurveEditor.swift
//  ColorCurveGen_iOS
//
//  Created by Zoe Van Brunt on 9/28/21.
//  Copyright © 2021 orgName. All rights reserved.
//

import SwiftUI

struct CurveEditor: View {
    var state: ColorCurveViewModel.State
    
    var onPreviousPressed: () -> ()
    var onNextPressed: () -> ()
    var onDeletePressed: () -> ()
    
    var onHueChange: (Double) -> ()
    var onSaturationChange: (Double) -> ()
    var onBrightnessChange: (Double) -> ()
    var onAlphaChange: (Double) -> ()
    
    @State var darkMode: Bool = false
    
    var body: some View {
        VStack(spacing: 64) {
            VStack {
                Spacer()
                PreviewBox(color: state.color)
                NodeSlider(value: state.hue,
                           range: 0.0...359.0,
                           title: "h",
                           numberFormatter: HueFormatter,
                           colors: state.possibleHueColors,
                           onEditingChanged: { onHueChange($0) })
                HStack(spacing: 64) {
                    Button(action: onPreviousPressed) {
                        Image(systemName: "chevron.left")
                    }
                    .disabled(!state.previousEnabled)
                    
                    Button(action: onNextPressed) {
                        Image(systemName: "chevron.right")
                    }
                    .disabled(!state.nextEnabled)
                    
                    Button(action: onDeletePressed) {
                        Image(systemName: "trash")
                    }
                    .disabled(!state.deleteEnabled)
                }
                
                NodeSlider(value: state.saturation,
                           title: "s",
                           colors: state.possibleSatColors,
                           onEditingChanged: { onSaturationChange($0) })
                NodeSlider(value: state.brightness,
                           title: "b",
                           colors: state.possibleBriColors,
                           onEditingChanged: { onBrightnessChange($0) })
                NodeSlider(value: state.alpha,
                           title: "a",
                           colors: state.possibleAlphaColors,
                           onEditingChanged: { onAlphaChange($0) })
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
}

private let HueFormatter: NumberFormatter = {
    let f = NumberFormatter()
    f.minimumIntegerDigits = 3
    return f
}()

struct CurveEditor_Previews: PreviewProvider {
    static var previews: some View {
        let state = ColorCurveViewModel
            .State(hue: 0.0,
                   saturation: 1.0,
                   brightness: 1.0,
                   alpha: 1.0,
                   previousEnabled: true,
                   nextEnabled: true,
                   deleteEnabled: true,
                   color: .red,
                   possibleHueColors: [.red, .orange, .yellow, .green, .blue, .purple],
                   possibleSatColors: [.red],
                   possibleBriColors: [.red],
                   possibleAlphaColors: [.red])
        CurveEditor(state: state, onPreviousPressed: {}, onNextPressed: {}, onDeletePressed: {}, onHueChange: { _ in }, onSaturationChange: { _ in }, onBrightnessChange: { _ in }, onAlphaChange: { _ in })
    }
}
