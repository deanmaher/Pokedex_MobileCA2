//
 //  PokemonDetailView.swift
 //  Pokedex_App2_MobileCA2
 //
 //  Created by Student on 17/05/2023.
 //

 import Foundation
 import SwiftUI

 struct PokemonDetailView: View {
     @EnvironmentObject var vm: ViewModel
     let pokemon: Pokemon

     var body: some View {
         VStack {
             PokemonView(pokemon: pokemon)

             VStack(spacing: 10) {
                 Text("**ID**: \(vm.pokemonDetails?.id ?? 0)")
                 Text("**Weight**: \(vm.formatHW(value: vm.pokemonDetails?.weight ?? 0)) KG")
                 Text("**Height**: \(vm.formatHW(value: vm.pokemonDetails?.height ?? 0)) M")
                 Text("**Base XP**: \(vm.pokemonDetails?.base_experience ?? 0)")

                 if let types = vm.pokemonDetails?.types {
                     ForEach(types, id: \.slot) { pokemonType in
                         Text("**Type**: \(pokemonType.type.name)")
                     }
                 } else {
                     Text("**Type**: Base")
                 }
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

 struct PokemonDetailView_Previews: PreviewProvider {
     static var previews: some View {
         PokemonDetailView(pokemon: Pokemon.samplePokemon)
             .environmentObject(ViewModel())
     }
 }
