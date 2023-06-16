//
//  String+Extensions.swift
//  WeatherApp
//
//  Created by Victoria Belinschi on 08.06.2023.
//

import Foundation
extension String {
    func hourMinuteString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: date)
        }

        return ""
    }
}

extension Date {
    func hourMinuteString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
}
