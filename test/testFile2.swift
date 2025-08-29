//
//  testFile2.swift
//  mE Health
//
//  Created by Rashtra Humane on 27/08/25.
//

import SwiftUI

let data : [Int] = [0,1,2,3,4]

//struct CurvedRectangle2: Shape {
//    func path(in rect: CGRect) -> Path {
//        var path = Path()
//        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
//        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
//        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - 50))
//        path.addQuadCurve(
//            to: CGPoint(x: rect.minX, y: rect.maxY - 50),
//            control: CGPoint(x: rect.midX, y: rect.maxY + 150)
//        )
//        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
//        return path
//    }
//}

struct testFile2: View {
    var body: some View {
        NavigationStack{
            VStack(spacing: 10){
                VStack() {
                    Image("Picture2")
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity,
                               maxHeight: UIScreen.main.bounds.height * 0.5)
                        .clipShape(CurvedRectangle())
                        .ignoresSafeArea(edges: .top)
                    Spacer()
                }
                
                Text("Your Data. Your Castle")
                    .foregroundStyle(Color(hex: "#232222"))
                    .font(.montserrat(18))
                    .bold()
                    .lineSpacing(10)
                
                Text("You Own It. You Rule It.")
                    .foregroundStyle(Color(hex: "#333333"))
                    .font(.montserrat(14))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                
                
                Text("Build your digital persona like a castle-\n copyrighted, protected, and powerful. mE stores,\n nothing in the cloud. Everything stays with you.")
                    .font(.montserrat(12))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color(hex: "#333333"))
                    .lineSpacing(10)
                    .padding(.bottom, 40)
                
                HStack(spacing:4){
                    ForEach(data.indices){ index in
                        if index == 1 {
                            Circle()
                                .fill(Color(hex: "#ff6606"))
                                .frame(width: 6, height: 6)
                        }
                        Circle()
                            .fill(Color(hex: "DADADA"))
                            .frame(width: 6, height: 6)
                    }
                }
                
                HStack(spacing:8) {
                    NavigationLink(destination: testFile()
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                    ) {
                        ZStack {
                            Circle()
                                .fill(Color(hex: "#ff6606"))
                                .frame(width: 50, height: 50)
                            Image(systemName: "arrow.left")
                                .foregroundStyle(Color.white)
                        }
                    }
                    NavigationLink(destination: testFile3()
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                    ) {
                        ZStack {
                            Circle()
                                .fill(Color(hex: "#ff6606"))
                                .frame(width: 50, height: 50)
                            Image(systemName: "arrow.right")
                                .foregroundStyle(Color.white)
                        }
                    }
                }
                
                NavigationLink(destination: WhenPressedSkip()) {
                    Text("Skip")
                        .font(.montserrat(14))
                        .bold(true)
                        .foregroundStyle(Color(hex: "#333333"))
                        .lineSpacing(10)
                }
            }
        }
        
    }
}

#Preview {
    testFile2()
}
