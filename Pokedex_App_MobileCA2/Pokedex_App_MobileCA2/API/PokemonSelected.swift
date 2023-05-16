import Foundation

struct PokemonSelected : Codable {
    var sprites: PokemonSprites
    var weight: Int
}

struct PokemonSprites : Codable {
    var front_default: String?
}

class PokemonSelectedApi  {
    func getData(url: String, completion:@escaping (PokemonSprites) -> ()) {
        
        //load this string which is api request to pokeapi for first gen pokemon
        guard let url = URL(string: url) else { return }
        
        //only using data
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            let pokemonSprite = try! JSONDecoder().decode(PokemonSelected.self, from: data)
            
            DispatchQueue.main.async {
                completion(pokemonSprite.sprites)
            }
        }.resume()
    }
}
