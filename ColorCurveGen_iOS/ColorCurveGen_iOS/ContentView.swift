
import Shared
import SwiftUI

struct ContentView: View {
    
	var body: some View {
        let model = CurveEditorModel(curve: BasicColorCurve(nodes: []))
        let intent = CurveEditorIntent(model: model)
        CurveEditor(viewModel: ColorCurveViewModel(intent: intent, model: model))
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
