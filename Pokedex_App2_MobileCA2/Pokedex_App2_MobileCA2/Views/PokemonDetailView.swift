//
//  PokemonDetailView.swift
//  Pokedex_App2_MobileCA2
//
//  Created by Student on 17/05/2023.
//

import Foundation
import SwiftUI
import AVFoundation


struct PokemonDetailView: View {
    @EnvironmentObject var vm: ViewModel
    @State private var audioPlayer: AVAudioPlayer?

    let pokemon: Pokemon
    
    var body: some View {
        VStack {
            PokemonView(pokemon: pokemon)
            
            VStack(spacing: 10) {
                Text("Pokemon ID: \(vm.pokemonDetails?.id ?? 0)")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                Text("Weight: \(vm.formatHW(value: vm.pokemonDetails?.weight ?? 0)) KG")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                Text("Height: \(vm.formatHW(value: vm.pokemonDetails?.height ?? 0)) M")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                Text("Base Experience: \( vm.pokemonDetails?.base_experience ?? 0) exp")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
            .padding()
        }
        .onAppear {
            vm.getDetails(pokemon: pokemon)
        }
    }
}

//func playSound() {
//    guard let soundURL = Bundle.main.url(forResource: "soundFileName", withExtension: "mp3") else {
//        fatalError("Sound file not found")
//    }
//    
//    do {
//        audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
//        audioPlayer?.play()
//    } catch {
//        fatalError("Unable to create audio player: \(error.localizedDescription)")
//    }
//}
//}

struct PokemonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetailView(pokemon: Pokemon.samplePokemon)
            .environmentObject(ViewModel())
    }
}
