//
//  MainViewController.swift
//  officialDemoNavi
//
//  Created by liubo on 10/8/16.
//  Copyright © 2016 AutoNavi. All rights reserved.
//

import Foundation

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    var sections: Array<String>!
    var titles: Array<Array<String>>!
    var classNames: Array<Array<UIViewController.Type>>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "高德地图API-导航-Swift"
        
        initTableData()
        initTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.isToolbarHidden = true
    }
    
    func initTableData() {
        
        let sec0Title = "导航组件"
        let sec0CellTitles = ["使用导航组件"]
        let sec0ClassNames: Array<UIViewController.Type> = [CompositeViewController.self]
        
        let sec1Title = "出行路线规划"
        let sec1CellTitles = ["驾车路线规划",
                              "步行路线规划",
                              "骑行路线规划"]
        let sec1ClassNames: Array<UIViewController.Type> = [DriveRoutePlanViewController.self,
                                                            WalkRoutePlanViewController.self,
                                                            RideRoutePlanViewController.self]
        
        let sec2Title = "在地图上导航"
        let sec2CellTitles = ["实时导航",
                              "模拟导航",
                              "智能巡航",
                              "传入外部GPS数据导航"]
        let sec2ClassNames: Array<UIViewController.Type> = [GPSNaviViewController.self,
                                                            EmulatorNaviViewController.self,
                                                            DetectedModeViewController.self,
                                                            GPSEmulatorViewController.self]
        
        let sec3Title = "导航UI定制化"
        let sec3CellTitles = ["自定义自车、罗盘",
                              "自定义交通路线Polyline",
                              "自定义路线Polyline",
                              "自定义转向信息",
                              "自定义路口放大图、车道信息",
                              "自定义导航光柱",
                              "自定义全览、缩放、路况按钮",
                              "自定义正北模式",
                              "自定义地图样式"]
        let sec3ClassNames: Array<UIViewController.Type> = [CustomCarCompassViewController.self,
                                                            CustomRouteTrafficPolylineViewController.self,
                                                            CustomRoutePolylineViewController.self,
                                                            CustomTurnInfoViewController.self,
                                                            CustomCrossLaneInfoViewController.self,
                                                            CustomTrafficBarViewController.self,
                                                            CustomFunctionalButtonViewController.self,
                                                            CustomTrackingModeViewController.self,
                                                            CustomMapTypeViewController.self]
        
        let sec4Title = "HUD导航模式"
        let sec4CellTitles = ["HUD导航"]
        let sec4ClassNames: Array<UIViewController.Type> = [HUDNaviViewController.self]
        
        let sec5Title = "综合展示"
        let sec5CellTitles = ["多路径规划导航",
                              "一键导航"]
        let sec5ClassNames: Array<UIViewController.Type> = [MultiRoutePlanViewController.self,
                                                           QuickStartViewController.self]
        
        sections = [sec0Title, sec1Title, sec2Title, sec3Title, sec4Title, sec5Title]
        titles = [sec0CellTitles, sec1CellTitles, sec2CellTitles, sec3CellTitles, sec4CellTitles, sec5CellTitles]
        classNames = [sec0ClassNames, sec1ClassNames, sec2ClassNames, sec3ClassNames, sec4ClassNames, sec5ClassNames]
    }
    
    func initTableView() {
        
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
    }
    
    //MARK:- TableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        let title = titles[indexPath.section][indexPath.row]
        let vcClass = classNames[indexPath.section][indexPath.row]
        let vcInstance = vcClass.init()
        vcInstance.title = title
        
        self.navigationController?.pushViewController(vcInstance, animated: true)
    }
    
    //MARK:- TableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "mainCellIdentifier"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellIdentifier)
            cell!.accessoryType = .disclosureIndicator
            cell!.detailTextLabel?.lineBreakMode = .byCharWrapping
            cell!.detailTextLabel?.numberOfLines = 0
            cell!.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
            cell!.detailTextLabel?.textColor = UIColor.lightGray
            cell!.textLabel?.font = UIFont.systemFont(ofSize: 13)
            cell!.textLabel?.textColor = UIColor.black
        }
        
        cell!.textLabel?.text = titles[indexPath.section][indexPath.row]
        cell!.detailTextLabel?.text = String(describing: classNames[indexPath.section][indexPath.row])
        
        return cell!
    }
    
}
