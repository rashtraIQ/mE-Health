//
//  SeriesGridView.swift
//  mE Health
//
//  Created by Rashida on 7/07/25.
//

import SwiftUI
import AVKit

struct UploadImageViewer: View {
    let item: SavedMedia
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?

    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    viewControllerHolder?.dismiss(animated: true)
                }

            VStack(spacing: 0) {
                Spacer()

                ZStack(alignment: .top) {
                    VStack(spacing: 16) {
                        // Drag indicator
                        Capsule()
                            .frame(width: 40, height: 5)
                            .foregroundColor(Color(hex: "F5F5FC"))
                            .padding(.top, 12)

                        // Title

                        Text(item.fileName)
                             .font(.montserrat(16, weight: .regular))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading,12)
                        
                        if let url = MediaStorageManager.shared.loadMedia(fileName: item.fileName),
                                let uiImage = UIImage(contentsOfFile: url.path) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 350, height: 350)
                                .clipped()
                                .cornerRadius(20)
                        }

                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: UIScreen.main.bounds.height * 0.65)
                    .background(
                        RoundedCorner(radius: 24, corners: [.topLeft, .topRight])
                            .fill(Color(hex: "F5F5FC"))
                    )
                    .clipShape(RoundedCorner(radius: 24, corners: [.topLeft, .topRight]))
                    .shadow(radius: 10)


                    // Close Button (X)
                    Button(action: {
                        viewControllerHolder?.dismiss(animated: true)
                    }) {
                        Image("close")
                            .frame(width: 40, height: 40)
                            .background(Color(hex: "F5F5FC"))
                            .clipShape(Circle())
                            .shadow(radius: 2)
                    }
                    .padding(.top, -64)
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}


struct VideoPlayerViewer: View {
    let videoURL: URL
    let item: SavedMedia
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?

    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    viewControllerHolder?.dismiss(animated: true)
                }

            VStack(spacing: 0) {
                Spacer()

                ZStack(alignment: .top) {
                    VStack(spacing: 16) {
                        // Drag indicator
                        Capsule()
                            .frame(width: 40, height: 5)
                            .foregroundColor(Color(hex: "F5F5FC"))
                            .padding(.top, 12)

                        // File title
                        Text(item.fileName)
                            .font(.montserrat(16, weight: .regular))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 12)

                        // Video Player (native AVPlayerViewController)
                        FullScreenVideoPlayer(url: videoURL)
                            .frame(width: 350, height: 350)
                            .cornerRadius(20)

                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: UIScreen.main.bounds.height * 0.65)
                    .background(
                        RoundedCorner(radius: 24, corners: [.topLeft, .topRight])
                            .fill(Color(hex: "F5F5FC"))
                    )
                    .clipShape(RoundedCorner(radius: 24, corners: [.topLeft, .topRight]))
                    .shadow(radius: 10)

                    // Close Button
                    Button(action: {
                        viewControllerHolder?.dismiss(animated: true)
                    }) {
                        Image("close")
                            .frame(width: 40, height: 40)
                            .background(Color(hex: "F5F5FC"))
                            .clipShape(Circle())
                            .shadow(radius: 2)
                    }
                    .padding(.top, -64)
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct FullScreenVideoPlayer: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        let player = AVPlayer(url: url)
        controller.player = player
        controller.entersFullScreenWhenPlaybackBegins = true
        controller.exitsFullScreenWhenPlaybackEnds = true
        player.play()
        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
}

