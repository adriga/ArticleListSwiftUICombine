import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    
    var moduleFactory: ModuleFactory = ModuleDependencyContainer()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
}
