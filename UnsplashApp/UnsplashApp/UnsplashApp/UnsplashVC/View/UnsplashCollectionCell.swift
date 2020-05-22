//
//  UnsplashCollectionCell.swift
//  UnsplashApp
//
//  Created by OMELCHUK Daniil on 26/12/2019.
//  Copyright © 2019 OMELCHUK Daniil. All rights reserved.
//

import UIKit

protocol UnsplashCollectionCellProtocol {
    
    
}

class UnsplashCollectionCell: UICollectionViewCell {
    
    static let reuseId = "PhotoCell"
    //MARK: - Добавляем "чек" изображение
    private let checkMark: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "bird1"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
        return imageView
    }()
    //MARK: - Добавляем изображение
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = #colorLiteral(red: 0.5768421292, green: 0.6187390685, blue: 0.664434731, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    //MARK: - Добавляем блюрэффект
    var blurEffect: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blur)
        blurredEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurredEffectView.isHidden = true
        return blurredEffectView
    }()
    
    override var isSelected: Bool {
        didSet {
            updateSelectedState()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    //MARK: - Функция обновления состояния изображения
    private func updateSelectedState() {
        photoImageView.alpha = isSelected ? 0.7 : 1
        checkMark.alpha = isSelected ? 1 : 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        updateSelectedState()
        setupPhotoImageView()
        setupCheckmarkView()
    }
    //MARK: - Функция обновление изображения новым
    func updateImageViewWithImage(_ image: UIImage?) {
        if let image = image {
            photoImageView.image = image
            photoImageView.alpha = 0
            UIView.animate(withDuration: 0.2, animations: {
                self.photoImageView.alpha = 1.0
            })
            
        } else {
            photoImageView.image = nil
            photoImageView.alpha = 0
        }
    }
    //MARK: -  Устанавливаем constraints для изображения и блюрэффекта
    private func setupPhotoImageView() {
        addSubview(photoImageView)
        
        photoImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        
        addSubview(blurEffect)
        
        blurEffect.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        blurEffect.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        blurEffect.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        blurEffect.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    }
    //MARK: - Устанавливаем constraints для "Чек" изображения
    private func setupCheckmarkView() {
        addSubview(checkMark)
        
        checkMark.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: -8).isActive = true
        checkMark.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: -8).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
