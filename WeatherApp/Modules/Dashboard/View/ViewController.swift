//
//  ViewController.swift
//  WeatherApp
//
//  Created by Victoria Belinschi on 06.06.2023.
//

import UIKit
import Lottie
import Combine

class ViewController: UIViewController {
    @IBOutlet weak var forecastBottomView: UIView!
    @IBOutlet weak var weatherAnimation: LottieAnimationView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var forecastStackView: UIStackView!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!

    private let viewModel = DashboardViewModel(networkService: NetworkServiceImp())
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupWeatherAnimation()
        viewModel.getWeatherData()
    }

    // MARK: - Private Methods

    private func setupWeatherAnimation() {
        weatherAnimation.contentMode = .scaleAspectFit
        weatherAnimation.loopMode = .loop
        weatherAnimation.animationSpeed = 0.5
        weatherAnimation.play()
        forecastBottomView.layer.cornerRadius = 20
    }

    private func setupBindings() {
        viewModel.$setupCurrent
            .sink { (date, condition, wind, temp, humidity, animation) in
            self.dateLabel.text = "Today, \(date)"
            self.conditionLabel.text = condition
            self.windLabel.text = wind
            self.currentTempLabel.text = temp
            self.humidityLabel.text = humidity
            if let weatherAnimation = LottieAnimation.named(animation) {
                self.weatherAnimation.animation = weatherAnimation
                self.weatherAnimation.play()
                self.weatherAnimation.loopMode = .loop
            }
        }.store(in: &cancellables)

        viewModel.$setupForecast.sink { forecast in
            self.createForeCastStackViews(forecastData: forecast)
        }.store(in: &cancellables)
    }

    private func createForeCastStackViews(forecastData: [(String, Double, String)]) {
        for forecastHour in forecastData {
            let stackView = CustomWeatherStackView()
            stackView.timeLabel.text = forecastHour.0
            stackView.degreeLabel.text = "\(String(describing: forecastHour.1)) C"
            if let weatherAnimation = LottieAnimation.named(forecastHour.2) {
                stackView.weatherAnimation.animation = weatherAnimation
                stackView.weatherAnimation.loopMode = .loop
                stackView.weatherAnimation.play()
            }
            self.forecastStackView.addArrangedSubview(stackView)
        }

    }

}

