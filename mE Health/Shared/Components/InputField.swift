import SwiftUI

struct InputField: View {
    var label: String
    var icon: String
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    @Binding var showPassword: Bool

    /// Called when the user taps the **text-field** area (for pickers)
    var onTap: (() -> Void)? = nil

    var showValidation: Bool = false
    var validation: ((String) -> String?)? = nil

    @Environment(\.colorScheme) var colorScheme
    @FocusState private var isFocused: Bool

    private var errorMessage: String? {
        showValidation ? validation?(text) : nil
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Label
            Text(label)
                .font(.caption).bold()
                .foregroundColor(.primary)
                .font(.system(size: 12))
                //.frame(width: .infinity, height: 14, alignment: .leading)

            // Icon + Input
            HStack(spacing: 5) {
                // Icon
                if UIImage(named: icon) != nil {
                    Image(icon)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 24, height: 24)
                        .foregroundColor(iconColor)
                } else {
                    Image(systemName: icon)
                        .foregroundColor(iconColor)
                        .frame(width: 24, height: 24)
                }

                // Text input or picker
                if isSecure {
                    Group {
                        if showPassword {
                            TextField(
                                "",
                                text: $text,
                                prompt: Text(placeholder)
                                    .foregroundColor(colorScheme == .dark ? Theme.gray : Color(.placeholderText))
                            )
                                .focused($isFocused)
                                .doneToolbar()
                        } else {
                            SecureField("", text: $text, prompt: Text(placeholder)
                                .foregroundColor(colorScheme == .dark ? Theme.gray : Color(.placeholderText))
                                        )
                                .focused($isFocused)
                        }
                    }
                    Button {
                        showPassword.toggle()
                    } label: {
                        if colorScheme == .dark{
                            Image( showPassword ? "eye" : "eyeclose")
                                .foregroundColor(Theme.gray)
                        }else{
                            Image( showPassword ? "eye" : "eyeclose")
                                .foregroundColor(.gray)
                        }
                    }
                } else if let onTap = onTap {
                    Text(text.isEmpty ? placeholder : text)
                        .foregroundColor(text.isEmpty ? Color(UIColor.placeholderText) : .primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                        .onTapGesture { onTap() }
                } else {
                    TextField(
                        "",
                        text: $text,
                        prompt: Text(placeholder)
                            .foregroundColor(colorScheme == .dark ? Theme.gray : Color(.placeholderText))
                    )
                        .focused($isFocused)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .doneToolbar()
                }
            }

            // Underline
            Rectangle()
                .frame(height: 1)
                .foregroundColor(lineColor)
                .padding(.leading, 29)
                .padding(.top,-2)

            // Error message
            if let error = errorMessage {
                Text(error)
                    .font(.caption2)
                    .foregroundColor(.red)
                    .padding(.top,-2)
            }
        }
        .padding(8)
        .padding(.horizontal, 4)
        .frame(maxWidth: .infinity)
        .frame(height: errorMessage == nil ? 77 : 91)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(colorScheme == .dark ? Color.black : Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(boxBorder, lineWidth: 1)
        )
    }

    private var iconColor: Color {
        if errorMessage != nil     { return .red }
        else if isFocused          { return Theme.primary }
        else                       { return .primary }
    }

    private var lineColor: Color {
        if errorMessage != nil     { return .red }
        else if isFocused          { return Theme.primary }
        else                       { return .primary }
    }


    private var boxBorder: Color {
        colorScheme == .dark
        ? Theme.gray
            : Theme.labelBorders
    }

}

