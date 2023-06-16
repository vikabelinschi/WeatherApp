//
//  CustomWeatherStackView.swift
//  WeatherApp
//
//  Created by Victoria Belinschi on 07.06.2023.
//

import Foundation
import UIKit
import Lottie

class CustomWeatherStackView: UIStackView {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var degreeLabel:UILabel!
    @IBOutlet weak var weatherAnimation: LottieAnimationView!

    override init(frame: CGRect) {
           super.init(frame: frame)
       // self.layer.cornerRadius = 20
        let nib = UINib(nibName: "CustomWeatherStackView", bundle: nil)
        if let contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            contentView.layer.cornerRadius = 20
            addArrangedSubview(contentView)
        }
        self.weatherAnimation.play()
        self.weatherAnimation.loopMode = .loop
       }

    required init(coder: NSCoder) {
        super.init(coder: coder)
//        let nib = UINib(nibName: "CustomWeatherStackView", bundle: nil)
//        if let contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView {
//            addArrangedSubview(contentView)
//        }
       }
}
