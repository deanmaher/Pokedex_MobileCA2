//
//  PokemonModel.swift
//  Pokedex_App2_MobileCA2
//
//  Created by Student on 17/05/2023.
//

import Foundation

struct PokemonPage: Codable {
    let count: Int
    let next: String
    let results: [Pokemon]
}

struct Pokemon: Codable, Identifiable, Equatable {
    let id = UUID()
    let name: String
    let url: String
    
    static var samplePokemon = Pokemon(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/")
}

struct DetailPokemon: Codable {
    //can pull more info if needed eg base stat
    let id: Int
    let height: Int
    let weight: Int
}
