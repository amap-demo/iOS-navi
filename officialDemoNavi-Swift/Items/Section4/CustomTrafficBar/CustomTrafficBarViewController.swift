//
//  CustomTrafficBarViewController.swift
//  officialDemoNavi
//
//  Created by liubo on 2017/4/18.
//  Copyright © 2017年 AutoNavi. All rights reserved.
//

import UIKit

class CustomTrafficBarViewController: UIViewController, AMapNaviDriveManagerDelegate, AMapNaviDriveViewDelegate, AMapNaviDriveDataRepresentable {
    
    var driveView: AMapNaviDriveView!
    var driveManager: AMapNaviDriveManager!
    
    let startPoint = AMapNaviPoint.location(withLatitude: 39.993135, longitude: 116.474175)!
    let endPoint = AMapNaviPoint.location(withLatitude: 39.910267, longitude: 116.370888)!
    let wayPints = [AMapNaviPoint.location(withLatitude: 39.973135, longitude: 116.444175)!,
                    AMapNaviPoint.location(withLatitude: 39.987125, longitude: 116.353145)!]
    
    var routeLength = 0
    lazy var trafficBarView = AMapNaviTrafficBarView(frame: CGRect(x: 30, y: 200, width: 25, height: 300))
    
    deinit {
        driveManager.stopNavi()
        driveManager.removeDataRepresentative(driveView)
        driveManager.removeDataRepresentative(self)
        driveManager.delegate = nil
        
        driveView.removeFromSuperview()
        driveView.delegate = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        initDriveView()
        initDriveManager()
        configSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        calculateRoute()
    }
    
    // MARK: - Initalization
    
    func initDriveView() {
        driveView = AMapNaviDriveView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 400))
        driveView.delegate = self
        
        //将导航界面的界面元素进行隐藏，然后通过自定义的控件展示导航信息
        driveView.showUIElements = false
        
        view.addSubview(driveView)
    }
    
    func initDriveManager() {
        driveManager = AMapNaviDriveManager()
        driveManager.delegate = self
        
        //将driveView添加为导航数据的Representative，使其可以接收到导航诱导数据
        driveManager.addDataRepresentative(driveView)
        
        //将当前VC添加为导航数据的Representative，使其可以接收到导航诱导数据
        driveManager.addDataRepresentative(self)
    }
    
    //MARK: - Route Plan
    
    func calculateRoute() {
        driveManager.calculateDriveRoute(withStart: [startPoint],
                                         end: [endPoint],
                                         wayPoints: wayPints,
                                         drivingStrategy: .singleDefault)
    }
    
    //MARK: - Subviews
    
    func configSubviews() {
        trafficBarView.showCar = true
        view.addSubview(trafficBarView)
    }
    
    //MARK: - AMapNaviDriveDataRepresentable
    
    func driveManager(_ driveManager: AMapNaviDriveManager, update naviMode: AMapNaviMode) {
        NSLog("updateNaviMode:%d", naviMode.rawValue)
    }
    
    func driveManager(_ driveManager: AMapNaviDriveManager, updateNaviRouteID naviRouteID: Int) {
        NSLog("updateNaviRouteID:%d", naviRouteID)
    }
    
    func driveManager(_ driveManager: AMapNaviDriveManager, update naviRoute: AMapNaviRoute?) {
        NSLog("updateNaviRoute")
        
        guard let aNaviRoute = naviRoute else {
            return
        }
        
        //更新路径长度
        routeLength = aNaviRoute.routeLength
    }
    
    func driveManager(_ driveManager: AMapNaviDriveManager, update naviInfo: AMapNaviInfo?) {
        
        guard let aNaviInfo = naviInfo else {
            return
        }
        
        //更新交通光柱信息
        let percent: Double = (routeLength > 0) ? (1.0 - Double(aNaviInfo.routeRemainDistance) / Double(routeLength)) : 0.0
        trafficBarView.updateTrafficBar(withCarPositionPercent: percent)
    }
    
    func driveManager(_ driveManager: AMapNaviDriveManager, update naviLocation: AMapNaviLocation?) {
//        NSLog("updateNaviLocation")
    }
    
    func driveManager(_ driveManager: AMapNaviDriveManager, showCross crossImage: UIImage) {
        NSLog("showCrossImage")
    }
    
    func driveManagerHideCrossImage(_ driveManager: AMapNaviDriveManager) {
        NSLog("hideCrossImage")
    }
    
    func driveManager(_ driveManager: AMapNaviDriveManager, showLaneBackInfo laneBackInfo: String, laneSelectInfo: String) {
        NSLog("showLaneInfo")
    }
    
    func driveManagerHideLaneInfo(_ driveManager: AMapNaviDriveManager) {
        NSLog("hideLaneInfo")
    }
    
    func driveManager(_ driveManager: AMapNaviDriveManager, updateTrafficStatus trafficStatus: [AMapNaviTrafficStatus]?) {
        NSLog("updateTrafficStatus")
        
        guard let status = trafficStatus else {
            return
        }
        
        //更新交通光柱信息
        trafficBarView.updateTrafficBar(withTrafficStatuses: status)
    }
    
    func driveManager(_ driveManager: AMapNaviDriveManager, update cameraInfos: [AMapNaviCameraInfo]?) {
        NSLog("updateCameraInfos")
    }
    
    func driveManager(_ driveManager: AMapNaviDriveManager, update serviceAreaInfos: [AMapNaviServiceAreaInfo]?) {
        NSLog("updateServiceAreaInfos")
    }
    
    //MARK: - AMapNaviDriveManager Delegate
    
    func driveManager(_ driveManager: AMapNaviDriveManager, error: Error) {
        let error = error as NSError
        NSLog("error:{%d - %@}", error.code, error.localizedDescription)
    }
    
    func driveManager(onCalculateRouteSuccess driveManager: AMapNaviDriveManager) {
        NSLog("CalculateRouteSuccess")
        
        driveManager.startEmulatorNavi()
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
        return false
    }
    
    func driveManager(_ driveManager: AMapNaviDriveManager, playNaviSound soundString: String, soundStringType: AMapNaviSoundType) {
        NSLog("playNaviSoundString:{%d:%@}", soundStringType.rawValue, soundString);
    }
    
    func driveManagerDidEndEmulatorNavi(_ driveManager: AMapNaviDriveManager) {
        NSLog("didEndEmulatorNavi");
    }
    
    func driveManager(onArrivedDestination driveManager: AMapNaviDriveManager) {
        NSLog("onArrivedDestination");
    }
    
}
