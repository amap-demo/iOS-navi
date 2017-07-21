//
//  CompositeViewController.swift
//  officialDemoNavi
//
//  Created by eidan on 2017/6/13.
//  Copyright © 2017年 AutoNavi. All rights reserved.
//

import UIKit

class CompositeViewController: UIViewController, AMapNaviCompositeManagerDelegate {
    
    var compositeManager : AMapNaviCompositeManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white;
        
        let routeBtn = UIButton.init(type: UIButtonType.system)
        routeBtn.frame = CGRect.init(x: (UIScreen.main.bounds.size.width - 100) / 2.0, y: 100.0, width: 100.0, height: 45.0)
        routeBtn.setTitle("开始", for: UIControlState.normal)
        routeBtn.setTitleColor(UIColor.init(red: 53/255.0, green: 117/255.0, blue: 255/255.0, alpha: 1), for: UIControlState.normal)
        routeBtn.layer.cornerRadius = 5
        routeBtn.layer.borderColor = UIColor.init(red: 53/255.0, green: 117/255.0, blue: 255/255.0, alpha: 1).cgColor
        routeBtn.layer.borderWidth = 1
        
        routeBtn.addTarget(self, action: #selector(self.routePlanAction),for: UIControlEvents.touchUpInside)
        
        self.view.addSubview(routeBtn)

        // Do any additional setup after loading the view.
    }
    
    func routePlanAction() {
        if self.compositeManager == nil {
            self.compositeManager = AMapNaviCompositeManager.init()
            self.compositeManager.delegate = self
        }
        self.compositeManager.presentRoutePlanViewController(withOptions: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - AMapNaviCompositeManagerDelegate
    
    func compositeManager(_ compositeManager: AMapNaviCompositeManager, error: Error) {
        let error = error as NSError
        NSLog("error:{%d - %@}", error.code, error.localizedDescription)
    }
    
    func compositeManager(onCalculateRouteSuccess compositeManager: AMapNaviCompositeManager) {
        NSLog("onCalculateRouteSuccess,%ld", compositeManager.naviRouteID)
    }
    
    func compositeManager(_ compositeManager: AMapNaviCompositeManager, onCalculateRouteFailure error: Error) {
        let error = error as NSError
        NSLog("onCalculateRouteFailure error:{%d - %@}", error.code, error.localizedDescription)
    }
    
    func compositeManager(_ compositeManager: AMapNaviCompositeManager, didStartNavi naviMode: AMapNaviMode) {
        NSLog("didStartNavi")
    }
    
    func compositeManager(_ compositeManager: AMapNaviCompositeManager, didArrivedDestination naviMode: AMapNaviMode) {
        NSLog("didArrivedDestination")
    }
    
    func compositeManager(_ compositeManager: AMapNaviCompositeManager, update naviLocation: AMapNaviLocation?) {
//        NSLog("updateNaviLocation,%@",naviLocation)
    }
    
//    //以下注释掉的3个回调方法，如果需要自定义语音，可开启
//    func compositeManagerIsNaviSoundPlaying(_ compositeManager: AMapNaviCompositeManager) -> Bool {
//        return SpeechSynthesizer.Shared.isSpeaking()
//    }
//    
//    func compositeManager(_ compositeManager: AMapNaviCompositeManager, playNaviSound soundString: String?, soundStringType: AMapNaviSoundType) {
//        if (soundString != nil) {
//            SpeechSynthesizer.Shared.speak(soundString!)
//        }
//    }
//    
//    func compositeManagerStopPlayNaviSound(_ compositeManager: AMapNaviCompositeManager) {
//        SpeechSynthesizer.Shared.stopSpeak()
//    }
    
}
