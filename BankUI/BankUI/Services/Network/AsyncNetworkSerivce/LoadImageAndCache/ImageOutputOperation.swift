//
//  ImageOutputOperation.swift
//  BankUI
//
//  Created by KOLESNIKOV Lev on 16.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

class ImageOutputOperation: GetImageOperation {

    ///Блок кода который нужно выполнить извне, когда изображение получено
    private let completion: (UIImage?) -> Void

    public init(completion: @escaping (UIImage?) -> Void) {
        self.completion = completion
        super.init(image: nil, imageName: nil)
    }

    override public func main() {
        if isCancelled { completion(nil) }

        guard let inputImage = inputImage, let imageName = getImageName else { return }

        self.saveImageCacheDirectory(image: inputImage, imageName: "\(imageName)")

        completion(inputImage)
    }

    func saveImageCacheDirectory(image: UIImage, imageName: String) {
        let fileManager = FileManager.default
        let cachePath = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first

        guard let path = cachePath else { return }

        if !fileManager.fileExists(atPath: path.absoluteString) {
            do {
                try fileManager.createDirectory(atPath: path.absoluteString, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }

        do {
            let imagePath = path.appendingPathComponent(imageName)
            try image.jpegData(compressionQuality: 1.0)?.write(to: imagePath)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

}
