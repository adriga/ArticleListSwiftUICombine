import SwiftUI

@main
struct ArticleListCombineApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ProductListRouter().createModule(factory: appDelegate.moduleFactory)
        }
    }
}
