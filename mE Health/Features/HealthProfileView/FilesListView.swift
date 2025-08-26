//
//  FilesListView.swift
//  mE Health
//
//  Created by Rashida on 27/06/25.
//
import SwiftUI
import AVFoundation



struct FilesListView: View {
    let fileData: SavedMedia
    let onDelete: () -> Void
    let onTap: () -> Void
    
    private var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df
    }

    

    var body: some View {
        HStack(spacing: 4) {
            VStack(alignment: .leading, spacing: 12) {
                
                Text(fileData.fileName)
                   .font(.montserrat(14, weight: .bold))
                
                HStack(spacing: 0) {
                    Text("Category:")
                       .font(.montserrat(14, weight: .bold))
                    Text(fileData.categories.first ?? "-")
                         .font(.montserrat(12, weight: .regular))
                }

                Text(dateFormatter.string(from: fileData.createdAt))
                     .font(.montserrat(12, weight: .regular))

                                
            }

            Spacer()
            
            FilesActionColumn(
                onDelete: {
                        onDelete() // Pass from parent
                    },
                    onAIAdvice: {
                        // Handle AI Advice if needed
                    },
                    onIgnore: {
                        // Handle Ignore if needed
                    }
            )
                .frame(height:150)
                .padding(.trailing, 0)
        }
        .padding(.leading, 12)
        .frame(height:150)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
        .onTapGesture {
            onTap()
        }
    }
}


struct FilesSectionView: View {
    
    var filesArray: [SavedMedia]
    let searchText: String
    let startDate: Date?
    let endDate: Date?
    let selectedFilters: [FilterType]
    var onCardTap: (SavedMedia) -> Void
    let addedFile: SavedMedia?
    let onDelete: (SavedMedia) -> Void
    
    
    var dateFormatter: ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }

    var filteredMedia: [SavedMedia] {
        filesArray.filter { fileData in
            let matchesSearch = searchText.isEmpty || fileData.fileName.localizedCaseInsensitiveContains(searchText)

            let matchesDate: Bool
            if let start = startDate, let end = endDate {
                matchesDate = (fileData.createdAt >= start) && (fileData.createdAt <= end)
            } else {
                matchesDate = true
            }

            // 3. Filter by category
            let activeFilters = selectedFilters
                .filter { $0.label.lowercased() != "all" }
                .map { $0.label.lowercased() }

            let fileCategories = fileData.categories.map { $0.lowercased() }
            let matchesCategory: Bool = activeFilters.isEmpty || !Set(activeFilters).isDisjoint(with: fileCategories)

            return matchesSearch && matchesDate && matchesCategory

        }
    }


    


    @State private var selectedCategory: UploadCategory? = nil
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?

    var body: some View {
      
       // NavigationStack {
        VStack(spacing: 20) {
            // Horizontal date cards
            
            if filteredMedia.isEmpty {
                        NoDataView()
            } else {
                ForEach(filteredMedia) { files in
                    FilesListView(fileData: files, onDelete: {
                        onDelete(files) // Call delete
                    }) {
                        onCardTap(files)
                    }
                }
            }
        }
        .padding(.horizontal)

    }
}


struct FilesActionColumn: View {
    let icons = ["a", "delete", "a"]
    let onDelete: () -> Void
    let onAIAdvice: () -> Void
    let onIgnore: () -> Void


    var body: some View {
        VStack(spacing: 0) {
            ForEach(icons, id: \.self) { icon in
                Button(action: {
                    handleAction(for: icon)
                    
                }) {
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 20, height: 20)
                        .padding()
                        .frame(width: 50, height: 50)
                        .background(Color(hex: "FF6605"))
                }
            }
        }
        .padding(.trailing,0)
        .frame(width: 50) // Fixed width for the action column
        .background(
            RoundedCorners(color: Color.white, tl: 0, tr: 12, bl: 12, br: 0)
        )
    }
    
    private func handleAction(for icon: String) {
           switch icon {
           case "delete":
               onDelete()
           case "AIAdvice":
               onAIAdvice()
           case "white_Ignore":
               onIgnore()
           default:
               break
           }
       }
}


struct VideoThumbnailView: View {
    let url: URL
    var body: some View {
        if let image = generateThumbnail(url: url) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
        } else {
            Rectangle()
                .fill(Color.gray)
                .overlay(Image(systemName: "video.fill").foregroundColor(.white))
        }
    }

    func generateThumbnail(url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        do {
            let cgImage = try assetImgGenerate.copyCGImage(at: .zero, actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch {
            print("Error generating thumbnail: \(error)")
            return nil
        }
    }
}
