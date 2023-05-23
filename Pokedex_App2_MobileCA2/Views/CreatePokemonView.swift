import Foundation
import SwiftUI

struct CreatePokemonView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showingImagePicker = false
    @State private var showingCamera = false  // NEW: for presenting the camera
    @State private var inputImage: UIImage?
    @State private var name: String = ""
    @State private var type: String = ""
    @State private var ability: String = ""
    @State private var age: String = ""
    @Binding var pokemonList: [PokemonT]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    if let inputImage = inputImage {
                        Image(uiImage: inputImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                            .padding()
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .foregroundColor(.gray)
                            .padding()
                    }

                    Group {
                        TextField("Name", text: $name)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        TextField("Type", text: $type)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        TextField("Ability", text: $ability)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        TextField("Age", text: $age)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }.padding(.horizontal)

                    Button(action: { self.showingImagePicker = true }) {
                        HStack {
                            Image(systemName: "photo")
                            Text("Select Image")
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                    .padding()

                    Button(action: { self.showingCamera = true }) {
                        HStack {
                            Image(systemName: "camera")
                            Text("Take Photo")
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                    .padding()
                    .disabled(!UIImagePickerController.isSourceTypeAvailable(.camera))

                    Button(action: { savePokemon() }) {
                        Text("Save Pokemon")
                            .fontWeight(.bold)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .disabled(name.isEmpty || type.isEmpty || ability.isEmpty || age.isEmpty || inputImage == nil)
                    .opacity((name.isEmpty || type.isEmpty || ability.isEmpty || age.isEmpty || inputImage == nil) ? 0.5 : 1.0)
                    .padding()
                }
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage, sourceType: .photoLibrary)  // Adjusted to explicitly set sourceType
            }
            .sheet(isPresented: $showingCamera, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage, sourceType: .camera)  // NEW: for capturing photo with camera
            }
        }
    }

    func loadImage() {
        guard let inputImage = inputImage else { return }
        self.inputImage = inputImage
    }

    func savePokemon() {
        let filename = getDocumentsDirectory().appendingPathComponent("SavedPokemon")

        do {
            let newPokemon = PokemonT(name: name, type: type, ability: ability, age: age, imageData: inputImage!.pngData()!)
            pokemonList.append(newPokemon)
            let data = try JSONEncoder().encode(self.pokemonList)
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
            self.presentationMode.wrappedValue.dismiss()
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
    var sourceType: UIImagePickerController.SourceType  // NEW: for specifying the source

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
        picker.sourceType = sourceType  // Set the source type when creating the controller
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
}
