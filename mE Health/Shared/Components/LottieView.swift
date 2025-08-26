//
//  LottieView.swift
//  mE Health
//
//  Created by Rashida on 29/07/25.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let name: String
    let loopMode: LottieLoopMode

    init(name: String, loopMode: LottieLoopMode = .loop) {
        self.name = name
        self.loopMode = loopMode
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView()

        let animationView = LottieAnimationView(name: name)
        animationView.loopMode = loopMode
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

