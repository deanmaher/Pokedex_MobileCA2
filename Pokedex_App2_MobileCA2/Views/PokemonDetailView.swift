import Foundation
import SwiftUI
import AVFoundation

struct PokemonDetailView: View {
    @EnvironmentObject var vm: ViewModel
    @Binding var pokemonList2: [PokemonT]
    let pokemon: Pokemon
    @State private var audioPlayer: AVAudioPlayer?
    @State private var  typeColour: String?
    
    var body: some View {
        VStack {
            PokemonView(pokemon: pokemon,dimensions: 150)
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
                    }.padding(.bottom)
                }
                .tabItem {
                    Label("Base Stats", systemImage: "info")
                }
            }
            .padding()
            .background(Color.white)
            .clipShape(RoundCorners(radius: 30, corners: [.topLeft, .topRight]))
        }
        .onAppear {
            vm.getDetails(pokemon: pokemon)
            let audioSession = AVAudioSession.sharedInstance()
                do {
                    try audioSession.setCategory(.playback)
                } catch {
                    print("Setting up audio session failed: \(error)")
                }
            
            if let soundURL = Bundle.main.url(forResource: "audio/pokemon cries_mixdown_Track \(pokemon.id)", withExtension: "mp3") {
                    do {
                        audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                    } catch {
                        print("Audio player initialization failed: \(error)")
                    }
                } else {
                    print("File not found")
                }
        }
        .navigationTitle(Text(pokemon.name.capitalized))
        .navigationBarTitleDisplayMode(.inline)
        .background(backgroundTypeColour(vm.colourType).ignoresSafeArea())
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

struct RoundCorners: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

func backgroundTypeColour(_ type: String) -> Color {
    switch type {
    case "normal":
        return Color(red: 168/255, green: 167/255, blue: 122/255)
    case "fire":
        return  Color(red: 238/255, green: 129/255, blue: 48/255)
    case "water":
        return Color(red: 99/255, green: 144/255, blue: 240/255)
    case "electric":
        return  Color(red: 247/255, green: 208/255, blue: 44/255)
    case "grass":
        return Color(red: 122/255, green: 199/255, blue: 76/255)
    case "ice":
        return Color(red: 150/255, green: 217/255, blue: 214/255)
    case "fighting":
        return Color(red: 194/255, green: 46/255, blue: 40/255)
    case "poison":
        return Color(red: 163/255, green: 62/255, blue: 161/255)
    case "ground":
        return Color(red: 226/255, green: 191/255, blue: 101/255)
    case "flying":
        return Color(red: 169/255, green: 143/255, blue: 243/255)
    case "psychic":
        return Color(red: 249/255, green: 85/255, blue: 135/255)
    case "bug":
        return Color(red: 166/255, green: 185/255, blue: 26/255)
    case "rock":
        return Color(red: 182/255, green: 161/255, blue: 54/255)
    case "ghost":
        return Color(red: 115/255, green: 87/255, blue: 151/255)
    case "dragon":
        return Color(red: 111/255, green: 53/255, blue: 252/255)
    case "dark":
        return Color(red: 112/255, green: 87/255, blue: 70/255)
    case "steel":
        return Color(red: 183/255, green: 183/255, blue: 206/255)
    case "fairy":
        return Color(red: 214/255, green: 133/255, blue: 173/255)
    default:
        return Color.gray
    }
}

//struct PokemonDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        PokemonDetailView(pokemon: Pokemon.samplePokemon)
//            .environmentObject(ViewModel())
//    }
//}
