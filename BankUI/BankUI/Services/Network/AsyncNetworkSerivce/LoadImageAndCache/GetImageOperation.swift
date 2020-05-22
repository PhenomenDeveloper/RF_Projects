//
//  GetImageOperation.swift
//  BankUI
//
//  Created by KOLESNIKOV Lev on 16.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

protocol LoadedImageProtocol {
    var image: UIImage? { get }
    var imageName: String? { get }
}

class GetImageOperation: Operation {
    ///Загруженное изображение
    var outputImage: UIImage?

    private let _inputImage: UIImage?
    private let _imageName: String?

    public init(image: UIImage?, imageName: String?) {
        _inputImage = image
        _imageName = imageName
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

    public var getImageName: String? {
        var name: String?
        if let imageName = _imageName {
            name = imageName
        } else if let dataProvider = dependencies
            .filter({ $0 is LoadedImageProtocol })
            .first as? LoadedImageProtocol {
            name = dataProvider.imageName
        }
        return name
    }
}
