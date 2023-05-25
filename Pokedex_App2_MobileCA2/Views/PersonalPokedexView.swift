import SwiftUI

struct PersonalPokedexView: View {
    @Binding var pokemonList2: [PokemonT]

    var body: some View {
        NavigationView {
            List {
                ForEach(pokemonList2.indices, id: \.self) { index in
                    NavigationLink(destination: PersonalPokemonDetailView(pokemon: $pokemonList2[index])) {
                        HStack {
                            pokemonList2[index].image
                                .resizable()
                                .scaledToFit()
                                .frame(height: 80)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                                .padding(5)
                            VStack(alignment: .leading) {
                                Text(pokemonList2[index].name)
                                    .font(.headline)
                                Text(pokemonList2[index].type)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text(pokemonList2[index].height)
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                Text(pokemonList2[index].weight)
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                Text(pokemonList2[index].baseXP)
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: delete)
            }
        }
    }

    private func delete(at offsets: IndexSet) {
        pokemonList2.remove(atOffsets: offsets)
        savePokemon() // save the changes to the file
    }

    private func savePokemon() {
        let filename = getDocumentsDirectory().appendingPathComponent("SavedPokemon")

        do {
            let data = try JSONEncoder().encode(self.pokemonList2)
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Could not save data.")
        }
    }
    

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

