//
//  DemoHistory.swift
//  InboxScreenUI
//
//  Created by KOLESNIKOV Lev on 04/12/2019.
//  Copyright © 2019 SwiftOverflow. All rights reserved.
//

import Foundation

struct DemoHistory {
    
    var day: String?
    var date: String?
    var name: String?
    var operation: String?
    
    
    init(day: String, date: String, name: String, operation: String) {
        self.day = day
        self.date = date
        self.name = name
        self.operation = operation
    }
    
    init() {}
    
    func generateFirstSection() -> [DemoHistory] {
        return [DemoHistory(day: "Сегодня",
                            date: "21:30",
                            name: "CAFECO\nСумма: 198 RUR\nБаланс: 3 212.05 RUR",
                            operation: "Операция по карте *3631"),
        DemoHistory(day: "Сегодня",
        date: "21:30",
        name: "CAFECO\nСумма: 199 RUR\nБаланс: 3 212.05 RUR",
        operation: "Операция по карте *3631")]
    }
    
    func generateSecondSection() -> [DemoHistory] {
        return [DemoHistory(day: "21 декабря",
                            date: "21:30",
                            name: "C2C R-ONLINE\nСписано: 150 RUB\nБаланс: 3 212.05 RUB",
                            operation: "Операция по карте *3631"),
                DemoHistory(day: "21 декабря",
                            date: "20:43",
                            name: "Списано: 150 RUB\nБаланс: 3 212.05 RUB\nATM 440948 50 ELEVATOR KUPINO",
                            operation: "Снятие наличных длинный текст *3631"),
                DemoHistory(day: "21 декабря",
                            date: "19:15",
                            name: "Зачислено: 150 RUB\nБаланс: 3 212.05 RUB",
                            operation: "Пополнение счета *0012")]
    }
    
    func generateThirdSection() -> [DemoHistory] {
        return [DemoHistory(day: "21 декабря",
                            date: "09:14",
                            name: "C2C R-ONLINE\nСписано: 150 RUB\nБаланс: 3 212.05 RUB",
                            operation: "Зачисление зарплаты *0012"),
                DemoHistory(day: "21 декабря",
                            date: "09:02",
                            name: "Вам отправлен перевод\nСписано: 150 RUB\nОтправитель: Иван Иванович И.\nСообщение: Привет!",
                            operation: "Рублевый перевод")]
    }
    
    
    
}
