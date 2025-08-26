//
//  PractitionerDetailView.swift
//  mE Health
//
//  Created by Ishant on 16/06/25.
//

import SwiftUI
import AVFoundation
import Combine

struct PractitionerDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var practOrganisationVM = ReadDatapractitioner_organization()
    @StateObject private var organisationVM = ReadDataorganization()
    
    @State private var filteredOrganizations: [Organization] = []
    
    
    @StateObject private var appointmentVM = ReadDataappointment()
    @State private var filteredAppointments: [AppointmentData] = []
    
    @StateObject private var visitsVM = ReadDatencounter()
    @State private var filteredVisits: [VisitDummyData] = []


    @State private var orgCancellable: AnyCancellable?
    @State private var appointmentCancellable: AnyCancellable?
    @State private var visitCancellable: AnyCancellable?

    let practitioner: PractitionerData

    @State private var showVistList = false
    @State private var showApptList = false
    
    @State private var showUploadView = false

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
        savedFiles.filter { $0.categoryId == practitioner.id }
    }
    @State private var selectedCategory: UploadCategory? = nil
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
    
       private var get_file_name: String {
           "\(practitioner.name)_\(practitioner.formattedCreatedDate)"
    }

    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            
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

            VStack(alignment: .leading, spacing: 16) {
                Text("Details")
                   .font(.montserrat(32, weight: .bold))
                
                PractitionerCardView(
                    practitioner: practitioner,
                    onTap: {
                        
                    },
                    onActionTapped: {
                       
                    }
                )
                
                VStack(spacing: 12) {
                    
                    Text("Organizations")
                        .font(.montserrat(22, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(filteredOrganizations) { org in
                                OrganizationCardView(organization: org)
                            }
                        }
                        .frame(height:110)
                        .padding(.horizontal)
                        
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Appointments")
                            .font(.montserrat(22, weight: .bold))

                        Spacer()

                        // Show button only if more than 2 appointments
                        if filteredAppointments.count > 2 {
                            Button(action: {
                                showApptList = true
                            }) {
                                Text("View All")
                                    .font(.montserrat(12, weight: .semibold))
                                    .foregroundColor(Color(hex: "FF6605"))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color(hex: "FF6605").opacity(0.1))
                                    .cornerRadius(16)
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        // Show only first 2 appointments
                        ForEach(filteredAppointments.prefix(2)) { appointment in
                            PractionerAppoitmentsCardView(
                                name: appointment.practitionerName,
                                dateTime: appointment.formattedStartDate
                            )
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Visits")
                            .font(.montserrat(22, weight: .bold))

                        Spacer()

                        // Show button only if more than 2 appointments
                        if filteredVisits.count > 2 {
                            Button(action: {
                                showVistList = true
                            }) {
                                Text("View All")
                                    .font(.montserrat(12, weight: .semibold))
                                    .foregroundColor(Color(hex: "FF6605"))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color(hex: "FF6605").opacity(0.1))
                                    .cornerRadius(16)
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        // Show only first 2 appointments
                        ForEach(filteredVisits.prefix(2)) { visit in
                            PractionerAppoitmentsCardView(
                                name: visit.description,
                                dateTime: visit.formattedDate
                            )
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
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

                


                
                NavigationLink(
                    destination: VisitAllView(filteredVisits: filteredVisits),
                    isActive: $showVistList,
                    label: {
                        EmptyView()
                    })
                
                NavigationLink(
                    destination: AppoitmentAllView(filteredAppointments: filteredAppointments),
                    isActive: $showApptList,
                    label: {
                        EmptyView()
                    })
                
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
            .onAppear {
                savedFiles = MediaStorageManager.shared.fetchSavedMedia()

                if selectedCategory == nil {
                    selectedCategory = UploadCategory(name: "Practitioners", id: practitioner.id)
                }

                // CombineLatest for practitioner-organization + organization
                orgCancellable = Publishers.CombineLatest(
                    practOrganisationVM.$organizations,
                    organisationVM.$organizations
                )
                .receive(on: DispatchQueue.main)
                .sink { (practData, orgData) in
                    let orgIds = practData
                        .filter { $0.practitionerId == practitioner.id }
                        .map { $0.organizationId }

                    filteredOrganizations = orgData.filter { orgIds.contains($0.id) }

                    print("✅ Filtered orgs count: \(filteredOrganizations.count)")
                }

                // Appointment filtering
                appointmentCancellable = appointmentVM.$appoitments
                    .receive(on: DispatchQueue.main)
                    .sink { appointments in
                        filteredAppointments = appointments.filter { $0.practitionerId == practitioner.id }
                        print("✅ Filtered \(filteredAppointments.count) appointments for \(practitioner.id)")
                    }
                
                visitCancellable = visitsVM.$visitData
                    .receive(on: DispatchQueue.main)
                    .sink { encounter in
                        filteredVisits = encounter.filter { $0.practitionerId == practitioner.id }
                    }

            }

            
            .padding()
            .background(Color.white)
            .navigationBarBackButtonHidden(true)

        }
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



