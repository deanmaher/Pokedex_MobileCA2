import Foundation
import SwiftUI

struct PersonalPokemonDetailView: View {
    @Binding var pokemon: PokemonT
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                pokemon.image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    .padding(5)
                
                Group {
                    Text("About").font(.title2).fontWeight(.bold)
                    DetailRow2(title: "ID", value: "\(pokemon.id)")
                    DetailRow2(title: "Weight", value: "\(pokemon.weight)")
                    DetailRow2(title: "Height", value: "\(pokemon.height)")

                    VStack(alignment: .leading) {
                        Text("Base XP:")
                            .font(.headline)
                            .foregroundColor(.gray)
                        ProgressBar2(value: Double(pokemon.baseXP)! / 400)
                        Text("\(pokemon.baseXP) / 400")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    DetailRow2(title: "Type", value: "\(pokemon.type)")
                }
            }
            .padding()
            .background(Color.white)
            .clipShape(RoundCorners2(radius: 30, corners: [.topLeft, .topRight]))
        }
        .navigationTitle(Text(pokemon.name.capitalized))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailRow2: View {
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

struct ProgressBar2: View {
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

struct RoundCorners2: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
