import SwiftUI
import Shared

@main
struct iOSApp: App {
    
    let database = Database(databaseDriverFactory: DatabaseDriverFactory())
    
	var body: some Scene {
		WindowGroup {
			ContentView(database: database)
		}
	}
}
