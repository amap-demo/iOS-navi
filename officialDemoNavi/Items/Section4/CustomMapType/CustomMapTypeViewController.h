//
//  CustomMapTypeViewController.h
//  AMapNaviKit
//
//  Created by liubo on 2017/6/12.
//  Copyright © 2017年 Amap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapNaviKit/AMapNaviKit.h>

@interface CustomMapTypeViewController : UIViewController

@property (nonatomic, strong) AMapNaviDriveManager *driveManager;

@property (nonatomic, strong) AMapNaviDriveView *driveView;

@end
