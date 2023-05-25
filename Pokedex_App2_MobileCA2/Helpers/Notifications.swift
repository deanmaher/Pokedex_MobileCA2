//
//  Notifications.swift
//  Pokedex_App2_MobileCA2
//
//  Created by Student on 25/05/2023.
//

import Foundation
import UserNotifications
import CoreLocation
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        
        locationManager.delegate = self
    }
    
    func requestLocationPermission() {
        locationManager.requestAlwaysAuthorization()
    }
}

func notificationTomorrow() {
    let content = UNMutableNotificationContent()
    
    content.sound = UNNotificationSound.defaultCritical
    
    let currentDate = Date()
    let calendar = Calendar.current
    var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: currentDate)
    if let currentDay = dateComponents.day {
        dateComponents.day = currentDay + 1
    }
    // Increment the current day by 1
    //    if let currentDay = dateComponents.day {
    //        dateComponents.day = currentDay + 1
    //    }
    content.title = "It's Pokemon time \(dateComponents.day)"
    content.body = "It's Pokemon time \(dateComponents.day)"
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
}

func notificationOnCertainDay(day: Int) {
    let content = UNMutableNotificationContent()
    content.title = "It's Pokemon time"
    content.body = "It's Pokemon time"
    content.sound = UNNotificationSound.defaultRingtone
    
    let calendar = Calendar.current
    var dateComponents = DateComponents()
    dateComponents.day = day // set the day you want the notification to trigger
    dateComponents.hour = 18-1 // set the hour
    dateComponents.minute = 54 // set the minute
    
    if let currentMinute = dateComponents.minute {
        dateComponents.minute = currentMinute + 1
    }
    
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
}

func requestNotificationPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        if let error = error {
            print("Error requesting notification authorization: \(error.localizedDescription)")
        }
    }
}

func scheduleNotification() {
    let content = UNMutableNotificationContent()
    content.title = "Pokemon Fact"
    content.body = "Did you know? Pikachu is one of the most recognizable Pokemon!"
    content.sound = UNNotificationSound.default
    
    // Schedule the notification.
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request)
}

// triggers notification at current time plus 1 minute daily. so if 3:03 clicked then 3:04 everyday triggers notif
func dailyNotification() {
    let content = UNMutableNotificationContent()
    content.title = "It's Pokemon time"
    content.body = "It's Pokemon time"
    content.sound = UNNotificationSound.defaultRingtone
    
    let currentDate = Date()
    let calendar = Calendar.current
    var dateComponents = calendar.dateComponents([.hour, .minute], from: currentDate)
    
    // Add 1 minute to the current minute
    if let currentMinute = dateComponents.minute {
        dateComponents.minute = currentMinute + 1
    }
    
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
}

func setupLocationBasedNotifications() {
    let geofencingCenter = CLLocationCoordinate2D(latitude: 53.98143043999698, longitude: 53.98143043999698)
    let region = CLCircularRegion(center: geofencingCenter, radius: 100.0, identifier: "Headquarters")
    region.notifyOnEntry = true
    region.notifyOnExit = true
    
    let content = UNMutableNotificationContent()
    content.title = "Welcome to Headquarters"
    content.body = "You have entered the region"
    
    let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
    
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request) { (error) in
        if let error = error {
            print("Error while adding location notification request: ", error.localizedDescription)
        }
    }
}

