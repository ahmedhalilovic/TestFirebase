//
//  ViewController.swift
//  TestFirebase
//
//  Created by Net Solution on 10. 11. 2023..
//
// Remote config from firebase is controlling the screens

import UIKit
import FirebaseRemoteConfig

class ViewController: UIViewController {
    
    // System red background
    private let view1: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        view.isHidden = true
        return view
    }()
    
    // System blue background
    private let view2: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.isHidden = true
        return view
    }()
    
    private let view3: UIView = {
        let view = UIView()
        view.backgroundColor = .systemCyan
        view.isHidden = true
        return view
    }()
    
    private let remoteConfig = RemoteConfig.remoteConfig()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(view1)
        view.addSubview(view2)
        view.addSubview(view3)
        
 //        fetchValues()
         updateValues()
    }
    
    // MARK: Fetches values on start
    // But only once and changed values will take effect only when app restarts
    
//    func fetchValues() {
//        
//        //shows_new_ui
//        
//        let defaults: [String: NSObject] = [
//            "shows_new_ui": false as NSObject,
//            "shows_ui_inside": false as NSObject
//        ]
//        
//        remoteConfig.setDefaults(defaults)
//        
//        let settings = RemoteConfigSettings()
//        settings.minimumFetchInterval = 0
//        remoteConfig.configSettings = settings
//        
//        updateUI(newUI: false)
//        updateUI2(newUI: false)
//         
//        self.remoteConfig.fetch(withExpirationDuration: 0, completionHandler: { status, error in
//            if status == .success, error == nil {
//                
//                do {
//                    try self.remoteConfig.activate()
//                    let value = self.remoteConfig.configValue(forKey: "shows_new_ui").boolValue
//                    print("Fetched value: \(value)")
//                    
//                    DispatchQueue.main.async {
//                        self.updateUI(newUI: value)
//                    }
//                } catch {
//                    print("Error activating remote config: \(error)")
//                }
//            }else {
//                print("something went wrong!")
//            }
//        })
//        
//        self.remoteConfig.fetch(withExpirationDuration: 0, completionHandler:   { status2, error in
//            if status2 == .success, error == nil {
//                
//                do {
//                    try self.remoteConfig.activate()
//                    let value = self.remoteConfig.configValue(forKey: "shows_ui_inside").boolValue
//                    print("Fetched value 2: \(value)")
//                    
//                    DispatchQueue.main.async {
//                        self.updateUI2(newUI: value)
//                    }
//                } catch {
//                    print("Error activating remote config2")
//                }
//            }else {
//                print("something went wrong twice")
//            }
//        })
//        
//    }
    
    // MARK: Keeps values updated real-time
    
    func updateValues() {
        
        let defaults: [String: NSObject] = [
            "shows_new_ui": false as NSObject,
            "shows_ui_inside": false as NSObject
        ]
        
        remoteConfig.setDefaults(defaults)
        
        updateUI(newUI: false)
        updateUI2(newUI: false)
        
        remoteConfig.addOnConfigUpdateListener { configUpdate, error in
            guard let configUpdate, error == nil else {
                print("Error listening for config updates: \(error)")
                return
            }
            
            self.remoteConfig.activate() { changed, error in
                guard error == nil else { return print("neki problem") }
                DispatchQueue.main.async {
                    self.updateUI(newUI: self.remoteConfig.configValue(forKey: "shows_new_ui").boolValue)
                }
                print("Promijenjena value za view3")
            }
            
            self.remoteConfig.activate() { changed2, error in
                guard error == nil else { return print("neki problem koje je tipa 2") }
                DispatchQueue.main.async {
                    self.updateUI2(newUI: self.remoteConfig.configValue(forKey: "shows_ui_inside").boolValue)
                }
                print("Promijenjena value za view1 ili view2")
            }
        }
    }
    
    func updateUI(newUI: Bool) {
        if newUI {
            view2.isHidden = false
            // blue color screen
        }
        else {
            view1.isHidden = false
            // red color screen
        }
    }
    
    func updateUI2(newUI: Bool) {
        if newUI {
            // cyan color screen
            view3.isHidden = false
        }else {
            view2.isHidden = true
            view3.isHidden = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view1.frame = view.bounds
        view2.frame = view.bounds
        view3.frame = view.bounds
    }

}

