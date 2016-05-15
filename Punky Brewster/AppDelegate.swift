import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let oneSignalAppId = NSProcessInfo.processInfo().environment["ONESIGNAL_APP_ID"]!
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        customiseAppearance()
        
        _ = OneSignal(launchOptions: launchOptions, appId: oneSignalAppId, handleNotification: nil, autoRegister: false)
        
        return true
    }
    func customiseAppearance() {
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.barStyle = .Black
        navBarAppearance.barTintColor = .blackColor()
        navBarAppearance.titleTextAttributes = [NSFontAttributeName: defaultFontWithSize(20)]
        
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.barStyle = .Black
        tabBarAppearance.barTintColor = .blackColor()
        tabBarAppearance.tintColor = .whiteColor()
        
        let tabBarItemAppearance = UITabBarItem.appearance()
        tabBarItemAppearance.setTitleTextAttributes([NSFontAttributeName: defaultFontWithSize(11)], forState: UIControlState.Normal)
        
        let uiLabelAppearance = UILabel.appearance()
        uiLabelAppearance.font = defaultFontWithSize(18)
    }
    
    func defaultFontWithSize(size: CGFloat) -> UIFont {
        let fontDescriptor = UIFontDescriptor(name: "DIN Condensed", size: size)
        return UIFont(descriptor: fontDescriptor, size: size)
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("Device token: \(deviceToken)")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print(userInfo)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print(error)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

