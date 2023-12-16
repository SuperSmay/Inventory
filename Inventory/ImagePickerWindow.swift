//
//  ImagePickerWinder.swift
//  Inventory
//
//  Created by Smay on 12/15/23.
//

import SwiftUI
import PhotosUI
import CoreTransferable

struct ImagePickerWindow: View {
    
    @Binding var imageSelection: PhotosPickerItem?
    @Binding var imageState: ImageState
    @Binding var imageData: Data?
    
    @State var photoPickerShowing = false
    
    // Basically stolen from https://developer.apple.com/documentation/photokit/bringing_photos_picker_to_your_swiftui_app
    // Modified with information from https://www.hackingwithswift.com/quick-start/swiftui/how-to-let-users-select-pictures-using-photospicker
    enum ImageState {
        case empty
        case loading(Progress)
        case success(Data)
        case failure(Error)
        
        var toString: String {
            switch self {
                case .empty: return "Emtpy"
                case .loading: return "Loading"
                case .success: return "Success"
                case .failure: return "Failure"
                
            }
        }
        
    }
    
    var body: some View {
        VStack {
            Menu {
                
                Button {
                    photoPickerShowing.toggle()
                } label: {
                    Label("Choose Photo", systemImage: "photo.on.rectangle")
                }
                if case .success = imageState {
                    Button(role: .destructive) {
                        imageState = .empty
                    } label: {
                        Label("Remove Photo", systemImage: "trash")
                    }
                }
                
            } label: {
                
                if let image = UIImage(data: imageData ?? Data()) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                            .overlay(alignment: .bottomTrailing) {
                                PhotosPicker(selection: $imageSelection,
                                             matching: .images) {
                                    Image(systemName: "pencil")
                                        .font(.title2)
                                        .bold()
                                        .padding()
                                        .background(.ultraThickMaterial)
                                        .clipShape(Circle())
                                        .padding()
                                }
                            }
                } else {
                    
                    switch imageState {
                        case .success(let data):
                        Label("Photo Loaded", systemImage: "checkmark.circle")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(.thickMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                            .padding()
                        case .loading(let progress):
                            ProgressView(value: progress.fractionCompleted)
                        case .empty:
                            Button(action: { photoPickerShowing = true }) {
                                Label("Add Photo", systemImage: "camera")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(.thickMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                                    .padding()
                            }
                            
                        case .failure:
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                    }
                }
            }
            
        }
        .photosPicker(isPresented: $photoPickerShowing, selection: $imageSelection)
        .onChange(of: imageSelection) {
            if let imageSelection {
                let progress = loadTransferable(from: imageSelection)
                imageState = .loading(progress)
            } else {
                imageState = .empty
            }
        }
    }
    
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let data?):
                        self.imageState = .success(data)
                    case .success(nil):
                        self.imageState = .empty
                    case .failure(let error):
                        self.imageState = .failure(error)
                }
            }
        }
    }
}

#Preview {
    
    @State var imageSelection: PhotosPickerItem?
    @State var imageState: ImagePickerWindow.ImageState = .empty
    
    return ImagePickerWindow(imageSelection: $imageSelection, imageState: $imageState, imageData: Binding.constant(nil))
}