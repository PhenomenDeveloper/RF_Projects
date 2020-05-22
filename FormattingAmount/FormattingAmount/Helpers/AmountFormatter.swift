//
//  AmountFormatter.swift
//  FormattingAmount
//
//  Created by KOLESNIKOV Lev on 22.01.2020.
//  Copyright © 2020 SwiftOverflow. All rights reserved.
//

import Foundation

protocol SumFormatterProtocol {
    func formatter(number: Decimal, currency: Currency) -> String?
}

enum Currency: String {
    case rub = "₽"
    case usd = "$"
    case eur = "€"
}

enum SpaceType: Int {
    case zeroMeanNumber = 0
    case oneMeanNumber = 1
    case twoMeanNumber = 2
}


class AmountFormatter {
    
    /// Функция форматирования значения суммы
    ///
    /// - Parameters:
    ///     - amount: значение суммы
    ///     - currency: валюта суммы
    /// - Returns:
    ///     Возвращает отформатированную строку суммы в зависимости от валюты
    func formatter(amount: Decimal?, currency: Currency) -> String? {
        guard let amount = amount else { return "0,00 \(currency.rawValue)" }

        let amountString = decimalToString(amount: amount, digit: 2)
        guard let str = amountString else { return nil }
        
        var resultString = str
        resultString = formatAmount(str: resultString) + " \(currency.rawValue)"
        
        return resultString.replacingOccurrences(of: ".", with: ",")
    }
    
    /// Функция для перевода суммы из Decimal в String
    ///
    /// - Parameters:
    ///     - amount: значение суммы
    ///     - digit: разрядность числа после запятой
    /// - Returns:
    ///     Возвращает сумму в виде строки
    private func decimalToString(amount: Decimal?, digit: Int) -> String? {
        // Переменная для хранения округленного значения типа Decimal
        var value: Decimal = 0
        var temp = amount
        NSDecimalRound(&value, &temp!, digit, .plain)
        
        let result = NSDecimalNumber(decimal: value)
        
        return NSDecimalNumber(decimal: result as Decimal).stringValue
    }
    
    /// Вспомогательная функция для форматирования суммы. Откидывает дробную часть и расставляет пробелы между цифрами.
    ///
    /// - Parameters:
    ///     - str: Строка с суммой
    /// - Returns:
    ///      Возвращает отформатированную строку суммы
    private func formatAmount(str: String) -> String {
        var onlyNumbersStr = ""
        let strIndex = str.firstIndex(of: ".")
        if let index = strIndex {
            onlyNumbersStr = String(str.prefix(upTo: index))
        } else {
            onlyNumbersStr = str
        }
        
        let resultStr = str
        
        if onlyNumbersStr.count % 3 == 0 {
            
            return spaceFormatter(onlyNumbersStr: onlyNumbersStr,
                                  resultStr: resultStr,
                                  meanNumber: .zeroMeanNumber,
                                  spaceIndex: 3)
            
        } else if onlyNumbersStr.count % 3 == 1 {
            
            return spaceFormatter(onlyNumbersStr: onlyNumbersStr,
                                  resultStr: resultStr,
                                  meanNumber: .oneMeanNumber,
                                  spaceIndex: 1)
        } else {
            return spaceFormatter(onlyNumbersStr: onlyNumbersStr,
                                  resultStr: resultStr,
                                  meanNumber: .twoMeanNumber,
                                  spaceIndex: 2)
        }
    }
    
    /// Вспомогательная функция для расстановки пробелов между цифрами в сумме
    ///
    /// - Parameters:
    ///     - onlyNumbersStr: строка, которая содержит только цифры без дробной части
    ///     - resultStr: строка, которая содержит результат форматирования
    ///     - meanNumber: количество значащих цифр, 1_000 или 20_000
    ///     - spaceIndex: индекс первого пробела
    /// - Returns:
    ///     Возвращает строку суммы с правильно расставленными пробелами между цифрами
    
    private func spaceFormatter(onlyNumbersStr: String, resultStr: String, meanNumber: SpaceType, spaceIndex: Int) -> String {
        let tripleNumberCount = (onlyNumbersStr.count - meanNumber.rawValue) / 3
        var result = resultStr
        var index = spaceIndex
        
        if meanNumber.rawValue == 0 {
            for _ in 0..<tripleNumberCount - 1 {
                result.insert(" ", at: result.index(resultStr.startIndex, offsetBy: index))
                index += 4
            }
        } else {
            for _ in 0..<tripleNumberCount {
                result.insert(" ", at: result.index(resultStr.startIndex, offsetBy: index))
                index += 4
            }
        }
        return result
    }
}
