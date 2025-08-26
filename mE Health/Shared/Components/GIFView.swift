import SwiftUI
import WebKit

struct GIFView: UIViewRepresentable {
    let gifName: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        webView.backgroundColor = .clear
        webView.isOpaque = false
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let path = Bundle.main.path(forResource: gifName, ofType: "gif") else {
            print("❌ Could not find GIF named \(gifName).gif in bundle.")
            return
        }

        do {
            let fileURL = URL(fileURLWithPath: path)
            let directoryURL = fileURL.deletingLastPathComponent()
            let data = try Data(contentsOf: fileURL)
            uiView.load(data, mimeType: "image/gif", characterEncodingName: "UTF-8", baseURL: directoryURL)
            print("✅ Loaded GIF: \(gifName)")
        } catch {
            print("❌ Failed to load data for GIF: \(error.localizedDescription)")
        }
    }

}
