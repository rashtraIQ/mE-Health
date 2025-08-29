//
//  testFile3.swift
//  mE Health
//
//  Created by Rashtra Humane on 27/08/25.
//

import SwiftUI

struct testFile3: View {
    var body: some View {
        NavigationStack{
            VStack(spacing: 10){
                VStack() {
                    Image("Picture3")
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity,
                               maxHeight: UIScreen.main.bounds.height * 0.5)
                        .clipShape(CurvedRectangle())
                        .ignoresSafeArea(edges: .top)
                    Spacer()
                }
                
                Text("AI That Learns You, Not \n the World")
                    .foregroundStyle(Color(hex: "#232222"))
                    .font(.montserrat(18))
                    .bold()
                    .lineSpacing(10)
                    .multilineTextAlignment(.center)
                
                Text("Personalized AI, Edge-Powered")
                    .foregroundStyle(Color(hex: "#333333"))
                    .font(.montserrat(14))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                
                Text("No more generic bots. mE is your personal AI\n advisor- trained on-device, evolving with you,\n guiding our life with radical precision")
                    .font(.montserrat(12))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color(hex: "#333333"))
                    .lineSpacing(10)
                    .padding(.bottom, 40)
                
                HStack(spacing:4){
                    ForEach(data.indices){ index in
                        if index == 2 {
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
                    NavigationLink(destination: testFile2()
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
                    NavigationLink(destination: testFile4()
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
    testFile3()
}
