//
//  AppFont.swift
//  mE Health
//
//  Created by Ishant Tiwari on 30/07/25.
//

import SwiftUI
import UIKit

class FontManager {
    static func montserrat(_ size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        let fontName: String

        switch weight {
        case .bold:
            fontName = "Montserrat-Bold"
        case .semibold:
            fontName = "Montserrat-SemiBold"
        case .medium:
            fontName = "Montserrat-Medium"
        case .light:
            fontName = "Montserrat-Light"
        case .thin:
            fontName = "Montserrat-Thin"
        default:
            fontName = "Montserrat-Regular"
        }

        return UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size, weight: weight)
    }
}


extension Font {
    static func montserrat(_ size: CGFloat, weight: UIFont.Weight = .regular) -> Font {
        return Font(FontManager.montserrat(size, weight: weight))
    }
}
