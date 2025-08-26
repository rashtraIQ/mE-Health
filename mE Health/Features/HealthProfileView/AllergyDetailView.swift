//
//  AllergyDetailView.swift
//  mE Health
//
//  Created by Rashida on 18/06/25.
//

import SwiftUI
import AVFoundation
import ComposableArchitecture
struct AllergyDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    let allergy: AllergyData

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
    
    @State private var documentToPreview: URL? = nil
    @State private var showDocumentPreview: Bool = false


   @State private var savedFiles: [SavedMedia] = []
    private var practitionerFiles: [SavedMedia] {
        savedFiles.filter { $0.categoryId == allergy.id }
    }
    @State private var selectedCategory: UploadCategory? = nil
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
    

    private var get_file_name: String {
        "\(allergy.code?.display ?? "Allergy")_\(allergy.formattedRecordedDate)"
    }
    
    @StateObject private var visitsVM = ReadDatencounter()
    @StateObject private var viewModelPrac = ReadDatapractitioner()
    @StateObject private var practOrganisationVM = ReadDatapractitioner_organization()
    @StateObject private var organisationVM = ReadDataorganization()
    @State private var selectVisits: VisitDummyData? = nil

    @State private var navigatePatient = false
    
    @State private var selectedPractitioner: PractitionerData? = nil
    @State private var organizationName: String = ""

    @StateObject private var medicationVM = ReadDatamedication_request()
    @State private var encounterMedications: [MedicationDummyData] = []

    @StateObject private var conditionVM = ReadDatcondition()
    @State private var encounterCondition: [ConditionDummyData] = []

    
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
                    Text("Allergies")
                       .font(.montserrat(32, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    // Allergy Detail Card
                    VStack(alignment: .leading, spacing: 16) {
                        Text(allergy.code?.display ?? "")
                           .font(.montserrat(19, weight: .bold))

                        HStack {
                            Text("Clinical Status")
                            Spacer()
                            Text(allergy.clinicalStatus)
                                .font(.montserrat(8, weight: .semibold))
                                .padding(.vertical, 4)
                                .padding(.horizontal, 10)
                                .background(Color(hex: "06C270").opacity(0.2))
                                .foregroundColor(Color(hex: "06C270"))
                                .cornerRadius(12)
                                .frame(width: 60, height: 24)
                        }

                        HStack {
                            Text("Recorded Date")
                             .font(.montserrat(14, weight: .regular))
                            Spacer()
                            Text(allergy.formattedRecordedDate)
                            .font(.montserrat(13, weight: .semibold))
                        }

                        HStack {
                            Text("Allergy ID")
                             .font(.montserrat(14, weight: .regular))
                            Spacer()
                            Text("\(allergy.id)")
                                .font(.montserrat(13, weight: .semibold))
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 2)
                    .padding(.horizontal)
                    
                    
                    Button(action: {
                        // Your action here
                        navigatePatient = true

                    }) {
                        
                        HStack {
   //                        Image("profile_placeholder") // Replace with actual image
   //                            .resizable()
   //                            .frame(width: 50, height: 50)
   //                            .clipShape(Circle())
                           
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
                       .background(.white)
                       .cornerRadius(12)
                       .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 2)
                       .padding(.horizontal)

                    }
                    .buttonStyle(PlainButtonStyle())

                    
                    

                    if !encounterCondition.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 24) {
                                Rectangle()
                                    .fill(Color(hex: "FF6605"))
                                    .frame(width: 5)
                                    .frame(height:90)
                                    .padding(.leading, 6)
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    
                                    Text("Conditions (\(encounterCondition.count)")
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
                        title: "Refresh Data",
                        onRefresh: {
                            print("Refresh tapped")
                        },
                        onShare: {
                            showShare = true
                        }
                    )
                    .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 2)

                    
                    Spacer()

                }
                .padding(.horizontal,8)
                
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
                ShareSheet(activityItems: [generateAllergyShareText()])
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
                    selectedCategory = UploadCategory(name: "Allergies", id: allergy.id)
                }
                
                findEncounter()
            }
            .padding(.top)
            .background(Color.white.ignoresSafeArea())
            .navigationBarBackButtonHidden(true)
        }
    }
    
    
    private func findEncounter() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // 1. Find the encounter
            if let encounter = visitsVM.visitData.first(where: { $0.id == allergy.encounterId }) {
                self.selectVisits = encounter
                
                if let practitioner = viewModelPrac.practitioners.first(where: { $0.id == encounter.practitionerId }) {
                    self.selectedPractitioner = practitioner
                    
                    if let link = practOrganisationVM.organizations.first(where: { $0.practitionerId == practitioner.id }) {
                        if let org = organisationVM.organizations.first(where: { $0.id == link.organizationId }) {
                            self.organizationName = org.name
                        }
                    }
                }
                
                
                self.encounterMedications = medicationVM.medication.filter {
                        $0.encounterId == encounter.id
                }
                
                self.encounterCondition = conditionVM.conditionArray.filter {
                        $0.encounterId == encounter.id
                }
            }
        }
    }


    
    func generateAllergyShareText() -> String {
        let name = allergy.code?.display ?? "Allergy"
        let clinicalStatus = allergy.clinicalStatus
        let recordedDate = allergy.formattedRecordedDate
        let allergyID = "\(allergy.id)"

        let userName = "\(userProfileData?.first_name ?? "") \(userProfileData?.last_name ?? "")"
        let userGender = userProfileData?.gender ?? "M"
        let userAge = "34 years"

        return """
        
        Allergy Information

        Here is my allergy record from mEinstein! It's a fantastic app to manage your health.
        https://bit.ly/4ipzMmF

        Allergy Name: \(name)
        Clinical Status: \(clinicalStatus)
        Recorded Date: \(recordedDate)
        Allergy ID: \(allergyID)

        Patient: \(userName)
        Age/Gender: \(userAge) - \(userGender)

        Conditions (2)
        Essential Hypertension
        Clinical Status: Active
        Type 2 Diabetic
        Clinical Status: Active

        Medications (2)
        Lisinopril 10mg
        Clinical Status: Active
        Metformin 500mg
        Clinical Status: Active

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

struct ActionButtonsView: View {
    let title: String
    var onRefresh: () -> Void
    var onShare: () -> Void

    var body: some View {
        HStack(spacing: 32) {
            
            // Refresh Button
            Button(action: onRefresh) {
                HStack(spacing: 8) {
                    Image("Refresh_data")
                        .foregroundColor(Color(hex: "FF6605"))
                    Text(title)
                        .foregroundColor(.black)
                        .font(.montserrat(16, weight: .medium))
                }
            }

            // Share Button
            Button(action: onShare) {
                HStack(spacing: 8) {
                    Image("ShareRecord")
                        .foregroundColor(Color(hex: "FF6605"))
                    Text("Share Record")
                        .foregroundColor(.black)
                        .font(.montserrat(16, weight: .medium))
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(Color(hex: "F5F5F5"))
        .cornerRadius(32)
        
    }
}

