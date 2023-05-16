

import SwiftUI

struct ContentView: View {
    @State var pokemon = [PokemonEntry]()
    @State var searchText = ""
    
    
    var body: some View {
        NavigationView {
            
            List {
                //if search bar is blank show all pokemon
                ForEach(searchText == "" ? pokemon: pokemon.filter( {$0.name.contains(searchText.lowercased())} )) {
                    entry in
                    
                    HStack {
                        PokemonImage(imageLink: "\(entry.url)")
                            .padding(.trailing, 20)
                        
                        NavigationLink("\(entry.name)".capitalized ,destination: DetailView(pokemonName: entry.name))
                    }
                }
            }
            
            .onAppear {
                PokeApi().getData() { pokemon in
                    self.pokemon = pokemon
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Pokedex")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
