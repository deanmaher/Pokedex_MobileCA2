//
//  ContentView.swift
//  Pokedex_App2_MobileCA2
//
//  Created by Student on 17/05/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = ViewModel()
    //    @ObservedObject var viewModel: ViewModel
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 150))
    ]
    @State private var types: [String] = [] //20
    
    var body: some View {
        NavigationView {
            ScrollView {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(types, id: \.self) { type in
                            Button(action: {
                                print("\(type) tapped")
                            }) {
                                Text("\(type)")
                                    .padding()
                                    .background(Color(red: 0.5, green: 0.3, blue: 0.1))
                                    .foregroundColor(.white)
                                    .cornerRadius(50)
                            }
                        }
                    }.padding()
                }
                
                LazyVGrid(columns: adaptiveColumns, spacing: 10) {
                    ForEach(vm.filteredPokemon) { pokemon in
                        NavigationLink(destination: PokemonDetailView(pokemon: pokemon)
                        ) {
                            PokemonView(pokemon: pokemon)
                        }
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: vm.filteredPokemon.count)
                .navigationTitle("Pokedex")
                .navigationBarTitleDisplayMode(.inline)
            }
            .searchable(text: $vm.searchText)
        }.onAppear {
            fetchPokemonTypes()
        }
        .environmentObject(vm)
    }
    
    func fetchPokemonTypes() {
        guard let url = URL(string: "https://pokeapi.co/api/v2/type") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error: \(error)")
                return
            }

            if let data = data {
                do {
                    let response = try JSONDecoder().decode(PokemonTypeResponse.self, from: data)
                    DispatchQueue.main.async {
                        types = response.results.map { $0.name }
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            }
        }.resume()
    }
    
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
