

import SwiftUI

enum Theme {
    
    // MARK: - Colors
    static let primary = Color(hex: "#FF6605")
    static let labelBorders = Color(hex: "#BFC2D1")
    static let secondary = Color(hex: "#333333")
    static let gray = Color(hex: "#DADADA")
    static let iconColor = Color.red
    static let textColor = Color.black
    static let placeholderColor = Color.gray

    // MARK: - Fonts
    static let headingFont = Font.title.bold()
    static let subheadingFont = Font.body
    static let buttonFont = Font.headline

    // MARK: - Padding
    static let fieldPadding: CGFloat = 12
    static let horizontalPadding: CGFloat = 16

    // MARK: - Corner Radius
    static let cornerRadius: CGFloat = 8
}


struct RoundedCorners: View {
    var color: Color = .black
    var tl: CGFloat = 0.0
    var tr: CGFloat = 0.0
    var bl: CGFloat = 0.0
    var br: CGFloat = 0.0

    var body: some View {
        GeometryReader { geo in
            SwiftUI.Path { path in
                let w = geo.size.width
                let h = geo.size.height

                let tr = min(min(self.tr, h/2), w/2)
                let tl = min(min(self.tl, h/2), w/2)
                let bl = min(min(self.bl, h/2), w/2)
                let br = min(min(self.br, h/2), w/2)

                path.move(to: CGPoint(x: w / 2.0, y: 0))
                path.addLine(to: CGPoint(x: w - tr, y: 0))
                path.addArc(center: CGPoint(x: w - tr, y: tr),
                            radius: tr,
                            startAngle: Angle(degrees: -90),
                            endAngle: Angle(degrees: 0),
                            clockwise: false)

                path.addLine(to: CGPoint(x: w, y: h - br))
                path.addArc(center: CGPoint(x: w - br, y: h - br),
                            radius: br,
                            startAngle: Angle(degrees: 0),
                            endAngle: Angle(degrees: 90),
                            clockwise: false)

                path.addLine(to: CGPoint(x: bl, y: h))
                path.addArc(center: CGPoint(x: bl, y: h - bl),
                            radius: bl,
                            startAngle: Angle(degrees: 90),
                            endAngle: Angle(degrees: 180),
                            clockwise: false)

                path.addLine(to: CGPoint(x: 0, y: tl))
                path.addArc(center: CGPoint(x: tl, y: tl),
                            radius: tl,
                            startAngle: Angle(degrees: 180),
                            endAngle: Angle(degrees: 270),
                            clockwise: false)
            }
            .fill(self.color)
        }
    }
}
