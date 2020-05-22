//
//  Extension + String.swift
//  BankUI
//
//  Created by MANVELYAN Gevorg on 04/12/2019.
//  Copyright © 2019 SwiftOverflow. All rights reserved.
//
import UIKit

public extension String {

    // MARK: - Форматирование

    func getImageName() -> String? {
        guard self.count > 0 else { return nil }
        let index = self.index(self.startIndex, offsetBy: 17)
        if String(self.prefix(upTo: index)) == "/import/statement" {
            return String(self.suffix(from: index))
        } else {
            return "ErrorName.png"
        }
    }

    ///Форматирвоание номера телефона
    /// - Returns:
    ///     Возвращает форматированную строку номера телефона
    func toPhoneNumber() -> String {

        guard self.count != 0 else { return "Пустой номер" }

        var onlyNumberString: String = self
            .components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()

        if onlyNumberString.hasPrefix("8") {
            onlyNumberString.remove(at: onlyNumberString.startIndex)
            return onlyNumberString.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d{2})", with: "+7 ($1) $2-$3-$4", options: .regularExpression, range: nil)
        } else if onlyNumberString.hasPrefix("9") {
            return onlyNumberString.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d{2})", with: "+7 ($1) $2-$3-$4", options: .regularExpression, range: nil)
        } else if onlyNumberString.hasPrefix("7") {
            return onlyNumberString.replacingOccurrences(of: "(\\d{1})(\\d{3})(\\d{3})(\\d{2})", with: "+$1 ($2) $3-$4-$5", options: .regularExpression, range: nil)
        } else {
            return onlyNumberString.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d{2})", with: "+7 ($1) $2-$3-$4", options: .regularExpression, range: nil)
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         guard let text = textField.text else { return true }
         let newLength = text.count + string.count - range.length
         return newLength <= 18
    }

    var htmlAttributedString: NSAttributedString? {
        return try? NSAttributedString(data: Data(utf8), options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
    }
}
