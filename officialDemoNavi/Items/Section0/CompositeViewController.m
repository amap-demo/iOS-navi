//
//  CompositeViewController.m
//  AMapNaviKit
//
//  Created by eidan on 2017/5/10.
//  Copyright © 2017年 Amap. All rights reserved.
//

#import "CompositeViewController.h"
#import <AMapNaviKit/AMapNaviKit.h>
#import "SpeechSynthesizer.h"

@interface CompositeViewController () <AMapNaviCompositeManagerDelegate>

@property (nonatomic, strong) AMapNaviCompositeManager *compositeManager;

@end

@implementation CompositeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *routeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    routeBtn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 100) / 2, 100, 100, 45);
    [routeBtn setTitle:@"开始" forState:UIControlStateNormal];
    [routeBtn setTitleColor:[UIColor colorWithRed:53/255.0 green:117/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
    routeBtn.layer.borderWidth = 1;
    routeBtn.layer.borderColor = [UIColor colorWithRed:53/255.0 green:117/255.0 blue:255/255.0 alpha:1].CGColor;
    routeBtn.layer.cornerRadius = 5;
    
    [routeBtn addTarget:self action:@selector(routePlanAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:routeBtn];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)routePlanAction {
    self.compositeManager = [[AMapNaviCompositeManager alloc] init];  // 初始化
    self.compositeManager.delegate = self;  // 如果需要使用AMapNaviCompositeManagerDelegate的相关回调（如自定义语音、获取实时位置等），需要设置delegate
    [self.compositeManager presentRoutePlanViewControllerWithOptions:nil];  // 通过present的方式显示路线规划页面, options为预留参数，目前并无实际作用，需传入nil
}

#pragma mark - AMapNaviCompositeManagerDelegate

// 发生错误时,会调用代理的此方法
- (void)compositeManager:(AMapNaviCompositeManager *)compositeManager error:(NSError *)error {
    NSLog(@"error:{%ld - %@}", (long)error.code, error.localizedDescription);
}

// 算路成功后的回调函数,路径规划页面的算路、导航页面的重算等成功后均会调用此方法
- (void)compositeManagerOnCalculateRouteSuccess:(AMapNaviCompositeManager *)compositeManager {
    NSLog(@"onCalculateRouteSuccess,%ld",(long)compositeManager.naviRouteID);
}

// 算路失败后的回调函数,路径规划页面的算路、导航页面的重算等失败后均会调用此方法
- (void)compositeManager:(AMapNaviCompositeManager *)compositeManager onCalculateRouteFailure:(NSError *)error {
    NSLog(@"onCalculateRouteFailure error:{%ld - %@}", (long)error.code, error.localizedDescription);
}

// 开始导航的回调函数
- (void)compositeManager:(AMapNaviCompositeManager *)compositeManager didStartNavi:(AMapNaviMode)naviMode {
    NSLog(@"didStartNavi,%ld",(long)naviMode);
}

// 当前位置更新回调
- (void)compositeManager:(AMapNaviCompositeManager *)compositeManager updateNaviLocation:(AMapNaviLocation *)naviLocation {
    NSLog(@"updateNaviLocation,%@",naviLocation);
}

// 导航到达目的地后的回调函数
- (void)compositeManager:(AMapNaviCompositeManager *)compositeManager didArrivedDestination:(AMapNaviMode)naviMode {
    NSLog(@"didArrivedDestination,%ld",(long)naviMode);
}

//// 以下注释掉的3个回调方法，如果需要自定义语音，可开启
//
//// SDK需要实时的获取是否正在进行导航信息播报，需要开发者根据实际播报情况返回布尔值
//- (BOOL)compositeManagerIsNaviSoundPlaying:(AMapNaviCompositeManager *)compositeManager {
//    return [[SpeechSynthesizer sharedSpeechSynthesizer] isSpeaking];
//}
//
//// 导航播报信息回调函数
//- (void)compositeManager:(AMapNaviCompositeManager *)compositeManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType {
//    NSLog(@"playNaviSoundString:{%ld:%@}", (long)soundStringType, soundString);
//    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:soundString];
//}
//
//// 停止导航语音播报的回调函数，当导航SDK需要停止外部语音播报时，会调用此方法
//- (void)compositeManagerStopPlayNaviSound:(AMapNaviCompositeManager *)compositeManager {
//    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
//}




@end
