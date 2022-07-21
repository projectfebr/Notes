//
//  TextFormatterProtocol.swift
//  Notes
//
//  Created by Aleksandr Bolotov on 21.07.2022.
//

import Foundation

protocol TextFormatterProtocol {
    func format(text: String) -> String
}

extension TextFormatterProtocol {
    func format(text: String) -> String { return text }
}

enum TextFormatter {
    case removeSpaces, removeCommas, removeDots
}

class RemoveSpacesTextFormatter: TextFormatterProtocol {
    func format(text: String) -> String {
        return text.replacingOccurrences(of: " ", with: "")
    }
}

class RemoveDotsTextFormatter: TextFormatterProtocol {
    func format(text: String) -> String {
        return text.replacingOccurrences(of: ".", with: "")
    }
}

class RemoveCommasTextFormatter: TextFormatterProtocol {
    func format(text: String) -> String {
        return text.replacingOccurrences(of: ",", with: "")
    }
}
