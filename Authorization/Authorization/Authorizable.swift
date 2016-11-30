//
//  AuthorizationManager.swift
//  Authorization
//
//  Created by Kilin on 2016/11/22.
//  Copyright © 2016年 Kilin. All rights reserved.
//

//  Required: iOS 10 or later.
//  Required: Swift 3.0 or later.

import CoreLocation
import AVFoundation
import Photos
import Contacts
import CoreBluetooth
import EventKit
import MediaPlayer
import StoreKit
import HealthKit
import CoreMotion
import Speech
import Intents

let OutputLogs = true


// MARK: - Location
/*
 The authorization status of Location can only change in settings.
 
 Depend On:
 You must import the library of CoreLocation.
 
 Note:
 You should initial the locationManager and hold it while requesting. Otherwise the requesting dialog will be passed quickly.
 
 Important:
 1.Your app’s Info.plist file must provide a value for the NSLocationAlwaysUsageDescription key that explains to the user why your app is always use Location information.
 2.Your app’s Info.plist file must provide a value for the NSLocationWhenInUseUsageDescription key that explains to the user why your app is use Location information.
 */
protocol LocationAuthorizable {
    
    var locationManager: CLLocationManager {get set}
    
    func requestAuthorizationLocationAlways(CompletionHandler completion: @escaping LocationAuthorizationCompletionHandler)
    func requestAuthorizationLocationInUse(CompletionHandler completion: @escaping LocationAuthorizationCompletionHandler)
    
}

extension LocationAuthorizable {
    
    typealias LocationAuthorizationCompletionHandler = (_ status: CLAuthorizationStatus) -> Void
    
    func requestAuthorizationLocationAlways(CompletionHandler completion: @escaping LocationAuthorizationCompletionHandler){
        let authorizationStatus = self.checkLocationAuthorizationStatus()
        if case .notDetermined = authorizationStatus {
            self.locationManager.requestWhenInUseAuthorization()
        }
        completion(authorizationStatus)
    }
    
    func requestAuthorizationLocationInUse(CompletionHandler completion: @escaping LocationAuthorizationCompletionHandler){
        let authorizationStatus = self.checkLocationAuthorizationStatus()
        if case .notDetermined = authorizationStatus {
            self.locationManager.requestWhenInUseAuthorization()
        }
        completion(authorizationStatus)
    }
    
    private func checkLocationAuthorizationStatus() -> CLAuthorizationStatus {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if OutputLogs == true {
            switch authorizationStatus {
            case .authorizedAlways:
                print("Core Location authorization status: Authorized Always.")
            case .authorizedWhenInUse:
                print("Core Location authorization status: Authorized When In Use.")
            case .notDetermined:
                print("Core Location authorization status: Not Determined.")
            case .denied:
                print("Core Location authorization status: Denied.")
            case .restricted:
                print("Core Location authorization status: Restricted.")
            }
        }
        
        return authorizationStatus
    }
}


// MARK: - Camera
/*
 The authorization status of Camera can only change in settings.
 
 Depend On:
 You must import the library of AVFoundation.
 
 Important:
 Your app’s Info.plist file must provide a value for the NSCameraUsageDescription key that explains to the user why your app is requesting Camera access.
 */
protocol CameraAuthorizable {

    func requestAuthorizationCamera(CompletionHandler completion: @escaping CameraAuthorizationCompletionHandler)
    
}

extension CameraAuthorizable {
    
    typealias CameraAuthorizationCompletionHandler = (_ status: AVAuthorizationStatus) -> Void
    
    func requestAuthorizationCamera(CompletionHandler completion: @escaping CameraAuthorizationCompletionHandler) {
        let authorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        if OutputLogs == true {
            switch authorizationStatus {
            case .authorized:
                print("Camera authorization status: Authorized.")
            case .notDetermined:
                print("Camera authorization status: Not Determined.")
            case .denied:
                print("Camera authorization status: Denied.")
            case .restricted:
                print("Camera authorization status: Restricted.")
            }
        }
        
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted) in
            if granted == true {
                completion(AVAuthorizationStatus.authorized)
            }else {
                completion(authorizationStatus)
            }
        })
    }
}

// MARK: - Photos
/*
 The authorization status of Photos can only change in settings.
 
 Depend On:
 You must import the library of Photos.
 
 Important:
 Your app’s Info.plist file must provide a value for the NSPhotoLibraryUsageDescription key that explains to the user why your app is requesting Photos access.
 */
protocol PhotosAuthorizable {
    
    func requestAuthorizationPhotos(CompletionHandler completion: @escaping PhotosAuthorizationCompletionHandler)
    
}

extension PhotosAuthorizable {
    
    typealias PhotosAuthorizationCompletionHandler = (_ status: PHAuthorizationStatus) -> Void
    
    @discardableResult func requestAuthorizationPhotos(CompletionHandler completion: @escaping PhotosAuthorizationCompletionHandler) {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        if OutputLogs == true {
            switch authorizationStatus {
            case .authorized:
                print("Photos authorization status: Authorized.")
            case .notDetermined:
                print("Photos authorization status: Not Determined.")
            case .denied:
                print("Photos authorization status: Denied.")
            case .restricted:
                print("Photos authorization status: Restricted.")
            }
        }
        
        PHPhotoLibrary.requestAuthorization { (status) in
            completion(status)
        }
    }
}


// MARK: - Microphone
/*
 The authorization status of Microphone can only change in settings.
 
 Depend On:
 You must import the library of AVFoundation.
 
 Important:
 Your app’s Info.plist file must provide a value for the NSMicrophoneUsageDescription key that explains to the user why your app is requesting Microphone access.
 */
protocol MicrophoneAuthorizable {
    
    func requestAuthorizationMicrophone(CompletionHandler completion: @escaping MicrophoneAuthorizationCompletionHandler)
    
}

extension MicrophoneAuthorizable {
    
    typealias MicrophoneAuthorizationCompletionHandler = (_ status: AVAudioSessionRecordPermission) -> Void
    
    @discardableResult func requestAuthorizationMicrophone(CompletionHandler completion: @escaping MicrophoneAuthorizationCompletionHandler) {
        let authorizationStatus = AVAudioSession.sharedInstance().recordPermission()
        if OutputLogs == true {
            switch  authorizationStatus{
            case AVAudioSessionRecordPermission.granted:
                print("Microphone authorization status: Granted.")
            case AVAudioSessionRecordPermission.undetermined:
                print("Microphone authorization status: Undetermined.")
            case AVAudioSessionRecordPermission.denied:
                print("Microphone authorization status: Denied.")
            default:
                print("Microphone authorization status: Unknown.")
            }
        }
        
        AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
            if granted == true {
                completion(AVAudioSessionRecordPermission.granted)
            }else{
                completion(authorizationStatus)
            }
        }
    }
}


// MARK: - Contacts
/*
 The authorization status of Contacts can only change in settings.
 
 Depend On:
 You must import the library of Contacts.
 
 Note:
 You should initial the contactsStore and hold it while requesting.
 
 Important:
 Your app’s Info.plist file must provide a value for the NSContactsUsageDescription key that explains to the user why your app is requesting Contacts access.
 */
protocol ContactsAuthorizable {
    
    var contactsStore: CNContactStore {get set}
    
    func requestAuthorizationContacts(CompletionHandler completion: @escaping ContactsAuthorizationCompletionHandler)
    
}

extension ContactsAuthorizable {
    
    typealias ContactsAuthorizationCompletionHandler = (_ status: CNAuthorizationStatus, _ error: Error?) -> Void
    
    @discardableResult func requestAuthorizationContacts(CompletionHandler completion: @escaping ContactsAuthorizationCompletionHandler) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
        if OutputLogs == true {
            switch  authorizationStatus{
            case .authorized:
                print("Contacts authorization status: Authorized.")
            case .notDetermined:
                print("Contacts authorization status: Undetermined.")
            case .denied:
                print("Contacts authorization status: Denied.")
            case .restricted:
                print("Contacts authorization status: Restricted.")
            }
        }
        
        self.contactsStore.requestAccess(for: .contacts, completionHandler: {(granted, error) in
            if granted == true {
                completion(.authorized, error)
            }else{
                completion(authorizationStatus, error)
            }
        })
    }
}


// MARK: - Calendar
/*
 The authorization status of Calendar can only change in settings.
 
 Depend On:
 You must import the library of EventKit.
 
 Note:
 You should initial the calendarEventStore and hold it while requesting.
 
 Important:
 Your app’s Info.plist file must provide a value for the NSCalendarsUsageDescription key that explains to the user why your app is requesting Calendar access.
 */
protocol CalendarAuthorizable {
    
    var calendarEventStore: EKEventStore {get set}
    
    func requestAuthorizationCalendar(CompletionHandler completion: @escaping CalendarAuthorizationCompletionHandler)
    
}

extension CalendarAuthorizable {
    
    typealias CalendarAuthorizationCompletionHandler = (_ status: EKAuthorizationStatus, _ error: Error?) -> Void
    
    @discardableResult func requestAuthorizationCalendar(CompletionHandler completion: @escaping CalendarAuthorizationCompletionHandler) {
        let authorizationStatus = EKEventStore.authorizationStatus(for: .event)
        if OutputLogs == true {
            switch  authorizationStatus{
            case .authorized:
                print("Calendar authorization status: Authorized.")
            case .notDetermined:
                print("Calendar authorization status: Undetermined.")
            case .denied:
                print("Calendar authorization status: Denied.")
            case .restricted:
                print("Calendar authorization status: Restricted.")
            }
        }
        
        self.calendarEventStore.requestAccess(to: .event, completion: {(granted, error) in
            if granted == true {
                completion(.authorized, error)
            }else {
                completion(authorizationStatus, error)
            }
        })
    }
}


// MARK: - Reminder
/*
 The authorization status of Reminder can only change in settings.
 
 Depend On:
 You must import the library of EventKit.
 
 Note:
 You should initial the reminderEventStore and hold it while requesting.
 
 Important:
 Your app’s Info.plist file must provide a value for the NSRemindersUsageDescription key that explains to the user why your app is requesting Reminder access.
 */
protocol ReminderAuthorizable {
    
    var reminderEventStore: EKEventStore {get set}
    
    func requestAuthorizationReminder(CompletionHandler completion: @escaping ReminderAuthorizationCompletionHandler)
    
}

extension ReminderAuthorizable {
    
    typealias ReminderAuthorizationCompletionHandler = (_ status: EKAuthorizationStatus, _ error: Error?) -> Void
    
    @discardableResult func requestAuthorizationReminder(CompletionHandler completion: @escaping ReminderAuthorizationCompletionHandler) {
        let authorizationStatus = EKEventStore.authorizationStatus(for: .reminder)
        if OutputLogs == true {
            switch  authorizationStatus{
            case .authorized:
                print("Reminder authorization status: Authorized.")
            case .notDetermined:
                print("Reminder authorization status: Undetermined.")
            case .denied:
                print("Reminder authorization status: Denied.")
            case .restricted:
                print("Reminder authorization status: Restricted.")
            }
        }
        
        self.reminderEventStore.requestAccess(to: .reminder, completion: {(granted, error) in
            if granted == true {
                completion(.authorized, error)
            }else {
                completion(authorizationStatus, error)
            }
        })
    }
}


// MARK: - Media
/*
 The authorization status of Media can only change in settings.
 
 Depend On:
 You must import the library of MediaPlayer.
 
 Important:
 Your app’s Info.plist file must provide a value for the NSAppleMusicUsageDescription key that explains to the user why your app is requesting Media access.
 */
protocol MediaAuthorizable {
    
    func requestAuthorizationMedia(CompletionHandler completion: @escaping MediaAuthorizationCompletionHandler)
    
}

extension MediaAuthorizable {
    
    typealias MediaAuthorizationCompletionHandler = (_ status: MPMediaLibraryAuthorizationStatus) -> Void
    
    @discardableResult func requestAuthorizationMedia(CompletionHandler completion: @escaping MediaAuthorizationCompletionHandler) {
        let authorizationStatus = MPMediaLibrary.authorizationStatus()
        if OutputLogs == true {
            switch  authorizationStatus{
            case .authorized:
                print("Media authorization status: Authorized.")
            case .notDetermined:
                print("Media authorization status: Undetermined.")
            case .denied:
                print("Media authorization status: Denied.")
            case .restricted:
                print("Media authorization status: Restricted.")
            }
        }
        
        MPMediaLibrary.requestAuthorization { (status) in
            completion(status)
        }
    }
}


// MARK: - Music
/*
 The authorization status of Music can only change in settings.
 
 Depend On:
 You must import the library of StoreKit.
 
 Important:
 Your app’s Info.plist file must provide a value for the NSAppleMusicUsageDescription key that explains to the user why your app is requesting Music access.
 */
protocol MusicAuthorizable {
    
    func requestAuthorizationMusic(CompletionHandler completion: @escaping MusicAuthorizationCompletionHandler)
    
}

extension MusicAuthorizable {
    
    typealias MusicAuthorizationCompletionHandler = (_ status: SKCloudServiceAuthorizationStatus) -> Void
    
    @discardableResult func requestAuthorizationMusic(CompletionHandler completion: @escaping MusicAuthorizationCompletionHandler) {
        let authorizationStatus = SKCloudServiceController.authorizationStatus()
        if OutputLogs == true {
            switch  authorizationStatus{
            case .authorized:
                print("Music authorization status: Authorized.")
            case .notDetermined:
                print("Music authorization status: Undetermined.")
            case .denied:
                print("Music authorization status: Denied.")
            case .restricted:
                print("Music authorization status: Restricted.")
            }
        }
        
        SKCloudServiceController.requestAuthorization { (status) in
            completion(status)
        }
    }
}


// MARK: - Health
/*
 The authorization status of Health can only change in settings.
 
 Depend On:
 You must import the library of HealthKit.
 
 Note:
 1.You should initial the healthStore and hold it while requesting.
 2.You should enable the HealthKit in Capabilities.
 3.The health framework has many restrict(e.g. HealthKit and the Health app are unavailable on iPad), please read the guide documation carefully before develop.
 
 Important:
 1.Your app’s Info.plist file must provide values for the NSHealthShareUsageDescription & NSHealthUpdateUsageDescription key that explains to the user why your app is requesting Health access.
 2.Setup NSHealthShareUsageDescription key to customize the message for reading data.
 3.Setup NSHealthUpdateUsageDescription key to customize the message for writing data.
 */
protocol HealthAuthorizable {
    
    var healthStore: HKHealthStore {get set}
    
    func requestAuthorizationHealthStepCount(CompletionHandler completion: @escaping HealthAuthorizationCompletionHandler)
    
}

extension HealthAuthorizable {
    
    typealias HealthAuthorizationCompletionHandler = (_ status: HKAuthorizationStatus) -> Void
    
    @discardableResult func requestAuthorizationHealthStepCount(CompletionHandler completion: @escaping HealthAuthorizationCompletionHandler) {
        guard HKHealthStore.isHealthDataAvailable() == true else {
            completion(.sharingDenied)
            return
        }
        
        guard let hkObjectTypeStepCount = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) else {
            completion(.sharingDenied)
            return
        }
        let authorizationStatus = self.healthStore.authorizationStatus(for: hkObjectTypeStepCount)
        if OutputLogs == true {
            switch  authorizationStatus{
            case .sharingAuthorized:
                print("Health authorization status: Authorized.")
            case .notDetermined:
                print("Health authorization status: Undetermined.")
            case .sharingDenied:
                print("Health authorization status: Denied.")
            }
        }
        
        self.healthStore.requestAuthorization(toShare:[hkObjectTypeStepCount], read:[hkObjectTypeStepCount], completion: {
            (success, error) in
            // No matter select allow or not allow, the result of success always true, and the error is nil.
            completion(authorizationStatus)
        })
    }
}


// MARK: - Motion
/*
 The authorization status of Motion can only change in settings.
 
 Depend On:
 You must import the library of CoreMotion.
 
 Important:
 Your app’s Info.plist file must provide values for the NSMotionUsageDescription key that explains to the user why your app is requesting Motion access.
 */
protocol MotionAuthorizable {
    
    func requestAuthorizationMotion(CompletionHandler completion: @escaping MotionAuthorizationCompletionHandler)
    
}

extension MotionAuthorizable {
    
    typealias MotionAuthorizationCompletionHandler = (_ motionActivity: CMMotionActivity?) -> Void
    
    @discardableResult func requestAuthorizationMotion(CompletionHandler completion: @escaping MotionAuthorizationCompletionHandler) {
        // Check motion data is available on the current device.
        guard CMMotionActivityManager.isActivityAvailable() == true else {
            return
        }
        
        let authorizationStatus = CMMotionActivityManager()
        authorizationStatus.startActivityUpdates(to: .main, withHandler: {
            (motionActivity) in
            completion(motionActivity)
        })
    }
}


// MARK: - Speech Recognition
/*
 The authorization status of Speech Recognition can only change in settings.
 
 Depend On:
 You must import the library of Speech.
 
 Important:
 Your app’s Info.plist file must provide values for the NSSpeechRecognitionUsageDescription key that explains to the user why your app is requesting Speech Recognition access.
 */
protocol SpeechAuthorizable {
    
    func requestAuthorizationSpeech(CompletionHandler completion: @escaping SpeechAuthorizationCompletionHandler)
    
}

extension SpeechAuthorizable {
    
    typealias SpeechAuthorizationCompletionHandler = (_ isSupportedLocales: Bool,_ status: SFSpeechRecognizerAuthorizationStatus ,_ errorMessage: String) -> Void
    
    @discardableResult func requestAuthorizationSpeech(CompletionHandler completion: @escaping SpeechAuthorizationCompletionHandler) {
        let supportedLocales = SFSpeechRecognizer.supportedLocales()
        let currentLocale = NSLocale.current
        // Note: You should use the regionCode perporty to compare with the region information, because of the identifier is not comparable with the string format(e.g. element in suppertedLocales which element.identifier is 'zh-CN' and the currentLocale.identifier is 'zh_CN').
        guard supportedLocales.filter({$0.regionCode == currentLocale.regionCode}).count > 0 else {
            completion(false, .denied, "Device not supported current locale.")
            return
        }
        
        let authorizationStatus = SFSpeechRecognizer.authorizationStatus()
        if OutputLogs == true {
            switch  authorizationStatus{
            case .authorized:
                print("Speech Recognition authorization status: Authorized.")
            case .notDetermined:
                print("Speech Recognition authorization status: Undetermined.")
            case .denied:
                print("Speech Recognition authorization status: Denied.")
            case .restricted:
                print("Speech Recognition authorization status: Restricted.")
            }
        }
        
        SFSpeechRecognizer.requestAuthorization { (status) in
            completion(true, status, "")
        }
    }
}


// MARK: - Siri
/*
 The authorization status of Siri can only change in settings.
 
 Depend On:
 You must import the library of Intents.
 
 Important:
 Your app’s Info.plist file must provide values for the NSSiriUsageDescription key that explains to the user why your app is requesting Siri access.
 */
protocol SiriAuthorizable {
    
    func requestAuthorizationSiri(CompletionHandler completion: @escaping SiriAuthorizationCompletionHandler)
    
}

extension SiriAuthorizable {
    
    typealias SiriAuthorizationCompletionHandler = (_ status: INSiriAuthorizationStatus) -> Void
    
    @discardableResult func requestAuthorizationSiri(CompletionHandler completion: @escaping SiriAuthorizationCompletionHandler) {
        let authorizationStatus = INPreferences.siriAuthorizationStatus()
        if OutputLogs == true {
            switch  authorizationStatus{
            case .authorized:
                print("Siri authorization status: Authorized.")
            case .notDetermined:
                print("Siri authorization status: Undetermined.")
            case .denied:
                print("Siri authorization status: Denied.")
            case .restricted:
                print("Siri authorization status: Restricted.")
            }
        }
        
        INPreferences.requestSiriAuthorization { (status) in
            completion(status)
        }
    }
}


// MARK: - Bluetooth
/*
 The authorization status of Bluetooth can only change in settings.
 
 Depend On:
 You must import the library of CoreBluetooth.
 
 Note:
 1.You should initial the bluetooth and hold it while requesting.
 2.Because of the bluetooth authorization permission is only enable in a delegate(CBCentralManager), everytime user manipulate bluetooth will invoke the delegate and change status, thus recommend that you should monitor the status by your code.
 
 Important:
 Your app’s Info.plist file must provide values for the NSBluetoothPeripheralUsageDescription key that explains to the user why your app is requesting Bluetooth access.
 */
protocol BluetoothAuthorizable {

    var bluetooth: BluetoothStatus {get set}

    func requestAuthorizationBluetooth(CompletionHandler completion: @escaping BluetoothAuthorizableCompletionHandler)

}

extension BluetoothAuthorizable {
    
    typealias BluetoothAuthorizableCompletionHandler = (_ status: CBManagerState) -> Void
    
    @discardableResult func requestAuthorizationBluetooth(CompletionHandler completion: @escaping BluetoothAuthorizableCompletionHandler) {
        self.bluetooth.statusChanged = {
            status in
            completion(status)
        }
    }
}

class BluetoothStatus: NSObject,CBCentralManagerDelegate {
    
    public var statusChanged: ((_ status: CBManagerState) -> Void)?
    
    private var status: CBManagerState = .unknown
    private var centralManager: CBCentralManager?
    
    /**
     Note: Every time user changed the status of bluetooch will invoke the fucntion, thus the relevant property of statusChanged will called.
     */
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        status = central.state
        if OutputLogs == true {
            switch status {
            // iPhone Simulation
            case .unsupported:
                print("The platform doesn't support the Bluetooth Low Energy Central/Client role.")
            case .unknown:
                print("State unknown, update imminent.")
            case .unauthorized:
                print("The application is not authorized to use the Bluetooth Low Energy role.")
            case .resetting:
                print("The connection with the system service was momentarily lost, update imminent.")
            case .poweredOn:
                print("Bluetooth is currently powered on and available to use.")
            case .poweredOff:
                print("Bluetooth is currently powered off.")
            }
        }
        
        statusChanged?(status)
    }
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
}

