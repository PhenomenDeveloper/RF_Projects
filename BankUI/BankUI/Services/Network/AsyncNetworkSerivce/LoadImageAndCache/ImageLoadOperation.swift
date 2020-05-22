//
//  ImageLoadOperation.swift
//  BankUI
//
//  Created by KOLESNIKOV Lev on 16.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

class ImageLoadOperation: AsyncOperation {
    ///url загружаемой картинки
    private var url: String?
    ///Загруженное изображение
    fileprivate var outputImage: UIImage?

    fileprivate var outputImageName: String?

    ///Объект для загрузки фотографий
    private var networkDataFetcher: DataFetcherProtocol?

    public init(url: String?) {
        self.url = url
        self.networkDataFetcher = NetworkDataFetcher(networking: NetworkService())
        super.init()
    }

    override public func main() {
        if self.isCancelled { return }
        guard let imageURL = url else { return }

        networkDataFetcher?.getLogoImage(imagePath: imageURL, completion: { (image) in
            if let imageData = image {
                if self.isCancelled { return }
                self.outputImage = imageData
                self.outputImageName = imageURL.getImageName()
            }
            self.state = .finished
        })
    }
}

extension ImageLoadOperation: LoadedImageProtocol {
    var image: UIImage? {
        return outputImage
    }

    var imageName: String? {
        return outputImageName
    }

}
