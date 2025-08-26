//
//  LabDetailView.swift
//  mE Health
//
//  Created by Rashida on 25/06/25.
//

import SwiftUI
import ComposableArchitecture
import AVFoundation

struct LabDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let lab: LabDummyData
  
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
        savedFiles.filter { $0.categoryId == lab.id }
    }
    @State private var selectedCategory: UploadCategory? = nil
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?

    @State private var documentToPreview: URL? = nil
    @State private var showDocumentPreview: Bool = false

    private var get_file_name: String {
        "\(lab.codeDisplay)_\(lab.formattedDate)"
    }
    
    @StateObject private var viewModelPrac = ReadDatapractitioner()
    @State private var selectedPractitioner: PractitionerData? = nil

    @StateObject private var visitsVM = ReadDatencounter()
    @State private var selectVisits: VisitDummyData? = nil

    
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
                        
                        TopCardView(title: lab.codeDisplay, subtitle: "Lab ID: \(lab.id)", desc: lab.fullFormattedDate, status: lab.status.capitalized)
                            .padding(.horizontal)
                        
                        // Allergy Detail Card
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Results")
                                .font(.montserrat(17, weight: .bold))
                            
                            ForEach(lab.result, id: \.reference) { item in
                                   VStack {
                                       Text(item.display)
                                           .font(.montserrat(14, weight: .regular))
                                   }
                               }

                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 2)
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            
                            Text("Performer")
                                .font(.montserrat(17, weight: .bold))
                            
                            Text(selectedPractitioner?.name ?? "")
                                .font(.montserrat(13, weight: .semibold))

                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 2)
                        .padding(.horizontal)


                        VStack(alignment: .leading, spacing: 12) {
                            
                            HStack(spacing: 8) {
                                Text("Visits Status")
                                    .font(.montserrat(17, weight: .bold))
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                if selectVisits?.status ==  "planned" {
                                    Text("Planned")
                                        .font(.montserrat(9, weight: .semibold))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 4)
                                        .background(Color(hex: "F09C00").opacity(0.2))
                                        .foregroundColor(Color(hex: "F09C00"))
                                        .clipShape(Capsule())

                                }
                                else if selectVisits?.status ==  "finished" {
                                    Text("Finished")
                                        .font(.montserrat(9, weight: .semibold))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 4)
                                        .background(Color.green.opacity(0.2))
                                        .foregroundColor(Color.green)
                                        .clipShape(Capsule())
                                }
                                
                            }

                            Text("Start Date: \(selectVisits?.formattedDate ?? "")")
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
                                                else if file.mediaType == .document,
                                                        let url = MediaStorageManager.shared.loadMedia(fileName: file.fileName)  {
                                                    Button {
                                                            documentToPreview = url
                                                            showDocumentPreview = true
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


                        // Bottom Buttons
                        ActionButtonsView(
                            title: "Refresh Data",
                            onRefresh: {
                                print("Refresh tapped")
                            },
                            onShare: {
                                showShare = true
                            }
                        )
                        
                        Spacer()

                    }
                }
                .sheet(isPresented: $showShare) {
                    ShareSheet(activityItems: [generateLabShareText()])
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
                        selectedCategory = UploadCategory(name: "Labs", id: lab.id)
                    }
                    
                    findPractitioner()
                    findEncounter()
                }
                .padding(.top)
                .background(Color.white.ignoresSafeArea())
                .navigationBarBackButtonHidden(true)

            }
    }
    
    private func findPractitioner() {
            // Wait until practitioners are loaded
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                selectedPractitioner = viewModelPrac.practitioners.first { $0.id == lab.performerId }
            }
        }
    
    private func findEncounter() {
            // Wait until practitioners are loaded
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                selectVisits = visitsVM.visitData.first { $0.id == lab.encounterId }
            }
        }

    func generateLabShareText() -> String {
        
        let labName = lab.codeDisplay
        let labID = lab.id
        let status = lab.status.capitalized
        let startDate = lab.formattedDate
        let performer = selectedPractitioner?.name ?? "Dr" // replace with `lab.performerName` if dynamic
        let rcb = "2500"            // replace with actual result if available
        let wbc = "200"
        let clinicalStatus = "13.5"

        return """
        Lab Details

        Here's my lab report info from mEinstein — your digital healthcare assistant!
        https://bit.ly/4ipzMmF

        Lab Name: \(labName)
        Lab ID: #\(labID)
        Status: \(status)
        Start Date: \(startDate)

        Results:
        • Clinical Status: \(clinicalStatus)
        • RCB: \(rcb)
        • WBC: \(wbc)
        
        Performer: \(performer)
        
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


struct TopCardView: View {
    
    let title : String
    let subtitle : String
    let desc : String
    let status : String
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            HStack(alignment: .top, spacing: 12) {
                
                Rectangle()
                    .fill(Color(hex: "FF6605"))
                    .frame(width: 5)
                    .padding(.bottom,2)
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text(title)
                        .font(.montserrat(17, weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading) // or .center, but not justified
                        .lineSpacing(4)

                    HStack(spacing: 8) {
                        Text(subtitle)
                             .font(.montserrat(13, weight: .regular))
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Text(status)
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color.green.opacity(0.2))
                            .foregroundColor(.green)
                            .clipShape(Capsule())
                        
                    }
                    
                    Text(desc)
                         .font(.montserrat(14, weight: .regular))
                        .foregroundColor(Color.black)


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
