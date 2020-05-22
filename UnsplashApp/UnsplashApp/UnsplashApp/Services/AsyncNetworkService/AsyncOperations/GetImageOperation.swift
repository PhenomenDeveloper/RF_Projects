//
//  GetImageOperation.swift
//  UnsplashApp
//
//  Created by OMELCHUK Daniil on 26/12/2019.
//  Copyright © 2019 OMELCHUK Daniil. All rights reserved.
//

import UIKit

protocol LoadedImageProtocol {
    var image: UIImage? { get }
}

class GetImageOperation: Operation {
    ///Загруженное изображение
    var outputImage: UIImage?
    
    private let _inputImage: UIImage?
    
    public init(image: UIImage?) {
        _inputImage = image
        super.init()
    }
    
    //Получаем изображение из другой операции
    public var inputImage: UIImage? {
        var image: UIImage?
        if let inputImage = _inputImage {
            image = inputImage
        } else if let dataProvider = dependencies
            .filter({ $0 is LoadedImageProtocol })
            .first as? LoadedImageProtocol {
            image = dataProvider.image
        }
        return image
    }
}

extension GetImageOperation: LoadedImageProtocol {
    var image: UIImage? {
        return outputImage
    }
}
