//
//  ImagingDetailView.swift
//  mE Health
//
//  Created by Rashida on 7/07/25.
//
import SwiftUI
import AVFoundation
import ComposableArchitecture
import Combine

struct ImagingDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    let imaging: ImagingDummyData
    
    @State private var showModal = false

    @Environment(\.viewController) private var viewControllerHolder: UIViewController?

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
        savedFiles.filter { $0.categoryId == imaging.id }
    }
    @State private var selectedCategory: UploadCategory? = nil
    
    @State private var documentToPreview: URL? = nil
    @State private var showDocumentPreview: Bool = false
    
    private var get_file_name: String {
        "\(imaging.modalityDisplay)_\(imaging.formattedStartDate)"
    }

    @State private var navigatePatient = false
    
    @StateObject private var conditionVM = ReadDatcondition()
    @State private var matchingConditions: [ConditionDummyData] = []
    @State private var conditionCancellable: AnyCancellable?
    
    @StateObject private var procedureVM = ReadDataprocedure()
    @State private var matchingProcedure: [ProcedureDummyData] = []
    @State private var procedureCancellable: AnyCancellable?

    @StateObject private var visitsVM = ReadDatencounter()
    @State private var selectVisits: VisitDummyData? = nil
    
    @StateObject private var viewModelPrac = ReadDatapractitioner()
    @StateObject private var practOrganisationVM = ReadDatapractitioner_organization()
    @StateObject private var organisationVM = ReadDataorganization()

    @State private var selectedPractitioner: PractitionerData? = nil
    @State private var organizationName: String = ""


    var body: some View {
        
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: 24) {
                    
                    HStack {
                        CustomBackButton(title: "Imaging") {
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
                    
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("\(imaging.modalityDisplay) (\(imaging.modalityCode))")
                                .font(.montserrat(16, weight: .medium))
                                .foregroundColor(.black)
                            Spacer()
                            
                            Text(imaging.status)
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Color.green.opacity(0.2))
                                .foregroundColor(.green)
                                .clipShape(Capsule())

                            
                        }
                        .padding(.top,12)
                        .padding(.horizontal,12)

                        
                        Text(imaging.formattedStartDate)
                             .font(.montserrat(13, weight: .regular))
                            .foregroundColor(.black)
                            .padding(.horizontal,12)

                        Text(imaging.description)
                            .font(.montserrat(16, weight: .medium))
                            .foregroundColor(.black)
                            .padding(.horizontal,12)
                        
                        Text("ID: \(imaging.id)")
                             .font(.montserrat(16, weight: .semibold))
                            .foregroundColor(Color(hex: "FF6605"))
                            .padding(.horizontal,12)

                    }
                    .padding()
                    .background(.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 2)
                    .padding(.horizontal)

                    Button(action: {
                        // Your action here
                        navigatePatient = true

                    }) {
                        
                        // Patient Card
                        HStack {
                            Image("ME-Logo") // Replace with actual image
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .overlay(
                                    Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )

                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(selectedPractitioner?.name ?? "")
                                    .font(.montserrat(18, weight: .medium))
                                    .foregroundColor(Color(hex: "FF6605"))
                                Text(organizationName)
                                     .font(.montserrat(14, weight: .regular))
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            Image(systemName: "arrow.right")
                                .foregroundColor(Color(hex: "FF6605"))
                        }
                        .padding()
                        .background(.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 2)
                        .padding(.horizontal)

                    }
                    .buttonStyle(PlainButtonStyle())
                    

                    if !matchingConditions.isEmpty {
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 24) {
                                Rectangle()
                                    .fill(Color(hex: "FF6605"))
                                    .frame(width: 5)
                                    .frame(height:90)
                                    .padding(.leading, 6)
                              
                                VStack(alignment: .leading, spacing: 12) {
                                    
                                    Text("Conditions (\(matchingConditions.count))")
                                       .font(.montserrat(16, weight: .bold))
                                        .padding(.leading, 4)
                                    
                                    ForEach(matchingConditions) { condition in
                                        
                                        HStack {
                                            Text(condition.description)
                                                 .font(.montserrat(12, weight: .regular))
                                            Spacer()
                                            Text("Clinical Status: \(condition.clinicalStatus.capitalized)")
                                               .font(.montserrat(12, weight: .medium))
                                        }
                                    }

                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.white) // Light blue background
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 2)
                        .padding(.horizontal)

                    }

                    if !matchingProcedure.isEmpty {
                        
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 24) {
                                Rectangle()
                                    .fill(Color(hex: "FF6605"))
                                    .frame(width: 5)
                                    .frame(height:90)
                                    .padding(.leading, 6)
                              
                                VStack(alignment: .leading, spacing: 12) {
                                    
                                    Text("Procedures (\(matchingProcedure.count))")
                                       .font(.montserrat(16, weight: .bold))
                                    
                                    
                                    ForEach(matchingProcedure) { proceedur in
                                        
                                        HStack {
                                            Text(proceedur.codeDisplay)
                                                 .font(.montserrat(12, weight: .regular))
                                            Spacer()
                                            Text("Status: \(proceedur.status.capitalized)")
                                               .font(.montserrat(12, weight: .medium))
                                        }
                                    }

                                }
                                
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.white) // Light blue background
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 2)
                        .padding(.horizontal)

                        
                    }
                    
                    if let performers = imaging.performer {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Performers")
                                .font(.montserrat(16, weight: .bold))
                            ForEach(performers, id: \.reference) { performer in
                                Text(performer.display)
                                    .font(.montserrat(13, weight: .semibold))

                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 2)
                        .padding(.horizontal)

                    }

                    
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

                    Spacer()

                }
                
                NavigationLink(
                    destination: Group {
                            if let practitioner = selectedPractitioner {
                                PractitionerDetailView(practitioner: practitioner)
                            } else {
                                EmptyView()
                            }
                        },
                    isActive: $navigatePatient
                ) {
                    EmptyView()
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
                    selectedCategory = UploadCategory(name: "Imaging", id: imaging.id)
                }
                
                // Appointment filtering
                conditionCancellable = conditionVM.$conditionArray
                    .receive(on: DispatchQueue.main)
                    .sink { condition in
                        matchingConditions = condition.filter { $0.id == imaging.conditionId }
                    }
                
                procedureCancellable = procedureVM.$procedures
                    .receive(on: DispatchQueue.main)
                    .sink { procedure in
                        matchingProcedure = procedure.filter { $0.id == imaging.procedureId }
                    }
                
                findEncounter()

            }
            .padding(.top)
            .background(Color((UIColor.systemGray6)).ignoresSafeArea())
            .navigationBarBackButtonHidden(true)
        }
    }
    
    private func findEncounter() {
            // Wait until practitioners are loaded
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                
                if let encounter = visitsVM.visitData.first(where: { $0.id == imaging.encounterId }) {
                    self.selectVisits = encounter
                    
                    if let practitioner = viewModelPrac.practitioners.first(where: { $0.id == encounter.practitionerId }) {
                        self.selectedPractitioner = practitioner
                        if let link = practOrganisationVM.organizations.first(where: { $0.practitionerId == practitioner.id }) {
                            if let org = organisationVM.organizations.first(where: { $0.id == link.organizationId }) {
                                self.organizationName = org.name
                            }
                        }
                    }
                }
            }
        }

    
    func generateVitalShareText() -> String {
        
        let modality = "\(imaging.modalityDisplay) (\(imaging.modalityCode))"
        let description = imaging.description
        let performer = imaging.performer?.first?.display ?? "N/A"
        let procedure = imaging.procedureCodeDisplay
        let status = imaging.status.capitalized
        let date = imaging.formattedStartDate
        let patientName = "\(userProfileData?.first_name ?? "") \(userProfileData?.last_name ?? "")"

        return """
        Imaging Report

        Here's my Imaging report info from mEinstein — your digital healthcare assistant!
        https://bit.ly/4ipzMmF

        Modality: \(modality)
        Description: \(description)
        Performer: \(performer)
        Procedure: \(procedure)
        Status: \(status)
        Date: \(date)

        Patient: \(patientName)
        Imaging ID: \(imaging.id)

        Visits Status: In-progress
        Start Date: \(date)

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
