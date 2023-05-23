//  PersonalPokedexView.swift
//  Pokedex_App2_MobileCA2
//
//  Created by Student on 23/05/2023.
//

import Foundation
import SwiftUI

struct PersonalPokedexView: View {
    @Binding var pokemonList: [PokemonT]

    var body: some View {
        List(pokemonList) { pokemon in
            VStack {
                HStack {
                    pokemon.image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 80)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        .padding(5)
                    VStack(alignment: .leading) {
                        Text(pokemon.name)
                            .font(.headline)
                        Text(pokemon.type)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(pokemon.ability)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        Text("Age: \(pokemon.age)")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}
