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

                 NavigationLink(destination: PokedexView(pokemonList: $pokemonList)) {
                     Text("Pokedex")
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

 struct CreatePokemonView: View {
     @State private var showingImagePicker = false
     @State private var inputImage: UIImage?
     @State private var name: String = ""
     @State private var type: String = ""
     @State private var ability: String = ""
     @State private var age: String = ""
     @Binding var pokemonList: [PokemonT]

     var body: some View {
         VStack {
             if let inputImage = inputImage {
                 Image(uiImage: inputImage)
                     .resizable()
                     .scaledToFit()
                     .frame(height: 200)
                     .clipShape(Circle())
                     .padding()
             }

             TextField("Name", text: $name)
             TextField("Type", text: $type)
             TextField("Ability", text: $ability)
             TextField("Age", text: $age)

             Button("Select Image") {
                 self.showingImagePicker = true
             }
             .padding()
             .foregroundColor(.white)
             .background(Color.blue)
             .cornerRadius(10)

             Button("Save Pokemon") {
                 guard let inputImage = inputImage else { return }
                 let newPokemon = PokemonT(name: name, type: type, ability: ability, age: age, imageData: inputImage.pngData()!)
                 pokemonList.append(newPokemon)
                 savePokemon()
             }
             .padding()
             .foregroundColor(.white)
             .background(Color.green)
             .cornerRadius(10)
         }
         .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
             ImagePicker(image: self.$inputImage)
         }
     }

     func loadImage() {
         guard let inputImage = inputImage else { return }
         self.inputImage = inputImage
     }

     func savePokemon() {
         let filename = getDocumentsDirectory().appendingPathComponent("SavedPokemon")

         do {
             let data = try JSONEncoder().encode(self.pokemonList)
             try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
         } catch {
             print("Could not save data.")
         }
     }

     func getDocumentsDirectory() -> URL {
         let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
         return paths[0]
     }
 }

 struct ImagePicker: UIViewControllerRepresentable {
     @Binding var image: UIImage?
     @Environment(\.presentationMode) var presentationMode

     class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
         let parent: ImagePicker

         init(_ parent: ImagePicker) {
             self.parent = parent
         }

         func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
             if let uiImage = info[.originalImage] as? UIImage {
                 parent.image = uiImage
             }

             parent.presentationMode.wrappedValue.dismiss()
         }
     }

     func makeCoordinator() -> Coordinator {
         Coordinator(self)
     }

     func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
         let picker = UIImagePickerController()
         picker.delegate = context.coordinator
         return picker
     }

     func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
     }
 }

 struct PokedexView: View {
     @Binding var pokemonList: [PokemonT]

     var body: some View {
         List(pokemonList) { pokemon in
             HStack {
                 pokemon.image
                     .resizable()
                     .scaledToFit()
                     .frame(height: 50)
                 VStack(alignment: .leading) {
                     Text(pokemon.name)
                     Text(pokemon.type)
                     Text(pokemon.ability)
                     Text(pokemon.age)
                 }
             }
         }
     }
 }

 struct HomeView_Previews: PreviewProvider {
     static var previews: some View {
         HomeView()
     }
 }
