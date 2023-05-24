//import Foundation
//import SwiftUI
//import AVFoundation
//
//struct PokemonDetailView: View {
//    @EnvironmentObject var vm: ViewModel
//    @Binding var pokemonList2: [PokemonT]
//    let pokemon: Pokemon
//    var type = "base"
//    @State private var audioPlayer: AVAudioPlayer?
//    
//    var body: some View {
//        ScrollView {
//            VStack {
//                PokemonView(pokemon: pokemon,dimensions: 250)
//                    .padding(.top)
//                
//                VStack(alignment: .leading, spacing: 20) {
//                    Group {
//                        Text("Details").font(.title2).fontWeight(.bold)
//                        DetailRow(title: "ID", value: "\(vm.pokemonDetails?.id ?? 0)")
//                        DetailRow(title: "Weight", value: "\(vm.formatHW(value: vm.pokemonDetails?.weight ?? 0)) KG")
//                        DetailRow(title: "Height", value: "\(vm.formatHW(value: vm.pokemonDetails?.height ?? 0)) M")
//                        
//                        VStack(alignment: .leading) {
//                            Text("Base XP:")
//                                .font(.headline)
//                                .foregroundColor(.gray)
//                            ProgressBar(value: Double(vm.pokemonDetails?.base_experience ?? 0) / 400)
//                            Text("\(vm.pokemonDetails?.base_experience ?? 0) / 400")
//                                .font(.footnote)
//                                .foregroundColor(.gray)
//                        }
//                    }
//                    
//                    
//                    if let types = vm.pokemonDetails?.types {
//                        ForEach(types, id: \.slot) { pokemonType in
//                            DetailRow(title: "Type", value: "\(pokemonType.type.name.capitalized)")
//                            var type = pokemonType.type.name
//                            let backColour = backgroundTypeColour(type)
//                            
//                        }
//                        
//                    } else {
//                        DetailRow(title: "Type", value: "Base")
//                    }
//                }
//                .padding()
//                .background(Color.white)
//                .clipShape(RoundCorners(radius: 30, corners: [.topLeft, .topRight]))
//                .padding(.vertical)
//            }
//            
//        }
//        
//        .onAppear {
//            vm.getDetails(pokemon: pokemon)
//            if let soundURL = Bundle.main.url(forResource: "1", withExtension: "mp3") {
//                             audioPlayer = try? AVAudioPlayer(contentsOf: soundURL)
//                         }
//        }
//        .navigationTitle(Text(pokemon.name.capitalized))
//        .navigationBarTitleDisplayMode(.inline)
//        .background(Color.red.ignoresSafeArea())
//    }
//    
//    
//    func playAudio() {
//        print("play audio")
//        audioPlayer?.play()
//    }
//}
//
//struct DetailRow: View {
//    var title: String
//    var value: String
//    
//    var body: some View {
//        HStack {
//            Text(title + ":").font(.headline).foregroundColor(.gray)
//            Spacer()
//            Text(value).font(.body)
//        }
//    }
//}
//
//struct ProgressBar: View {
//    var value: Double
//    
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack(alignment: .leading) {
//                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
//                    .opacity(0.3)
//                    .foregroundColor(Color(UIColor.systemTeal))
//                
//                Rectangle().frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width), height: geometry.size.height)
//                    .foregroundColor(Color(UIColor.systemTeal))
//                    .animation(.easeInOut(duration: 1))
//            }
//            .cornerRadius(45.0)
//        }
//    }
//}
//
//
//
//func getDocumentsDirectory() -> URL {
//    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//    return paths[0]
//}
//
//struct RoundCorners: Shape {
//    var radius: CGFloat = .infinity
//    var corners: UIRectCorner = .allCorners
//    
//    func path(in rect: CGRect) -> Path {
//        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//        return Path(path.cgPath)
//    }
//}
//func backgroundTypeColour(_ type: String) -> Color {
//    switch type {
//    case "normal":
//        return Color(red: 168/255, green: 167/255, blue: 122/255)
//    case "fire":
//        return  Color(red: 238/255, green: 129/255, blue: 48/255)
//    case "water":
//        return Color(red: 99/255, green: 144/255, blue: 240/255)
//    case "electric":
//        return  Color(red: 247/255, green: 208/255, blue: 44/255)
//    case "grass":
//        return Color(red: 122/255, green: 199/255, blue: 76/255)
//    case "ice":
//        return Color(red: 150/255, green: 217/255, blue: 214/255)
//    case "fighting":
//        return Color(red: 194/255, green: 46/255, blue: 40/255)
//    case "poison":
//        return Color(red: 163/255, green: 62/255, blue: 161/255)
//    case "ground":
//        return Color(red: 226/255, green: 191/255, blue: 101/255)
//    case "flying":
//        return Color(red: 169/255, green: 143/255, blue: 243/255)
//    case "psychic":
//        return Color(red: 249/255, green: 85/255, blue: 135/255)
//    case "bug":
//        return Color(red: 166/255, green: 185/255, blue: 26/255)
//    case "rock":
//        return Color(red: 182/255, green: 161/255, blue: 54/255)
//    case "ghost":
//        return Color(red: 115/255, green: 87/255, blue: 151/255)
//    case "dragon":
//        return Color(red: 111/255, green: 53/255, blue: 252/255)
//    case "dark":
//        return Color(red: 112/255, green: 87/255, blue: 70/255)
//    case "steel":
//        return Color(red: 183/255, green: 183/255, blue: 206/255)
//    case "fairy":
//        return Color(red: 214/255, green: 133/255, blue: 173/255)
//    default:
//        return Color.gray
//    }
//}
////struct PokemonDetailView_Previews: PreviewProvider {
////    static var previews: some View {
////        PokemonDetailView(pokemon: Pokemon.samplePokemon)
////            .environmentObject(ViewModel())
////    }
////}
