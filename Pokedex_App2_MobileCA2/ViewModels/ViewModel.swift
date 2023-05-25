//
//  ViewModel.swift
//  Pokedex_App2_MobileCA2
//
//  Created by Student on 17/05/2023.
//

import Foundation

import SwiftUI

class ViewModel: ObservableObject {
    let pokemonManager = PokemonManager()
    
    @Published var pokemonList = [Pokemon]()
    @Published var pokemonDetails: DetailPokemon?
    @Published var searchText = ""
    @Published var pokemonOfType = [PokemonTypeDetail]()
    @Published var colourType = ""
    
    func fetchPokemonByType(type: String) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/type/\(type)") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(PokemonTypeResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.pokemonList = response.pokemon.map {
                            _ = Int($0.pokemon.url.split(separator: "/").last ?? "0") ?? 0
                            return Pokemon(name: $0.pokemon.name, url: $0.pokemon.url)
                        }
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            }
        }.resume()
    }
    
    func fetchPokemonOfType(type: String) {
        pokemonManager.fetchPokemonOfType(type: type) { [weak self] data in
            DispatchQueue.main.async {
                self?.pokemonList = data
            }
        }
    }
    
    func getPokemonOfType2(typeName: String) {
        Bundle.main.fetchData(url: "https://pokeapi.co/api/v2/type/\(typeName)", model: PokemonTypeResponse.self) { data in
            let pokemonDetails = data.pokemon.map { $0.pokemon }
            DispatchQueue.main.async {
                self.pokemonList = pokemonDetails
            }
        } failure: { error in
            print(error)
        }
    }
    
    func getPokemonOfType(typeName: String) {
        self.pokemonOfType = []
        pokemonManager.getPokemonTypeDetail(typeName: typeName) { data in
            DispatchQueue.main.async {
                self.pokemonOfType = data.pokemon
            }
        }
    }
    // Used with searchText to filter pokemon results
    var filteredPokemon: [Pokemon] {
        return searchText == "" ? pokemonList : pokemonList.filter { $0.name.contains(searchText.lowercased()) }
    }
    
    init() {
        self.pokemonList = pokemonManager.getPokemon()
        self.pokemonDetails = nil
    }
    
    
    // Get the index of a pokemon ( index + 1 = pokemon id)
    func getPokemonIndex(pokemon: Pokemon) -> Int {
        if let index = self.pokemonList.firstIndex(of: pokemon) {
            return index + 1
        }
        return 0
    }
    
    // Get specific details for a pokemon
    func getDetails(pokemon: Pokemon) {
        guard let id = Int(pokemon.id) else {
            print("Invalid ID: \(pokemon.id)")
            return
        }
        
        self.pokemonDetails = nil
        pokemonManager.getDetailedPokemon(id: id) { data in
            DispatchQueue.main.async {
                self.pokemonDetails = data
                self.colourType = data.types.first?.type.name ?? ""
            }
        }
    }
    // Formats the Height or the Weight of a given pokemon
    func formatHW(value: Int) -> String {
        let dValue = Double(value)
        let string = String(format: "%.2f", dValue / 10)
        
        return string
    }
}
