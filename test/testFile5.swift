//
//  testFile5.swift
//  mE Health
//
//  Created by Rashtra Humane on 28/08/25.
//

import SwiftUI

struct testFile5: View {
    var body: some View {
        NavigationStack{
            VStack(spacing: 10){
                VStack() {
                    Image("Picture5")
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity,
                               maxHeight: UIScreen.main.bounds.height * 0.5)
                        .clipShape(CurvedRectangle())
                        .ignoresSafeArea(edges: .top)
                    Spacer()
                }
                
                Text("Welcome to mEinstein")
                    .foregroundStyle(Color(hex: "#232222"))
                    .font(.montserrat(18))
                    .bold()
                    .lineSpacing(10)
                Text("Your AI. Your Data. Your Edge.")
                    .foregroundStyle(Color(hex: "#333333"))
                    .font(.montserrat(14))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                
                
                Text("Join the movement rewriting the rules of the data \n economy. Your digital self isn't just protected- it's\n finally working for you.")
                    .font(.montserrat(12))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color(hex: "#333333"))
                    .lineSpacing(10)
                    .padding(.bottom, 40)
                
                HStack(spacing:4){
                    ForEach(data.indices){ index in
                        if index == 4 {
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
                    NavigationLink(destination: testFile4()
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
                    NavigationLink(destination: testFile6()
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
    testFile5()
}
