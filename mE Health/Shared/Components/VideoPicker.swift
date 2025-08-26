//
//  VideoPicker.swift
//  mE Health
//
//  Created by Rashida on 3/07/25.
//

import SwiftUI
import PhotosUI

struct VideoPicker: UIViewControllerRepresentable {
    var onVideoPicked: (URL?) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onPicked: onVideoPicked)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .videos // ✅ Only show videos
        config.selectionLimit = 1

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let onPicked: (URL?) -> Void

        init(onPicked: @escaping (URL?) -> Void) {
            self.onPicked = onPicked
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let result = results.first else {
                onPicked(nil)
                return
            }

            if result.itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, error in
                    if let fileURL = url {
                        // Copy the file to a temp location to persist it
                        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileURL.lastPathComponent)
                        try? FileManager.default.copyItem(at: fileURL, to: tempURL)
                        DispatchQueue.main.async {
                            self.onPicked(tempURL)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.onPicked(nil)
                        }
                    }
                }
            } else {
                onPicked(nil)
            }
        }
    }
}
