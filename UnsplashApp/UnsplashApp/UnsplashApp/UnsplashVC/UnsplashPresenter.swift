//
//  UnsplashPresenter.swift
//  UnsplashApp
//
//  Created by OMELCHUK Daniil on 26/12/2019.
//  Copyright © 2019 OMELCHUK Daniil. All rights reserved.
//

import UIKit

protocol UnsplashPresenterProtocol: class {
    
    func getPhotos(with searchRequest: String, with page: Int)
    
    func getRegularPhotoImage(with urlString: String, completion: @escaping (UIImage) -> ())
    
    func getThumbPhotoImage(with urlString: String, completion: @escaping (UIImage) -> ())
    
    func deleteRegularImageProvider(with urlString: String)
    
    func deleteThumbImageProvider(with urlString: String)
}

class UnsplashPresenter: UnsplashPresenterProtocol {
    
    // MARK: - Свойства
    
    weak var view: UnsplashVCProtocol!
    var interactor: UnsplashInteractorProtocol!
    var router: UnsplashRouterProtocol!
    
    private var searchText: String = ""
    
    ///Операции загружающие маленькие изображения для блюр эффекта
    private var imageThumbProviders = Set<ImageLoadProvider>()
    ///Операции загружающие картинки в хорошем качестве
    private var imageRegularProviders = Set<ImageLoadProvider>()
    ///Коллекция закэшированных изображение [Ссылка на изображение : Изображение]
    private var imageCashe = [String : UIImage]()
    
    required init(view: UnsplashVCProtocol) {
        self.view = view
    }
    
    ///Получение изображений по запросу пользователя
    ///
    /// - Parameters:
    ///     - searchRequest: пользовательский запрос
    func getPhotos(with searchRequest: String, with page: Int) {
        if page == 1 {
            self.searchText = searchRequest
        }
        interactor.getPhotosRequestData(with: searchText, page: page) {[weak self] (images) in
            self?.view.setCollectionView(with: images)
        }
    }
    
    ///Получение качественного изображения по ссылке
    ///
    /// - Parameters:
    ///     - urlString: ссылка на изображение
    ///     - completion: экземпляр изображения
    func getRegularPhotoImage(with urlString: String, completion: @escaping (UIImage) -> ()) {
        if let image = imageCashe[urlString] {
            completion(image)
        }
        else {
            imageRegularProviders.insert(interactor.loadPhoto(with: urlString, completion: { (image) in
                self.imageCashe[urlString] = image
                
                completion(image)
            }))
        }
    }
    
    ///Получение изображения низкого разрешения по ссылке
    ///
    /// - Parameters:
    ///     - urlString: ссылка на изображение
    ///     - completion: экземпляр изображения
    func getThumbPhotoImage(with urlString: String, completion: @escaping (UIImage) -> ()) {
        if let image = imageCashe[urlString] {
            completion(image)
        }
        else {
            imageThumbProviders.insert(interactor.loadPhoto(with: urlString, completion: { (image) in
                self.imageCashe[urlString] = image
                completion(image)
            }))
        }
    }
    
    ///Удаление определенного качественного изображения из ImageProvider
    ///
    /// - Parameters:
    ///     - urlString: ссылка на изображение
    func deleteRegularImageProvider(with urlString: String) {
        for provider in
            imageRegularProviders.filter({ $0.imageURLString == urlString}){

            provider.cancel()
            imageRegularProviders.remove(provider)
        }
    }
    
    ///Удаление определенного изображения низкого качества из ImageProvider
    ///
    /// - Parameters:
    ///     - urlString: ссылка на изображение
    func deleteThumbImageProvider(with urlString: String) {
        for provider in
            imageThumbProviders.filter({ $0.imageURLString == urlString}){

            provider.cancel()
            imageThumbProviders.remove(provider)
        }
    }
}
