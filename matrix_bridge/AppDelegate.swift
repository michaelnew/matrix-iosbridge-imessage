import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = MainNavController()
        window!.makeKeyAndVisible()
        //for familyName in UIFont.familyNames {
        //    for fontName in UIFont.fontNames(forFamilyName: familyName) {
        //        log("\(fontName)")
        //    }
        //}
        return true
    }
}
