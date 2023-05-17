import Foundation

struct PokemonGetSprite : Codable {
    var sprites: PokemonSprites
//    var weight: Int
}

struct PokemonGetWeight : Codable {
    var weight: PokemonWeight
}

struct PokemonWeight : Codable  {
    var weight: Int?
}

struct PokemonSprites : Codable {
    var front_default: String?
}

class PokemonGetSpriteApi2  {
    func getData(url: String, completion:@escaping (PokemonWeight) -> ()) {
        
        //load this string which is api request to pokeapi for first gen pokemon
        guard let url = URL(string: url) else { return }
        
        //only using data
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            let pokemonWeight = try! JSONDecoder().decode(PokemonGetWeight.self, from: data)
            
            DispatchQueue.main.async {
                
                completion(pokemonWeight.weight)
            }
        }.resume()
    }
}

class PokemonGetSpriteApi  {
    func getData(url: String, completion:@escaping (PokemonSprites) -> ()) {
        
        //load this string which is api request to pokeapi for first gen pokemon
        guard let url = URL(string: url) else { return }
        
        //only using data
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            let pokemonSprite = try! JSONDecoder().decode(PokemonGetSprite.self, from: data)
            
            DispatchQueue.main.async {
                completion(pokemonSprite.sprites)
            }
        }.resume()
    }
}
