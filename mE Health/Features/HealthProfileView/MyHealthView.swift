//
//  MyHealthView.swift
//  mE Health
//
//  Created by Ishant on 16/06/25.
//

import SwiftUI
import ComposableArchitecture

struct MyHealthView: View {
    let store: StoreOf<MyHealthFeature>
    @Environment(\.presentationMode) var presentationMode
    @State private var showAppoitmentOverlay = false
    
    @StateObject private var viewModel = ReadDatapractitioner()
    @StateObject private var appoitmentVM = ReadDataappointment()
    @StateObject private var procedureVM = ReadDataprocedure()
    @StateObject private var allergyVM = ReadDataallergyIntolerances()
    @StateObject private var immuneVM = ReadDataimmunization()
    @StateObject private var vitalVM = ReadDataobservation()
    @StateObject private var imagingVM = ReadDatimaging_study()
    @StateObject private var conditionVM = ReadDatcondition()
    @StateObject private var labVM = ReadDatdiagnostic_report()
    @StateObject private var billingVM = ReadDatclaim()
    @StateObject private var medicationVM = ReadDatamedication_request()
    @StateObject private var visitsVM = ReadDatencounter()
    @State private var savedFile: SavedMedia? = nil
    @State private var reloadTrigger = UUID()
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
    @State private var isClinicListActive = false
    @State private var savedFilesArray: [SavedMedia] = []
    @State private var selectedTab: DashboardTab = .menu
    @State private var showMenu: Bool = false
    @State private var selectedMenuTab: SideMenuTab = .persona
    @State private var navigateToSettings = false
    @State private var navigateToDashboard = false
    @State private var navigateToPersona = false
    @State private var navigateToContact = false
    
    @State private var showDeleteConfirmation = false
    @State private var fileToDeleteName: String = ""  // Replace `MediaFile` with your file model type


    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            
            MainLayout(
                selectedTab: $selectedTab,
                showMenu: $showMenu,
                selectedMenuTab: selectedMenuTab,
                onMenuItemTap: { tab in
                    selectedMenuTab = tab
                    showMenu = false
                    // Optional: route or update state
                    if tab == .dashboard {
                        navigateToDashboard = true
                    }
                    else if tab == .settings {
                        navigateToSettings = true
                    }
                    else if tab == .persona {
                        navigateToPersona = true
                    }
                    else if tab == .contact {
                        navigateToContact = true
                    }
                    else if tab == .logout {
                        
                    }

                },
                onDashboardTabTapped: {
                        navigateToDashboard = true
                    }
            )
            {
            
            VStack(alignment: .leading, spacing: 12) {
                                
                HStack {
                    CustomBackButton {
                        presentationMode.wrappedValue.dismiss()
                    }

                    Spacer()

                    Button(action: {
                        isClinicListActive = true
                    }) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 20))
                            .foregroundColor(Color(hex: "FF6605"))
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8) // adjust as needed


                Text("My Health")
                   .font(.montserrat(32, weight: .bold))
                    .padding(.horizontal)
                    .padding(.top, 16)

                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(viewStore.tiles.indices, id: \.self) { index in
                            let tile = viewStore.tiles[index]
                            MyHealthTileView(
                                icon: tile.icon,
                                title: tile.title,
                                countItem : getCount(for: tile.title),
                                isSelected: viewStore.selectedIndex == index
                            )
                            .onTapGesture {
                                viewStore.send(.selectTile(index), animation: .easeInOut(duration: 0.3))
                            }
                        }
                    }
                    .frame(height:180)
                    .padding(.horizontal)
                }
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        HeaderView(
                            store: store.scope(state: \.header, action: MyHealthFeature.Action.header)
                        )
                        let selectedTileTitle = viewStore.tiles[viewStore.selectedIndex].title
                        sectionView(for: selectedTileTitle, viewStore: viewStore)
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 100)
                }
                .padding(.top, 8)
                .padding(.bottom, 8)
                .onChange(of: viewStore.selectedIndex) { _ in
                    viewStore.send(.header(.hideSearch))
                    viewStore.send(.header(.removeDate))
                }

                
                navigationLinks()
            }
            .padding(.top, 8)
            .padding(.bottom, 0)
            .ignoresSafeArea(edges: .bottom)
            .navigationDestination(
                isPresented: viewStore.binding(
                    get: { $0.selectedPractitioner != nil },
                    send: .dismissPractitionerDetail
                )
            ) {
                if let selected = viewStore.selectedPractitioner {
                    PractitionerDetailView(practitioner: selected)
                }
            }
            
            .navigationDestination(
                isPresented: viewStore.binding(
                    get: { $0.selelctedApooitment != nil },
                    send: .closeApoitmentDetial
                )
            ) {
                if let selected = viewStore.selelctedApooitment {
                    AppoitmentDetailView(appoitment: selected)
                }
            }
            
            .navigationDestination(
                isPresented: viewStore.binding(
                    get: { $0.selectCondition != nil },
                    send: .closeConditionDetail
                )
            ) {
                if let selected = viewStore.selectCondition {
                    ConditionDetailView(condition: selected)
                }
            }
            
            
            .navigationDestination(
                isPresented: viewStore.binding(
                    get: { $0.selectVisit != nil },
                    send: .closeVisitDetail
                )
            ) {
                if let selected = viewStore.selectVisit {
                    VisitsDetailView(visit: selected)
                }
            }
            
            .navigationDestination(
                isPresented: viewStore.binding(
                    get: { $0.selctedProcedure != nil },
                    send: .closeProcedureDEtail
                )
            ) {
                if let selected = viewStore.selctedProcedure {
                    ProcedureDetailView(data: selected)
                }
            }
            
            .navigationDestination(
                isPresented: viewStore.binding(
                    get: { $0.selectImaging != nil },
                    send: .closeImagingDetail
                )
            ) {
                if let selected = viewStore.selectImaging {
                    ImagingDetailView(imaging: selected)
                }
            }
            
            .navigationDestination(
                isPresented: viewStore.binding(
                    get: { $0.selctedVital != nil },
                    send: .closeVitalDEtail
                )
            ) {
                if let selected = viewStore.selctedVital {
                    VitalDetailView(vital: selected)
                }
            }
            
            .navigationDestination(
                isPresented: viewStore.binding(
                    get: { $0.selectBilling != nil },
                    send: .closeBillingDetail
                )
            ) {
                if let selected = viewStore.selectBilling {
                    BillingDetailView(billing: selected)
                }
            }
            
            .navigationDestination(
                isPresented: viewStore.binding(
                    get: { $0.selectMed != nil },
                    send: .closeMedDetail
                )
            ) {
                if let selected = viewStore.selectMed {
                    MedicationDetailView(medication:selected)
                }
            }
            
            .navigationDestination(
                isPresented: viewStore.binding(
                    get: { $0.selectImune != nil },
                    send: .closeImmuneDetail
                )
            ) {
                if let selected = viewStore.selectImune {
                    ImmunizationDetailView(immune: selected)
                }
            }
            
            .navigationDestination(
                isPresented: viewStore.binding(
                    get: { $0.selelctedAllergy != nil },
                    send: .dismissAllergyDetail
                )
            ) {
                if let selected = viewStore.selelctedAllergy {
                    AllergyDetailView(allergy: selected)
                }
            }
            
            .navigationDestination(
                isPresented: viewStore.binding(
                    get: { $0.selectedLab != nil },
                    send: .closeLabDetail
                )
            ) {
                if let selected = viewStore.selectedLab {
                    LabDetailView(lab: selected)
                }
            }
            .onAppear {
                loadFiles()
            }
            .onChange(of: savedFile) { newFile in
                loadFiles()
            }
            .alert("Delete File?",
                   isPresented: $showDeleteConfirmation
            ) {
                Button("Delete", role: .destructive) {
                    deleteFile(fileName: fileToDeleteName)
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to delete \"\(fileToDeleteName)\"?")
            }

            .background(Color(UIColor.systemGray6))
            .navigationBarBackButtonHidden(true)
            .onChange(of: viewStore.header.isFilterPresented) { isPresented in
                if isPresented {
                    viewControllerHolder?.present(
                        style: .overCurrentContext,
                        transitionStyle: .crossDissolve
                    ) {
                        FilterPopupView(
                            store: store.scope(state: \.header, action: MyHealthFeature.Action.header)
                        )
                    }
                }
            }
        }
            .overlay(
                Group {
                    if showAppoitmentOverlay {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                showAppoitmentOverlay = false
                            }
                            .overlay(
                                ZStack {
                                    // Dimmed Background
                                    Color.black.opacity(0.4)
                                        .ignoresSafeArea()
                                        .transition(.opacity)

                                    // Centered Modal with padding
                                    VStack(spacing: 16) {
                                        Text("""
                                        Based on the data provided, here is some advice on savings ratio for your finance profile:

                                        1. Understand Your Financial Goals:
                                        Start by identifying your short-term and long-term financial goals. Whether it's saving for a vacation, emergency fund, retirement, or any other goal, having clarity on what you are saving for will help determine your savings ratio.

                                        2. *Assess Your Current Financial Situation:* Review your income, expenses, assets, liabilities, and spending habits. Understanding your cash flow will give you a clear...
                                        """)
                                        .font(.montserrat(14, weight: .semibold))
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                        .padding(.top, 24)

                                        Divider()

                                        Button(action: {
                                            withAnimation {
                                                showAppoitmentOverlay = false
                                            }
                                        }) {
                                            Text("OK")
                                                .font(.montserrat(20, weight: .bold))
                                                .foregroundColor(.blue)
                                                .frame(maxWidth: .infinity)
                                                .padding(.bottom, 12)
                                        }
                                    }
                                    .padding(.vertical, 16)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .shadow(radius: 10)
                                    .padding(.horizontal, 24)
                                    .transition(.scale)
                                }
                                .zIndex(10)
//                                    .frame(maxWidth: .infinity)
//                                    .padding()
                            )
                            .transition(.opacity)
                            .animation(.easeInOut(duration: 0.3), value: showAppoitmentOverlay)
                    }
                }
            )
        }
    }
    
    @ViewBuilder
    private func sectionView(for title: String, viewStore: ViewStoreOf<MyHealthFeature>) -> some View {
        
        switch title {
        case "Practitioners":
            PractitionerSectionView(
                practitioners: viewModel.practitioners,
                searchText: viewStore.header.searchText,
                startDate: viewStore.header.startDate,
                endDate: viewStore.header.endDate,
                onCardTap: { practitioner in
                    viewStore.send(.practitionerTapped(practitioner))
                }
            )
            
        case "Appointments":
            AppoitmentSectionView(
                appoitmentarray: appoitmentVM.appoitments,
                searchText: viewStore.header.searchText,
                startDate: viewStore.header.startDate,
                endDate: viewStore.header.endDate,
                selectedFilters: viewStore.header.selectedFilters,
                onCardTap:{ appoitmnet in
                    viewStore.send(.openApoitmentDetial(appoitmnet))
                },
                onReadMoreTap: { appoitmnet in
                    showAppoitmentOverlay = true
                }
            )
            
        case "Visits":
            
            VisitsSectionView(visit: visitsVM.visitData,
            searchText: viewStore.header.searchText,
                              startDate: viewStore.header.startDate,
                              endDate: viewStore.header.endDate,
                              selectedFilters: viewStore.header.selectedFilters,
                onCardTap: { visit in
                viewStore.send(.openVisitsDetail(visit))
                
            })

        case "Conditions":
           
            ConditionSectionView(conditions: conditionVM.conditionArray,
                                 searchText: viewStore.header.searchText,
                                 startDate: viewStore.header.startDate,
                                 endDate: viewStore.header.endDate,
                                 selectedFilters: viewStore.header.selectedFilters,
                                 onCardTap: { condition in
                viewStore.send(.openConditionDetail(condition))
            })

        case "Labs":
            LabSectionView(labs: labVM.labs,
                           searchText: viewStore.header.searchText,
                           startDate: viewStore.header.startDate,
                           endDate: viewStore.header.endDate,
                           selectedFilters: viewStore.header.selectedFilters,
                            onCardTap: { lab in
                viewStore.send(.openLabDetail(lab))
            })
            
        case "Vitals":
            VitalsSectionView(vitalsArray: vitalVM.vitalArray,
                              searchText: viewStore.header.searchText,
                              startDate: viewStore.header.startDate,
                              endDate: viewStore.header.endDate,
                              selectedFilters: viewStore.header.selectedFilters,
                              onCardTap:  { vital in
                viewStore.send(.openVitalDetail(vital))
            })
            
        case "Medications":
            MedicationSectionView(medications: medicationVM.medication,
                                  searchText: viewStore.header.searchText,
                                  startDate: viewStore.header.startDate,
                                  endDate: viewStore.header.endDate,
                                  selectedFilters: viewStore.header.selectedFilters,
                                  onCardTap: { medication in
                viewStore.send(.openMedDetail(medication))
            })
            
            
        case "Procedures":
            ProcedureSectionView(procedure: procedureVM.procedures,
                                 searchText: viewStore.header.searchText,
                                 startDate: viewStore.header.startDate,
                                 endDate: viewStore.header.endDate,
                                 selectedFilters: viewStore.header.selectedFilters,
                                 onCardTap: { data in
                viewStore.send(.openProcedureDetail(data))
            })
            
        case "Allergies":
            AllergySectionView(allergies: allergyVM.allergy,
                               searchText: viewStore.header.searchText,
                               startDate: viewStore.header.startDate,
                               endDate: viewStore.header.endDate,
                               selectedFilters: viewStore.header.selectedFilters,
                               onCardTap: { allergy in
                viewStore.send(.allergyTapped(allergy))
            })
            
        case "Immunizations":
            ImmuneSectionView(immune: immuneVM.immune,
                              searchText: viewStore.header.searchText,
                              startDate: viewStore.header.startDate,
                              endDate: viewStore.header.endDate,
                              selectedFilters: viewStore.header.selectedFilters,
                              onCardTap: { immune in
                viewStore.send(.openImmuneDetail(immune))
                
            })
            
            
        case "Billing":
            BillingSectionView(items: billingVM.claim,
                               searchText: viewStore.header.searchText,
                               startDate: viewStore.header.startDate,
                               endDate: viewStore.header.endDate,
                               selectedFilters: viewStore.header.selectedFilters,
                               onCardTap:{ billing in
                viewStore.send(.openBillingDetail(billing))
            })
            
        case "Records Vault":
            FilesSectionView(filesArray: savedFilesArray,
                             searchText: viewStore.header.searchText,
                             startDate: viewStore.header.startDate,
                             endDate: viewStore.header.endDate,
                             selectedFilters: viewStore.header.selectedFilters,
                             onCardTap:{ files in },
                             addedFile: savedFile,
                             onDelete: { file in
                                    showDeleteConfirmation = true
                                    fileToDeleteName = file.fileName
                                    
                                
                             })
            
        case "Imaging":
            ImagingSectionView(arrayImaging: imagingVM.imagingarray,
                               searchText: viewStore.header.searchText,
                               startDate: viewStore.header.startDate,
                               endDate: viewStore.header.endDate,
                               selectedFilters: viewStore.header.selectedFilters,
                               onCardTap: { data in
                viewStore.send(.openImagingDetail(data))
            })

        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    func navigationLinks() -> some View {
        
        NavigationLink(
            destination: ContactUsView(),
            isActive: $navigateToContact
        ) {
            EmptyView()
        }

              NavigationLink(
                  destination: SettingView(),
                  isActive: $navigateToSettings
              ) {
                  EmptyView()
              }
        
        NavigationLink(
            destination: DashboardView(
                store: Store(
                    initialState: DashboardFeature.State(),
                    reducer: { DashboardFeature() }
                )
            ),
            isActive: $navigateToDashboard
        ) {
            EmptyView()
        }

        NavigationLink(
            destination: PersonaView(
                store: Store(
                    initialState: PersonaFeature.State(),
                    reducer: { PersonaFeature() }
                )
            ),
            isActive: $navigateToPersona
        ){
            EmptyView()
        }
                
        NavigationLink(
            destination: ClinicListView(),
            isActive: $isClinicListActive
        ) {
            EmptyView()
        }
    }
    
    private var filterOverlay: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Group {
                if viewStore.header.isFilterPresented {
                    FilterPopupView(
                        store: store.scope(state: \.header, action: MyHealthFeature.Action.header)
                    )
                } else {
                    EmptyView()
                }
            }
        }
    }
    
    func getCount(for title: String) -> String {
        switch title {
        case "Practitioners":
            return "\(viewModel.practitioners.count)"
        case "Appointments":
            return "\(appoitmentVM.appoitments.count)"
        case "Visits":
            return "\(visitsVM.visitData.count)"
        case "Conditions":
            return "\(conditionVM.conditionArray.count)"
        case "Labs":
            return "\(labVM.labs.count)"
        case "Vitals":
            return "\(vitalVM.vitalArray.count)"
        case "Medications":
            return "\(medicationVM.medication.count)"
        case "Imaging":
            return "\(imagingVM.imagingarray.count)"
        case "Procedures":
            return "\(procedureVM.procedures.count)"
        case "Allergies":
            return "\(allergyVM.allergy.count)"
        case "Immunizations":
            return "\(immuneVM.immune.count)"
        case "Billing":
            return "\(billingVM.claim.count)"
        case "Records Vault":
            return "\(savedFilesArray.count)"
        default:
            return "-"
        }
    }

    private func loadFiles() {
        savedFilesArray = MediaStorageManager.shared.fetchSavedMedia()
    }
    
    func deleteFile(fileName : String) {
        MediaStorageManager.shared.deleteMedia(fileName)
        savedFilesArray.removeAll { $0.fileName == fileName }
    }



}




struct MyHealthTileView: View {
    let icon: String
    let title: String
    let countItem : String
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 12) {
            
            Text(title)
               .font(.montserrat(9, weight: .bold))
                .foregroundColor(.black)
            
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
                .foregroundColor(Color(hex: "FF6605"))

            Text(countItem)
               .font(.montserrat(9, weight: .bold))
                .foregroundColor(.black)
            

            // Selection Indicator Line
            if isSelected {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color(hex: "FF6605"))
                    .frame(width:58)
                    .frame(height: 6)
                    .padding(.horizontal, 8)
            }
            else {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color(hex: "6E6B78"))
                    .frame(width:58)
                    .frame(height: 6)
                    .padding(.horizontal, 8)
            }

            
            
        }
        .frame(width: 102, height: isSelected ? 168 : 133)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? Color(hex: "FF6605") : Color.clear, lineWidth: 2)
        )
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
        .animation(.easeInOut(duration: 0.3), value: isSelected)
    }
}


#Preview {
    MyHealthView(
        store: Store(
            initialState: MyHealthFeature.State(),
            reducer: {
                MyHealthFeature()
            }
        )
    )
}

struct SearchView: View { var body: some View { Text("Search View") } }
struct DatePickerView: View { var body: some View { Text("Date Picker View") } }
struct UploadView: View { var body: some View { Text("Upload View") } }
