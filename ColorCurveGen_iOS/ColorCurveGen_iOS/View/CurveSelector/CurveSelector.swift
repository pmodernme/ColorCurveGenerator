//
//  CurveSelector.swift
//  ColorCurveGen_iOS
//
//  Created by Zoe Van Brunt on 10/15/21.
//  Copyright © 2021 orgName. All rights reserved.
//

import SwiftUI

struct CurveSelector: View {
    
    @StateObject var viewModel: MVIContainer<CurveSelectorModelStateProtocol, CurveSelectorIntentProtocol>
    
    var body: some View {
        NavigationView {
            List(state.data) { item in
                NavigationLink(destination: {
                    let vm = model.editorViewModel(for: item)
                    CurveEditor(viewModel: vm, darkMode: item.isDark)
                }) {
                    CurveSelectorRow(item: item)
                }
            }
            .navigationTitle("Curves")
        }
    }
    
    var state: CurveSelectorState { viewModel.model.state }
    var model: CurveSelectorModelStateProtocol { viewModel.model }
    var intent: CurveSelectorIntentProtocol { viewModel.intent }
}

struct CurveSelectorRow: View {
    var item: CurveSelectorItem
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(item.name)
            ColorStack(colors: item.colors)
                .clipShape(Capsule(style: .circular))
            Spacer()
        }
        .padding()
        .background(
            Color(.systemBackground)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 8, height: 8))))
        .colorScheme(item.isDark ? .dark : .light)
        .padding()
    }
}

struct CurveSelector_Previews: PreviewProvider {
    
    static var previews: some View {
        let vm = DummyCurveSelectorViewModel()
        CurveSelector(viewModel: vm)
    }
}

func DummyCurveSelectorViewModel() -> MVIContainer<CurveSelectorModelStateProtocol, CurveSelectorIntentProtocol> {
    
    return MVIContainer(model: DummyCurveSelectorModel(), intent: DummyCurveSelectorIntent())
}

struct DummyCurveSelectorModel: CurveSelectorModelStateProtocol {
    var state = CurveSelectorState(
        data: (1...5).map {
            CurveSelectorItem(
                isDark: $0 % 2 == 0,
                name: "Curve \($0)"
            )
        }
    )
    
    func editorViewModel(for item: CurveSelectorItem) -> MVIContainer<CurveEditorModelStateProtocol, CurveEditorIntentProtocol> {
        DummyCurveEditorViewModel()
    }
}

struct DummyCurveSelectorIntent: CurveSelectorIntentProtocol {
    
}
