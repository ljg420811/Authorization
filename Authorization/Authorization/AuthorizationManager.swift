//
//  AuthorizationManager.swift
//  Authorization
//
//  Created by Kilin on 2016/11/23.
//  Copyright © 2016年 Kilin. All rights reserved.
//

import UIKit
import CoreLocation
import Contacts
import EventKit
import HealthKit

enum AuthorizationType: String {
    case LocationAlways
    case LocationInUse
    case Camera
    case Photo
    case Microphone
    case Contact
    case Calendar
    case Reminder
    case Media
    case Music
    case Health
    case Motion
    case SpeechRecognition
    case Siri
    case Bluetooth
}

// A simple usage of Authorizable
class AuthorizationManager: BluetoothAuthorizable,LocationAuthorizable,CameraAuthorizable,PhotosAuthorizable,MicrophoneAuthorizable,ContactsAuthorizable,CalendarAuthorizable,ReminderAuthorizable,MediaAuthorizable,MusicAuthorizable,HealthAuthorizable,MotionAuthorizable,SpeechAuthorizable,SiriAuthorizable {
    
    static let sharedManager = AuthorizationManager()
    private init(){}
    
    var locationManager = CLLocationManager()
    var contactsStore = CNContactStore()
    var bluetooth = BluetoothStatus()
    var reminderEventStore = EKEventStore()
    var calendarEventStore = EKEventStore()
    var healthStore = HKHealthStore()
}
