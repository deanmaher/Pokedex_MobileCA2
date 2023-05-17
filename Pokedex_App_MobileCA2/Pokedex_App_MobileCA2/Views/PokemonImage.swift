
import SwiftUI

struct PokemonImage: View {
    var imageLink = ""
    @State private var pokemonSprite = ""
    @State private var pokemonWeight = 0
    
    var body: some View {
        AsyncImage(url: URL(string: pokemonSprite))
            .frame(width: 75, height: 75)
            .onAppear {
                let loadedData = UserDefaults.standard.string(forKey: imageLink)
                let loadedData2 = UserDefaults.standard.int(forKey: pokemonWeight)
                if loadedData == nil {
                    getSprite(url: imageLink)
                    getWeight(url: pokemonWeight)
                    UserDefaults.standard.set(imageLink, forKey: imageLink)
                    //print("New url!!! Caching...")
                } else {
                    getSprite(url: loadedData!)
                    //print("Using cached url...")
                }
                //print(pokemonSprite)
            }
            .clipShape(Circle())
            .foregroundColor(Color.gray.opacity(0.60))
            .scaledToFit()
        
    }
    
    func getWeight(url: String){
        var tempWeight: Int?
        PokemonGetSpriteApi2().getData(url: url) { weight in
            tempWeight = weight.weight
            self.pokemonWeight = tempWeight ?? 9999
        }
    }
    
    func getSprite(url: String) {
        var tempSprite: String?
        PokemonGetSpriteApi().getData(url: url) { sprite in 
            tempSprite = sprite.front_default
            self.pokemonSprite = tempSprite ?? "placeholder"
        }
        
    }
}

struct PokemonDetail_Previews: PreviewProvider {
    static var previews: some View {
        PokemonImage()
            .previewInterfaceOrientation(.portrait)
    }
}
