//
//  ImagePickerView.swift
//  Inventory
//
//  Created by Smay on 5/10/23.
//

import SwiftUI
import UIKit
import PhotosUI

struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var image: UIImage?

        func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerView>) -> UIImagePickerController {
            var config = PHPickerConfiguration()
            config.filter = .images
            let picker = UIImagePickerController()
            picker.delegate = context.coordinator as? any UIImagePickerControllerDelegate & UINavigationControllerDelegate
            //picker.sourceType = .camera
            return picker
        }

        func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePickerView>) {

        }

        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }

        class Coordinator: NSObject, UIImagePickerControllerDelegate {
            let parent: ImagePickerView

            init(_ parent: ImagePickerView) {
                self.parent = parent
            }

            func picker(_ picker: UIImagePickerControllerDelegate, didFinishPicking results: [PHPickerResult]) {
                //picker.dismiss(animated: true)

                guard let provider = results.first?.itemProvider else { return }

                if provider.canLoadObject(ofClass: UIImage.self) {
                    provider.loadObject(ofClass: UIImage.self) { image, _ in
                        self.parent.image = image as? UIImage
                    }
                }
            }
        }
}

struct ImagePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePickerView(image: Binding.constant(nil))
    }
}
