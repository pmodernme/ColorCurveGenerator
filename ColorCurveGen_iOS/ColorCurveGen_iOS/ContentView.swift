
import Shared
import SwiftUI

struct ContentView: View {
    
	var body: some View {
        let model = CurveEditorModel(curve: BasicColorCurve(nodes: []))
        let intent = CurveEditorIntent(model: model)
        CurveEditor(viewModel: MVIContainer(model: model, intent: intent))
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
