//
//  AdviceCardView.swift
//  mE Health
//
//  Created by Rashida on 23/06/25.
//


import Foundation
import SwiftUI
import CoreData


struct AdviceItemData: Codable, Identifiable {
    var id = UUID()
    var role: String
    var content: String
    var title: String
    var date: String
    var fav: String
    var ignore: String
    var review: String
    var read: String
    var unread: String
}


struct AdviceCardView: View {

    @Binding var advice: AdviceItemData
    let onTap: () -> Void
    let onUpdate: () -> Void
    let onRemoveIfIgnored: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            VStack(alignment: .leading, spacing: 12) {
                Text("\("Health:") \(advice.title)")
                    .font(.montserrat(18, weight: .bold))
                    .padding(.top,12)
                
                HStack(alignment: .top, spacing: 12) {
                    
                    Rectangle()
                        .fill(Color(hex: "FF6605"))
                        .frame(width: 5)
                        .padding(.bottom,2)
                    
                    VStack(alignment: .leading, spacing: 8) {
                       
                        Text(advice.content)
                            .font(.montserrat(10, weight: .regular))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading) // or .center, but not justified
                            .lineSpacing(4)

                        Spacer()

                        HStack(spacing: 8) {
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Read more")
                                    .font(.montserrat(12, weight: .semibold))
                                    .foregroundColor(Color(hex: "FF6605"))
                                
                                Text(advice.date)
                                    .font(.montserrat(15, weight: .bold))
                                    .foregroundColor(Color(hex: "FF6605"))

                            }
                            
                            Rectangle()
                                .fill((Color(hex: "BFC2D1")))
                                .frame(width: 1)
                                .padding([.top,.bottom],8)

                            
                            Button(action: {
                                toggleReadStatus()
                            }) {
                                Image(advice.read == "1" ? "eye" : "eyeclose")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                            }


                        }
                    }
                }


          
                
            }
            .padding(.leading,16)

            Spacer()
            
            AdviceActionColumn(advice: $advice, onUpdate: onUpdate, onRemoveIfIgnored: onRemoveIfIgnored)
                .frame(height:150)
                .padding(.trailing, 0)
        }
        .padding(.leading, 12)
        .frame(height:180)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
        .onTapGesture {
            print(advice.content)
            onTap()
            assitcontent = advice.content
        }
    }
    
    func toggleReadStatus() {
        if advice.read == "1" {
            advice.read = "0"
            advice.unread = "1"
            // Keep review as is (should remain 1 if already set)
        } else {
            advice.read = "1"
            advice.unread = "0"
            advice.review = "1"
        }
        updateAdviceInCoreData()
        onUpdate()
    }
    
    func updateAdviceInCoreData() {
        let context = PersistenceController.shared.adviceContext
        let request: NSFetchRequest<Advicedata> = Advicedata.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", advice.title)
        do {
            let results = try context.fetch(request)
            if let item = results.first {
                item.fav = advice.fav
                item.ignore = advice.ignore
                item.review = advice.review
                item.read = advice.read
                item.unread = advice.unread
                try context.save()
            }
        } catch {
            print("Error updating Core Data: \(error)")
        }
    }


}


struct AdviceActionColumn: View {
    @Binding var advice: AdviceItemData
    var onUpdate: (() -> Void)?
    var onRemoveIfIgnored: (() -> Void)?

    @State private var showShareSheet = false
    @State private var shareContent: [Any] = []

    var body: some View {
        VStack(spacing: 1) {
            
            ForEach(AdviceAction.allCases, id: \.self) { action in
                Button(action: {
                    handleTap(for: action)
                }) {
                    let isActive = isActive(for: action)
                    Image(action.icon(for: advice))
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .padding(isActive ? 12 : 0)
                        .frame(width: 45, height: 45)
                        .background(Color(hex: "FF6605"))
                }
            }
        }
        .padding(.trailing,0)
        .frame(width: 45) // Fixed width for the action column
        .background(
            RoundedCorners(color: Color.white, tl: 0, tr: 12, bl: 12, br: 0)
        )
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: [advice.content])
        }
    }
    
    
    func isActive(for action: AdviceAction) -> Bool {
        switch action {
        case .like:
            return advice.fav == "1"
        case .ignore:
            return advice.ignore == "1"
        default:
            return false
        }
    }




    func handleTap(for action: AdviceAction) {
        switch action {
        case .like:
            advice.fav = advice.fav == "1" ? "0" : "1"
            updateAdviceInCoreData()
            onUpdate?()
        case .ignore:
            advice.ignore = advice.ignore == "1" ? "0" : "1"
            updateAdviceInCoreData()
            if advice.ignore == "1" {
                onRemoveIfIgnored?() 
            } else {
                onUpdate?()
            }
        case .provider:
            print("Contacting provider")
        case .share:
            shareContent = ["Advice: \(advice.title)\n\(advice.content)"]
            showShareSheet = true
        }
    }


    func updateAdviceInCoreData() {
        let context = PersistenceController.shared.adviceContext
        let request: NSFetchRequest<Advicedata> = Advicedata.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", advice.title)

        do {
            let results = try context.fetch(request)
            if let item = results.first {
                item.fav = advice.fav
                item.ignore = advice.ignore
                item.review = advice.review
                item.read = advice.read
                item.unread = advice.unread
                
                try context.save()
            }
        } catch {
            print("Error updating Core Data: \(error)")
        }
    }

}

enum AdviceAction: String, CaseIterable {
    case like
    case ignore
    case provider
    case share
    
    func icon(for advice: AdviceItemData) -> String {
        switch self {
        case .like:
            return advice.fav == "1" ? "like_advice" : "unlike"
        case .ignore:
            return advice.ignore == "1" ? "Ignore_fill" : "IGNORE_advice"
        case .provider:
            return "PROVIDER"
        case .share:
            return "SHARE"
        }
    }
}
