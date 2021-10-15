//
//  CurveEditor.swift
//  ColorCurveGen_iOS
//
//  Created by Zoe Van Brunt on 9/28/21.
//  Copyright © 2021 orgName. All rights reserved.
//

import SwiftUI

struct CurveEditor: View {
    @StateObject private var viewModel = ColorCurveViewModel()
    @State var darkMode: Bool = false
    
    var body: some View {
        VStack(spacing: 64) {
            VStack {
                Spacer()
                PreviewBox(color: viewModel.state.color)
                NodeSlider(value: viewModel.state.hue,
                           range: 0.0...359.0,
                           title: "h",
                           numberFormatter: HueFormatter,
                           colors: viewModel.state.possibleHueColors,
                           onEditingChanged: { viewModel.onHueChange($0) })
                HStack(spacing: 64) {
                    Button(action: viewModel.onPreviousPressed) {
                        Image(systemName: "chevron.left")
                    }
                    .disabled(!viewModel.state.previousEnabled)
                    
                    Button(action: viewModel.onNextPressed) {
                        Image(systemName: "chevron.right")
                    }
                    .disabled(!viewModel.state.nextEnabled)
                    
                    Button(action: viewModel.onDeletePressed) {
                        Image(systemName: "trash")
                    }
                    .disabled(!viewModel.state.deleteEnabled)
                }
                
                NodeSlider(value: viewModel.state.saturation,
                           title: "s",
                           colors: viewModel.state.possibleSatColors,
                           onEditingChanged: { viewModel.onSaturationChange($0) })
                NodeSlider(value: viewModel.state.brightness,
                           title: "b",
                           colors: viewModel.state.possibleBriColors,
                           onEditingChanged: { viewModel.onBrightnessChange($0) })
                NodeSlider(value: viewModel.state.alpha,
                           title: "a",
                           colors: viewModel.state.possibleAlphaColors,
                           onEditingChanged: { viewModel.onAlphaChange($0) })
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

struct CurveEditorPreviewContainer: View {
    var body: some View {
        CurveEditor()
    }
}

struct CurveEditor_Previews: PreviewProvider {
    static var previews: some View {
        CurveEditorPreviewContainer()
            .previewLayout(.sizeThatFits)
    }
}
