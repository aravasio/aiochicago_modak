import SwiftUI
import CoreData

@main
struct AIoC_ModakApp: App {
    let persistenceController = CoreDataController.shared
    
    var body: some Scene {
        WindowGroup {
            let viewModel = MainViewModel(
                initialState: .loading,
                networkClient: NetworkClient(),
                context: persistenceController.persistentContainer.viewContext
            )
            MainView(model: viewModel)
        }
    }
}
