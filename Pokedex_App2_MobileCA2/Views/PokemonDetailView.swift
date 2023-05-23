import Foundation
import SwiftUI

struct PokemonDetailView: View {
    @EnvironmentObject var vm: ViewModel
    @Binding var pokemonList2: [PokemonT]
    let pokemon: Pokemon

    var body: some View {
        ScrollView {
            VStack {
                PokemonView(pokemon: pokemon,dimensions: 250)
                    .padding(.top)

                VStack(alignment: .leading, spacing: 20) {
                    Group {
                        Text("Details").font(.title2).fontWeight(.bold)
                        DetailRow(title: "ID", value: "\(vm.pokemonDetails?.id ?? 0)")
                        DetailRow(title: "Weight", value: "\(vm.formatHW(value: vm.pokemonDetails?.weight ?? 0)) KG")
                        DetailRow(title: "Height", value: "\(vm.formatHW(value: vm.pokemonDetails?.height ?? 0)) M")

                        VStack(alignment: .leading) {
                            Text("Base XP:")
                                .font(.headline)
                                .foregroundColor(.gray)
                            ProgressBar(value: Double(vm.pokemonDetails?.base_experience ?? 0) / 400)
                            Text("\(vm.pokemonDetails?.base_experience ?? 0) / 400")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }

                    if let types = vm.pokemonDetails?.types {
                        ForEach(types, id: \.slot) { pokemonType in
                            DetailRow(title: "Type", value: "\(pokemonType.type.name.capitalized)")
                        }
                    } else {
                        DetailRow(title: "Type", value: "Base")
                    }
                }
                .padding()
            }
        }
        .onAppear {
            vm.getDetails(pokemon: pokemon)
        }
        .navigationTitle(Text(pokemon.name.capitalized))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailRow: View {
    var title: String
    var value: String

    var body: some View {
        HStack {
            Text(title + ":").font(.headline).foregroundColor(.gray)
            Spacer()
            Text(value).font(.body)
        }
    }
}

struct ProgressBar: View {
    var value: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color(UIColor.systemTeal))

                Rectangle().frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color(UIColor.systemTeal))
                    .animation(.linear)
            }
            .cornerRadius(45.0)
        }
    }
}



func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}



//struct PokemonDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        PokemonDetailView(pokemon: Pokemon.samplePokemon)
//            .environmentObject(ViewModel())
//    }
//}
