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
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - 50))
        path.addQuadCurve(
            to: CGPoint(x: rect.minX, y: rect.maxY - 50),
            control: CGPoint(x: rect.midX, y: rect.maxY + 80)
        )
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        return path
    }
}
struct testFile: View {
    var body: some View {
        VStack(spacing: 10){
            VStack() {
                Image("Picture1")
                    .frame(width: UIScreen.main.bounds.width,
                           height: UIScreen.main.bounds.height * 0.6)
                    .clipShape(CurvedRectangle())
                    .edgesIgnoringSafeArea(.top)
                Spacer()
            }
            
            Text("Welcome to the Revoultion")
                .font(.system(size: 25, weight: .bold, design: .default))
            Text("Where Others Build Apps,\n We Build Movements")
                .multilineTextAlignment(.center)
                .bold()
                .opacity(0.8)
            
            Text("mEinstein isn't just another app. It's a revolution-\n where your data belongs to you, your AI learns from \n you, and your phone becomes your power. ")
                .font(.system(size: 17, weight: .light, design: .default))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.black.opacity(0.8))
                .padding(.bottom, 20)
            
            HStack(spacing:5){
                Circle()
                    .fill(Color.orange)
                    .frame(width: 10, height: 10)
                ForEach(0..<4, id: \.self) { _ in
                    Circle()
                        .fill(Color.gray.opacity(0.4))
                        .frame(width: 10, height: 10)
                }
            }
            Button {
                
            } label: {
                ZStack{
                    Circle()
                        .fill(Color.orange)
                        .frame(width:50,height: 50)
                    Image(systemName: "arrow.right")
                        .foregroundStyle(Color.white)
                }
            }
            
            Button {
                
            } label: {
                Text("Skip")
                    .bold(true)
                    .foregroundStyle(Color.black)
            }
        }
    }
}
#Preview {
    testFile()
}
