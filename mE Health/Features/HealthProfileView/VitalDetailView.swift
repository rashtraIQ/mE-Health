//
//  VitalDetailView.swift
//  mE Health
//
//  Created by Rashida on 27/06/25.
//

import SwiftUI
import ComposableArchitecture
import AVFoundation

struct VitalDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    let vital : VitalDummyData
    
    @State private var showUploadView = false
    @State private var showShare = false
    @State private var showImagePicker = false
    @State private var mediaSource: UIImagePickerController.SourceType = .photoLibrary

    @State private var showVideoPicker = false
    @State private var showDocumentPicker = false

    @State private var selectedImage: UIImage?
    @State private var selectedVideoURL: URL?
    @State private var selectedFileURL: URL?

    @State private var navigateToPreview = false

   @State private var savedFiles: [SavedMedia] = []
    private var practitionerFiles: [SavedMedia] {
        savedFiles.filter { $0.categoryId == vital.id }
    }
    @State private var selectedCategory: UploadCategory? = nil
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?

    @State private var documentToPreview: URL? = nil
    @State private var showDocumentPreview: Bool = false
    
    private var get_file_name: String {
        "\(vital.codeDisplay)_\(vital.formattedDate)"
    }

    
    var body: some View {
            ZStack {
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack(spacing: 24) {
                        
                        HStack {
                            CustomBackButton {
                                presentationMode.wrappedValue.dismiss()
                            }
                            Spacer()
                            
                            Button(action: {
                                selectedImage = nil
                                selectedVideoURL = nil
                                selectedFileURL = nil
                                navigateToPreview = false
                                showUploadView = true
                            }) {
                                Image("Upload")
                                    .foregroundColor(Color(hex: "FF6605"))
                            }

                        }
                        .padding(.horizontal)
                        .padding(.top, 8)

                        
                        // Title
                        Text("Details")
                           .font(.montserrat(32, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        TopCardView(title: vital.codeDisplay, subtitle: "\(vital.valueQuantityValue ?? 0)" + " " + (vital.valueQuantityUnit ?? ""), desc: formatEffectiveDate(vital.effectiveDate),status: vital.status.capitalized)
                            .padding(.horizontal)
                        
                        
                        BottomDetailCardView(vital: vital)
                            .padding(.horizontal)
                        


                        VStack(alignment: .leading, spacing: 12) {
                            
                            HStack(spacing: 8) {
                                Text("Visits Status")
                                    .font(.montserrat(17, weight: .bold))
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Text("In-progress")
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(Color.blue.opacity(0.2))
                                    .foregroundColor(.blue)
                                    .clipShape(Capsule())
                                
                            }

                            
                            Text("Start Date: \(vital.formattedDate)")
                                .font(.montserrat(13, weight: .semibold))

                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 2)
                        .padding(.horizontal)


                        if !practitionerFiles.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Saved Files")
                                    .font(.montserrat(22, weight: .bold))
                                    .padding(.horizontal)

                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                    ForEach(practitionerFiles) { file in
                                        VStack(spacing: 8) {
                                            if let url = MediaStorageManager.shared.loadMedia(fileName: file.fileName) {
                                                if file.mediaType == .image,
                                                   let uiImage = UIImage(contentsOfFile: url.path) {
                                                    // IMAGE
                                                    Button {
                                                        viewControllerHolder?.present(style: .overCurrentContext, transitionStyle: .crossDissolve) {
                                                            UploadImageViewer(item: file)
                                                        }
                                                    } label: {
                                                        Image(uiImage: uiImage)
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: 140, height: 120)
                                                            .clipped()
                                                            .cornerRadius(8)
                                                    }
                                                }
                                                else if file.mediaType == .video,
                                                        let thumbnail = generateVideoThumbnail(url: url) {
                                                    // VIDEO
                                                    Button {
                                                        viewControllerHolder?.present(style: .overCurrentContext, transitionStyle: .crossDissolve) {
                                                            VideoPlayerViewer(videoURL: url,item: file)
                                                        }
                                                    } label: {
                                                        ZStack {
                                                            Image(uiImage: thumbnail)
                                                                .resizable()
                                                                .scaledToFill()
                                                                .frame(width: 140, height: 120)
                                                                .clipped()
                                                                .cornerRadius(8)

                                                            Image(systemName: "play.circle.fill")
                                                                .font(.system(size: 40))
                                                                .foregroundColor(.white)
                                                                .shadow(radius: 4)
                                                        }
                                                    }
                                                }
                                                else if file.mediaType == .document {
                                                    Button {
                                                        if let url = MediaStorageManager.shared.loadMedia(fileName: file.fileName) {
                                                            documentToPreview = url
                                                            showDocumentPreview = true
                                                        }
                                                    } label: {
                                                        VStack(spacing: 8) {
                                                            Image(systemName: "doc.text.fill")
                                                                .resizable()
                                                                .scaledToFit()
                                                                .frame(width: 60, height: 60)
                                                                .foregroundColor(.blue)

                                                            Text("Open Document")
                                                                .font(.montserrat(14))
                                                                .foregroundColor(.blue)
                                                        }
                                                        .frame(width: 140, height: 120)
                                                        .background(Color.gray.opacity(0.1))
                                                        .cornerRadius(8)
                                                    }
                                                }
                                            }

                                            
                                            Text(file.fileName)
                                                .font(.montserrat(12))
                                                .lineLimit(3)
                                                .truncationMode(.tail)

                                        }
                                        .padding(8)
                                        .background(Color.white)
                                        .cornerRadius(12)
                                        .shadow(radius: 2)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }

                        Spacer()

                        // Bottom Buttons
                        
                        ActionButtonsView(
                            title: "Sync Data",
                            onRefresh: {
                                print("Refresh tapped")
                            },
                            onShare: {
                                showShare = true
                            }
                        )


//                        Button(action: {
//                            
//                        }) {
//                            Text("Log New Vital")
//                                 .font(.montserrat(16, weight: .semibold))
//                                .foregroundColor(.white)
//                                .frame(maxWidth: .infinity, alignment: .center)
//                                .frame(height:45)
//                                .padding(.horizontal, 16)
//                                .padding(.vertical, 8)
//                                .background(Color(hex: "FF6605"))
//                                .cornerRadius(32)
//                        }
//                        .buttonStyle(PlainButtonStyle())
//                        .padding(.horizontal,12)

                        
                        Spacer()

                    }
                }
                .sheet(isPresented: $showShare) {
                    ShareSheet(activityItems: [generateVitalShareText()])
                }
                .actionSheet(isPresented: $showUploadView) {
                    ActionSheet(
                        title: Text("Select Type"),
                        buttons: [
                            .default(Text("Camera")) {
                                mediaSource = .camera
                                showImagePicker = true
                            },
                            .default(Text("Picture")) {
                                mediaSource = .photoLibrary
                                showImagePicker = true
                            },
                            .default(Text("Video")) {
                                showVideoPicker = true
                            },
                            .default(Text("Document")) {
                                showDocumentPicker = true
                            },
                            .cancel()
                        ]
                    )
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(sourceType: mediaSource) { image in
                        selectedImage = image
                        navigateToPreview = true
                    }
                }
                .sheet(isPresented: $showVideoPicker) {
                    VideoPicker { url in
                        if let videoURL = url {
                            selectedVideoURL = videoURL
                            navigateToPreview = true
                        }
                    }
                }
                .sheet(isPresented: $showDocumentPicker) {
                    DocumentPicker { urls in
                        if let first = urls.first {
                            selectedFileURL = first
                            navigateToPreview = true
                        }
                    }
                }
                .sheet(isPresented: $showDocumentPreview) {
                    if let url = documentToPreview {
                            DocumentPreviewView(url: url)
                        }
                }

                .navigationDestination(isPresented: $navigateToPreview) {
                    if let selectedImage = selectedImage,
                       let selectedCategory = selectedCategory {
                        UploadPreviewView(
                            image: selectedImage,
                            getFileName: get_file_name,
                            category: selectedCategory,
                            onSave: { saved in
        //                        savedFile = saved
        //                        savedFiles.append(saved)
                            }
                        )
                    }
                    else if let selectedVideoURL = selectedVideoURL, let selectedCategory = selectedCategory {
                            UploadPreviewView(
                                getFileName: get_file_name,
                                videoURL: selectedVideoURL,
                                category: selectedCategory,
                                onSave: { saved in
                                    //savedFiles.append(saved) // Works for video too
                                }
                            )
                        }
                    else if let selectedFileURL = selectedFileURL,
                                  let selectedCategory = selectedCategory {
                            UploadPreviewView(
                                getFileName: get_file_name,
                                documentURL: selectedFileURL,
                                category: selectedCategory,
                                onSave: { saved in }
                            )
                    }
                    else {
                        Text("No image selected") // fallback if needed
                    }
                }
                .onAppear {
                    savedFiles = MediaStorageManager.shared.fetchSavedMedia()
                    if selectedCategory == nil {
                        selectedCategory = UploadCategory(name: "Vitals", id: vital.id)
                    }
                }
                .padding(.top)
                .background(Color.white.ignoresSafeArea())
                .navigationBarBackButtonHidden(true)

            }
    }
    
    func formatEffectiveDate(_ isoString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        // Handle cases where no fractional seconds exist
        var date: Date? = isoFormatter.date(from: isoString)
        if date == nil {
            isoFormatter.formatOptions = [.withInternetDateTime]
            date = isoFormatter.date(from: isoString)
        }

        guard let parsedDate = date else {
            return isoString // fallback if parsing fails
        }

        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "MMMM d, yyyy 'at' hh:mm a"
        displayFormatter.amSymbol = "AM"
        displayFormatter.pmSymbol = "PM"
        displayFormatter.timeZone = .current // or set to specific time zone if needed

        return displayFormatter.string(from: parsedDate)
    }
    



    func generateVitalShareText() -> String {
        
        let labName = vital.codeDisplay
        let vitalId = vital.id
        let status = vital.status.capitalized
        let startDate = vital.formattedDate
        let value = vital.valueQuantityValue ?? 0
        let unit = vital.valueQuantityUnit ?? ""
        let patientName = "\(userProfileData?.first_name ?? "") \(userProfileData?.last_name ?? "")"

        return """
        Vital Details

        Here's my Vital report info from mEinstein — your digital healthcare assistant!
        https://bit.ly/4ipzMmF

        \(labName)
        \(value) \(unit)
        Status: \(status)
        \(startDate)

        Details:
        Patient Name: \(patientName)
        Vital ID: \(vitalId)

        Visits Status
        Status: In-progress
        Start Date: \(startDate)

        Thank You!!
        """
    }
    
    func generateVideoThumbnail(url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time = CMTime(seconds: 1.0, preferredTimescale: 600)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: img)
        } catch {
            print("Error generating thumbnail: \(error)")
            return nil
        }
    }
}



struct BottomDetailCardView: View {
    
    let vital : VitalDummyData
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            HStack(alignment: .top, spacing: 12) {
                
                Rectangle()
                    .fill(Color(hex: "FF6605"))
                    .frame(width: 5)
                    .padding(.bottom,2)
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text("Details")
                        .font(.montserrat(17, weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading) // or .center, but not justified
                        .lineSpacing(4)

                    HStack(spacing: 8) {
                        
                        Text("Patient Name")
                             .font(.montserrat(13, weight: .regular))
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Text("\(userProfileData?.first_name ?? "") \(userProfileData?.last_name ?? "")")
                            .font(.montserrat(13, weight: .semibold))
                            .foregroundColor(.black)

                    }
                    
                    HStack(spacing: 8) {
                        Text("Vital ID")
                             .font(.montserrat(13, weight: .regular))
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Text("obs-\(vital.id)")
                            .font(.montserrat(13, weight: .semibold))
                            .foregroundColor(.black)

                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 2)
      


    }
}
