//
//  MainViewController.swift
//  task_4
//
//  Created by Artem Sulzhenko on 29.12.2022.
//

import UIKit
import SnapKit
import MapKit
import CoreLocation
import SystemConfiguration

class MainViewController: UIViewController {

    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.overrideUserInterfaceStyle = .unspecified
        return map
    }()

    private lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Карта", "Список"])
        segmentControl.selectedSegmentIndex = 0
        segmentControl.backgroundColor = UIColor(named: "SegmentControlBackgroundColor")
        guard let borderColor = UIColor(named: "BorderColor") else { return segmentControl }
        segmentControl.layer.borderColor =  UIColor(named: "Gray")?.cgColor
        segmentControl.selectedSegmentTintColor = UIColor(named: "Green")
        segmentControl.layer.borderWidth = 0.5

        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "BlackWhite")]
        segmentControl.setTitleTextAttributes(titleTextAttributes as [NSAttributedString.Key: Any], for: .normal)

        let titleTextAttributes1 = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentControl.setTitleTextAttributes(titleTextAttributes1, for: .selected)
        segmentControl.addTarget(self, action: #selector(segmentControlValueChanged(_:)), for: .valueChanged)
        return segmentControl
    }()

    private lazy var listCollectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.backgroundColor = UIColor(named: "ViewBackgroundColor")
        return collectionView
    }()

    private lazy var locationManager = CLLocationManager()
    private lazy var refreshButton = UIBarButtonItem(title: "Обновить", style: .plain, target: self,
                                                     action: #selector(refreshButtonTapped))

    private lazy var atmList: [ATM] = []
    private lazy var atmListGroupedByCity: [String: [ATM]] = [:]
    private lazy var preliminaryDetails = PreliminaryDetailsViewController()
    private lazy var coordinateUserLocation: (x: Double, y: Double) = (0, 0)
    var infoStandList: [InformationStand] = []
    private lazy var infoStandListGroupedByCity: [String: [InformationStand]] = [:]
    var bank = [Bank]()
    private lazy var test: [String: [BelarusBank]] = [:]
    private lazy var test1: [String: [BelarusBank]] = [:]
    private lazy var test2: [String: [BelarusBank]] = [:]
    private lazy var allDataBelarusbank: [String: [BelarusBank]] = [:]
    private lazy var bel = [BelarusBank]()
    var seq: [String: [BelarusBank]] = [:]
    var groupd = [String]()



    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(mapView)
        view.addSubview(listCollectionView)
        view.addSubview(segmentControl)

        setSetting()
        setConstraint()
        checkingNetworkBeforeFetchingData()
        checkAuthorization()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            if let sheet = preliminaryDetails.sheetPresentationController {
                sheet.detents = [.large()]
                sheet.prefersGrabberVisible = true
                sheet.prefersEdgeAttachedInCompactHeight = true
            }
        } else {
            if let sheet = preliminaryDetails.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
                sheet.prefersEdgeAttachedInCompactHeight = false
            }
        }
    }

    private func setSetting() {
        view.backgroundColor = UIColor(named: "ViewBackgroundColor")

        let navigationBar = navigationController?.navigationBar
        navigationBar?.overrideUserInterfaceStyle = .unspecified
        let navBarAppearance = UINavigationBarAppearance()
        navigationBar?.standardAppearance = navBarAppearance
        navigationBar?.scrollEdgeAppearance = navBarAppearance
        navigationItem.title = "Банкоматы"
        navigationItem.rightBarButtonItem = refreshButton

        mapView.delegate = self

        listCollectionView.dataSource = self
        listCollectionView.delegate = self
        listCollectionView.register(CollectionViewCell.self,
                                    forCellWithReuseIdentifier: CollectionViewCell.identifier)
        listCollectionView.register(InfoCollectionViewCell.self,
                                    forCellWithReuseIdentifier: InfoCollectionViewCell.identifier)
        listCollectionView.register(HeaderCollectionReusableView.self,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: HeaderCollectionReusableView.reuserId)

        segmentControlValueChanged(segmentControl)
    }

    private func setConstraint() {
        mapView.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide).inset(0)
            maker.left.right.bottom.equalTo(view).inset(0)
        }
        segmentControl.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            maker.left.right.equalTo(view).inset(40)
            maker.height.equalTo(30)
        }
        listCollectionView.snp.makeConstraints { maker in
            maker.top.equalTo(segmentControl.snp.bottom).offset(10)
            maker.left.right.bottom.equalTo(view).inset(0)
        }
    }

    private func fethData() {
        let overlayView = UIView()
        let activityIndicator = UIActivityIndicatorView()
        overlayView.backgroundColor = .gray.withAlphaComponent(0.7)
        overlayView.frame = view.frame
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.color = .white
        activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
        overlayView.addSubview(activityIndicator)
        view.addSubview(overlayView)
        refreshButton.isHidden = true
        activityIndicator.startAnimating()
        mapView.removeAnnotations(mapView.annotations)


        let defaultLocation = CLLocation(latitude: 54.2083386, longitude: 28.4736882)

//        let defaultLocation = CLLocation(latitude: 52.425163, longitude: 31.015039)
        let group = DispatchGroup()


        bel = []
        test = [:]
        group.enter()
        NetworkManager.fetchDataAtm { atm in
            if NetworkManager.statusCodeAtm >= 200 && NetworkManager.statusCodeAtm < 300 {
                self.atmList = atm
                self.refreshButton.isHidden = false
                activityIndicator.stopAnimating()
                overlayView.removeFromSuperview()
                self.addPointsAutomatedTellerMachine()
                self.test = Dictionary(grouping: self.atmList, by: { $0.city })
                for item in self.test {
                    self.test[item.key] = item.value.sorted {
                        CLLocation(latitude: $0.coordinate.latitude,
                                   longitude: $0.coordinate.longitude).distance(
                                    from: defaultLocation) < CLLocation(latitude: $1.coordinate.latitude,
                                                                        longitude: $1.coordinate.longitude).distance(
                                                                            from: defaultLocation)
                    }
                }
                self.bel += self.atmList
                self.bel = self.bel.sorted {
                    CLLocation(latitude: $0.coordinate.latitude,
                               longitude: $0.coordinate.longitude).distance(
                                from: defaultLocation) < CLLocation(latitude: $1.coordinate.latitude,
                                                                    longitude: $1.coordinate.longitude).distance(
                                                                              from: defaultLocation)
                }
                var citySet = Set<String>()
                for bes in self.bel {
                    if !citySet.contains(bes.cityB){
                        self.groupd.append(bes.cityB)
                    }
                    citySet.insert(bes.cityB)
                }
                self.listCollectionView.reloadData()
                group.leave()
            } else {
                let alert = UIAlertController(title: "Код ответа \(NetworkManager.statusCodeAtm)",
                                              message: "Произошла неизвестная сетевая ошибка",
                                              preferredStyle: .alert)
                self.refreshButton.isHidden = false
                activityIndicator.stopAnimating()
                self.navigationItem.rightBarButtonItem = self.refreshButton
                alert.addAction(UIAlertAction(title: "Повторить ещё раз", style: .default) { _ in
                    self.fethData()
                    group.leave()
                })
                alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                group.leave()
            }
        }


        group.enter()
        DispatchQueue.global(qos:.background).async {
            NetworkManager.fetchDataInformationStand { infoStands in
                self.infoStandList = infoStands
                self.addPointsInformationStand()
                self.test1 = Dictionary(grouping: self.infoStandList, by: { $0.city })
                self.test.merge(self.test1, uniquingKeysWith: +)
                for item in self.test {
                    self.test[item.key] = item.value.sorted {
                        CLLocation(latitude: $0.coordinate.latitude,
                                   longitude: $0.coordinate.longitude).distance(
                                    from: defaultLocation) < CLLocation(latitude: $1.coordinate.latitude,
                                                                        longitude: $1.coordinate.longitude).distance(
                                                                            from: defaultLocation)
                    }
                }
                self.bel += self.infoStandList
                self.bel = self.bel.sorted {
                    CLLocation(latitude: $0.coordinate.latitude,
                               longitude: $0.coordinate.longitude).distance(
                                from: defaultLocation) < CLLocation(latitude: $1.coordinate.latitude,
                                                                    longitude: $1.coordinate.longitude).distance(
                                                                        from: defaultLocation)
                }
                var citySet = Set<String>()
                for bes in self.bel {
                    if !citySet.contains(bes.cityB){
                        self.groupd.append(bes.cityB)
                    }
                    citySet.insert(bes.cityB)
                }
                self.listCollectionView.reloadData()
                group.leave()
            }
        }

        group.enter()
        DispatchQueue.global(qos:.background).async {
            NetworkManager.fetchDataBank { tes in
                self.bank = tes
                self.addPointsBank()
                self.test2 = Dictionary(grouping: self.bank, by: { $0.city })
                self.test.merge(self.test2, uniquingKeysWith: +)
                for item in self.test {
                    self.test[item.key] = item.value.sorted {
                        CLLocation(latitude: $0.coordinate.latitude,
                                   longitude: $0.coordinate.longitude).distance(
                                    from: defaultLocation) < CLLocation(latitude: $1.coordinate.latitude,
                                                                        longitude: $1.coordinate.longitude).distance(
                                                                            from: defaultLocation)
                    }
                }
                self.bel += self.bank
                self.bel = self.bel.sorted {
                    CLLocation(latitude: $0.coordinate.latitude,
                               longitude: $0.coordinate.longitude).distance(
                                from: defaultLocation) < CLLocation(latitude: $1.coordinate.latitude,
                                                                    longitude: $1.coordinate.longitude).distance(
                                                                        from: defaultLocation)
                }
                var citySet = Set<String>()
                for bes in self.bel {
                    if !citySet.contains(bes.cityB){
                        self.groupd.append(bes.cityB)
                    }
                    citySet.insert(bes.cityB)
                }
                self.listCollectionView.reloadData()
                group.leave()
            }
        }

        group.notify(queue: .main) {

        }
    }

    private func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else { return false }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }

    private func checkingNetworkBeforeFetchingData() {
        if isConnectedToNetwork() {
            fethData()
        } else {
            let alert = UIAlertController(title: "Отсутствует интернет",
                                          message: "Проверьте ваше соединение с интернетом",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    private func setRegion(coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1500, longitudinalMeters: 1500)
        mapView.setRegion(region, animated: true)
    }

    private func setupManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }

    private func addPointsAutomatedTellerMachine() {
        for automatedTellerMachine in atmList {
            let pinLocation = automatedTellerMachine.coordinate
            let objectAnnotation = MKPointAnnotation()
            objectAnnotation.coordinate = pinLocation
            objectAnnotation.title = "Банкомат"
            objectAnnotation.subtitle = automatedTellerMachine.id
            mapView.addAnnotation(objectAnnotation)
        }
    }

    private func addPointsInformationStand() {
        for informationStand in infoStandList {
            let pinLocation = informationStand.coordinate
            let objectAnnotation = MKPointAnnotation()
            objectAnnotation.coordinate = pinLocation
            objectAnnotation.title = "Банк"
            objectAnnotation.subtitle = "\(informationStand.infoId)"
            mapView.addAnnotation(objectAnnotation)
        }
    }

    private func addPointsBank() {
        for ban in bank {
            let pinLocation = ban.coordinate
            let objectAnnotation = MKPointAnnotation()
            objectAnnotation.coordinate = pinLocation
            objectAnnotation.title = "Инфокиоск"
            objectAnnotation.subtitle = "\(ban.filialId)"
            mapView.addAnnotation(objectAnnotation)
        }
    }

    private func checkAuthorization() {
        switch locationAuthorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            mapView.userLocation.title = "Я"
            mapView.userLocation.subtitle = "Я"
        case .denied:
            let alert = UIAlertController(title: nil,
                                          message: "Для продолжения работы этому приложению требуется " +
                                          "доступ к вашей геолокации. Вы хотите предоставить доступ?",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Открыть настройки", style: .default) { _ in
                if let urlSetting = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(urlSetting)
                }})
            alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))

            present(alert, animated: true, completion: nil)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
        setupManager()
        guard let userCoordinate: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
        setRegion(coordinate: userCoordinate)
    }

    private func locationAuthorizationStatus() -> CLAuthorizationStatus {
        let locationManager = CLLocationManager()
        var locationAuthorizationStatus: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            locationAuthorizationStatus =  locationManager.authorizationStatus
        } else {
            locationAuthorizationStatus = CLLocationManager.authorizationStatus()
        }
        return locationAuthorizationStatus
    }

    private func showPreliminaryDetails(element: ATM) {
        preliminaryDetails.dataInPreliminaryDetails(element: element, coordinate: coordinateUserLocation)

        if UIDevice.current.orientation.isLandscape {
            if let sheet = preliminaryDetails.sheetPresentationController {
                sheet.detents = [.large()]
                sheet.prefersGrabberVisible = true
                sheet.prefersEdgeAttachedInCompactHeight = true
            }
        } else {
            if let sheet = preliminaryDetails.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
                sheet.prefersEdgeAttachedInCompactHeight = false
            }
        }

        present(preliminaryDetails, animated: true, completion: nil)
    }

    @objc func segmentControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.isHidden = false
            listCollectionView.isHidden = true
        case 1:
            mapView.isHidden = true
            listCollectionView.isHidden = false
        default:
            break
        }
    }

    @objc func refreshButtonTapped() {
        print(test.count)

        checkingNetworkBeforeFetchingData()
    }
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            coordinateUserLocation.x = location.coordinate.latitude
            coordinateUserLocation.y = location.coordinate.longitude
        }
    }
}

extension MainViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let title = view.annotation?.title, let titleValue = title else { return }
        guard let subtitle = view.annotation?.subtitle, let subtitleValue = subtitle else { return }
        let titleAtm = "Банкомат"

        if titleValue == titleAtm {
            var indexResult = 0
            for index in 0..<atmList.count where atmList[index].id == subtitleValue {
                indexResult = index
            }
            setRegion(coordinate: atmList[indexResult].coordinate)
            showPreliminaryDetails(element: atmList[indexResult])
            mapView.deselectAnnotation(view.annotation, animated: false)
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "something")
        if annotation.title == "Я" {
            annotationView.glyphImage = UIImage(named: "Human")
            annotationView.glyphTintColor = .white
        } else if annotation.title == "Банкомат" {
            annotationView.markerTintColor = UIColor(named: "Green")
            annotationView.glyphImage = UIImage(named: "ATM")
        } else if annotation.title == "Инфокиоск" {
            annotationView.markerTintColor = .brown
        }
        return annotationView
    }

}

extension MainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return test.keys.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return test[groupd[section]]?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        let cellTest = test[groupd[indexPath.section]]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier,
                                                            for: indexPath) as? CollectionViewCell else {
            return CollectionViewCell()
        }

        guard let cellTest = cellTest else { return cell }

        if let atm = cellTest[indexPath.row] as? ATM {
            cell.dataAtmInCell(element: atm)
        } else if let info = cellTest[indexPath.row] as? InformationStand {
            cell.dataInfoStandInCell(element: info)
        } else if let bank = cellTest[indexPath.row] as? Bank {
            cell.dataBankInCell(element: bank)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.reuserId, for: indexPath)
        guard let typedHeaderView = header as? HeaderCollectionReusableView else { return header }

        typedHeaderView.setTitleHeader(title: "\(groupd[indexPath.section])")
        return header
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 50)
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = test[groupd[indexPath.section]]
        guard let selectedItem = selectedItem else { return }
        if let atm = selectedItem[indexPath.row] as? ATM {
            showPreliminaryDetails(element: atm)
            segmentControl.selectedSegmentIndex = 0
            segmentControlValueChanged(segmentControl)
            setRegion(coordinate: atm.coordinate)
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 3
        let interItemSpacing: CGFloat = 5
        let width = (collectionView.bounds.width - (interItemSpacing * (itemsPerRow - 1)) - 20) / itemsPerRow
        return CGSize(width: width, height: width + 25)
    }

}
