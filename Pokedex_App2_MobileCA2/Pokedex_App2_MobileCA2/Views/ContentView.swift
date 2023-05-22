//
//  ContentView.swift
//  Pokedex_App2_MobileCA2
//
//  Created by Student on 17/05/2023.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @StateObject var vm = ViewModel()
    
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
       
        Button(action: {
            scheduleNotification()
        }) {
            Text("Get a Pokemon Fact")
        }
        NavigationView {
            ScrollView {
                LazyVGrid(columns: adaptiveColumns, spacing: 10) {
                    ForEach(vm.filteredPokemon) { pokemon in
                        NavigationLink(destination: PokemonDetailView(pokemon: pokemon)
                        ) {
                            PokemonView(pokemon: pokemon)
                        }
                    }
                    
                }
                .animation(.easeInOut(duration: 0.3), value: vm.filteredPokemon.count)
                .navigationTitle("Pokedex")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    requestNotificationPermission()
                }
            }
            .searchable(text: $vm.searchText)
        }
       
        .environmentObject(vm)
        Button(action: {
            dailyNotification()
        }) {
            Text("Schedule Reminder Notification")
        }
        
     
    }
    
    
    
    
    
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification authorization: \(error.localizedDescription)")
            }
        }
        
        struct ContentView_Previews: PreviewProvider {
            static var previews: some View {
                ContentView()
            }
        }
    }
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Pokemon Fact"
        content.body = "Did you know? Pikachu is one of the most recognizable Pokemon!"
        content.sound = UNNotificationSound.default
        
        // Schedule the notification.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func dailyNotification() {
        let content = UNMutableNotificationContent()
        content.title = "It's Pokemon time"
        content.body = "It's Pokemon time"
        content.sound = UNNotificationSound.defaultRingtone
        
        var dateComponents = DateComponents()
        dateComponents.hour = 19
        dateComponents.minute = 13
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    
    
}
