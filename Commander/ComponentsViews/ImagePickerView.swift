import SwiftUI
import PhotosUI
struct ImagePickerView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @Binding var selectedImageData: Data?
    var onImageSelected: ((UIImage) -> Void)? = nil

    var body: some View {
        VStack {
            
            if let imageData = selectedImageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
            } else {
         
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.gray)
            }

            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Text("Select Image")
                   
                    .customButton(typeBtn: .primary, width: 160, height: 50, cornerRadius: 15)
            }
            .padding(24)
            .onChange(of: selectedItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        selectedImageData = data
                        if let image = UIImage(data: data) {
                            onImageSelected?(image)
                        }
                    }

                }
            }
        }

    }
}




