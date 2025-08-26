//
//  BillingDetailView.swift
//  mE Health
//
//  Created by Rashida on 1/07/25.
//
import SwiftUI
import AVFoundation

struct BillingDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    let billing: BillingItem
    
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
    @State private var showPDF = false
    
    @State private var documentToPreview: URL? = nil
    @State private var showDocumentPreview: Bool = false

    
   @State private var savedFiles: [SavedMedia] = []
    private var practitionerFiles: [SavedMedia] {
        savedFiles.filter { $0.categoryId == billing.id }
    }
    @State private var selectedCategory: UploadCategory? = nil
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?

    private var get_file_name: String {
        "\(billing.insurance?.coverage.display ?? "Unknown")_\(billing.formattedCreatedDate)"
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
                    Text("Billing")
                       .font(.montserrat(32, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    
                    BillingCardView(claim: billing){
                    }
                    .padding(.horizontal)
                    

                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 24) {
                            Rectangle()
                                .fill(Color(hex: "FF6605"))
                                .frame(width: 5)
                                .frame(height:90)
                                .padding(.leading, 6)
                          
                            VStack(alignment: .leading, spacing: 12) {
                                
                                Text("Insurance Details")
                                   .font(.montserrat(19, weight: .bold))
                                    .padding(.leading, 4)
                                
                                HStack {
                                    Text("Insurance Company")
                                         .font(.montserrat(12, weight: .regular))
                                    Spacer()
                                    Text(billing.insurance?.coverage.display ?? "Unknown")
                                       .font(.montserrat(12, weight: .medium))
                                }
                                
                                HStack {
                                    Text("Coverage Type")
                                         .font(.montserrat(12, weight: .regular))
                                    Spacer()
                                    Text(billing.insurance?.coverage.reference ?? "")
                                       .font(.montserrat(12, weight: .medium))
                                }
                                
//                                HStack {
//                                    Text("Plan ID")
//                                         .font(.montserrat(12, weight: .regular))
//                                    Spacer()
//                                    Text("BCBS-2023-456")
//                                       .font(.montserrat(12, weight: .medium))
//                                }

                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.white) // Light blue background
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
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
                    ).shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 2)


                    Button(action: {
                        showPDF = true
                    }) {
                        Text("View Invoice")
                             .font(.montserrat(16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .frame(height:40)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color(hex: "FF6605"))
                            .cornerRadius(32)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal,24)
                    .sheet(isPresented: $showPDF) {
                        if let url = Bundle.main.url(forResource: "sample", withExtension: "pdf") {
                            PDFKitView(url: url)
                        } else {
                            Text("PDF not found.")
                        }
                    }

                    
                    Spacer()

                }
                .padding(.horizontal,8)
            }
            .sheet(isPresented: $showShare) {
                ShareSheet(activityItems: [generateBillingShareText()])
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
                    selectedCategory = UploadCategory(name: "Billing", id: billing.id)
                }
            }
            .padding(.top)
            .background(Color(UIColor.systemGray6).ignoresSafeArea())
            .navigationBarBackButtonHidden(true)

        }
    }
    
    func generateBillingShareText() -> String {
        let patientName = "\(userProfileData?.first_name ?? "") \(userProfileData?.last_name ?? "")"
        let status = billing.status.capitalized
        let totalAmount = String(format: "%.2f", billing.totalAmount)
        let billDate = billing.formattedCreatedDate

        return """
        Billing Report

        Here's my billing info from mEinstein — your digital healthcare assistant!
        https://bit.ly/4ipzMmF

        Blue Cross Blue Shield
        Status: \(status)
        Total Amount: $\(totalAmount)
        Date: \(billDate)

        Patient Name: \(patientName)
        Claim ID: \(billing.id)

        Insurance Details:
        • Company: Blue Cross Blue Shield
        • Coverage Type: Primary
        • Plan ID: BCBS-2023-456

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
