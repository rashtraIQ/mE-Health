import SwiftUI

struct NoDataView: View {
    var title: String = "No records found in this range."
    var message: String = "Maybe your body was just busy being awesome."
    
    var body: some View {
        VStack(spacing: 20) {
            // Placeholder illustration
            Image("noData")
                .resizable()
                .scaledToFit()
                .frame(width: 230, height: 230)
            
            Text(title)
               .font(.montserrat(12, weight: .bold))
                .multilineTextAlignment(.center)
            
            Text(message)
                .font(.montserrat(12, weight: .semibold))
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }


}

struct NoDataHealthView: View {
    var title: String = "Achieve more by setting your health goals."
    var message: String = "Set a goal to stay focused on your health journey. Track your progress and celebrate small wins."
    
    var body: some View {
        VStack(spacing: 20) {
            // Placeholder illustration
            Image("nodataHealth")
                .resizable()
                .scaledToFit()
                .frame(width: 230, height: 255)
            
            Text(title)
               .font(.montserrat(12, weight: .bold))
                .multilineTextAlignment(.center)
            
            Text(message)
                .font(.montserrat(12, weight: .semibold))
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }


}

struct NoDataAdviceView: View {
    var title: String = "Nothing here yet — and that’s okay."
    var message: String = "Just select a category in Assist to start receiving advice that truly understands you."
    var onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            // Placeholder illustration
            Image("noAdviceData")
                .resizable()
                .scaledToFit()
                .frame(width: 320, height: 280)
            
            Text(title)
               .font(.montserrat(12, weight: .bold))
                .multilineTextAlignment(.center)
            
            Text(message)
                .font(.montserrat(12, weight: .semibold))
                .multilineTextAlignment(.center)
            
            Button(action: {
                onTap()
            }) {
                Text("Go to Assist")
                     .font(.montserrat(16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(height:45)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color(hex: "FF6605"))
                    .cornerRadius(32)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal,12)

        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }


}
