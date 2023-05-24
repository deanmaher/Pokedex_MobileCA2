import Foundation
import SwiftUI
import AVFoundation

struct PokemonDetailView: View {
    @EnvironmentObject var vm: ViewModel
    @Binding var pokemonList2: [PokemonT]
    let pokemon: Pokemon
    @State private var audioPlayer: AVAudioPlayer?
    
    var body: some View {
        VStack {
            PokemonView(pokemon: pokemon,dimensions: 250)
                .padding(.top)
            Button(action: {
                playAudio()
            }) {
                Text("Play Audio")
            }
            TabView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Group {
                            Text("About").font(.title2).fontWeight(.bold)
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
                    }
                }
                .tabItem {
                    Label("About", systemImage: "info.circle.fill")
                }
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Base Stats").font(.title2).fontWeight(.bold)
                        if let types = vm.pokemonDetails?.types {
                            ForEach(types, id: \.slot) { pokemonType in
                                DetailRow(title: "Type", value: "\(pokemonType.type.name.capitalized)")
                            }
                        } else {
                            DetailRow(title: "Type", value: "Base")
                        }
                        
                        if let stats = vm.pokemonDetails?.stats {
                            ForEach(stats, id: \.stat.name) { pokemonStat in
                                DetailRow(title: pokemonStat.stat.name.capitalized, value: "\(pokemonStat.base_stat)")
                            }
                        }
                    }
                }
                .tabItem {
                    Label("Base Stats", systemImage: "info")
                }
            }
            .padding()
        }
        .onAppear {
            vm.getDetails(pokemon: pokemon)
            if let soundURL = Bundle.main.url(forResource: "1", withExtension: "mp3") {
                audioPlayer = try? AVAudioPlayer(contentsOf: soundURL)
            }
        }
        .navigationTitle(Text(pokemon.name.capitalized))
        .navigationBarTitleDisplayMode(.inline)
    }

    func playAudio() {
        print("play audio")
        audioPlayer?.play()
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
