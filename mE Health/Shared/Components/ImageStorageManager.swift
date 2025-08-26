import Foundation
import UIKit

enum MediaType: String, Codable {
    case image
    case video
    case document
}

struct SavedMedia: Codable, Identifiable, Equatable {
    var id = UUID()
    var fileName: String
    var categories: [String]
    var createdAt: Date
    var categoryId: String
    var mediaType: MediaType
}



class MediaStorageManager {
    static let shared = MediaStorageManager()
    private let storageKey = "SavedMedia"

    private init() {}

    // MARK: Save Image
    func saveImage(_ image: UIImage, categories: [String], categoryId: String,fileName:String) -> Bool {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return false }
        let mainFileName = "\(sanitizedFileName(fileName))_\(Date().formattedTime()).jpg"
        print(mainFileName)
        return saveFile(data: data, fileName: mainFileName, categories: categories, categoryId: categoryId, mediaType: .image)
    }

    // MARK: Save Video
    func saveVideo(_ videoURL: URL, categories: [String], categoryId: String,fileName:String) -> Bool {
        let mainFileName = "\(sanitizedFileName(fileName))_\(Date().formattedTime()).mp4"
        do {
            let data = try Data(contentsOf: videoURL)
            return saveFile(data: data, fileName: mainFileName, categories: categories, categoryId: categoryId, mediaType: .video)
        } catch {
            print("Error saving video: \(error)")
            return false
        }
    }

    // MARK: Common Save Method
    private func saveFile(data: Data, fileName: String, categories: [String], categoryId: String, mediaType: MediaType) -> Bool {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            try data.write(to: url)
            var saved = fetchSavedMedia()
            saved.append(SavedMedia(fileName: fileName, categories: categories, createdAt: Date(), categoryId: categoryId, mediaType: mediaType))
            saveToUserDefaults(saved)
            return true
        } catch {
            print("Error saving file: \(error)")
            return false
        }
    }

    // MARK: Fetch All Media
    func fetchSavedMedia() -> [SavedMedia] {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let media = try? JSONDecoder().decode([SavedMedia].self, from: data) else {
            return []
        }
        return media
    }

    // MARK: Load File
    func loadMedia(fileName: String) -> URL? {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        return FileManager.default.fileExists(atPath: url.path) ? url : nil
    }

    // MARK: Delete File
    func deleteMedia(_ fileName: String) {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            try FileManager.default.removeItem(at: url)
            print("Deleted file: \(url)")
        } catch {
            print("Error deleting file: \(error)")
        }
        var saved = fetchSavedMedia()
        saved.removeAll { $0.fileName == fileName }
        saveToUserDefaults(saved)
    }
    
    func saveDocument(_ documentURL: URL, categories: [String], categoryId: String,fileName:String) -> Bool {
        
        let mainFileName = "\(sanitizedFileName(fileName))_\(Date().formattedTime())_\(documentURL.lastPathComponent)"
        let destinationURL = getDocumentsDirectory().appendingPathComponent(mainFileName)

        do {
            let data = try Data(contentsOf: documentURL)
            try data.write(to: destinationURL)
            var saved = fetchSavedMedia()
            saved.append(SavedMedia(
                fileName: fileName,
                categories: categories,
                createdAt: Date(),
                categoryId: categoryId,
                mediaType: .document
            ))
            saveToUserDefaults(saved)
            return true
        } catch {
            print("Error saving document: \(error)")
            return false
        }
    }


    // MARK: Helpers
    private func saveToUserDefaults(_ media: [SavedMedia]) {
        if let data = try? JSONEncoder().encode(media) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func sanitizedFileName(_ raw: String) -> String {
        let invalidCharacters = CharacterSet(charactersIn: "/:\\?%*|\"<>")
        let cleaned = raw.components(separatedBy: invalidCharacters).joined(separator: "_")
        return cleaned.replacingOccurrences(of: " ", with: "_")
    }

}


extension Date {
    
    func formattedTime() -> String {
        let formatter = DateFormatter()

        formatter.dateFormat = "hh:mm a"


        return formatter.string(from: self)
    }
    
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: self)
    }
}
