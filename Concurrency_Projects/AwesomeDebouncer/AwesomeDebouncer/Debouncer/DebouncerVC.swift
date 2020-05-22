//
//  DebouncerVC.swift
//  AwesomeDebouncer
//
//  Created by Lev Kolesnikov on 28.12.2019.
//  Copyright © 2019 SwiftOverflow. All rights reserved.
//

import UIKit

class DebouncerVC: UIViewController {
    
    private let networkDataFetcher = NetworkDataFetcher()
    
    private var searchTaskWorkItem: DispatchWorkItem?
    
    // MARK: - Создание UI элементов
    
    lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl: UISegmentedControl = UISegmentedControl(items: ["Адреса", "Страны", "Банки"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectedSegmentTintColor = #colorLiteral(red: 0.9411764706, green: 0.7843137255, blue: 0, alpha: 1)
        segmentedControl.backgroundColor = .white
        return segmentedControl
    }()
    
    lazy var searchTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.tintColor = #colorLiteral(red: 0.9411764706, green: 0.7843137255, blue: 0, alpha: 1)
        textField.placeholder = "Введите ваш запрос"
        
        return textField
    }()
    
    lazy var resultLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Данных по вашему запросу нет. Попробуйте еще раз!"
        
        return label
    }()
    
    lazy var searchActivityIndicator: UIActivityIndicatorView = {
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.style = .medium
        activityIndicator.color = #colorLiteral(red: 0.9411764706, green: 0.7843137255, blue: 0, alpha: 1)
        
        return activityIndicator
    }()
    
    // MARK: - Функци viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        searchTextField.delegate = self
    }
    
    // MARK: - Настройка UI элементов
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(segmentedControl)
        
        segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        view.addSubview(searchTextField)
        
        searchTextField.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 30).isActive = true
        searchTextField.leadingAnchor.constraint(equalTo: segmentedControl.leadingAnchor).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: segmentedControl.trailingAnchor).isActive = true
        
        view.addSubview(searchActivityIndicator)
        
        searchActivityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchActivityIndicator.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 30).isActive = true
        
        view.addSubview(resultLabel)
        resultLabel.topAnchor.constraint(equalTo: searchActivityIndicator.bottomAnchor, constant: 30).isActive = true
        resultLabel.leadingAnchor.constraint(equalTo: segmentedControl.leadingAnchor).isActive = true
        resultLabel.trailingAnchor.constraint(equalTo: segmentedControl.trailingAnchor).isActive = true
        resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    // MARK: - Сетевая логика
    
    /// Создание сетевого запроса
    ///
    /// - Parameters:
    ///     -  searchWord: Ключевое слово по которому будет сформирован сетевой запрос
    private func networkRequest(searchWord: String) {
        
        guard searchWord != "" else {
            setupNewData(result: "")
            return
        }
        
        switch self.segmentedControl.selectedSegmentIndex {
            
        case 0:
            self.networkDataFetcher.getSuggestionsData(searchWord: searchWord, path: APINetwork.address) { (model) in
                guard let result = model?.suggestions.first?.value else {
                    self.setupNewData(result: "")
                    return
                }
                self.setupNewData(result: result)
            }
            
        case 1:
            self.networkDataFetcher.getSuggestionsData(searchWord: searchWord, path: APINetwork.country) { (model) in
                guard let result = model?.suggestions.first?.value else {
                    self.setupNewData(result: "")
                    return
                }
                self.setupNewData(result: result)
            }
            
        case 2:
            self.networkDataFetcher.getSuggestionsData(searchWord: searchWord, path: APINetwork.bank) { (model) in
                guard let result = model?.suggestions.first?.value else {
                    self.setupNewData(result: "")
                    return
                }
                self.setupNewData(result: result)
            }
            
        default:
            print("Oh no, no, no!😱")
        }
        
    }
    
    /// Установка нового значения для результата поиска + остановка ActivityIndicator
    ///
    /// - Parameters:
    ///     -  result: Результат выполнения запроса. Конкретный адрес/страна/название банка.
    private func setupNewData(result: String) {
        
        guard result != "" else {
            resultLabel.text = "Данных по вашему запросу нет. Попробуйте еще раз!"
            self.searchActivityIndicator.stopAnimating()
            return
        }
        
        self.resultLabel.text = result
        self.searchActivityIndicator.stopAnimating()
    }
}

// MARK: - UITextFieldDelegate
extension DebouncerVC: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        searchActivityIndicator.startAnimating()
        
        if let _ = searchTaskWorkItem {
            searchTaskWorkItem?.cancel()
            searchTaskWorkItem = nil
        }
        
        searchTaskWorkItem = DispatchWorkItem(block: {
            guard let searchWord = textField.text else { return }
            self.networkRequest(searchWord: searchWord)
        })
        
        guard searchTaskWorkItem != nil else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: searchTaskWorkItem!)
    }
    
}

