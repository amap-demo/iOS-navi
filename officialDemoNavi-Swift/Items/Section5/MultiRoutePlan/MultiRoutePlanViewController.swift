//
//  MultiRoutePlanViewController.swift
//  officialDemoNavi
//
//  Created by liubo on 10/14/16.
//  Copyright © 2016 AutoNavi. All rights reserved.
//

import UIKit

class MultiRoutePlanViewController: UIViewController, MAMapViewDelegate, AMapNaviDriveManagerDelegate, DriveNaviViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let routePlanInfoViewHeight: CGFloat = 130.0
    let routeIndicatorViewHeight: CGFloat = 64.0
    let collectionCellIdentifier = "kCollectionCellIdentifier"
    
    var mapView: MAMapView!
    var driveManager: AMapNaviDriveManager!
    
    let startPoint = AMapNaviPoint.location(withLatitude: 39.993135, longitude: 116.474175)!
    let endPoint = AMapNaviPoint.location(withLatitude: 39.908791, longitude: 116.321257)!
    
    var routeIndicatorInfoArray = [RouteCollectionViewInfo]()
    var routeIndicatorView: UICollectionView!
    var preferenceView: PreferenceView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        initMapView()
        initDriveManager()
        configSubview()
        initRouteIndicatorView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addAnnotations()
    }
    
    // MARK: - Initalization
    
    func initMapView() {
        mapView = MAMapView(frame: CGRect(x: 0, y: routePlanInfoViewHeight, width: view.bounds.width, height: view.bounds.height - routePlanInfoViewHeight))
        mapView.delegate = self
        view.addSubview(mapView)
    }
    
    func initDriveManager() {
        driveManager = AMapNaviDriveManager()
        driveManager.delegate = self
        
        driveManager.allowsBackgroundLocationUpdates = true
        driveManager.pausesLocationUpdatesAutomatically = false
    }
    
    func initRouteIndicatorView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        routeIndicatorView = UICollectionView(frame: CGRect(x: 0, y: view.bounds.height - routeIndicatorViewHeight, width: view.bounds.width, height: routeIndicatorViewHeight), collectionViewLayout: layout)
        
        guard let routeIndicatorView = routeIndicatorView else {
            return
        }
        
        routeIndicatorView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        routeIndicatorView.backgroundColor = UIColor.clear
        routeIndicatorView.isPagingEnabled = true
        routeIndicatorView.showsVerticalScrollIndicator = false
        routeIndicatorView.showsHorizontalScrollIndicator = false
        routeIndicatorView.delegate = self
        routeIndicatorView.dataSource = self
        
        routeIndicatorView.register(RouteCollectionViewCell.self, forCellWithReuseIdentifier: collectionCellIdentifier)
        view.addSubview(routeIndicatorView)
    }
    
    func addAnnotations() {
        let beginAnnotation = NaviPointAnnotation()
        beginAnnotation.coordinate = CLLocationCoordinate2D(latitude: Double(startPoint.latitude), longitude: Double(startPoint.longitude))
        beginAnnotation.title = "起始点"
        beginAnnotation.naviPointType = .start
        
        mapView.addAnnotation(beginAnnotation)
        
        let endAnnotation = NaviPointAnnotation()
        endAnnotation.coordinate = CLLocationCoordinate2D(latitude: Double(endPoint.latitude), longitude: Double(endPoint.longitude))
        endAnnotation.title = "终点"
        endAnnotation.naviPointType = .end
        
        mapView.addAnnotation(endAnnotation)
    }
    
    //MARK: - Button Action
    
    func routePlanAction(sender: UIButton) {
        //进行多路径规划
        driveManager.calculateDriveRoute(withStart: [startPoint],
                                         end: [endPoint],
                                         wayPoints: nil,
                                         drivingStrategy: preferenceView.strategy(isMultiple: true))
    }
    
    //MARK: - Handle Navi Routes
    
    func showNaviRoutes() {
        
        guard let allRoutes = driveManager.naviRoutes else {
            return
        }
        
        mapView.removeOverlays(mapView.overlays)
        routeIndicatorInfoArray.removeAll()
        
        for (aNumber, aRoute) in allRoutes {
            
            //添加路径Polyline
            var coords = [CLLocationCoordinate2D]()
            for coordinate in aRoute.routeCoordinates {
                coords.append(CLLocationCoordinate2D(latitude: Double(coordinate.latitude), longitude: Double(coordinate.longitude)))
            }
            
            let polyline = MAPolyline(coordinates: &coords, count: UInt(aRoute.routeCoordinates.count))!
            let selectablePolyline = SelectableOverlay(aOverlay: polyline)
            selectablePolyline.routeID = Int(aNumber)
            
            mapView.add(selectablePolyline)
            
            //更新CollectonView的信息
            let title = String(format: "路径ID:%d | 路径计算策略:%d", Int(aNumber), preferenceView.strategy(isMultiple: true).rawValue)
            let subtitle = String(format: "长度:%d米 | 预估时间:%d秒 | 分段数:%d", aRoute.routeLength, aRoute.routeTime, aRoute.routeSegments.count)
            let info = RouteCollectionViewInfo(routeID: Int(aNumber), title: title, subTitle: subtitle)
            
            routeIndicatorInfoArray.append(info)
        }
        
        mapView.showAnnotations(mapView.annotations, animated: false)
        routeIndicatorView.reloadData()
        
        if let first = routeIndicatorInfoArray.first {
            selectNaviRouteWithID(routeID: first.routeID)
        }
    }
    
    func selectNaviRouteWithID(routeID: Int) {
        //在开始导航前进行路径选择
        if driveManager.selectNaviRoute(withRouteID: routeID) {
            selecteOverlayWithRouteID(routeID: routeID)
        }
        else {
            NSLog("路径选择失败!")
        }
    }
    
    func selecteOverlayWithRouteID(routeID: Int) {
        guard let allOverlays = mapView.overlays else {
            return
        }
        
        for (index, aOverlay) in allOverlays.enumerated() {
            
            if let selectableOverlay = aOverlay as? SelectableOverlay {
                
                guard let overlayRenderer = mapView.renderer(for: selectableOverlay) as? MAPolylineRenderer else {
                    return
                }
                
                if selectableOverlay.routeID == routeID {
                    selectableOverlay.selected = true
                    
                    overlayRenderer.fillColor = selectableOverlay.selectedColor
                    overlayRenderer.strokeColor = selectableOverlay.selectedColor
                    
                    mapView.exchangeOverlay(at: UInt(index), withOverlayAt: UInt(allOverlays.count - 1))
                }
                else {
                    selectableOverlay.selected = false
                    
                    overlayRenderer.fillColor = selectableOverlay.reguarColor
                    overlayRenderer.strokeColor = selectableOverlay.reguarColor
                }
                
                overlayRenderer.glRender()
            }
        }
    }
    
    //MARK: - SubViews
    
    func configSubview() {
        let startPointLabel = UILabel(frame: CGRect(x: 0, y: 5, width: view.bounds.width, height: 20))
        startPointLabel.textAlignment = .center
        startPointLabel.font = UIFont.systemFont(ofSize: 14)
        startPointLabel.text = String(format: "起 点: %.6f, %.6f", startPoint.latitude, startPoint.longitude)
        
        view.addSubview(startPointLabel)
        
        let endPointLabel = UILabel(frame: CGRect(x: 0, y: 30, width: view.bounds.width, height: 20))
        endPointLabel.textAlignment = .center
        endPointLabel.font = UIFont.systemFont(ofSize: 14)
        endPointLabel.text = String(format: "终 点: %.6f, %.6f", endPoint.latitude, endPoint.longitude)
        
        view.addSubview(endPointLabel)
        
        preferenceView = PreferenceView(frame: CGRect(x: 0, y: 60, width: view.bounds.width, height: 30))
        view.addSubview(preferenceView)
        
        let routeBtn = buttonForTitle("路径规划")
        routeBtn.frame = CGRect(x: (view.bounds.width - 80) / 2.0, y: 95, width: 80, height: 30)
        routeBtn.addTarget(self, action: #selector(self.routePlanAction(sender:)), for: .touchUpInside)
        
        view.addSubview(routeBtn)
    }
    
    private func buttonForTitle(_ title: String) -> UIButton {
        let reBtn = UIButton(type: .custom)
        
        reBtn.layer.borderColor = UIColor.lightGray.cgColor
        reBtn.layer.borderWidth = 1.0
        reBtn.layer.cornerRadius = 5
        
        reBtn.bounds = CGRect(x: 0, y: 0, width: 80, height: 30)
        reBtn.setTitle(title, for: .normal)
        reBtn.setTitleColor(UIColor.black, for: .normal)
        reBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        
        return reBtn
    }
    
    //MARK: - AMapNaviDriveManager Delegate
    
    func driveManager(_ driveManager: AMapNaviDriveManager, error: Error) {
        let error = error as NSError
        NSLog("error:{%d - %@}", error.code, error.localizedDescription)
    }
    
    func driveManager(onCalculateRouteSuccess driveManager: AMapNaviDriveManager) {
        NSLog("CalculateRouteSuccess")
        
        showNaviRoutes()
    }
    
    func driveManager(_ driveManager: AMapNaviDriveManager, onCalculateRouteFailure error: Error) {
        let error = error as NSError
        NSLog("CalculateRouteFailure:{%d - %@}", error.code, error.localizedDescription)
    }
    
    func driveManager(_ driveManager: AMapNaviDriveManager, didStartNavi naviMode: AMapNaviMode) {
        NSLog("didStartNavi");
    }
    
    func driveManagerNeedRecalculateRoute(forYaw driveManager: AMapNaviDriveManager) {
        NSLog("needRecalculateRouteForYaw");
    }
    
    func driveManagerNeedRecalculateRoute(forTrafficJam driveManager: AMapNaviDriveManager) {
        NSLog("needRecalculateRouteForTrafficJam");
    }
    
    func driveManager(_ driveManager: AMapNaviDriveManager, onArrivedWayPoint wayPointIndex: Int32) {
        NSLog("ArrivedWayPoint:\(wayPointIndex)");
    }
    
    func driveManagerIsNaviSoundPlaying(_ driveManager: AMapNaviDriveManager) -> Bool {
        return SpeechSynthesizer.Shared.isSpeaking()
    }
    
    func driveManager(_ driveManager: AMapNaviDriveManager, playNaviSound soundString: String, soundStringType: AMapNaviSoundType) {
        NSLog("playNaviSoundString:{%d:%@}", soundStringType.rawValue, soundString);
        
        SpeechSynthesizer.Shared.speak(soundString)
    }
    
    func driveManagerDidEndEmulatorNavi(_ driveManager: AMapNaviDriveManager) {
        NSLog("didEndEmulatorNavi");
    }
    
    func driveManager(onArrivedDestination driveManager: AMapNaviDriveManager) {
        NSLog("onArrivedDestination");
    }
    
    //MARK: - 
    
    func driveNaviViewCloseButtonClicked() {
        //开始导航后不再允许选择路径，所以停止导航
        driveManager.stopNavi()
        
        //停止语音
        SpeechSynthesizer.Shared.stopSpeak()
        
        _ = navigationController?.popViewController(animated: false)
    }
    
    //MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let driveVC = DriveNaviViewViewController()
        driveVC.delegate = self
        
        //将driveView添加为导航数据的Representative，使其可以接收到导航诱导数据
        driveManager.addDataRepresentative(driveVC.driveView)
        
        _ = navigationController?.pushViewController(driveVC, animated: false)
        driveManager.startEmulatorNavi()
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let cell = routeIndicatorView.visibleCells.first as? RouteCollectionViewCell else {
            return;
        }
        
        if let info = cell.info {
            selectNaviRouteWithID(routeID: info.routeID)
        }
    }
    
    //MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return routeIndicatorInfoArray.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellIdentifier, for: indexPath) as! RouteCollectionViewCell
        cell.shouldShowPrevIndicator = (indexPath.row > 0 && indexPath.row < routeIndicatorInfoArray.count)
        cell.shouldShowNextIndicator = (indexPath.row >= 0 && indexPath.row < routeIndicatorInfoArray.count-1)
        cell.info = routeIndicatorInfoArray[indexPath.row]
        
        return cell
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 10, height: collectionView.bounds.height - 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 5, 5, 5)
    }
    
    //MARK: - MAMapView Delegate
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        
        if annotation is NaviPointAnnotation {
            let annotationIdentifier = "NaviPointAnnotationIdentifier"
            
            var pointAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MAPinAnnotationView
            
            if pointAnnotationView == nil {
                pointAnnotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            }
            
            pointAnnotationView?.animatesDrop = false
            pointAnnotationView?.canShowCallout = true
            pointAnnotationView?.isDraggable = false
            
            let annotation = annotation as! NaviPointAnnotation
            if annotation.naviPointType == .start {
                pointAnnotationView?.pinColor = .green
            }
            else if annotation.naviPointType == .end {
                pointAnnotationView?.pinColor = .red
            }
            
            return pointAnnotationView
        }
        return nil
    }
    
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        
        if overlay is SelectableOverlay {
            let selectableOverlay = overlay as! SelectableOverlay
            
            let polylineRenderer = MAPolylineRenderer(overlay: selectableOverlay.overlay)
            polylineRenderer?.lineWidth = 8.0
            polylineRenderer?.strokeColor = selectableOverlay.selected ? selectableOverlay.selectedColor : selectableOverlay.reguarColor
            
            return polylineRenderer
        }
        return nil
    }

}
