//
//  CaptureImageView.swift
//  Inventory
//
//  Created by Smay on 5/10/23.
//

import SwiftUI

// No damn clue how to do this in SwiftUI, so I stole this whole view from https://iosapptemplates.com/blog/swiftui/photo-camera-swiftui

struct CaptureImageView {
    /// MARK: - Properties
        @Binding var image: UIImage?
    @Binding var sourceType: UIImagePickerController.SourceType
        @Environment(\.dismiss) var dismiss
        func makeCoordinator() -> Coordinator {
            return Coordinator(image: $image, dismiss: dismiss)
        }
}
extension CaptureImageView: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<CaptureImageView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<CaptureImageView>) {
        
    }
}

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  @Binding var imageInCoordinator: UIImage?
    var dismiss: DismissAction
    init(image: Binding<UIImage?>, dismiss: DismissAction) {
    _imageInCoordinator = image
        self.dismiss = dismiss
  }
  func imagePickerController(_ picker: UIImagePickerController,
                didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
     guard let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
     imageInCoordinator = unwrapImage
      dismiss()
  }
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      dismiss()
  }
}

struct CaptureImageView_Previews: PreviewProvider {
    static var previews: some View {
        CaptureImageView(image: Binding.constant(nil), sourceType: Binding.constant(.photoLibrary))
    }
}
