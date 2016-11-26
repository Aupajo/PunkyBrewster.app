import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // If this line fails, see notes on setting environment variables in the README
    let oneSignalAppId = ProcessInfo.processInfo.environment["ONESIGNAL_APP_ID"]!
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        customiseAppearance()
        
        // Initializes OneSignal for push notifications
        _ = OneSignal.initWithLaunchOptions(launchOptions, appId: oneSignalAppId, handleNotificationAction: nil, settings: [
                // This will allow notifications to pop up while using the app.
                kOSSettingsKeyInFocusDisplayOption: OSNotificationDisplayType.notification.rawValue,
                
                // Disables prompting the user to enable notifications at app load – we handle this
                // inside the BerListTableViewController instead, so we can present a nicer message
                // to the user.
                kOSSettingsKeyAutoPrompt: false
            ])
        
        return true
    }
    func customiseAppearance() {
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.barStyle = .black
        navBarAppearance.barTintColor = .black
        navBarAppearance.titleTextAttributes = [NSFontAttributeName: defaultFontWithSize(20)]
        
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.barStyle = .black
        tabBarAppearance.barTintColor = .black
        tabBarAppearance.tintColor = .white
        
        let tabBarItemAppearance = UITabBarItem.appearance()
        tabBarItemAppearance.setTitleTextAttributes([NSFontAttributeName: defaultFontWithSize(11)], for: UIControlState())
        
        let uiLabelAppearance = UILabel.appearance()
        uiLabelAppearance.font = defaultFontWithSize(18)
    }
    
    func defaultFontWithSize(_ size: CGFloat) -> UIFont {
        let fontDescriptor = UIFontDescriptor(name: "DIN Condensed", size: size)
        return UIFont(descriptor: fontDescriptor, size: size)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

