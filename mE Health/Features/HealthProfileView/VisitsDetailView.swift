//
//  VisitsDetailView.swift
//  mE Health
//
//  Created by Rashida on 30/06/25.
//

import SwiftUI
import AVFoundation

struct VisitsDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    let visit: VisitDummyData

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
        savedFiles.filter { $0.categoryId == visit.id }
    }
    @State private var selectedCategory: UploadCategory? = nil
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?

    @State private var documentToPreview: URL? = nil
    @State private var showDocumentPreview: Bool = false
    
    private var get_file_name: String {
        "\(visit.typeDisplay)_\(visit.formattedDate)"
    }
    
    @State private var navigatePractioner = false
    @StateObject private var viewModelPrac = ReadDatapractitioner()
    @State private var selectedPractitioner: PractitionerData? = nil
    @State private var organizationName: String = ""
    @StateObject private var practOrganisationVM = ReadDatapractitioner_organization()
    @StateObject private var organisationVM = ReadDataorganization()

    @StateObject private var medicationVM = ReadDatamedication_request()
    @State private var encounterMedications: [MedicationDummyData] = []

    @StateObject private var conditionVM = ReadDatcondition()
    @State private var encounterCondition: [ConditionDummyData] = []

    
    @StateObject private var procedureVM = ReadDataprocedure()
    @State private var matchingProcedure: [ProcedureDummyData] = []
    
    @StateObject private var allergyVM = ReadDataallergyIntolerances()
    @State private var matchingAllergy: [AllergyData] = []



    var body: some View {
        
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: 24) {
                    
                    HStack {
                        CustomBackButton(title: "Visit") {
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
                    
                    // Allergy Detail Card
                    VStack(alignment: .leading, spacing: 16) {
                        
                        HStack(spacing: 8) {
                            Text("Visit Details")
                                .font(.montserrat(18, weight: .bold))
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            if visit.status ==  "planned" {
                                Text("Planned")
                                    .font(.montserrat(9, weight: .semibold))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(Color(hex: "F09C00").opacity(0.2))
                                    .foregroundColor(Color(hex: "F09C00"))
                                    .clipShape(Capsule())

                            }
                            else if visit.status ==  "finished" {
                                Text("Finished")
                                    .font(.montserrat(9, weight: .semibold))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(Color.green.opacity(0.2))
                                    .foregroundColor(Color.green)
                                    .clipShape(Capsule())
                            }
                            
                        }

                        HStack {
                            Text("Visit ID")
                               .font(.montserrat(12, weight: .medium))
                            Spacer()
                            Text("ENC-\(visit.id)")
                            .font(.montserrat(12, weight: .semibold))
                        }

                        HStack {
                            Text("Start date")
                               .font(.montserrat(12, weight: .medium))
                            Spacer()
                            Text(visit.formattedDate)
                            .font(.montserrat(12, weight: .semibold))
                        }
                        
                        HStack {
                            Text("Type")
                               .font(.montserrat(12, weight: .medium))
                            Spacer()
                            Text(visit.typeDisplay)
                            .font(.montserrat(12, weight: .semibold))
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 2)
                    .padding(.horizontal)


                    // Patient Card
                    Button(action: {
                        // Your action here
                        if let practitioner = viewModelPrac.practitioners.first(where: { $0.id == visit.practitionerId }) {
                            selectedPractitioner = practitioner
                            navigatePractioner = true
                        }

                    }) {
                        HStack {
                            Image("ME-Logo")
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
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 2)
                        .padding(.horizontal)
                    }
                    .buttonStyle(PlainButtonStyle()) // To remove default button styling

                    

                    if !encounterCondition.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 24) {
                                Rectangle()
                                    .fill(Color(hex: "FF6605"))
                                    .frame(width: 5)
                                    .frame(height:90)
                                    .padding(.leading, 6)
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    
                                    Text("Conditions (\(encounterCondition.count))")
                                        .font(.montserrat(19, weight: .bold))
                                        .padding(.leading, 4)
                                    
                                    ForEach(encounterCondition) { condition in
                                        
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
                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
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

                    if !encounterMedications.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 24) {
                                Rectangle()
                                    .fill(Color(hex: "FF6605"))
                                    .frame(width: 5)
                                    .frame(height:90)
                                    .padding(.leading, 6)
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    
                                    Text("Medications (\(encounterMedications.count))")
                                        .font(.montserrat(19, weight: .bold))
                                        .padding(.leading, 4)
                                    
                                    ForEach(encounterMedications) { med in
                                        HStack {
                                            Text(med.medicationCodeDisplay)
                                                .font(.montserrat(12, weight: .regular))
                                            Spacer()
                                            Text("Clinical Status: \(med.status.capitalized)")
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
                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                        .padding(.horizontal)
                    }
                    
                    
                    
                    if !matchingAllergy.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 24) {
                                Rectangle()
                                    .fill(Color(hex: "FF6605"))
                                    .frame(width: 5)
                                    .frame(height:90)
                                    .padding(.leading, 6)
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Allergies (\(matchingAllergy.count))")
                                        .font(.montserrat(19, weight: .bold))
                                        .padding(.leading, 4)
                                    
                                    ForEach(matchingAllergy) { allergy in
                                        HStack {
                                            Text(allergy.code?.display ?? "")
                                                .font(.montserrat(12, weight: .regular))
                                            Spacer()
                                            Text("Clinical Status: \(allergy.clinicalStatus.capitalized)")
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
                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                        .padding(.horizontal)
                    }

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
                .padding(.horizontal,8)
            }
            
            NavigationLink(
                destination: Group {
                        if let practitioner = selectedPractitioner {
                            PractitionerDetailView(practitioner: practitioner)
                        } else {
                            EmptyView()
                        }
                    },
                isActive: $navigatePractioner
            ) {
                EmptyView()
            }
            
            .sheet(isPresented: $showShare) {
                ShareSheet(activityItems: [generateVisitShareText()])
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
                    selectedCategory = UploadCategory(name: "Visits", id: visit.id)
                }
                
                findPractitioner()
                
            }
            .padding(.top)
            .background(Color.white.ignoresSafeArea())
            .navigationBarBackButtonHidden(true)

        }
    }
    
    private func findPractitioner() {
            // Wait until practitioners are loaded
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                
                selectedPractitioner = viewModelPrac.practitioners.first { $0.id == visit.practitionerId }
                
                
                    
                    if let practitioner = viewModelPrac.practitioners.first(where: { $0.id == visit.practitionerId }) {
                        self.selectedPractitioner = practitioner
                        
                        if let link = practOrganisationVM.organizations.first(where: { $0.practitionerId == practitioner.id }) {
                            if let org = organisationVM.organizations.first(where: { $0.id == link.organizationId }) {
                                self.organizationName = org.name
                            }
                        }
                    }
                    
                    self.encounterMedications = medicationVM.medication.filter {
                            $0.encounterId == visit.id
                    }
                
                    self.encounterCondition = conditionVM.conditionArray.filter {
                        $0.encounterId == visit.id
                    }
                
                    self.matchingProcedure = procedureVM.procedures.filter {
                        $0.encounterId == visit.id
                    }
                
                    self.matchingAllergy = allergyVM.allergy.filter {
                        $0.encounterId == visit.id
                    }
                
                

            }
        }
    
    func generateVisitShareText() -> String {
        let patientName = "\(userProfileData?.first_name ?? "") \(userProfileData?.last_name ?? "")"
        let visitID = "ENC-\(visit.id)"
        let status = visit.status.capitalized
        let startDate = visit.formattedDate
        let type = visit.typeDisplay
        
        return """
        Visit Details

        Here's my recent visit info from mEinstein — your digital healthcare assistant!
        https://bit.ly/4ipzMmF

        Visit ID: \(visitID)
        Status: \(status)
        Start Date: \(startDate)
        Type: \(type)

        Patient Name: \(patientName)
        
        Encountered Conditions:
        • Essential Hypertension (Active)
        • Type 2 Diabetes (Active)

        Procedures:
        • Appendectomy (Completed)

        Medications:
        • Lisinopril 10mg (Active)
        • Metformin 500mg (Active)

        Allergies:
        • Penicillin (Severe)
        • Sulfa Drugs (Moderate)

        Thank you!
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
