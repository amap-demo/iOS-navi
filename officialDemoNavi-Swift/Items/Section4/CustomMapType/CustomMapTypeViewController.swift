//
//  CustomMapTypeViewController.swift
//  officialDemoNavi
//
//  Created by liubo on 2017/6/13.
//  Copyright © 2017年 AutoNavi. All rights reserved.
//

import Foundation

class CustomMapTypeViewController: UIViewController, AMapNaviDriveManagerDelegate, AMapNaviDriveViewDelegate {
    
    var driveView: AMapNaviDriveView!
    var driveManager: AMapNaviDriveManager!
    
    let startPoint = AMapNaviPoint.location(withLatitude: 39.993135, longitude: 116.474175)!
    let endPoint = AMapNaviPoint.location(withLatitude: 39.910267, longitude: 116.370888)!
    let wayPints = [AMapNaviPoint.location(withLatitude: 39.973135, longitude: 116.444175)!,
                    AMapNaviPoint.location(withLatitude: 39.987125, longitude: 116.353145)!]
    
    var mapStyle: UISegmentedControl!
    var trafficLayerButton: UIButton!
    var zoomInButton: UIButton!
    var zoomOutButton: UIButton!
    
    deinit {
        driveManager.stopNavi()
        driveManager.removeDataRepresentative(driveView)
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
        mapStyle = UISegmentedControl(items: ["白天模式","黑夜模式","自定义样式"])
        mapStyle.frame = CGRect(x: 10, y: 410, width: 250, height: 30)
        mapStyle.addTarget(self, action: #selector(self.mapStyleAction(sender:)), for: .valueChanged)
        mapStyle.selectedSegmentIndex = 0
        view.addSubview(mapStyle)
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
    
    //MARK: - Button Action
    
    func mapStyleAction(sender: UISegmentedControl) {
        //改变界面的地图样式
        if sender.selectedSegmentIndex == 0 {
            //白天模式
            driveView.showStandardNightType = false
        }
        else if sender.selectedSegmentIndex == 1 {
            //黑夜模式
            driveView.showStandardNightType = true
        }
        else if sender.selectedSegmentIndex == 2 {
            //自定义样式
            
            guard let dataPath = Bundle.main.path(forResource: "mystyle_sdk_1497259956_0100", ofType: "data") else {
                NSLog("Map Style Data File Not Exist!");
                return
            }
            
            guard let mapStyleData = NSData(contentsOfFile: dataPath) as Data? else {
                NSLog("Map Style Data File Format Error!");
                return
            }
            
            driveView.setCustomMapStyleWithWebData(mapStyleData)
            driveView.customMapStyleEnabled = true
        }
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
