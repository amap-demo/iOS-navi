# iOS-navi
iOS 导航SDK官方Demo

## 前述 ##

- 工程是基于iOS 导航SDK实现的
- [开发指南](http://lbs.amap.com/api/ios-navi-sdk/summary/).
- [高德官方网站申请key](http://lbs.amap.com/api/ios-navi-sdk/guide/create-project/get-key).
- 查阅[参考手册](http://a.amap.com/lbs/static/unzip/iOS_Navi_Doc/index.html).

## 使用方法 ##

- 运行demo请先执行pod install --repo-update 安装依赖库，完成后打开.xcworkspace 文件
- 如有疑问请参阅[自动部署](http://lbs.amap.com/api/ios-navi-sdk/guide/create-project/cocoapods).


## 说明 ##

`导航组件`

| 功能说明 | 对应文件名 |
| -----|:-----:|
|使用导航组件|CompositeViewController|


`出行路线规划`

| 功能说明 | 对应文件名 |
| -----|:-----:|
|驾车路线规划|DriveRoutePlanViewController|
|步行路线规划|WalkRoutePlanViewController|
|骑行路线规划|RideRoutePlanViewController|


`在地图上导航`

| 功能说明 | 对应文件名 |
| -----|:-----:|
|实时导航|GPSNaviViewController|
|模拟导航|EmulatorNaviViewController|
|智能巡航|DetectedModeViewController|
|传入外部GPS数据导航|GPSEmulatorViewController|


`导航UI定制化`

| 功能说明 | 对应文件名 |
| -----|:-----:|
|自定义自车、罗盘|CustomCarCompassViewController|
|自定义交通路线Polyline|CustomRouteTrafficPolylineViewController|
|自定义路线Polyline|CustomRoutePolylineViewController|
|自定义转向信息|CustomTurnInfoViewController|
|自定义路口放大图、车道信息|CustomCrossLaneInfoViewController|
|自定义导航光柱|CustomTrafficBarViewController|
|自定义全览、缩放、路况按钮|CustomFunctionalButtonViewController|
|自定义正北模式|CustomTrackingModeViewController|
|自定义地图样式|CustomMapTypeViewController|


`HUD导航模式`

| 功能说明 | 对应文件名 |
| -----|:-----:|
|HUD导航|HUDNaviViewController|


`综合展示`

| 功能说明 | 对应文件名 |
| -----|:-----:|
|多路径规划导航|MultiRoutePlanViewController|
|一键导航|QuickStartViewController|

