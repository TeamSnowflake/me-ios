//
//  AppDelegate.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/21/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if  UserDefaults.standard.string(forKey: ALConstants.kPincode) != "" && UserDefaults.standard.string(forKey: ALConstants.kPincode) != nil{
        let storyboard:UIStoryboard = UIStoryboard(name: "Tabs", bundle: nil)
        let rootViewController:UIViewController = storyboard.instantiateViewController(withIdentifier: "walet") as UIViewController
        self.window?.rootViewController = rootViewController
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print(url, options)
        return true
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MeApp")
        container.viewContext.automaticallyMergesChangesFromParent = true
        let description = container.persistentStoreDescriptions
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

