//
//  DetailView.swift
//  Pokedex_App_MobileCA2
//
//  Created by Student on 16/05/2023.
//
import SwiftUI

struct DetailView: View {
    let pokemonEntry: PokemonEntry
    @State var pokemonSelected: PokemonSelected?

    var body: some View {
        VStack {
            if let pokemonSelected = pokemonSelected {
                // Display the Pokemon sprite and name here
                Text(pokemonEntry.name.capitalized)
                    .font(.largeTitle)
                    .padding()
                if let spriteURL = pokemonSelected.sprites.front_default {
                    //PokemonImage(url: spriteURL)
                    //    .padding(.bottom, 20)
                }
            } else {
                Text("Loading...")
            }
        }
        .onAppear {
            
            }
        }
    }



