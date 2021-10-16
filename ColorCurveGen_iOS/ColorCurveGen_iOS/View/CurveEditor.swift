//
//  CurveEditor.swift
//  ColorCurveGen_iOS
//
//  Created by Zoe Van Brunt on 9/28/21.
//  Copyright © 2021 orgName. All rights reserved.
//

import SwiftUI

struct CurveEditor: View {
    
    @StateObject var viewModel: ColorCurveViewModel
    
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
                           onEditingChanged: { intent.onHueChange($0) })
                HStack(spacing: 64) {
                    Button(action: intent.onPreviousPressed) {
                        Image(systemName: "chevron.left")
                    }
                    .disabled(!state.previousEnabled)
                    
                    Button(action: intent.onNextPressed) {
                        Image(systemName: "chevron.right")
                    }
                    .disabled(!state.nextEnabled)
                    
                    Button(action: intent.onDeletePressed) {
                        Image(systemName: "trash")
                    }
                    .disabled(!state.deleteEnabled)
                }
                
                NodeSlider(value: state.saturation,
                           title: "s",
                           colors: state.possibleSatColors,
                           onEditingChanged: { intent.onSaturationChange($0) })
                NodeSlider(value: state.brightness,
                           title: "b",
                           colors: state.possibleBriColors,
                           onEditingChanged: { intent.onBrightnessChange($0) })
                NodeSlider(value: state.alpha,
                           title: "a",
                           colors: state.possibleAlphaColors,
                           onEditingChanged: { intent.onAlphaChange($0) })
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
    
    var state: CurveEditorState { viewModel.model.state }
    var intent: CurveEditorIntentProtocol { viewModel.intent }
}

private let HueFormatter: NumberFormatter = {
    let f = NumberFormatter()
    f.minimumIntegerDigits = 3
    return f
}()

struct CurveEditor_Previews: PreviewProvider {
    
    static var previews: some View {
        let vm = DummyCurveEditorViewModel()
        CurveEditor(viewModel: vm)
    }
}

func DummyCurveEditorViewModel() -> ColorCurveViewModel {
    ColorCurveViewModel(intent: DummyCurveEditorIntent(), model: DummyCurveEditorModel())
}

struct DummyCurveEditorModel: CurveEditorModelStateProtocol {
    let state: CurveEditorState = CurveEditorState(
        hue: 0.0,
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
}

struct DummyCurveEditorIntent: CurveEditorIntentProtocol {
    func onHueChange(_ hue: Double) { }
    func onSaturationChange(_ saturation: Double) { }
    func onBrightnessChange(_ brightness: Double) { }
    func onAlphaChange(_ alpha: Double) { }
    func onPreviousPressed() { }
    func onNextPressed() { }
    func onDeletePressed() { }
}
