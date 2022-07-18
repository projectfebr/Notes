//
//  File.swift
//  Notes
//
//  Created by Aleksandr Bolotov on 15.07.2022.
//

import Foundation

extension Date {
    func formatted(timeStyle: DateFormatter.Style, dateStyle: DateFormatter.Style) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter.string(from: self)
    }
}
