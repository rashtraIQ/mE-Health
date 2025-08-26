//
//  ImagePreviewView.swift
//  mE Health
//
//  Created by Rashida on 2/07/25.
//
import SwiftUI
import AVKit

struct UploadCategory : Equatable{
    let name: String
    let id: String? 
}


struct UploadPreviewView: View {
    let image: UIImage?
    let getFileName :String
    let videoURL: URL?
    let documentURL: URL?
    let category: UploadCategory
    var onSave: (Any) -> Void  // Can be SavedImage or SavedVideo

    @Environment(\.presentationMode) var presentationMode
    @State private var showSaveAlert = false
    @State private var selectedTags: Set<String> = []
    @State private var isExpanded = true
    @State private var tagWidths: [String: CGFloat] = [:]

    private let categoryItems = [
        "Practitioners", "Appointments", "Visits", "Conditions", "Labs",
        "Vitals","Medications", "Imaging", "Procedures", "Allergies", "Immunizations", "Billing"
    ]

    private var tagRows: [[String]] {
        var rows: [[String]] = [[]]
        let totalWidth = UIScreen.main.bounds.width - 48
        var currentRowWidth: CGFloat = 0

        for tag in categoryItems {
            let tagWidth = tagWidths[tag, default: 150] + 12
            if currentRowWidth + tagWidth > totalWidth {
                rows.append([tag])
                currentRowWidth = tagWidth
            } else {
                rows[rows.count - 1].append(tag)
                currentRowWidth += tagWidth
            }
        }

        return rows
    }

    init(image: UIImage? = nil,getFileName :String, videoURL: URL? = nil, documentURL: URL? = nil,category: UploadCategory, onSave: @escaping (Any) -> Void) {
        self.image = image
        self.getFileName = getFileName
        self.videoURL = videoURL
        self.documentURL = documentURL
        self.category = category
        self.onSave = onSave
        _selectedTags = State(initialValue: [category.name])
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("Data Items")
                .font(.montserrat(28, weight: .bold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

            // Media Preview
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(8)
                    .padding(.horizontal)
            } else if let videoURL = videoURL {
                VideoPlayer(player: AVPlayer(url: videoURL))
                    .frame(height: 200)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            else if let documentURL = documentURL {
                VStack(spacing: 8) {
                    Image(systemName: "doc.text")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray)
                    Text(documentURL.lastPathComponent)
                        .font(.montserrat(16, weight: .medium))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding()
            }

                

            // File Info
            VStack(spacing: 4) {
                if image != nil {
                    Text("Name: Image_\(Date().timeIntervalSince1970).jpg")
                } else if videoURL != nil {
                    Text("Name: Video_\(Date().timeIntervalSince1970).mp4")
                }
                else if let documentURL = documentURL {
                        Text("Name: \(documentURL.lastPathComponent)")
                }
                Text("File Size: ~3 MB")
            }
            .font(.montserrat(14, weight: .regular))
            .foregroundColor(.gray)

            // Tag selection
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(image != nil ? "Image" : "Video")
                        .font(.montserrat(16, weight: .semibold))
                    Spacer()
                    Button(action: { isExpanded.toggle() }) {
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .foregroundColor(Color(hex: "FF6605"))
                    }
                }
                .padding([.top, .bottom], 16)

                if isExpanded {
                    Rectangle()
                        .fill(Color(hex: "FF6605"))
                        .frame(height: 1)
                        .frame(maxWidth: .infinity)

                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(tagRows, id: \.self) { row in
                            HStack(spacing: 12) {
                                ForEach(row, id: \.self) { tag in
                                    TagItemView(tag: tag, isSelected: selectedTags.contains(tag)) {
                                        if selectedTags.contains(tag) {
                                            selectedTags.remove(tag)
                                        } else {
                                            selectedTags.insert(tag)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.vertical, 16)
                    .onPreferenceChange(TagWidthPreferenceKey.self) { value in
                        tagWidths = value
                    }
                }
            }
            .padding()
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(hex: "FF6605"), lineWidth: 1)
            )

            Spacer()

            // Buttons
            HStack(spacing: 16) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(32)
                        .overlay(
                            RoundedRectangle(cornerRadius: 32)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                }
                .foregroundColor(.black)

                Button(action: {
                    let categories = Array(selectedTags)

                    if let image = image {
                        let saved = MediaStorageManager.shared.saveImage(image, categories: categories, categoryId: category.id ?? "",fileName:getFileName)
                            if saved, let last = MediaStorageManager.shared.fetchSavedMedia().last {
                                onSave(last)
                                showSaveAlert = true
                            }
                        } else if let videoURL = videoURL {
                            let saved = MediaStorageManager.shared.saveVideo(videoURL, categories: categories, categoryId: category.id ?? "",fileName:getFileName)
                            if saved, let last = MediaStorageManager.shared.fetchSavedMedia().last {
                                onSave(last)
                                showSaveAlert = true
                            }
                        }
                        else if let documentURL = documentURL {
                            let saved = MediaStorageManager.shared.saveDocument(documentURL, categories: categories, categoryId: category.id ?? "",fileName:getFileName)
                            if saved, let last = MediaStorageManager.shared.fetchSavedMedia().last {
                                onSave(last)
                                showSaveAlert = true
                            }
                        }
                }) {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "FF6605"))
                        .foregroundColor(.white)
                        .cornerRadius(32)
                }
                .alert("Saved Successfully", isPresented: $showSaveAlert) {
                    Button("OK") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.horizontal, 16)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                CustomBackButton {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}





struct TagWidthPreferenceKey: PreferenceKey {
    static var defaultValue: [String: CGFloat] = [:]

    static func reduce(value: inout [String: CGFloat], nextValue: () -> [String: CGFloat]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

struct TagItemView: View {
    let tag: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 4) {
                Text(tag)
                if isSelected {
                    Image("tick_full")
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .stroke((Color(hex: "FF6605")), lineWidth: 1)
            )
            .foregroundColor((Color(hex: "FF6605")))
             .font(.montserrat(14, weight: .regular))
            .background(
                GeometryReader { geo in
                    Color.clear
                        .preference(key: TagWidthPreferenceKey.self, value: [tag: geo.size.width])
                }
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

