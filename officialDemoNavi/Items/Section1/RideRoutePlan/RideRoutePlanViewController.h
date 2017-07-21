//
//  RideRoutePlanViewController.h
//  AMapNaviKit
//
//  Created by liubo on 9/19/16.
//  Copyright © 2016 AutoNavi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapNaviKit/AMapNaviKit.h>

@interface RideRoutePlanViewController : UIViewController

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) AMapNaviRideManager *rideManager;

@end
