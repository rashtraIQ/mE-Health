//
//  HeaderFeature.swift
//  mE Health
//
//  Created by Rashida on 20/06/25.
//

import ComposableArchitecture
import Foundation


enum HeaderActionIcon: CaseIterable, Identifiable {
    case search, date, filter

    var id: Self { self }

    var iconName: String {
        switch self {
        case .search: return "magnifyingglass"
        case .date: return "calendar"
        case .filter: return "line.3.horizontal.decrease.circle"
        }
    }
}//case .upload: return "square.and.arrow.up"

struct FilterType: Identifiable, Equatable, Hashable {
    let id = UUID()
    let label: String

    static func == (lhs: FilterType, rhs: FilterType) -> Bool {
        lhs.label == rhs.label
    }

    static let all = FilterType(label: "All")
}



struct HeaderFeature: Reducer {
    struct State: Equatable {
        var title: String = "List of Practitioners"
        var categoryName: String = "Practitioners"
        var isSearchVisible = false
        var searchText: String = ""
        var isDatePickerPresented = false
        var isFilterPresented = false
        var availableFilters: [FilterType] = [FilterType.all] // default
        var selectedFilters: [FilterType] = []
        var startDate: Date? = nil
        var endDate: Date? = nil
        
        var filterIconVisible: Bool {
            switch categoryName {
            case "Appointments","Visits","Conditions","Labs","Vitals","Medications","Imaging","Procedures","Allergies","Immunizations","Billing","Files":
                return true
            default:
                return false
            }
        }
    }
    

    enum Action: Equatable {
        case iconTapped(HeaderIcon)
        case dismissSheet
        case searchTextChanged(String)
        case hideSearch

        case toggleFilter(FilterType)
        case applyFilters
        case clearFilters
        case removeFilter(FilterType)
        
        case removeDate
        
        case setStartDate(Date?)
        case setEndDate(Date?)


    }

    enum HeaderIcon: CaseIterable, Identifiable, Equatable {
        case date,search, filter

        var id: Self { self }

        var iconName: String {
            switch self {
            case .date: return "datepicker"
            case .search: return "Search"
            case .filter: return "filter"
            }
        }
    }
    
    // case .upload: return "file_upload"

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .iconTapped(let icon):
                switch icon {
                case .search:
                    state.isSearchVisible.toggle()
                case .date: state.isDatePickerPresented.toggle()
                case .filter: state.isFilterPresented.toggle()
                }
                return .none

            case .dismissSheet:
                state.isFilterPresented = false
                return .none
                
            case .searchTextChanged(let text):
                state.searchText = text
                return .none

            case .hideSearch:
                state.isSearchVisible = false
                state.searchText = ""
                return .none
                
            case .removeDate:
                state.isDatePickerPresented = false
                state.startDate = nil
                state.endDate = nil
                return .none
                
                
            case .toggleFilter(let filter):
                if state.selectedFilters.contains(filter) {
                    state.selectedFilters.removeAll(where: { $0 == filter })
                } else {
                    state.selectedFilters.append(filter)
                }
                return .none

            case .applyFilters:
                state.isFilterPresented = false
                return .none

            case .clearFilters:
                state.selectedFilters.removeAll()
                return .none
                
            case .removeFilter(let filter):
                if state.selectedFilters.contains(filter) {
                    state.selectedFilters.removeAll(where: { $0 == filter })
                }
                return .none
                
                
            case .setStartDate(let date):
                state.startDate = date
                return .none

            case .setEndDate(let date):
                state.endDate = date
                return .none

            }
        }
    }
}

