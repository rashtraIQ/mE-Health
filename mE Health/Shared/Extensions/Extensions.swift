import SwiftUI
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")  // Skip `#` if present

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}

extension Color {
    static var backGroundColorN: Color { Color(UIColor(red: 0.96, green: 0.96, blue: 0.99, alpha: 1.00)) }
}



struct Validator {
    static func validateEmail(_ input: String) -> String? {
        if input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "Required"
        } else if !NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: input) {
            return "Please enter a valid email address"
        }
        return nil
    }

    static func validatePassword(_ input: String) -> String? {
        if input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "Required"
        } else if input.count < 8 {
            return "Password must be at least 8 characters"
        }
        return nil
    }
}

extension Date {
    func toString(format: String = "MM-dd-yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX") // Recommended for fixed format
        return formatter.string(from: self)
    }
}



extension String {
    /// Calculates age based on the string assuming it's a date in a specific format.
    /// - Parameter format: The date format string, e.g. `"yyyy-MM-dd"` or `"dd/MM/yyyy"`.
    /// - Returns: Age in years, or `nil` if parsing fails.
    func age(fromFormat format: String = "yyyy-MM-dd") -> Int? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")

        guard let birthDate = formatter.date(from: self) else {
            return nil
        }

        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: now)
        return ageComponents.year
    }
}


