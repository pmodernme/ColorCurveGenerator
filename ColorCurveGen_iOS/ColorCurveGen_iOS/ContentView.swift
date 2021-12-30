
import Shared
import SwiftUI

struct ContentView: View {
    
    let database: Database
    
	var body: some View {
        let model = CurveSelectorModel(database: database)
        let intent = CurveSelectorIntent(model: model)
        CurveSelector(viewModel: MVIContainer(model: model, intent: intent, modelChangePublisher: model.objectWillChange))
	}
}
