//
//  CurveEditor.swift
//  ColorCurveGen_iOS
//
//  Created by Zoe Van Brunt on 9/28/21.
//  Copyright © 2021 orgName. All rights reserved.
//

import SwiftUI

struct CurveEditor: View {
    
    @StateObject var viewModel: MVIContainer<CurveEditorModelStateProtocol, CurveEditorIntentProtocol>
    
    var body: some View {
        VStack(spacing: 64) {
            VStack {
                TextField("Name", text: $viewModel.model.name)
                    .onSubmit {
                        intent.onNameChanged()
                    }
                    .border(.secondary)
                Spacer()
                PreviewBox(color: state.color)
                NodeSlider(value: state.hue,
                           range: 0.0...359.0,
                           title: "h",
                           numberFormatter: HueFormatter,
                           colors: state.possibleHueColors,
                           onEditingChanged: { intent.onHueChange($0) })
                HStack(spacing: 64) {
                    CurveNavButton(systemName: "chevron.left", enabled: state.previousEnabled, action: intent.onPreviousPressed)
                    CurveNavButton(systemName: "chevron.right", enabled: state.nextEnabled, action: intent.onNextPressed)
                    CurveNavButton(systemName: "trash", enabled: state.deleteEnabled, action: intent.onDeletePressed)
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
            Toggle("Dark Mode", isOn: $viewModel.model.isDark)
        }
        .padding()
        .background(
            Color(.systemBackground)
                .ignoresSafeArea()
        )
        .colorScheme(viewModel.model.isDark ? .dark : .light)
    }
    
    var model: CurveEditorModelStateProtocol { viewModel.model }
    var state: CurveEditorState { viewModel.model.state }
    var intent: CurveEditorIntentProtocol { viewModel.intent }
}

private struct CurveNavButton: View {
    var systemName: String
    var enabled: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .frame(minWidth: 44, minHeight: 44)
        }
        .disabled(!enabled)
    }
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

func DummyCurveEditorViewModel() -> MVIContainer<CurveEditorModelStateProtocol, CurveEditorIntentProtocol> {
    MVIContainer(model: DummyCurveEditorModel(), intent: DummyCurveEditorIntent())
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
    var name: String = "New Curve"
    var isDark: Bool = false
}

struct DummyCurveEditorIntent: CurveEditorIntentProtocol {
    func onHueChange(_ hue: Double) { }
    func onSaturationChange(_ saturation: Double) { }
    func onBrightnessChange(_ brightness: Double) { }
    func onAlphaChange(_ alpha: Double) { }
    func onPreviousPressed() { }
    func onNextPressed() { }
    func onDeletePressed() { }
    func saveNameChange() { }
    func onNameChanged() { }
}
