//
//  ConditionDetailView.swift
//  mE Health
//
//  Created by Rashida on 1/07/25.
//

import SwiftUI
import AVFoundation
import Combine

struct ConditionDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode

    @State var organizations: [Organization] = []

    @State private var showPractitionerList = false
    let condition: ConditionDummyData
    
    @State private var showVitalList = false
    @State private var showLabsList = false
    @State private var showMedicationList = false
    @State private var showVistList = false
    
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
        savedFiles.filter { $0.categoryId == condition.id }
    }
    @State private var selectedCategory: UploadCategory? = nil
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?

    private var get_file_name: String {
        "\(condition.codeDisplay)_\(condition.formattedOnSetDate)"
    }
    
    @StateObject private var visitsVM = ReadDatencounter()
    @State private var filteredVisits: [VisitDummyData] = []
    @State private var visitCancellable: AnyCancellable?
    
    @StateObject private var viewModelPrac = ReadDatapractitioner()
    @StateObject private var practOrganisationVM = ReadDatapractitioner_organization()
    @StateObject private var organisationVM = ReadDataorganization()
    @StateObject private var labVM = ReadDatdiagnostic_report()
    @StateObject private var vitalVM = ReadDataobservation()
    @StateObject private var medicationVM = ReadDatamedication_request()
    @State private var displayList: [PractitionerDisplay] = []
    
    @State private var filteredLabs: [LabDummyData] = []
    @State private var filteredVitals: [VitalDummyData] = []
    @State private var filteredMedication: [MedicationDummyData] = []


    var body: some View {
        
        ZStack {

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 12) {
                    
                    HStack {
                        CustomBackButton(title: "Condition") {
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

                    Text("Current Details")
                       .font(.montserrat(32, weight: .bold))
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        
                        HStack(spacing: 8) {
                            Text(condition.codeDisplay)
                                .font(.montserrat(17, weight: .bold))
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            if condition.clinicalStatus ==  "active" {
                                Text("Active")
                                    .font(.montserrat(9, weight: .semibold))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(Color(hex: "06C270").opacity(0.2))
                                    .foregroundColor(Color(hex: "06C270"))
                                    .clipShape(Capsule())

                            }
                            else  {
                                Text("Resolved")
                                    .font(.montserrat(9, weight: .semibold))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(Color(hex: "A811C7").opacity(0.2))
                                    .foregroundColor(Color(hex: "A811C7"))
                                    .clipShape(Capsule())
                            }
                        }
                        
                        HStack {
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Onset")
                                     .font(.montserrat(12, weight: .regular))
                                Text(condition.formattedOnSetDate)
                                     .font(.montserrat(14, weight: .regular))
                                
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Recorded")
                                     .font(.montserrat(12, weight: .regular))
                                
                                Text(condition.formattedOnRecordDate)
                                     .font(.montserrat(14, weight: .regular))
                                
                            }
                        }
                        
                        
                        HStack {
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Condition ID")
                                     .font(.montserrat(12, weight: .regular))
                                
                                Text("\(condition.id)")
                                     .font(.montserrat(14, weight: .regular))
                                
                            }
                            Spacer()
                        }
                        
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 2)
                    .padding(.horizontal)
                
                    if !displayList.isEmpty {
                        
                        VStack(spacing: 8) {
                            HStack {
                                Text("Practitioners")
                                    .font(.montserrat(22, weight: .bold))
                                
                                Spacer()
                                
                                if displayList.count > 2 {
                                    Button(action: {
                                        showPractitionerList = true
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
                            .padding(.horizontal)
                            
                            
                            VStack(alignment: .leading, spacing: 8) {
                                // Show only first 2 appointments
                                ForEach(displayList.prefix(2)) { item in
                                    
                                    HStack {
                                        Image("ME-Logo") // Replace with actual image
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                            .overlay(
                                                Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                            )

                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(item.name)
                                                .font(.montserrat(18, weight: .medium))
                                                .foregroundColor(Color(hex: "FF6605"))
                                            Text(item.organizationName)
                                                 .font(.montserrat(14, weight: .regular))
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                    }
                                    .padding()
                                    .background(.clear)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    
                    
                    if !filteredVitals.isEmpty {
                        
                        VStack(spacing: 12) {
                            HStack {
                                Text("Vitals")
                                    .font(.montserrat(22, weight: .bold))
                                
                                Spacer()
                                
                                if filteredVitals.count > 2 {
                                    
                                    Button(action: {
                                        showVitalList = true
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
                            
                            
                            ForEach(filteredVitals.prefix(2)) { vitals in
                                VStack(alignment: .leading, spacing: 8) {
                                    PractionerAppoitmentsCardView(
                                        name: vitals.codeDisplay,
                                        dateTime: vitals.formattedDate
                                    )
                                    .frame(height: 80)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 2)
                            }


                        }
                        .padding()
                        .background(Color.clear)
                        .padding(.horizontal)

                    }
                    
                    
                    if !filteredLabs.isEmpty {
                        
                        VStack(spacing: 12) {
                            HStack {
                                Text("Labs")
                                    .font(.montserrat(22, weight: .bold))
                                
                                Spacer()
                                
                                if filteredLabs.count > 2 {
                                    
                                    Button(action: {
                                        showLabsList = true
                                        
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
                            
                            ForEach(filteredLabs.prefix(2)) { lab in
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    PractionerAppoitmentsCardView(
                                        name: lab.codeDisplay,
                                        dateTime: lab.formattedDate
                                    )
                                    .frame(height: 80)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 2)
                            }
                        }
                        .padding()
                        .background(Color.clear)
                        .padding(.horizontal)

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
                                .frame(height: 80)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 2)

                    }
                    .padding()
                    .background(Color.clear)
                    .padding(.horizontal)

                    
                    

                    if !filteredMedication.isEmpty {
                        
                        VStack(spacing: 12) {
                            HStack {
                                Text("Medication")
                                    .font(.montserrat(22, weight: .bold))
                                
                                Spacer()
                                
                                if filteredMedication.count > 2 {
                                    Button(action: {
                                        showMedicationList = true
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
                                ForEach(filteredMedication.prefix(2)) { med in
                                    PractionerAppoitmentsCardView(
                                        name: med.description,
                                        dateTime: med.formattedAuthoredDate
                                    )
                                    .frame(height: 80)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 2)

                        }
                        .padding()
                        .background(Color.clear)
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
                            print(generateConditionSummary())
                            showShare = true
                        }
                    )
                    .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 2)
                    .padding(.horizontal)


                    
//                    Button(action: {
//                        
//                    }) {
//                        Text("Add Related Data")
//                             .font(.montserrat(16, weight: .semibold))
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity, alignment: .center)
//                            .frame(height:40)
//                            .padding(.horizontal, 16)
//                            .padding(.vertical, 8)
//                            .background(Color(hex: "FF6605"))
//                            .cornerRadius(32)
//                    }
//                    .buttonStyle(PlainButtonStyle())
//                    .padding(.horizontal,24)

                    Spacer()
                }
                
                NavigationLink(
                    destination: PractionerListView(arrayItem: displayList, condition: condition),
                    isActive: $showPractitionerList,
                    label: {
                        EmptyView()
                    })
                
                NavigationLink(
                    destination: VitalsAllView(vitalPassArray: filteredVitals),
                    isActive: $showVitalList,
                    label: {
                        EmptyView()
                    })
                
                NavigationLink(
                    destination: LabsAllView(array: filteredLabs),
                    isActive: $showLabsList,
                    label: {
                        EmptyView()
                    })
                
                NavigationLink(
                    destination: VisitAllView(filteredVisits: filteredVisits),
                    isActive: $showVistList,
                    label: {
                        EmptyView()
                    })
                
                NavigationLink(
                    destination: MedicationAllView(array: filteredMedication),
                    isActive: $showMedicationList,
                    label: {
                        EmptyView()
                    })

            }
            .sheet(isPresented: $showShare) {
                
                ShareSheet(activityItems: [generateConditionSummary()])
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
                    selectedCategory = UploadCategory(name: "Conditions", id: condition.id)
                }
                
                visitCancellable = visitsVM.$visitData
                    .receive(on: DispatchQueue.main)
                    .sink { encounter in
                        filteredVisits = encounter.filter { $0.id == condition.encounterId }
                    }
                
                buildDisplayList()
                

            }
            .background(Color(UIColor.systemGray6).ignoresSafeArea())
            .navigationBarBackButtonHidden(true)
        }
    }
    
    private func buildDisplayList() {
        // Find the encounter
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            guard let encounter = visitsVM.visitData.first(where: { $0.id == condition.encounterId }) else { return }
            
            filteredLabs = labVM.labs.filter {
                   $0.encounterId == encounter.id
            }
            
            filteredVitals = vitalVM.vitalArray.filter {
                   $0.encounterId == encounter.id
            }
            
            filteredMedication = medicationVM.medication.filter {
                   $0.encounterId == encounter.id
            }
            
            // Find the practitioner for that encounter
            let practitioners = viewModelPrac.practitioners.filter { $0.id == encounter.practitionerId }
            
            
            // Build display array
            displayList = practitioners.compactMap { practitioner in
                guard let link = practOrganisationVM.organizations.first(where: { $0.practitionerId == practitioner.id }),
                      let org = organisationVM.organizations.first(where: { $0.id == link.organizationId })
                else {
                    return PractitionerDisplay(id: practitioner.id,
                                                name: practitioner.name,
                                                organizationName: "Unknown Organization")
                }
                
                return PractitionerDisplay(id: practitioner.id,
                                            name: practitioner.name,
                                            organizationName: org.name)
            }
            
            
        }

    }

    
    func generateConditionSummary() -> String {
        
        let conditionName = condition.codeDisplay
        let status = condition.clinicalStatus.capitalized
        let onsetDate = condition.formattedOnSetDate
        let recordedDate = condition.formattedOnRecordDate
        let conditionID = condition.id

        return """
            
                Here's my health condition info from mEinstein — your digital healthcare assistant!
                https://bit.ly/4ipzMmF

                Condition: \(conditionName)
                Status: \(status)
                Onset Date: \(onsetDate)
                Recorded Date: \(recordedDate)
                Condition ID: \(conditionID)
                Practitioner: Dr. Emily Carter, MD - Family Medicine
                Recent Vital: Blood Pressure - 1 July 2021
                Recent Lab: Lipid Panel - 1 General Street, Lawrence, MA 01841
                Visit Type: Ambulatory - 1 General Street, Lawrence, MA 01841
                Medication: Cetirizine 10 mg - 1 General Street, Lawrence, MA 01841
            
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



struct PractitionerDisplay: Identifiable {
    let id: String
    let name: String
    let organizationName: String
}
