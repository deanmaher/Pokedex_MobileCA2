//
//  ContentView.swift
//  Pokedex_App2_MobileCA2
//
//  Created by Student on 17/05/2023.
//

import SwiftUI
import UserNotifications
import CoreLocation

struct ContentView: View {
    @Binding var pokemonList2: [PokemonT]
    var dimensions2: Double = 140
    func isSelectedType(type: String) -> Bool {
                return selectedType == type
            }
    @StateObject var vm = ViewModel()
        @State private var selectedType: String?
        @State private var types: [String] = []
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
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(types, id: \.self) { type in
                            Button(action: {
                                if selectedType != type {
                                    selectedType = type
                                    vm.fetchPokemonOfType(type: type)
                                } else {
                                    selectedType = nil
                                    vm.pokemonList = vm.pokemonManager.getPokemon()
                                }
                            }) {
                                Text("\(type)")
                                    .padding()
                                    .background(colorForType2(type))
                                    .foregroundColor(.white)
                                    .cornerRadius(22)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 22)
                                            .stroke(Color.blue, lineWidth: isSelectedType(type: type) ? 4 : 0)
                                    )
                            }
                        }
                    }.padding()
                }
                
                LazyVGrid(columns: adaptiveColumns, spacing: 10) {
                    ForEach(vm.filteredPokemon) { pokemon in
                        NavigationLink(destination: PokemonDetailView(pokemonList2: $pokemonList2, pokemon: pokemon)
                        ) {
                            PokemonView(pokemon: pokemon,dimensions:140)
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
        }.onAppear {
            fetchPokemonTypes()
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
        dateComponents.hour = 18
        dateComponents.minute = 52
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
            func setupLocationBasedNotifications() {
                let geofencingCenter = CLLocationCoordinate2D(latitude: 51.5073359, longitude: -0.12765)
                let region = CLCircularRegion(center: geofencingCenter, radius: 2000.0, identifier: "Headquarters")
                region.notifyOnEntry = true
                region.notifyOnExit = false
    
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
    
    func fetchPokemonTypes() {
            guard let url = URL(string: "https://pokeapi.co/api/v2/type?limit=18") else {
                return
            }

            URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    print("Error: \(error)")
                    return
                }

                if let data = data {
                    do {
                        let response = try JSONDecoder().decode(TypeResponse.self, from: data)
                        DispatchQueue.main.async {
                            types = response.results.map { $0.name }
                        }
                    } catch {
                        print("Error decoding data: \(error)")
                    }
                }
            }.resume()
        }
    
    private func colorForType2(_ type: String) -> Color {
            switch type {
            case "normal":
                return isSelectedType(type: type) ? Color(red: 168/255, green: 167/255, blue: 122/255) : Color.gray
            case "fire":
                return isSelectedType(type: type) ? Color(red: 238/255, green: 129/255, blue: 48/255) : Color.gray
            case "water":
                return isSelectedType(type: type) ? Color(red: 99/255, green: 144/255, blue: 240/255) : Color.gray
            case "electric":
                return isSelectedType(type: type) ? Color(red: 247/255, green: 208/255, blue: 44/255) : Color.gray
            case "grass":
                return isSelectedType(type: type) ? Color(red: 122/255, green: 199/255, blue: 76/255) : Color.gray
            case "ice":
                return isSelectedType(type: type) ? Color(red: 150/255, green: 217/255, blue: 214/255) : Color.gray
            case "fighting":
                return isSelectedType(type: type) ? Color(red: 194/255, green: 46/255, blue: 40/255) : Color.gray
            case "poison":
                return isSelectedType(type: type) ? Color(red: 163/255, green: 62/255, blue: 161/255) : Color.gray
            case "ground":
                return isSelectedType(type: type) ? Color(red: 226/255, green: 191/255, blue: 101/255) : Color.gray
            case "flying":
                return isSelectedType(type: type) ? Color(red: 169/255, green: 143/255, blue: 243/255) : Color.gray
            case "psychic":
                return isSelectedType(type: type) ? Color(red: 249/255, green: 85/255, blue: 135/255) : Color.gray
            case "bug":
                return isSelectedType(type: type) ? Color(red: 166/255, green: 185/255, blue: 26/255) : Color.gray
            case "rock":
                return isSelectedType(type: type) ? Color(red: 182/255, green: 161/255, blue: 54/255) : Color.gray
            case "ghost":
                return isSelectedType(type: type) ? Color(red: 115/255, green: 87/255, blue: 151/255) : Color.gray
            case "dragon":
                return isSelectedType(type: type) ? Color(red: 111/255, green: 53/255, blue: 252/255) : Color.gray
            case "dark":
                return isSelectedType(type: type) ? Color(red: 112/255, green: 87/255, blue: 70/255) : Color.gray
            case "steel":
                return isSelectedType(type: type) ? Color(red: 183/255, green: 183/255, blue: 206/255) : Color.gray
            case "fairy":
                return isSelectedType(type: type) ? Color(red: 214/255, green: 133/255, blue: 173/255) : Color.gray
            default:
                return Color.gray
            }
        }
}
