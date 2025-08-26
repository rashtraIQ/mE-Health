//
//  TreatmentDetailView.swift
//  mE Health
//
//  Created by Rashida on 9/07/25.
//
import SwiftUI

struct TreatmentDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var appoitmentVM = ReadDataappointment()
    
    let condition: ConditionDummyData
    
    @State private var org: [Organization] = []
    
    @State private var showShare = false
    
    var body: some View {
        
        ZStack {
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Treatment")
                       .font(.montserrat(32, weight: .bold))
                        .padding(.horizontal)
                    
                    Divider()
                    
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
                            }                        }
                        
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
                                Text("Category")
                                     .font(.montserrat(12, weight: .regular))
                                
                                Text("Problem List Item")
                                     .font(.montserrat(14, weight: .regular))
                                
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Condition ID")
                                     .font(.montserrat(12, weight: .regular))
                                
                                Text("#\(condition.id)")
                                     .font(.montserrat(14, weight: .regular))
                                
                            }
                        }
                        
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)
                    .padding(.horizontal)
                    
                    if let firstAppointment = appoitmentVM.appoitments.first {
                        AppoitmentMainView(appoinmnt: firstAppointment,
                                           onTap: {},
                                           onReadMoreTap: {})
                            .padding(.horizontal)
                    }
                    
                    
                    
                    VStack(spacing: 12) {
                        HStack {
                            Text("Practitioners")
                                .font(.montserrat(22, weight: .bold))
                            
                            Spacer()
                            
                            Text("View All")
                                .font(.montserrat(12, weight: .semibold))
                                .foregroundColor(Color(hex: "06C270"))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color(hex: "DBFCE6"))
                                .cornerRadius(16)
                        }
                        
                        HStack {
                            Image("profile_placeholder") // Replace with actual image
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Dr. John Doe")
                                    .font(.montserrat(18, weight: .medium))
                                    .foregroundColor(Color(hex: "FF6605"))
                                Text("Apollo Hospital")
                                     .font(.montserrat(14, weight: .regular))
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                        }
                        .background(.clear)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    
                    VStack(spacing: 12) {
                        HStack {
                            Text("Visits")
                                .font(.montserrat(22, weight: .bold))
                            
                            Spacer()
                            
                            Text("View All")
                                .font(.montserrat(12, weight: .semibold))
                                .foregroundColor(Color(hex: "06C270"))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color(hex: "DBFCE6"))
                                .cornerRadius(16)
                        }
                        .padding(.horizontal)
                        
                        HStack(spacing: 12) {
                            Image("date_placeholder")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .foregroundColor(Color(hex: "FF6605"))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                
                                Text("Jan 1, 2023") // You can pull from organization.type if dynamic
                                    .font(.montserrat(16, weight: .medium))
                                    .foregroundColor(.black)
                                
                                Text("ABC Hospital")
                                     .font(.montserrat(12, weight: .regular))
                                    .foregroundColor(Color(hex: "FF6605"))
                            }
                        }
                        .frame(height: 70)
                        .background(Color.clear)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(spacing: 12) {
                        
                        HStack(alignment: .top, spacing: 12) {
                            
                            Rectangle()
                                .fill(Color(hex: "FF6605"))
                                .frame(width: 5)
                                .padding(.bottom,2)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                
                                Text("Lab Result")
                                    .font(.montserrat(17, weight: .bold))
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.leading) // or .center, but not justified
                                    .lineSpacing(4)
                                
                                HStack(spacing: 8) {
                                    Text("Hemoglobin")
                                         .font(.montserrat(13, weight: .regular))
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    Text("13.5")
                                         .font(.montserrat(14, weight: .regular))
                                        .foregroundColor(Color.black)
                                    
                                }
                                
                                HStack(spacing: 8) {
                                    Text("Wbc")
                                         .font(.montserrat(13, weight: .regular))
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    Text("5.6")
                                         .font(.montserrat(14, weight: .regular))
                                        .foregroundColor(Color.black)
                                    
                                }
                                
                                
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)
                    .padding(.horizontal)
                    
                    
                    VStack(spacing: 12) {
                        
                        HStack(alignment: .top, spacing: 12) {
                            
                            Rectangle()
                                .fill(Color(hex: "FF6605"))
                                .frame(width: 5)
                                .padding(.bottom,2)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                
                                HStack(spacing: 8) {
                                    
                                    Text("Procedure")
                                        .font(.montserrat(17, weight: .bold))
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.leading) // or .center, but not justified
                                        .lineSpacing(4)
                                    
                                    
                                    Spacer()
                                    
                                    Text("Active")
                                        .font(.montserrat(12, weight: .semibold))
                                        .foregroundColor(Color(hex: "06C270"))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color(hex: "DBFCE6"))
                                        .cornerRadius(16)
                                    
                                    
                                }
                                
                                
                                Text("Appendectomy")
                                     .font(.montserrat(13, weight: .regular))
                                    .foregroundColor(.black)
                                
                                Text("03/15/2024")
                                     .font(.montserrat(13, weight: .regular))
                                    .foregroundColor(.black)
                                
                                
                                
                                
                                
                                
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)
                    .padding(.horizontal)
                    
                    
                    VStack(spacing: 12) {
                        
                        HStack(alignment: .top, spacing: 12) {
                            
                            Rectangle()
                                .fill(Color(hex: "FF6605"))
                                .frame(width: 5)
                                .padding(.bottom,2)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                
                                HStack(spacing: 8) {
                                    
                                    Text("Current Medication")
                                        .font(.montserrat(17, weight: .bold))
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.leading) // or .center, but not justified
                                        .lineSpacing(4)
                                    
                                    
                                    Spacer()
                                    
                                    Text("Active")
                                        .font(.montserrat(12, weight: .semibold))
                                        .foregroundColor(Color(hex: "06C270"))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color(hex: "DBFCE6"))
                                        .cornerRadius(16)
                                    
                                    
                                }
                                
                                Text("Amoxicillin")
                                     .font(.montserrat(13, weight: .regular))
                                    .foregroundColor(.black)
                                
                                Text("500 mg. Twice Daily")
                                     .font(.montserrat(13, weight: .regular))
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Text("Amoxicillin")
                                     .font(.montserrat(13, weight: .regular))
                                    .foregroundColor(.black)
                                
                                Text("500 mg. Twice Daily")
                                     .font(.montserrat(13, weight: .regular))
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)
                    .padding(.horizontal)
                    
                    
                    VStack(spacing: 12) {
                        
                        Text("Medical Documents")
                            .font(.montserrat(22, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                        VStack(alignment: .leading, spacing: 12) {
                            
                            Text("Diagnostic Report")
                                .font(.montserrat(17, weight: .bold))
                            
                            Text("PDF • 2.4 MB")
                                .font(.montserrat(13, weight: .semibold))

                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 4)

                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)

                
                    ActionButtonsView(
                        title: "Sync Data",
                        onRefresh: {
                            print("Refresh tapped")
                        },
                        onShare: {
                            showShare = true
                        }
                    )
                    .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 2)
                    .padding(.horizontal)


                    
                    Spacer()
                }
                

                
            }
            .sheet(isPresented: $showShare) {
                ShareSheet(activityItems: ["Sharing from DetailView!"])
            }
            .background(Color(UIColor.systemGray6).ignoresSafeArea())
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    CustomBackButton {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
