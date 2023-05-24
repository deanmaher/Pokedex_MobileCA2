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

struct Pokemon: Codable, Identifiable, Equatable{
    var id: String {
        String(url.split(separator: "/").last ?? "")
    }
    let name: String
    let url: String
}

struct PokemonResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Pokemon]
}

struct DetailPokemon: Codable {
    let id: Int
    let height: Int
    let weight: Int
    let base_experience: Int
    let types: [PokemonTypes]
    let stats: [PokemonStats]
}

struct PokemonStats: Codable {
     let base_stat: Int
     let effort: Int
     let stat: StatData
 }

 struct StatData: Codable {
     let name: String
     let url: String
 }


struct PokemonTypes: Codable {
    let slot: Int
    let type: TypeData
}

struct TypeData: Codable {
    let name: String
    let url: String
}

struct TypeResponse: Codable {
    let results: [Pokemon]
}

struct PokemonTypeResponse: Codable {
    let pokemon: [PokemonTypeDetail]
}


struct PokemonTypeDetailResponse: Codable {
    let pokemon: [PokemonTypeDetail]
}

struct PokemonTypeDetail: Codable {
    let pokemon: Pokemon
}



