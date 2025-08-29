//
//  testFile.swift
//  mE Health
//
//  Created by Rashtra Humane on 26/08/25.
//
import SwiftUI

struct CurvedRectangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addQuadCurve(
            to: CGPoint(x: rect.minX, y: rect.maxY),
            control: CGPoint(x: rect.midX, y: rect.maxY + 150)
        )
        path.closeSubpath()
        return path
    }
}


struct testFile: View {
    var body: some View {
        NavigationStack{
            VStack(spacing: 10){
                VStack() {
                    Image("Picture1")
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity,
                               maxHeight: UIScreen.main.bounds.height * 0.45)
                        .clipShape(CurvedRectangle())
                        .ignoresSafeArea(edges: .top)
                    Spacer()
                }
                Text("Welcome to the Revoultion")
                    .foregroundStyle(Color(hex: "#232222"))
                    .font(.montserrat(18))
                    .bold()
                    .lineSpacing(10)
                
                
                Text("Where Others Build Apps,\n We Build Movements")
                    .foregroundStyle(Color(hex: "#333333"))
                    .font(.montserrat(14))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                
                
                Text("mEinstein isn't just another app. It's a revolution-\n where your data belongs to you, your AI learns from \n you, and your phone becomes your power. ")
                    .font(.montserrat(12))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color(hex: "#333333"))
                    .lineSpacing(10)
                    .padding(.bottom, 40)
                
                HStack(spacing:4){
                    Circle()
                        .fill(Color(hex: "#ff6606"))
                        .frame(width: 6, height: 6)
                    ForEach(0..<4, id: \.self) { _ in
                        Circle()
                            .fill(Color(hex: "DADADA"))
                            .frame(width: 6, height: 6)
                    }
                }
                NavigationLink(destination: testFile2()
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
    testFile()
}



