import SwiftUI

struct PokemonT: Identifiable, Codable {
    var id = UUID()
    var name: String
    var type: String
    var ability: String
    var age: String
    var imageData: Data
    var image: Image {
        Image(uiImage: UIImage(data: imageData)!)
    }
}

struct HomeView: View {
    @State private var pokemonList: [PokemonT] = []

    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                Image("pokedex")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                
                NavigationLink(destination: ContentView(pokemonList: $pokemonList)) {
                    Text("Pokedex")
                        .font(.headline)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.yellow)
                        .cornerRadius(10)
                }
                .padding(.bottom)
                
                
                NavigationLink(destination: PersonalPokedexView(pokemonList: $pokemonList)) {
                    Text("My Pokedex")
                        .font(.headline)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .padding(.bottom)

                NavigationLink(destination: CreatePokemonView(pokemonList: $pokemonList)) {
                    Text("Create Pokemon")
                        .font(.headline)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }

                Spacer()
            }
            .padding()
            .onAppear {
                loadPokemon()
            }
        }
    }

    func loadPokemon() {
        let filename = getDocumentsDirectory().appendingPathComponent("SavedPokemon")

        do {
            let data = try Data(contentsOf: filename)
            let decodedData = try JSONDecoder().decode([PokemonT].self, from: data)
            self.pokemonList = decodedData
        } catch {
            print("Could not load saved data.")
        }
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}





struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
