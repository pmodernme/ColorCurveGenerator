//
//  CurveSelector.swift
//  ColorCurveGen_iOS
//
//  Created by Zoe Van Brunt on 10/15/21.
//  Copyright © 2021 orgName. All rights reserved.
//

import SwiftUI

struct CurveSelector<ViewModel: CurveSelectorViewModelProtocol>: View {
    var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.state.data) { item in
                NavigationLink(destination: {
                    
                }) {
                    CurveSelectorRow(item: item)
                }
            }
            .navigationTitle("Curves")
        }
    }
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
        let vm = DummyCurveSelectorVM()
        CurveSelector(viewModel: vm)
    }
}

class DummyCurveSelectorVM: CurveSelectorViewModelProtocol {
    
    var state = CurveSelectorState(
        data: (1...5).map {
            CurveSelectorItem(
                isDark: $0 % 2 == 0,
                name: "Curve \($0)"
            )
        }
    )
}
