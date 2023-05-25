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
    
    @StateObject private var locationManager = LocationManager()
    var body: some View {
        
        
        NavigationView {
            
            ScrollView {
                Button(action: {
                    scheduleNotification()
                }) {
                    Text("Get a Pokemon Fact in 1 second")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
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
                                    .font(.headline)
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
        }
        .onAppear {
            fetchPokemonTypes()
        }
        
        .environmentObject(vm)
        
        Button(action: {
            dailyNotification()
        }) {
            Text("Schedule Reminder Notification Next Minute")
                .font(.headline)
                .foregroundColor(.white)
                .padding(5)
                .background(Color.blue)
                .cornerRadius(8)
        }
        .onAppear{
            locationManager.requestLocationPermission()
            setupLocationBasedNotifications()
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
            return Color(red: 168/255, green: 167/255, blue: 122/255)
        case "fire":
            return  Color(red: 238/255, green: 129/255, blue: 48/255)
        case "water":
            return Color(red: 99/255, green: 144/255, blue: 240/255)
        case "electric":
            return  Color(red: 247/255, green: 208/255, blue: 44/255)
        case "grass":
            return Color(red: 122/255, green: 199/255, blue: 76/255)
        case "ice":
            return Color(red: 150/255, green: 217/255, blue: 214/255)
        case "fighting":
            return Color(red: 194/255, green: 46/255, blue: 40/255)
        case "poison":
            return Color(red: 163/255, green: 62/255, blue: 161/255)
        case "ground":
            return Color(red: 226/255, green: 191/255, blue: 101/255)
        case "flying":
            return Color(red: 169/255, green: 143/255, blue: 243/255)
        case "psychic":
            return Color(red: 249/255, green: 85/255, blue: 135/255)
        case "bug":
            return Color(red: 166/255, green: 185/255, blue: 26/255)
        case "rock":
            return Color(red: 182/255, green: 161/255, blue: 54/255)
        case "ghost":
            return Color(red: 115/255, green: 87/255, blue: 151/255)
        case "dragon":
            return Color(red: 111/255, green: 53/255, blue: 252/255)
        case "dark":
            return Color(red: 112/255, green: 87/255, blue: 70/255)
        case "steel":
            return Color(red: 183/255, green: 183/255, blue: 206/255)
        case "fairy":
            return Color(red: 214/255, green: 133/255, blue: 173/255)
        default:
            return Color.gray
        }
    }
}

