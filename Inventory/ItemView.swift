//
//  ItemView.swift
//  Inventory
//
//  Created by Smay on 5/9/23.
//

import SwiftUI
import PhotosUI

struct ItemView: View {
    
    @Environment(\.managedObjectContext) private var moc
    
    @Binding var itemDisplayStack: [Item]
    
    @ObservedObject var item: Item
    
    
    
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showingImagePicker = false
//    @State private var inputImage: UIImage?
    
    
    @State private var waitingForSave = false
    
    var body: some View {
        /// Non nil binding for name
        let itemName = Binding (
            get: { return item.name ?? "" },
            set: {
                item.name = $0
                save()
            }
        )
        /// Non nil binding for image
        let itemImage = Binding(
            get: { () -> UIImage? in
                if item.image != nil, let loadedImage = UIImage(data: item.image!) {
                    return loadedImage
                } else {
                    return nil
                }}, set: {
                guard let inputImage = $0 else { return }
                    item.image = inputImage.pngData()
                save()
        })
        
        VStack {
            
            TextField("Name", text: itemName)
                .padding()
                .background(.thickMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .padding()
            
            Menu {
                
                Button {
                    sourceType = .camera
                    showingImagePicker.toggle()
                } label: {
                    Label("Take Photo", systemImage: "camera")
                }
                Button {
                    sourceType = .photoLibrary
                    showingImagePicker.toggle()
                } label: {
                    Label("Choose Photo", systemImage: "photo.on.rectangle")
                }
                if item.image != nil {
                    Button(role: .destructive) {
                        item.image = nil
                    } label: {
                        Label("Remove Photo", systemImage: "trash")
                    }
                }
            } label: {
                
                if item.image == nil {
                        Label("Add Photo", systemImage: "camera")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(.thickMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                            .padding()
                    } else {
                        
                        ZStack {
                            
                            Image(uiImage: UIImage(data: item.image!)!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                                .padding()
                            
                            HStack {
                                
                                Spacer()
                                
                                VStack {
                                    
                                    Spacer()
                                    
                                    Image(systemName: "pencil")
                                        .font(.title2)
                                        .bold()
                                        .padding()
                                        .background(.ultraThickMaterial)
                                        .clipShape(Circle())
                                        .padding()
                                    
                                }
                            }
                        }
                        
                    }
                    
                   
                    
                
                
            }
                 
            Form {
                ForEach(item.subitems?.allObjects as? [Item] ?? []) { subitem in
                    
                        NavigationLink(subitem.name ?? "Unnamed item", value: subitem)

                }
            }
            
            Button {
                let newItem = Item(context: moc)
                newItem.id = UUID()
                
                if item.subitems == nil {
                    item.subitems = NSSet()
                }
                let modifiedSubitemSet = item.subitems?.adding(newItem)
                item.subitems = modifiedSubitemSet as? NSSet
                
                do {
                    try moc.save()
                    itemDisplayStack.append(newItem)
                } catch {
                    print(error)
                }
                
                
            } label: {
                Label("Add", systemImage: "plus")
            }
            
        }
        .navigationTitle(Text(item.name ?? "Unnamed Item"))
        .sheet(isPresented: $showingImagePicker, content: {
            CaptureImageView(image: itemImage, sourceType: $sourceType)
        })
//        .onChange(of: inputImage) { _ in loadImage() }
    }
    
    func loadImage() {
        
    }
    
    /// Simple batched updates
    func save() {
        
        guard !waitingForSave else { return }
        waitingForSave = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            do {
                try moc.save()
                print("Saved")
            } catch {
                print(error.localizedDescription)
            }
            
            waitingForSave = false
            
        }
    }
    
    
}

struct ItemView_Previews: PreviewProvider {
    
    static var previews: some View {
        ItemView(itemDisplayStack: Binding.constant([]), item: makeItem())
    }
    
    /// Kinda jank shit to make it display *something*
    static func makeItem() -> Item {
        
        let dataController = DataController()
        
        let newItem = Item(context: dataController.container.viewContext)
        newItem.name = "Test"
        return newItem
    }
}
