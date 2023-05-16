//
//  pokemon.swift
//  Pokedex_App_MobileCA2
//
//  Created by Student on 16/05/2023.
// The api link to get first 151 pokemon aka first gen pokemon only   https://pokeapi.co/api/v2/pokemon/?offset=0&limit=151

import Foundation

struct Pokemon : Codable{
    var results: [PokemonEntry]
}

struct PokemonEntry : Codable, Identifiable  {
    let id = UUID()
    var name: String
    var url: String
}

class PokeApi  {

    func getData(completion:@escaping ([PokemonEntry]) -> ()) {
        
        //load this string which is api request to pokeapi for first gen pokemon
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=151") else {
            
        //if null return out of this block
        return
            
        }
        
        //only using data
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            let pokemonList = try! JSONDecoder().decode(Pokemon.self, from: data)
            
            DispatchQueue.main.async {
                completion(pokemonList.results)
            }
        }.resume()
    }
}
