////  PersonalPokedexView.swift
////  Pokedex_App2_MobileCA2
////
////  Created by Student on 23/05/2023.
////
//
//import Foundation
//import SwiftUI
//
//struct PersonalPokedexView: View {
//    @Binding var pokemonList2: [PokemonT]
//
//    var body: some View {
//        List(pokemonList2) { pokemon in
//            VStack {
//                HStack {
//                    pokemon.image
//                        .resizable()
//                        .scaledToFit()
//                        .frame(height: 80)
//                        .clipShape(Circle())
//                        .shadow(radius: 10)
//                        .padding(5)
//                    VStack(alignment: .leading) {
//                        Text(pokemon.name)
//                            .font(.headline)
//                        Text(pokemon.type)
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
//                        Text(pokemon.ability)
//                            .font(.footnote)
//                            .foregroundColor(.secondary)
//                        Text("Age: \(pokemon.age)")
//                            .font(.footnote)
//                            .foregroundColor(.secondary)
//                    }
//                }
//
//            }
//
//        }
//        Button(action: {
//            notificationOnCertainDay(day:5)
//        }) {
//            Text("Get a Pokemon Fact")
//                .font(.headline)
//                .foregroundColor(.white)
//                .padding(5)
//                .background(Color.blue)
//                .cornerRadius(8)
//        }
//    }
//
//    func notificationOnCertainDay(day: Int) {
//        let content = UNMutableNotificationContent()
//        content.title = "It's Pokemon time"
//        content.body = "It's Pokemon time"
//        content.sound = UNNotificationSound.defaultRingtone
//
//        let calendar = Calendar.current
//        var dateComponents = DateComponents()
//        dateComponents.day = day // set the day you want the notification to trigger
//        dateComponents.hour = 9 // set the hour
//        dateComponents.minute = 0 // set the minute
//
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
//    }
//
//}
