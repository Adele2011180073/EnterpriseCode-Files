//
//  HZMapServiceViewController.m
//  HZGHJ
//
//  Created by zhang on 2017/5/17.
//  Copyright © 2017年 FiveFu. All rights reserved.
//

#import "HZMapServiceViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件

#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

@interface HZMapServiceViewController ()<BMKLocationServiceDelegate,BMKMapViewDelegate>{
    BMKMapView* _mapView;
    BMKLocationService *_service;//定位服务
}

@end

@implementation HZMapServiceViewController
-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden=NO;
    self.view.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回"style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.title=@"地图选址";

     _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-44)];
    _mapView.delegate =self;
    //设置地图的显示样式
    _mapView.mapType = BMKMapTypeSatellite;//卫星地图
    _service = [[BMKLocationService alloc] init];
    
    //设置代理
    _service.delegate = self;
    
    //开启定位
    [_service startUserLocationService];
    //设定地图是否打开路况图层
    _mapView.trafficEnabled = YES;
    
    //底图poi标注
    _mapView.showMapPoi = NO;
    
    //在手机上当前可使用的级别为3-21级
   _mapView.zoomLevel = 21;
    
    //设定地图View能否支持旋转
    _mapView.rotateEnabled = NO;
    
    //设定地图View能否支持用户移动地图
    _mapView.scrollEnabled = NO;
    self.view = _mapView;
}
#pragma mark -------BMKLocationServiceDelegate

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    
    
    //展示定位
    _mapView.showsUserLocation = YES;
    
    //更新位置数据
    [_mapView updateLocationData:userLocation];
    
    //获取用户的坐标
    _mapView.centerCoordinate = userLocation.location.coordinate;
    
    _mapView.zoomLevel =18;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
