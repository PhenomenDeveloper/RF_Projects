//
//  ImageLoadProvider.swift
//  UnsplashApp
//
//  Created by OMELCHUK Daniil on 26/12/2019.
//  Copyright © 2019 OMELCHUK Daniil. All rights reserved.
//

import UIKit
class ImageLoadProvider {
    
    private var operationQueue = OperationQueue ()
    let imageURLString: String
    
    init(imageURLString: String,completion: @escaping (UIImage?) -> ()) {
        self.imageURLString = imageURLString
        operationQueue.maxConcurrentOperationCount = 6
        
        guard let imageURL = URL(string: imageURLString) else {return}
        
        // Создаем операции
        let dataLoad = ImageLoadOperation(url: imageURL)
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

extension ImageLoadProvider: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(imageURLString.hashValue)
    }
    
    static func ==(lhs: ImageLoadProvider, rhs: ImageLoadProvider) -> Bool {
        return lhs.imageURLString == rhs.imageURLString
    }
}
