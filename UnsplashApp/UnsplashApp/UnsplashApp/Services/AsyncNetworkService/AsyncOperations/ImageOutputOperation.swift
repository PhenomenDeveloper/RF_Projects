//
//  ImageOutputOperation.swift
//  UnsplashApp
//
//  Created by OMELCHUK Daniil on 26/12/2019.
//  Copyright © 2019 OMELCHUK Daniil. All rights reserved.
//

import UIKit

class ImageOutputOperation: GetImageOperation {
    
    ///Блок кода который нужно выполнить извне, когда изображение получено
    private let completion: (UIImage?) -> ()
    
    public init(completion: @escaping (UIImage?) -> ()) {
        self.completion = completion
        super.init(image: nil)
    }
    
    override public func main() {
        if isCancelled { completion(nil) }
        completion(inputImage)
    }
}
