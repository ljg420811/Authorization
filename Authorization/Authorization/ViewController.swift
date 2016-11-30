//
//  ViewController.swift
//  Authorization
//
//  Created by Kilin on 2016/11/21.
//  Copyright © 2016年 Kilin. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation
import Contacts
import HealthKit
import CoreMotion

class ViewController: UIViewController {
    
    var authorizationTypes: [AuthorizationType] = {
        return [
            .LocationAlways,
            .LocationInUse,
            .Camera,
            .Photo,
            .Microphone,
            .Contact,
            .Bluetooth,
            .Calendar,
            .Reminder,
            .Media,
            .Music,
            .Health,
            .Motion,
            .SpeechRecognition,
            .Siri,
        ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert(Message message: String) {
        DispatchQueue.main.async {
            let alertActionOK = UIAlertAction(title: "OK", style: .default, handler: nil)
            let alertActionOpen = UIAlertAction(title: "Open", style: .default, handler: { (action) in
                if let url = URL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            })
            
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alertController.addAction(alertActionOK)
            alertController.addAction(alertActionOpen)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

// UITableviewDataSource and UITableviewDelegate
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentify = "CellIdentify"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify)
        
        if let cell = cell {
            cell.textLabel?.text = authorizationTypes[indexPath.row].rawValue
        }else{
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentify)
            cell?.textLabel?.text = authorizationTypes[indexPath.row].rawValue
        }
        
        return cell!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return authorizationTypes.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch authorizationTypes[indexPath.row] {
        case .LocationInUse:
            AuthorizationManager.sharedManager.requestAuthorizationLocationInUse(CompletionHandler: { (authorizationStatus) in
                if authorizationStatus == .denied || authorizationStatus == .restricted {
                    self.showAlert(Message: "User denied or restricted the location services. \nYou can reset it in settings.")
                }
            })
        case .LocationAlways:
            AuthorizationManager.sharedManager.requestAuthorizationLocationAlways(CompletionHandler: { (authorizationStatus) in
                if authorizationStatus == .denied || authorizationStatus == .restricted {
                    self.showAlert(Message: "User denied or restricted the location services. \nYou can reset it in settings.")
                }
            })
        case .Camera:
            AuthorizationManager.sharedManager.requestAuthorizationCamera(CompletionHandler: { (authorizationStatus) in
                if authorizationStatus == .denied || authorizationStatus == .restricted {
                    self.showAlert(Message: "User denied or restricted the camera. \nYou can reset it in settings.")
                }                
            })
        case .Photo:
            AuthorizationManager.sharedManager.requestAuthorizationPhotos(CompletionHandler: { (authorizationStatus) in
                if authorizationStatus == .denied || authorizationStatus == .restricted {
                    self.showAlert(Message: "User denied or restricted the photos. \nYou can reset it in settings.")
                }
            })
        case .Microphone:
            AuthorizationManager.sharedManager.requestAuthorizationMicrophone(CompletionHandler: { (authorizationStatus) in
                if authorizationStatus == AVAudioSessionRecordPermission.denied {
                    self.showAlert(Message: "User denied the microphone. \nYou can reset it in settings.")
                }
            })
        case .Contact:
            AuthorizationManager.sharedManager.requestAuthorizationContacts(CompletionHandler: { (authorizationStatus, error) in
                if authorizationStatus == .denied || authorizationStatus == .restricted {
                    self.showAlert(Message: "User denied or restricted the contacts. \nYou can reset it in settings.")
                    print("error : ",error as Any)
                }
            })
        case .Bluetooth:
            AuthorizationManager.sharedManager.requestAuthorizationBluetooth(CompletionHandler: { (authorizationStatus) in
                // You should implement the CNCentralManagerDelegate in yourself code to monitor the status of bluetooth.
                // This function will automatic called while the status changed of bluetooth. This can tumble you workflow.
            })
        case .Calendar:
            AuthorizationManager.sharedManager.requestAuthorizationCalendar(CompletionHandler: { (authorizationStatus, error) in
                if authorizationStatus == .denied || authorizationStatus == .restricted {
                    self.showAlert(Message: "User denied or restricted the Calendar. \nYou can reset it in settings.")
                    print("error : ",error as Any)
                }
            })
        case .Reminder:
            AuthorizationManager.sharedManager.requestAuthorizationReminder(CompletionHandler: { (authorizationStatus, error) in
                if authorizationStatus == .denied || authorizationStatus == .restricted {
                    self.showAlert(Message: "User denied or restricted the Reminder. \nYou can reset it in settings.")
                    print("error : ",error as Any)
                }
            })
        case .Media:
            AuthorizationManager.sharedManager.requestAuthorizationMedia(CompletionHandler: { (authorizationStatus) in
                if authorizationStatus == .denied || authorizationStatus == .restricted {
                    self.showAlert(Message: "User denied or restricted the Media. \nYou can reset it in settings.")
                }
            })
        case .Music:
            AuthorizationManager.sharedManager.requestAuthorizationMusic(CompletionHandler: { (authorizationStatus) in
                if authorizationStatus == .denied || authorizationStatus == .restricted {
                    self.showAlert(Message: "User denied or restricted the Music. \nYou can reset it in settings.")
                }
            })
        case .Health:
            AuthorizationManager.sharedManager.requestAuthorizationHealthStepCount(CompletionHandler: { (authorizationStatus) in
                if authorizationStatus == .sharingDenied {
                    // Notice: If you did not setup any authorization request before requesting health, while below tips display, you should not select 'open' button, otherwise the system will be crashed, it't a bug of iOS.
                    self.showAlert(Message: "User denied the Health. \nYou can reset it in settings.")
                }
            })
        case .Motion:
            AuthorizationManager.sharedManager.requestAuthorizationMotion(CompletionHandler: { (motionActivity) in
                print(motionActivity!)
            })
        case .SpeechRecognition:
            AuthorizationManager.sharedManager.requestAuthorizationSpeech(CompletionHandler: { (isSupportedLocale,authorizationStatus,errorMessage) in
                guard isSupportedLocale == true else {
                    print(errorMessage)
                    return
                }
                
                if authorizationStatus == .denied || authorizationStatus == .restricted {
                    self.showAlert(Message: "User denied or restricted the Speech Recognition. \nYou can reset it in settings.")
                }
            })
        case .Siri:
            AuthorizationManager.sharedManager.requestAuthorizationSiri(CompletionHandler: { (authorizationStatus) in
                if authorizationStatus == .denied || authorizationStatus == .restricted {
                    self.showAlert(Message: "User denied or restricted the Siri. \nYou can reset it in settings.")
                }
            })
        }
    }
}
