//
//  HeaderView.swift
//  mE Health
//
//  Created by Rashida on 20/06/25.
//

import SwiftUI
import ComposableArchitecture

struct HeaderView: View {
    let store: StoreOf<HeaderFeature>

    @State private var isStartDatePickerPresented = false
    @State private var isEndDatePickerPresented = false
    @State private var selectedDate = Date()
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            
            let startDate = Binding<Date?>(
                get: { viewStore.startDate },
                set: { viewStore.send(.setStartDate($0)) }
            )
            let endDate = Binding<Date?>(
                get: { viewStore.endDate },
                set: { viewStore.send(.setEndDate($0)) }
            )

            VStack(spacing: 16) {
                HStack {
                    Text(viewStore.title)
                        .font(.montserrat(20, weight: .bold))
                        .foregroundColor(.black)

                    Spacer()

                    HStack(spacing: 16) {
                        ForEach(HeaderFeature.HeaderIcon.allCases) { icon in
                            if icon == .filter && !viewStore.filterIconVisible {
                                
                            }else {
                                Button {
                                    viewStore.send(.iconTapped(icon))
                                } label: {
                                    Image(icon.iconName)
                                        .foregroundColor(.black)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)

                if viewStore.isSearchVisible {
                    

                    HStack {
                        HStack(spacing: 8) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color(hex: Constants.API.PrimaryColorHex))

                            TextField("Search...", text: viewStore.binding(
                                get: \.searchText,
                                send: HeaderFeature.Action.searchTextChanged
                            ))
                             .font(.montserrat(14, weight: .regular))
                            .padding(.vertical, 10)
                            .doneToolbar()
                        }
                        .frame(height: 50)
                        .padding(.horizontal)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: Constants.API.PrimaryColorHex), lineWidth: 1.5)
                        )
                        .cornerRadius(10)

                        Button {
                            viewStore.send(.hideSearch)
                        } label: {
                            Image("close")
                        }
                        .padding(.leading, 4)
                    }
                    .padding(.horizontal)

                }
                
                if !viewStore.selectedFilters.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(viewStore.selectedFilters, id: \.self) { filter in
                                HStack(spacing: 6) {
                                    Text(filter.label)
                                        .font(.montserrat(13, weight: .bold))
                                        .foregroundColor(Color.white)
                                    
                                    // Close icon button
                                    Button(action: {
                                        // Call action to remove this filter
                                        viewStore.send(.removeFilter(filter))
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(Color.white)
                                            
                                    }
                                    .buttonStyle(.plain)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color(hex: Constants.API.PrimaryColorHex))
                                .cornerRadius(18)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                if viewStore.isDatePickerPresented {
                    if let start = viewStore.startDate, let end = viewStore.endDate {
                        HStack {
                            HStack(spacing: 8) {
                                Text("Date Range: ")
                                   .font(.montserrat(12, weight: .medium))
                                    .foregroundColor(.black)

                                Text("\(formattedRange(start: start, end: end))")
                                   .font(.montserrat(12, weight: .medium))
                                    .foregroundColor(.black)
                                
                                Spacer()

                                Button(action: {
                                    // Clear selected dates
                                    isStartDatePickerPresented = false
                                    isEndDatePickerPresented = false
                                    viewStore.send(.setStartDate(nil))
                                    viewStore.send(.setEndDate(nil))
                                    viewStore.send(.removeDate)
                                    
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                            .frame(height: 40)
                            .background(Color.clear)
                            .padding(.leading,4)
                        }
                        .padding(.horizontal)
                    } else {
                        // Show start and end date pickers
                        HStack(spacing: 12) {
                            Button(action: {
                                isStartDatePickerPresented = true
                            }) {
                                DateCardView(title: "Start Date", date: formattedDate(viewStore.startDate))
                            }
                            .sheet(isPresented: $isStartDatePickerPresented) {
                                DatePickerModalView(
                                    title: "Start Date",
                                    isPresented: $isStartDatePickerPresented,
                                    selectedDate: Binding(
                                        get: { viewStore.startDate ?? Date() },
                                        set: { viewStore.send(.setStartDate($0)) }
                                    ),
                                    minimumDate: nil
                                )
                            }

                            Button(action: {
                                if viewStore.startDate != nil {
                                    isEndDatePickerPresented = true
                                }
                            }) {
                                DateCardView(title: "End Date", date: formattedDate(viewStore.endDate))
                            }
                            .disabled(viewStore.startDate == nil)
                            .opacity(viewStore.startDate == nil ? 0.5 : 1.0)
                            .sheet(isPresented: $isEndDatePickerPresented) {
                                if let safeStartDate = viewStore.startDate {
                                    DatePickerModalView(
                                        title: "End Date",
                                        isPresented: $isEndDatePickerPresented,
                                        selectedDate: Binding(
                                            get: { viewStore.endDate ?? safeStartDate },
                                            set: {
                                                if $0 >= safeStartDate {
                                                    viewStore.send(.setEndDate($0))
                                                }
                                            }
                                        ),
                                        minimumDate: safeStartDate
                                    )
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }

    }
    
    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "dd-MM-yyyy" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func formattedRange(start: Date, end: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
    }

}



extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(
            RoundedCorner(radius: radius, corners: corners)
        )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
