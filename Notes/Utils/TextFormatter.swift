//
//  TextFormatterProtocol.swift
//  Notes
//
//  Created by Aleksandr Bolotov on 21.07.2022.
//

import Foundation

protocol TextFormatterProtocol {
    func format(text: String)
    var onFormatDate: (String?) -> Void { get set }
}

extension TextFormatterProtocol {
    func format(text: String) {
        onFormatDate(text)
    }
}

class RemoveSpacesTextFormatter: TextFormatterProtocol {
    var onFormatDate: (String?) -> Void
    func format(text: String) {
        onFormatDate(text.replacingOccurrences(of: " ", with: ""))
    }
    init(onFormatDate: @escaping (String?) -> Void) {
        self.onFormatDate = onFormatDate
    }
}

class RemoveDotsTextFormatter: TextFormatterProtocol {
    var onFormatDate: (String?) -> Void
    func format(text: String) {
        onFormatDate(text.replacingOccurrences(of: ".", with: ""))
    }
    init(onFormatDate: @escaping (String?) -> Void) {
        self.onFormatDate = onFormatDate
    }
}

class RemoveCommasTextFormatter: TextFormatterProtocol {
    var onFormatDate: (String?) -> Void
    func format(text: String) {
        onFormatDate(text.replacingOccurrences(of: ",", with: ""))
    }
    init(onFormatDate: @escaping (String?) -> Void) {
        self.onFormatDate = onFormatDate
    }
}

class BadTextFormatter: TextFormatterProtocol {
    var onFormatDate: (String?) -> Void
    func format(text: String) {
        onFormatDate(nil)
    }
    init(onFormatDate: @escaping (String?) -> Void) {
        self.onFormatDate = onFormatDate
    }
}


