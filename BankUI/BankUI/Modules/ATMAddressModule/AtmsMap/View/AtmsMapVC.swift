//
//  AtmsMapVC.swift
//  BankUI
//
//  Created by KOLESNIKOV Lev on 11.02.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit
import GoogleMaps

protocol AtmsMapVCProtocol: class {

}

class AtmsMapVC: UIViewController {

    // MARK: - Свойства

    var configurator: AtmsMapConfiguratorProtocol = AtmsMapConfigurator()
    var presenter: AtmsMapPresenterProtocol?

    let atmsInfoBottomCardPresenter = TransitionCardFromBottom(presentDuration: 0.6, dismissDuration: 0.25, interactionController: nil)

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    lazy var exitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.cornerRadius = 18
        button.addTarget(self, action: #selector(closeMapButtonTapped), for: .touchUpInside)
        button.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4.0)
        button.isHidden = true
        return button
    }()

    private lazy var plusZoomButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.cornerRadius = 18
        button.addTarget(self, action: #selector(plusZoomButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var minusZoomButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "subtract"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.cornerRadius = 18
        button.addTarget(self, action: #selector(minuzZoomButtonTapped), for: .touchUpInside)
        return button
    }()

    private let zoomButtonStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.backgroundColor = .red
        stack.spacing = 8
        stack.axis = .vertical
        return stack
    }()

    private let googleMap = GMSMapView()
    private let locationManager = CLLocationManager()
    private var zoomLevel: Float = 14

    // MARK: - Инициализация

    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configureView(with: self)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        configureView()
        configureCrossView()

        loadAtmsForMap()
    }

    private func configureView() {
        self.view.addSubview(googleMap)
        googleMap.delegate = self
        googleMap.setMinZoom(9, maxZoom: 18)
        self.googleMap.fillToSuperView(view: view)

        self.view.addSubview(exitButton)

        exitButton.setPosition(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 36, height: 36)

        zoomButtonStack.addArrangedSubview(plusZoomButton)
        zoomButtonStack.addArrangedSubview(minusZoomButton)
        self.view.addSubview(zoomButtonStack)
        zoomButtonStack.setPosition(top: nil, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 36, height: 80)
        zoomButtonStack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    ///Устанавливает spinner
    private func setupSpinner() {
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    ///Устанавливает кнопку закрытия карты
    func configureCrossView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeMapButtonTapped))
        exitButton.isUserInteractionEnabled = true
        exitButton.addGestureRecognizer(tap)
    }

    // MARK: - Работа с БД

    func loadAtmsForMap(for cluster: AtmsClastarizationByDistance = .twoHundredMeters, shouldUpdate: Bool = true) {
        spinner.startAnimating()
        presenter?.getClasteredAtms(for: cluster, shouldUpdate: shouldUpdate, completion: {[weak self] (result) in
            if result > 0 {
                OperationQueue.main.addOperation {
                    self?.spinner.stopAnimating()
                    self?.setAtmsOnMap()
                }
            } else {
                self?.spinner.stopAnimating()
            }
        })
    }

    // MARK: - Установка маркеров на карте

    private func setAtmsOnMap() {
        guard let presenter = presenter else { return }
        let atms = presenter.getClasterizedAtms()
        for atm in atms.values {
            if atm.value.count == 1 {
                guard let atm = presenter.getAtmsInfo(byLatitide: atm.key.latitude, byLongitude: atm.key.longitude) else {return}
                setUpMarker(atm: atm)
            } else {
                setUpClasterMarker(location: atm.key, atmsCount: atm.value.count)
            }
        }
    }

    private func setUpMarker(atm: ATMMapModelProtocol) {
        let atmPin = AtmPinIndicator()
        atmPin.setImageForAtmType(typeID: atm.typeId)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: atm.latitude, longitude: atm.longitude)
        marker.snippet = atm.addressFull
        marker.iconView = atmPin
        marker.map = googleMap
    }

    private func setUpClasterMarker(location: AtmLocationProtocol, atmsCount: Int) {
        let atmPin = AtmsCountPinIndicator()
        atmPin.setAtmsCount(count: atmsCount)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        marker.iconView = atmPin
        marker.map = googleMap
    }

    // MARK: - Работа с кнопками

    @objc func closeMapButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc private func plusZoomButtonTapped() {
        guard zoomLevel < 18 else {return}
        googleMap.clear()
        zoomLevel += 1
        googleMap.animate(toZoom: zoomLevel)
        showMapInfo(with: zoomLevel)
    }

    @objc private func minuzZoomButtonTapped() {
        guard zoomLevel > 9 else {return}
        googleMap.clear()
        zoomLevel -= 1
        googleMap.animate(toZoom: zoomLevel)
        showMapInfo(with: zoomLevel)
    }

    private func showMapInfo(with zoom: Float) {
        switch zoomLevel {
        case 9:
            loadAtmsForMap(for: .fiftyKillometers, shouldUpdate: false)
        case 10:
            loadAtmsForMap(for: .tenKillometers, shouldUpdate: false)
        case 11:
            loadAtmsForMap(for: .threeKillometers, shouldUpdate: false)
        case 12:
            loadAtmsForMap(for: .killometers, shouldUpdate: false)
        case 13:
            loadAtmsForMap(for: .fiveHundredMeters, shouldUpdate: false)
        case 14:
            loadAtmsForMap(for: .twoHundredMeters, shouldUpdate: false)
        case 15:
            loadAtmsForMap(for: .hundredMeters, shouldUpdate: false)
        case 16:
            loadAtmsForMap(for: .fiftyMeters, shouldUpdate: false)
        case 17:
            loadAtmsForMap(for: .twentyMeteres, shouldUpdate: false)
        case 18:
            loadAtmsForMap(for: .tenMeters, shouldUpdate: false)
        default:
            break
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension AtmsMapVC: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        guard status == .authorizedWhenInUse else {
            return
        }

        locationManager.startUpdatingLocation()
        googleMap.isMyLocationEnabled = true
        googleMap.settings.myLocationButton = true
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.first else {
            return
        }

        googleMap.camera = GMSCameraPosition(target: location.coordinate, zoom: zoomLevel, bearing: 0, viewingAngle: 0)
        locationManager.stopUpdatingLocation()
    }
}

extension AtmsMapVC: AtmsMapVCProtocol {

}

extension AtmsMapVC: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {

        let atms = presenter?.showDetailInfo(forLatitude: marker.position.latitude, forLongitude: marker.position.longitude)
        if let count = atms?.count, count > 10 {
            zoomLevel += 1
            googleMap.clear()
            googleMap.camera = GMSCameraPosition(target: marker.position, zoom: zoomLevel, bearing: 0, viewingAngle: 0)
            showMapInfo(with: zoomLevel)
            return true
        }
        let card = AtmsCardViewVC()
        card.atmsInfo = atms
        card.modalPresentationStyle = .custom
        card.transitioningDelegate = self
        atmsInfoBottomCardPresenter.interactionDismiss = BottomCardInteractiveTransition(viewController: card)
        self.present(card, animated: true, completion: nil)
        return true
    }

    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let previousZoom = zoomLevel
        zoomLevel = round(position.zoom)
        if zoomLevel != previousZoom {
            googleMap.clear()
            showMapInfo(with: zoomLevel)
        }
    }
}

extension AtmsMapVC: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        atmsInfoBottomCardPresenter.isPresenting = true
        return atmsInfoBottomCardPresenter
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        atmsInfoBottomCardPresenter.isPresenting = false
        atmsInfoBottomCardPresenter.isDismissing = true
        return atmsInfoBottomCardPresenter
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let animator = animator as? TransitionCardFromBottom,
          let interactionController = animator.interactionDismiss,
          interactionController.interactionInProgress
          else {
            return nil
        }
        return interactionController
    }
}
