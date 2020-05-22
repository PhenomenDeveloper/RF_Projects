//
//  UnsplashInteractor.swift
//  UnsplashApp
//
//  Created by OMELCHUK Daniil on 26/12/2019.
//  Copyright © 2019 OMELCHUK Daniil. All rights reserved.
//

import UIKit

protocol UnsplashInteractorProtocol: class {
    
    func getPhotosRequestData(with searchText: String, page: Int, completion: @escaping ([UnsplashPhoto]) -> ())
    func loadPhoto(with urlString: String, completion: @escaping (UIImage) -> ()) -> ImageLoadProvider
}

class UnsplashInteractor: UnsplashInteractorProtocol {
    
    // MARK: - Свойтсва
    
    weak var presenter: UnsplashPresenterProtocol!
    
    private var networkDataFetcher = NetworkDataFetcher()
    
    required init(presenter: UnsplashPresenterProtocol) {
        self.presenter = presenter
    }
    
    // MARK: - UnsplashInteractorProtocol
    
    ///Загружает фото в отдельном потоке
    ///
    /// - Parameters:
    ///     - urlString: Адрес по которому загружается изображение
    ///     - completion: Блок кода который выполнится вне данной функции
    /// - Returns:
    ///     Возвращает операцию которая загружает изображение
    func loadPhoto(with urlString: String, completion: @escaping (UIImage) -> ()) -> ImageLoadProvider {
        let imageProvider = ImageLoadProvider(imageURLString: urlString) {
            image in
            guard let image = image else {return}
            completion(image)
        }
        return imageProvider
    }
    
    ///Получает данные из сети в соответствии с запрашиваемым значениеем строки поиска
    ///
    /// - Parameters:
    ///     - searchText: Строка поиска
    ///     - completion: Блок кода который выполнится вне данной функции
    func getPhotosRequestData(with searchText: String, page: Int, completion: @escaping ([UnsplashPhoto]) -> ()){
        networkDataFetcher.fetchImages(serachTerm: searchText, page: page) { (searchResults) in
            guard let fetchedPhotos = searchResults else { return }
            completion(fetchedPhotos.results)
        }
    }
}

