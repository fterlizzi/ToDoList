//
//  AppDelegate.swift
//  Destini
//
//  Created by Philipp Muellauer on 01/09/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
   /*
    class Device {
        var currentDevice : UUID?
        var modelname : String?
        init(){
            currentDevice = UUID()
            modelname = ""
        }
        init(device aDevice:UUID ){
            currentDevice = aDevice
            modelname = ""
        }
        
    }

    var device : Device
*/
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // creo una istanza di device
       // device = Device()

        
        print("didFinishLaunchingWithOptions\n")
        // ottengo il path dove è salvato il defaults ; ovvero il plist dove archivio informazioni legate all'app in particolare la lista
        print(" il path della sandbox dell'app dove trovare il defaults plist \(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!)")
        let uuid = UUID().uuidString
        print("\n **** lo UUID dell'app è : \(uuid)\n")
        
        /* Il valore della proprietà identifierForVendor è lo stesso per le app che provengono dallo stesso fornitore in esecuzione sullo stesso dispositivo. Viene restituito un valore diverso per le app sullo stesso dispositivo che provengono da fornitori diversi e per le app su dispositivi diversi indipendentemente dal fornitore.
          Normalmente, il venditore è determinato dai dati forniti dall'App Store. Se l'app non è stata installata dall'app store (ad esempio app aziendali e app ancora in fase di sviluppo), viene calcolato un identificatore del fornitore in base all'ID bundle dell'app. Si presume che l'ID bundle sia in formato DNS inverso.
        */
        let currentDevice = UIDevice.current.identifierForVendor // Una stringa alfanumerica che identifica in modo univoco un dispositivo per il fornitore dell'app
        print("\n **** l'ID del dispositivo :\(currentDevice!.uuidString)\n")
        
        

        
        
        /* otterrò il seguente path dove torvo il plist :
        /Users/francesco_terlizzi/Library/Developer/CoreSimulator/Devices/20E5A160-BA4F-4C39-AB10-98527C35F17B/data/Containers/Data/Application/C0A9EB12-98F0-45D4-9914-B50CE6AEEC52/Documents
         --- > IMPORTANTE 20E5A160-BA4F-4C39-AB10-98527C35F17B rapprensenta l'identificativo del device in questo caso il simulatore
         
         ----> C0A9EB12-98F0-45D4-9914-B50CE6AEEC52 rappresenta  la particolare istanza dell'app lanciata qui l'ID (Sandbox)
         
         dell'app Device ID UUID identifica il nostro dispositivo e cambia ogni qualvolta è lanciata l'app
         20E5A160-BA4F-4C39-AB10-98527C35F17B
         /Users/francesco_terlizzi/Library/Developer/CoreSimulator/Devices/20E5A160-BA4F-4C39-AB10-98527C35F17B/data/Containers/Data/Application/61BE9498-E9ED-4F31-99D4-25212B03C259/library/preferences trovo il file com.acrmnet.todoey-ios13.Todoey.plist
        */
        
       
        return true
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

