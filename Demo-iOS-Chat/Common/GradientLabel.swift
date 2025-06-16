//
//  GradientLabel.swift
//  Demo-iOS-Chat
//
//  Created by Tien Nguyen on 17/6/25.
//

import UIKit

class GradientTextLabel: UILabel {
    private let gradientLayer = CAGradientLayer()

    /// Colors to use in the gradient
    var gradientColors: [UIColor] = [.red, .orange, .yellow] {
        didSet {
            updateGradient()
        }
    }

    /// Gradient direction
    var startPoint: CGPoint = CGPoint(x: 0, y: 0.5)
    var endPoint: CGPoint = CGPoint(x: 1, y: 0.5)

    override func layoutSubviews() {
        super.layoutSubviews()
        setupGradient()
    }

    private func setupGradient() {
        gradientLayer.removeFromSuperlayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = gradientColors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint

        // Create a mask using the label’s text
        let textMask = createTextMask()
        gradientLayer.mask = textMask

        layer.addSublayer(gradientLayer)
    }

    private func createTextMask() -> CALayer? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        guard let _ = UIGraphicsGetCurrentContext() else { return nil }

        // Draw the label text into the context
        super.drawText(in: bounds)

        let textImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        let maskLayer = CALayer()
        maskLayer.contents = textImage?.cgImage
        maskLayer.frame = bounds
        return maskLayer
    }

    private func updateGradient() {
        gradientLayer.colors = gradientColors.map { $0.cgColor }
    }

    // Prevent default text rendering
    override func drawText(in rect: CGRect) {}
}
