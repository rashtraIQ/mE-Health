//
//  testFile6.swift
//  mE Health
//
//  Created by Rashtra Humane on 28/08/25.
//

import SwiftUI

struct testFile6: View {
    var body: some View {
        NavigationStack{
            VStack(spacing: 10){
                VStack() {
                    Image("Picture6")
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity,
                               maxHeight: UIScreen.main.bounds.height * 0.5)
                        .clipShape(CurvedRectangle())
                        .ignoresSafeArea(edges: .top)
                    Spacer()
                }
                
                Text("Meet Your Digital Brew")
                    .foregroundStyle(Color(hex: "#232222"))
                    .font(.montserrat(18))
                    .bold()
                    .lineSpacing(10)
                Text("Smarter. Sharper. Always on Tap.")
                    .foregroundStyle(Color(hex: "#333333"))
                    .font(.montserrat(14))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                
                
                Text("Whatever you need, mEinstein is brewed to be your \n AI- powered daily companion- crafted to think fast \n and act smarter.")
                    .font(.montserrat(12))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color(hex: "#333333"))
                    .lineSpacing(10)
                    .padding(.bottom, 40)
                
                HStack(spacing:4){
                    ForEach(data.indices){ index in
                        Circle()
                            .fill(Color(hex: "DADADA"))
                            .frame(width: 6, height: 6)
                    }
                    Circle()
                        .fill(Color(hex: "#ff6606"))
                        .frame(width: 6, height: 6)
                }
                HStack(spacing:8){
                    NavigationLink(destination: testFile5()
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
                    Button {
                        
                    } label: {
                        ZStack{
                            Circle()
                                .fill(Color(hex: "#ff6606"))
                                .frame(width:50,height: 50)
                            Image(systemName: "arrow.right")
                                .foregroundStyle(Color.white)
                        }
                    }
                }
                
                Button {
                    
                } label: {
                    Text("Continue")
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
    testFile6()
}
