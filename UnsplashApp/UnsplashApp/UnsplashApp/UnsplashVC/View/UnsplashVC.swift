//
//  UnsplashVC.swift
//  UnsplashApp
//
//  Created by OMELCHUK Daniil on 26/12/2019.
//  Copyright © 2019 OMELCHUK Daniil. All rights reserved.
//

import UIKit

protocol UnsplashVCProtocol: class {
    func setCollectionView(with value: [UnsplashPhoto])
}

class UnsplashVC: UICollectionViewController {
    
    // MARK: - Свойства
    
    var configurator: UnsplashConfiguratorProtocol = UnsplashConfigurator()
    var presenter: UnsplashPresenterProtocol!
    
    var photos: [UnsplashPhoto] = []
    var pageCount: Int = 1
    
    private var searchTaskWorkItem: DispatchWorkItem?
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let itemsPerRow: CGFloat = Constants.searchItemsPerRow
    private let sectionInsets = Constants.searchSectionInsets

    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped))
    }()

    private lazy var actionBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionBarButtonTapped))
    }()

    private var numberOfSelectedPhotos: Int {
        return collectionView.indexPathsForSelectedItems?.count ?? 0
    }

    private let enterSearchTermLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите название для поиска фото..."

        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let enterSearchImage: UIImageView = {
        let image = #imageLiteral(resourceName: "search")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = .white
        configurator.configureView(with: self)
        
        updateNavButtonsState()
        setupCollectionView()
        setupNavigationBar()
        setupSearchBar()
        setupEnterView()
        setupSpinner()
    }
    
    // MARK: - Functions
    ///Обновление состояния кнопок Navigation Bar в зависимости от количества выбранных изображений
    private func updateNavButtonsState() {
        addBarButtonItem.isEnabled =  numberOfSelectedPhotos > 0
        actionBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
    }
    
    ///Сброс всех выбранных изображений
    func refresh() {
        self.collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
        enterSearchTermLabel.isHidden = photos.count != 0
        enterSearchImage.isHidden = photos.count != 0
        updateNavButtonsState()
    }

//    MARK: - NavigationItems Action

    @objc private func addBarButtonTapped() {

        
    }

    @objc private func actionBarButtonTapped(sender: UIBarButtonItem) {
        
    }

//    MARK: - Setup UI Elements
    /// Настройка CollectionView
    private func setupCollectionView() {
        collectionView.register(UnsplashCollectionCell.self, forCellWithReuseIdentifier: UnsplashCollectionCell.reuseId)

        collectionView.layoutMargins = Constants.searchSectionMargins
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.allowsMultipleSelection = true
        
    }
    
    /// Настройка view заглушки при отсутствии запроса
    private func setupEnterView() {
        collectionView.addSubview(enterSearchTermLabel)
        collectionView.addSubview(enterSearchImage)

        enterSearchTermLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        enterSearchTermLabel.topAnchor.constraint(equalTo: collectionView.topAnchor, constant: Constants.enterLabelConstraint).isActive = true

        enterSearchImage.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        enterSearchImage.topAnchor.constraint(equalTo: enterSearchTermLabel.bottomAnchor, constant: Constants.enterImageConstraint).isActive = true
    }
    
    /// Настройка индикатора состояния
    private func setupSpinner() {
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor).isActive = true
    }
    
    /// Настройка Navigation Bar
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "ФОТОГРАФИИ"
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        titleLabel.textColor = #colorLiteral(red: 0.5019607843, green: 0.4980392157, blue: 0.4980392157, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)

        navigationItem.rightBarButtonItems = [actionBarButtonItem, addBarButtonItem]
    }

     /// Настройка Search Bar
    private func setupSearchBar() {
        searchController.searchBar.placeholder = "Поиск"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }

//    MARK: - UICollectionViewDataSource, UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UnsplashCollectionCell.reuseId, for: indexPath) as! UnsplashCollectionCell

        cell.photoImageView.backgroundColor = UIColor(hexString: photos[indexPath.item].color)
        
        return cell
    }

//    Обработка нажатий на картинки

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }

    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }

}

//    MARK: - UISearchBarDelegate

extension UnsplashVC: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        collectionView.isHidden = true
        enterSearchImage.isHidden = true
        enterSearchTermLabel.isHidden = true
        self.spinner.startAnimating()

        if let _ = searchTaskWorkItem {
            searchTaskWorkItem?.cancel()
            searchTaskWorkItem = nil
        }
        
        searchTaskWorkItem = DispatchWorkItem(block: {
            self.pageCount = 1
            self.photos = []
            self.collectionView.reloadData()
            self.presenter.getPhotos(with: searchText, with: self.pageCount)
        })
        
        guard searchTaskWorkItem != nil else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: searchTaskWorkItem!)
    }

}

//    MARK: - UICollectionViewDelegateFlowLayout
extension UnsplashVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo = photos[indexPath.item]
        //        сколько у нас имеется отступов между объектами, в данном случае 3( от левого края до 1-ого фото, от края 1-ого фото до 2-ого фото и от 2-ого до края экрана
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        
        //        вычисление доступной ширины с учетом отступов
        let avaliableWidth = view.frame.width - paddingSpace
        
        //        вычисление ширины для одного объекта с учетом того, сколько мы хоим видеть объектов (столбцов)
        let widthPerItem = avaliableWidth / itemsPerRow
        
        //        получение итоговой высоты объекта с учетом его ширины
        let height = CGFloat(photo.height) * widthPerItem / CGFloat(photo.width)
        
        return CGSize(width: widthPerItem, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let cell = cell as? UnsplashCollectionCell else { return }
        
        if indexPath.item == photos.count - 1 {
            pageCount += 1
            presenter.getPhotos(with: "", with: pageCount)
        }
        
        guard let thumbUrl = photos[indexPath.item].urls[URLKind.thumb.rawValue],
        let regularUrl = photos[indexPath.item].urls[URLKind.regular.rawValue] else { return }
        
        presenter.getThumbPhotoImage(with: thumbUrl) { (image) in
            OperationQueue.main.addOperation {
                cell.blurEffect.isHidden = false
                cell.updateImageViewWithImage(image)
            }
            self.presenter.deleteThumbImageProvider(with: thumbUrl)
        }
        
        presenter.getRegularPhotoImage(with: regularUrl) { (image) in
            OperationQueue.main.addOperation {
                cell.blurEffect.isHidden = true
                cell.updateImageViewWithImage(image)
            }
            self.presenter.deleteRegularImageProvider(with: regularUrl)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard photos.count > 0 else { return }

        guard photos.count > 0, let thumbUrl = photos[indexPath.item].urls[URLKind.thumb.rawValue],
            let regularUrl = photos[indexPath.item].urls[URLKind.regular.rawValue] else { return }
        
        presenter.deleteThumbImageProvider(with: thumbUrl)
        presenter.deleteRegularImageProvider(with: regularUrl)
    }
}

extension UnsplashVC: UnsplashVCProtocol {
    
    func setCollectionView(with value: [UnsplashPhoto]) {
        spinner.stopAnimating()
        self.collectionView.isHidden = false
        photos.append(contentsOf: value)
        refresh()
        collectionView.reloadData()
    }
}
