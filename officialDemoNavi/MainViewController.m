//
//  MainViewController.m
//  DevDemoNavi
//
//  Created by 刘博 on 15/12/21.
//  Copyright © 2015年 AutoNavi. All rights reserved.
//

#import "MainViewController.h"

#define MainViewControllerTitle @"高德地图API-导航"

@interface MainViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) NSArray *classNames;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MainViewController

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_sections[section][1] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _sections[section][0];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *mainCellIdentifier = @"com.autonavi.mainCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mainCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:mainCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    cell.textLabel.text = _sections[indexPath.section][1][indexPath.row];
    
    cell.detailTextLabel.text = self.classNames[indexPath.section][indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *className = self.classNames[indexPath.section][indexPath.row];
    
    UIViewController *subViewController = [[NSClassFromString(className) alloc] init];

    subViewController.title = _sections[indexPath.section][1][indexPath.row];
    
    [self.navigationController pushViewController:subViewController animated:YES];
}

#pragma mark - Initialization

- (void)initTitles
{
    NSString *sec0Title = @"导航组件";
    NSArray *sec0CellTitles = @[@"使用导航组件"];
    NSArray *section0 = @[sec0Title, sec0CellTitles];
    
    NSString *sec1Title = @"出行路线规划";
    NSArray *sec1CellTitles = @[@"驾车路线规划",
                                @"步行路线规划",
                                @"骑行路线规划"];
    NSArray *section1 = @[sec1Title, sec1CellTitles];
    
    NSString *sec2Title = @"在地图上导航";
    NSArray *sec2CellTitles = @[@"实时导航",
                                @"模拟导航",
                                @"智能巡航",
                                @"传入外部GPS数据导航"];
    NSArray *section2 = @[sec2Title, sec2CellTitles];
    
    NSString *sec3Title = @"导航UI定制化";
    NSArray *sec3CellTitles = @[@"自定义自车、罗盘",
                                @"自定义交通路线Polyline",
                                @"自定义路线Polyline",
                                @"自定义转向信息",
                                @"自定义路口放大图、车道信息",
                                @"自定义导航光柱",
                                @"自定义全览、缩放、路况按钮",
                                @"自定义正北模式",
                                @"自定义地图样式"];
    NSArray *section3 = @[sec3Title, sec3CellTitles];
    
    NSString *sec4Title = @"HUD导航模式";
    NSArray *sec4CellTitles = @[@"HUD导航"];
    NSArray *section4 = @[sec4Title, sec4CellTitles];
    
    NSString *sec5Title = @"综合展示";
    NSArray *sec5CellTitles = @[@"多路径规划导航",
                                @"一键导航"];
    NSArray *section5 = @[sec5Title, sec5CellTitles];
    
    self.sections = [NSArray arrayWithObjects:section0, section1, section2, section3, section4, section5, nil];
}

- (void)initClassNames
{
    NSArray *sec0ClassNames = @[@"CompositeViewController"];
    
    NSArray *sec1ClassNames = @[@"DriveRoutePlanViewController",
                                @"WalkRoutePlanViewController",
                                @"RideRoutePlanViewController"];
    
    NSArray *sec2ClassNames = @[@"GPSNaviViewController",
                                @"EmulatorNaviViewController",
                                @"DetectedModeViewController",
                                @"GPSEmulatorViewController"];
    
    NSArray *sec3ClassNames = @[@"CustomCarCompassViewController",
                                @"CustomRouteTrafficPolylineViewController",
                                @"CustomRoutePolylineViewController",
                                @"CustomTurnInfoViewController",
                                @"CustomCrossLaneInfoViewController",
                                @"CustomTrafficBarViewController",
                                @"CustomFunctionalButtonViewController",
                                @"CustomTrackingModeViewController",
                                @"CustomMapTypeViewController"];
    
    NSArray *sec4ClassNames = @[@"HUDNaviViewController"];
    
    NSArray *sec5ClassNames = @[@"MultiRoutePlanViewController",
                                @"QuickStartViewController"];
    
    self.classNames = [NSArray arrayWithObjects:sec0ClassNames, sec1ClassNames, sec2ClassNames, sec3ClassNames, sec4ClassNames, sec5ClassNames, nil];
}

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

#pragma mark - Life Cycle

- (id)init
{
    if (self = [super init])
    {
        self.title = MainViewControllerTitle;
        
        [self initTitles];
        
        [self initClassNames];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden       = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.toolbarHidden             = YES;
}

@end
