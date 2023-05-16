//
//  DetailView.swift
//  Pokedex_App_MobileCA2
//
//  Created by Student on 16/05/2023.
//
import SwiftUI



struct DetailView: View {
    
    @State var sprites = [PokemonSprites]()
    @State var pokemon = [PokemonEntry]()
    let pokemonName: String
    let url = "https://pokeapi.co/api/v2/pokemon/"
    
    var body: some View {
        // Add pokemonName to end of url to pull data from
        let url = "https://pokeapi.co/api/v2/pokemon/"+pokemonName
        Text("Detail view for \(pokemonName)")
        Text("Call PokeAPI with url ending in pokemonName ->"+pokemonName)
        
        ForEach(pokemon.filter( {$0.name.contains(pokemonName)} )) {
            entry in
            
            HStack {
                PokemonImage(imageLink: "\(entry.url)")
                    .padding(.trailing, 20)
                
            }
        }
        
        
        
        
            .onAppear {
                PokeApi().getData() { pokemon in
                    self.pokemon = pokemon
                }
            }
    }
    
    
    //    func getSelectedPokemonSprite(url: String) {
    //        var tempSprite: String?
    //        PokemonSelectedApi().getData(url: url) { sprite in
    //            tempSprite = sprite.front_default
    //        }
    //
    //    }
    
    //    func getSelectedPokemonData(_: pokemonName) {
    //
    //        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/"+pokemonName) else {
    //
    //            //if null return out of this block
    //            return
    //
    //        }
    //
    //        //only using data
    //        URLSession.shared.dataTask(with: url) { (data, response, error) in
    //            guard let data = data else { return }
    //
    //            let pokemonList = try! JSONDecoder().decode(Pokemon.self, from: data)
    //
    //            DispatchQueue.main.async {
    //                completion(pokemonList.results)
    //            }
    //        }.resume()
    //    }
    
    
}
