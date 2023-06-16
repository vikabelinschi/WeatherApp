//
//  Observable.swift
//  WeatherApp
//
//  Created by Victoria Belinschi on 08.06.2023.
//

import Foundation

final class Observable <T> {

    private var notifyListenerTimer: Timer?

    var value: T {
        didSet {
            notifyListenerTimer?.invalidate()
            notifyListenerTimer = Timer.scheduledTimer(timeInterval: 0.01,
                                                       target: self,
                                                       selector: #selector(notifyListener),
                                                       userInfo: nil,
                                                       repeats: false)
        }
    }

    @objc func notifyListener() {
        listener?(value)
    }

    private var listener: ((T) -> Void)?

    init(_ value: T) {
        self.value = value
    }

    func bind(fire: Bool = true, _ closure: @escaping (T) -> Void) {
        if fire {
            closure(value)
        }
        listener = closure
    }
}
