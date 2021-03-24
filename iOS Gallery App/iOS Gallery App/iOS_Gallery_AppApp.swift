//
//  iOS_Gallery_AppApp.swift
//  iOS Gallery App
//
//  Created by Shreyas Babu on 3/23/21.
//

import SwiftUI
import Photos

@UIApplicationMain
class iOS_Gallery_AppApp: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let photos = PHPhotoLibrary.authorizationStatus()
        if (photos == .notDetermined)
        {
            PHPhotoLibrary.requestAuthorization({status in
                if (status == .authorized)
                {
                    self.callContentView()
                }
                else
                {
                    let alert = UIAlertController(title: "Access Denied", message: "Need access to photo library", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                }
            })
        }
        else if (photos == .authorized)
        {
            callContentView()
        }
        
        return true
    }
    
    func callContentView()
    {
        DispatchQueue.main.async(execute: { () -> Void in
            self.window = UIWindow(frame: UIScreen.main.bounds)
            if let window = self.window
            {
                window.backgroundColor = UIColor.white
                let nav = UINavigationController()
                let mainView = ContentView()
                nav.viewControllers = [mainView]
                window.rootViewController = nav
                window.makeKeyAndVisible()
            }
        })
    }
}
