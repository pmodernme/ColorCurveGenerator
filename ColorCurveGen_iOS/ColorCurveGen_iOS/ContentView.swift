import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ColorCurveViewModel()
    
	var body: some View {
        CurveEditor(
            state: viewModel.state,
            onPreviousPressed: viewModel.onPreviousPressed,
            onNextPressed: viewModel.onNextPressed,
            onDeletePressed: viewModel.onDeletePressed,
            onHueChange: viewModel.onHueChange(_:),
            onSaturationChange: viewModel.onSaturationChange(_:),
            onBrightnessChange: viewModel.onBrightnessChange(_:),
            onAlphaChange: viewModel.onAlphaChange(_:))
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
