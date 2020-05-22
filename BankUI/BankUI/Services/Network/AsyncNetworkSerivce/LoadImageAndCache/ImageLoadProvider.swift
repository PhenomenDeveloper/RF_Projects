//
//  ImageLoadProvider.swift
//  BankUI
//
//  Created by KOLESNIKOV Lev on 16.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit
class ImageLoadProvider {

    private var operationQueue = OperationQueue()

    init(imageURLString: String, completion: @escaping (UIImage?) -> Void) {
        operationQueue.maxConcurrentOperationCount = 6

        // Создаем операции
        let dataLoad = ImageLoadOperation(url: imageURLString)
        let output = ImageOutputOperation(completion: completion)

        let operations = [dataLoad, output]

        // Добавляем dependencies
        output.addDependency(dataLoad)

        operationQueue.addOperations(operations, waitUntilFinished: false)
    }

    func cancel() {
        operationQueue.cancelAllOperations()
    }
}
