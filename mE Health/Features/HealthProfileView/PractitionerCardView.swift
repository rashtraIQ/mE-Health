//
//  PractitionerCardView.swift
//  mE Health
//
//  Created by Ishant on 16/06/25.
//
import SwiftUI

struct PractitionerResponse: Codable {
    let practitioners: [PractitionerData]
}

struct PractitionerData: Codable, Equatable , Identifiable{
    let id: String
    let name: String
    let specialty: String
    let telecom: String
    let qualification: String
    var phone: String? {
        telecom
            .components(separatedBy: ";")
            .first(where: { $0.hasPrefix("phone:") })?
            .replacingOccurrences(of: "phone:", with: "")
    }
    
    var email: String? {
        telecom
            .components(separatedBy: ";")
            .first(where: { $0.hasPrefix("email:") })?
            .replacingOccurrences(of: "email:", with: "")
    }
    let createdAt: String
}

extension PractitionerData {
    var createdDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // Adjust to your date format
        return formatter.date(from: createdAt)
    }
    
    var createdConvertDate: Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.date(from: createdAt)
    }
    
    var formattedCreatedDate: String {
        guard let date = createdConvertDate else { return "" }
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy"
        return outputFormatter.string(from: date)
    }
    
}

struct PractitionerOrganisationResponse: Codable, Equatable {
    let practitionerOrganizations: [PractitionerOrganization]
}

struct PractitionerOrganization: Codable,Equatable {
    let id: String
    let practitionerId: String
    let organizationId: String
}


struct PractitionerCardView: View {
    let practitioner: PractitionerData
    let onTap: () -> Void
    let onActionTapped: () -> Void  // ← ADD this
    
    var body: some View {
        HStack(spacing: 4) {
            VStack(alignment: .leading, spacing: 12) {
                Text(practitioner.name)
                    .font(.montserrat(16, weight: .bold))
                
                Text(practitioner.specialty)
                    .font(.montserrat(14, weight: .regular))
                    .foregroundColor(.gray)
                
                HStack(spacing: 8) {
                    Image(systemName: "phone.fill")
                        .foregroundColor(Color(hex: "FF6605"))
                    Text(practitioner.phone ?? "")
                        .font(.montserrat(14, weight: .regular))
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(Color(hex: "FF6605"))
                    Text(practitioner.email ?? "")
                        .font(.montserrat(14, weight: .regular))
                }
                
                
            }
            
            Spacer()
            PractitionerActionColumn(
                practitioner: practitioner,
                onViewTapped: onActionTapped // ← PASS CALLBACK
            )
            .frame(height: 150)
            .padding(.trailing, 0)  
        }
        .padding(.leading, 12)
        .frame(height:150)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
        .onTapGesture {
            onTap()
        }
    }
}

struct PractitionerActionColumn: View {
    //let icons = ["", "", "eye.fill"]
    
    let icons = ["envelope.fill", "phone.fill", "upload_white"]
    let practitioner: PractitionerData
    let onViewTapped: () -> Void  // ← ADD this
    
    var body: some View {
        VStack(spacing: 1) {
            ForEach(icons, id: \.self) { icon in
                Button(action: {
                    handleAction(for: icon)
                }) {
                    iconImage(for: icon)
                }
            }
        }
        .padding(.trailing, 0)
        .frame(width: 50)
        .background(
            RoundedCorners(color: Color.white, tl: 0, tr: 12, bl: 12, br: 0)
        )
    }
    
    @ViewBuilder
    private func iconImage(for icon: String) -> some View {
        if icon.contains(".fill") || icon.contains(".") || icon == "envelope.fill" || icon == "phone.fill" {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(width: 20, height: 20)
                .padding()
                .frame(width: 50, height: 50)
                .background(Color(hex: "FF6605"))
            
        } else {
            Image(icon)
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(width: 20, height: 20)
                .padding()
                .frame(width: 50, height: 50)
                .background(Color(hex: "FF6605"))
            
        }
    }
    
    
    private func handleAction(for icon: String) {
        switch icon {
        case "envelope.fill":
            if let url = URL(string: "mailto:\(practitioner.email ?? "")") {
                UIApplication.shared.open(url)
            }
        case "phone.fill":
            if let url = URL(string: "tel://\(practitioner.phone ?? "")") {
                UIApplication.shared.open(url)
            }
        case "upload_white":
            onViewTapped()
        default:
            break
        }
    }
}


struct PractitionerSectionView: View {
    
    let practitioners: [PractitionerData]
    let searchText: String
    let startDate: Date?
    let endDate: Date?
    var onCardTap: (PractitionerData) -> Void
    
    var dateFormatter: ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }
    
    @State private var showActionSheet = false
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var mediaSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var navigateToPreview = false
    
    @State private var showDocumentPicker = false
    @State private var selectedFileURL: URL?
    
    @State private var showVideoPicker = false
    @State private var selectedVideoURL: URL?
    
    @State private var selectedCategory: UploadCategory? = nil
    
    
    var filteredPractitioners: [PractitionerData] {
        practitioners.filter { practitioner in
            // 1. Filter by search text if available
            let matchesSearch: Bool
            if searchText.isEmpty {
                matchesSearch = true
            } else {
                matchesSearch = practitioner.name.localizedCaseInsensitiveContains(searchText) ||
                practitioner.specialty.localizedCaseInsensitiveContains(searchText) ||
                (practitioner.email?.localizedCaseInsensitiveContains(searchText) ?? false) ||
                (practitioner.phone?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
            let matchesDate: Bool
            if let start = startDate, let end = endDate {
                if let createdDate = dateFormatter.date(from: practitioner.createdAt) {
                    matchesDate = (createdDate >= start) && (createdDate <= end)
                } else {
                    matchesDate = false
                }
            } else {
                matchesDate = true // no date filter applied
            }
            return matchesSearch && matchesDate
        }
    }
    
    
    var body: some View {
        
        VStack(spacing: 20) {
            // Horizontal date cards
            
            if filteredPractitioners.isEmpty {
                NoDataView()
            } else {
                ForEach(filteredPractitioners) { practitioner in
                    
                    PractitionerCardView(
                        practitioner: practitioner,
                        onTap: {
                            onCardTap(practitioner)
                        },
                        onActionTapped: {
                            selectedCategory = UploadCategory(name: "Practitioners", id: practitioner.id)
                            selectedImage = nil
                            selectedVideoURL = nil
                            selectedFileURL = nil
                            navigateToPreview = false
                            showActionSheet = true
                        }
                    )
                }
            }
        }
        .padding(.horizontal)
        .actionSheet(isPresented: $showActionSheet) {
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
        .navigationDestination(isPresented: $navigateToPreview) {
            // let fileName = "\(allergy.code?.display ?? "Allergy")_\(allergy.formattedRecordedDate)"
            if let selectedImage = selectedImage,
               let selectedCategory = selectedCategory {
                UploadPreviewView(
                    image: selectedImage,
                    getFileName: "",
                    category: selectedCategory,
                    onSave: { saved in
                        //                        savedFile = saved
                        //                        savedFiles.append(saved)
                    }
                )
            }
            else if let selectedVideoURL = selectedVideoURL, let selectedCategory = selectedCategory {
                UploadPreviewView(
                    getFileName: "",
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
                    getFileName: "",
                    documentURL: selectedFileURL,
                    category: selectedCategory,
                    onSave: { saved in }
                )
            }
            else {
                Text("No image selected") // fallback if needed
            }
        }
        
    }
    
}





