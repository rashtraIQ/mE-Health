//
//  HealthGoalCardView.swift
//  mE Health
//
//  Created by Ishant Tiwari on 31/07/25.
//

import Foundation
import SwiftUI

var goalmorecontent = ""
var isExpanded: Bool = false

struct HealthCardData: Identifiable, Equatable {
    
    var id :String
    let goalDescrition: String
    let date: String
}


struct HealthGoalCardView: View {
    let health: HealthCardData
    let onTap: () -> Void
    let onDelete: () -> Void
    let onEdit: () -> Void

    @State private var isExpanded: Bool = false
    @State private var goalmorecontent: String = ""

    var body: some View {
        HStack(spacing: 4) {
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(health.goalDescrition)
                        .font(.custom("Montserrat-Regular", size: 12))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(4)
                        .lineLimit(isExpanded ? nil : 2)
                        .padding(.top, 20)

                    if needsReadMore(text: health.goalDescrition) {
                        Button(action: {
                            onTap()
                            goalmorecontent = health.goalDescrition
                            isExpanded.toggle()
                        }) {
                            Text(isExpanded ? "Read More" : "Read More")
                                .font(.custom("Montserrat-SemiBold", size: 12))
                                .foregroundColor(Color(hex: "FF6605"))
                        }
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(health.date)
                            .font(.custom("Montserrat-Regular", size: 10))
                            .foregroundColor(Color(hex: "333333"))
                    }
                }
            }
            .padding(.leading, 16)

            Spacer()

            HealthGoalActionColumn(
                goaldata: health,
                onDelete: onDelete,
                onEdit: onEdit
            )
            .frame(height: 150)
            .padding(.trailing, 0)
        }
        .padding(.leading, 12)
        .frame(height: 90)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
    }

    private func needsReadMore(text: String) -> Bool {
        return text.count > 40
    }
}
struct HealthGoalActionColumn: View {
    let icons = ["Edit", "delete"]
    let goaldata: HealthCardData
    let onDelete: () -> Void
    let onEdit: () -> Void

    var body: some View {
        VStack(spacing: 1) {
            ForEach(icons, id: \.self) { icon in
                Button(action: {
                    handleAction(icon: icon)
                }) {
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 18, height: 18)
                        .padding()
                        .frame(width: 45, height: 45)
                        .background(Color(hex: "FF6605"))
                }
            }
        }
        .padding(.trailing, 0)
        .frame(width: 45)
        .background(
            RoundedCorners(color: Color.white, tl: 0, tr: 12, bl: 12, br: 0)
        )
    }

    private func handleAction(icon: String) {
        switch icon {
        case "delete":
            onDelete()
        case "Edit":
            onEdit()
        default:
            break
        }
    }
}

