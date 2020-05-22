//
//  ImageLoadOperation.swift
//  UnsplashApp
//
//  Created by OMELCHUK Daniil on 26/12/2019.
//  Copyright © 2019 OMELCHUK Daniil. All rights reserved.
//

import UIKit

class ImageLoadOperation: AsyncOperation {
    ///url загружаемой картинки
    private var url: URL?
    ///Загруженное изображение
    fileprivate var outputImage: UIImage?
    
    private var networkTask: URLSessionDataTask?
    
    public init(url: URL?) {
        self.url = url
        super.init()
    }
    
    override public func main() {
        if self.isCancelled { return }
        guard let imageURL = url else {return}
        networkTask = URLSession.shared.dataTask(with: imageURL){(data, response, error) in
            if self.isCancelled { return }
            if let data = data,
                let imageData = UIImage(data: data) {
                if self.isCancelled { return }
                self.outputImage = imageData
            }
            self.state = .finished
        }
        networkTask?.resume()
    }
    
//    override func cancel() {
//        guard let networkTask = networkTask else {return}
//        networkTask.cancel()
//        super.cancel()
//    }
}


extension ImageLoadOperation: LoadedImageProtocol {
    var image: UIImage? {
        return outputImage
    }
}
