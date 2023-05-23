//
//  PokemonManager.swift
//  Pokedex_App2_MobileCA2
//
//  Created by Student on 17/05/2023.
//

import Foundation

class PokemonManager {
    func getPokemon() -> [Pokemon] {
        let data: PokemonPage = Bundle.main.decode(file:"pokemon.json")
        let pokemon: [Pokemon] = data.results
        
        return pokemon
    }
    
    func getDetailedPokemon(id: Int, _ completion:@escaping (DetailPokemon) -> ()) {
        Bundle.main.fetchData(url: "https://pokeapi.co/api/v2/pokemon/\(id)/", model: DetailPokemon.self) { data in
            completion(data)
            print(data)
            
        } failure: { error in
            print(error)
        }
    }
    
    func fetchPokemonOfType(type: String, _ completion:@escaping ([Pokemon]) -> ()) {
        Bundle.main.fetchData(url: "https://pokeapi.co/api/v2/type/\(type)/", model: PokemonTypeDetailResponse.self) { data in
            let pokemonList = data.pokemon.map { $0.pokemon }
            completion(pokemonList)
        } failure: { error in
            print(error)
        }
    }
    
    func getPokemonTypeDetail(typeName: String, _ completion:@escaping (PokemonTypeDetailResponse) -> ()) {
        Bundle.main.fetchData(url: "https://pokeapi.co/api/v2/type/\(typeName)/", model: PokemonTypeDetailResponse.self) { data in
            completion(data)
            print(data)
        } failure: { error in
            print(error)
        }
    }
    
}
