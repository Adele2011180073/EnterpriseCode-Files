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
#import "HZLocateContentViewController.h"
#import "UIView+Toast.h"

@interface HZMapServiceViewController ()<BMKLocationServiceDelegate,BMKMapViewDelegate>{
    BMKMapView* _mapView;
    BMKLocationService *_service;//定位服务
    CLLocationCoordinate2D  _userLocation;
    
    NSMutableArray *_posArray;
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

    _posArray=[[NSMutableArray alloc]init];
     _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-44)];
    _mapView.delegate =self;
    //设置地图的显示样式
//    _mapView.userTrackingMode=BMKUserTrackingModeNone;
//    _mapView.mapType = BMKMapTypeStandard;//卫星地图
    _service = [[BMKLocationService alloc] init];
    
    //设置代理
    _service.delegate = self;
    //开启定位
    [_service startUserLocationService];
    //底图poi标注
//    _mapView.showMapPoi = YES;
    //在手机上当前可使用的级别为3-21级
   _mapView.zoomLevel = 18;
    _mapView.showsUserLocation = YES;//显示定位图层
    //设定地图View能否支持旋转
    _mapView.rotateEnabled = NO;
    //设定地图View能否支持用户移动地图
    _mapView.scrollEnabled = YES;
    [self.view addSubview:_mapView];
   
    UIButton *commit=[[UIButton alloc]initWithFrame:CGRectMake(20,Height-64-60, Width-40, 45)];
    [commit addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    commit.backgroundColor=[UIColor colorWithRed:23/255.0 green:177/255.0 blue:242/255.0 alpha:1];
    commit.clipsToBounds=YES;
    commit.layer.cornerRadius=10;
    [commit setTitle:@"确认选址" forState:UIControlStateNormal];
    [self.view addSubview:commit];
}
//MARK:确认选址
-(void)commit{
    if (_posArray.count>0) {
        HZLocateContentViewController *content=[[HZLocateContentViewController alloc]init];
        content.posArray=_posArray;
        [self.navigationController pushViewController:content animated:YES];
    }else{
        [self.view makeToast:@"请选取点位地址" duration:2 position:CSToastPositionCenter];
    }
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
    
}

-(void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi *)mapPoi{
    NSLog(@"mapPoi.text   %@",mapPoi.text);
    if (_posArray.count>8) {
        
    }else{
    //创建气球上面的位置显示框
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = mapPoi.pt;
    annotation.title = mapPoi.text;
//    annotation.subtitle = @"this is a test!this is a test!";
    [_mapView addAnnotation:annotation];
    //关键代码 如下：
    //这样就可以在初始化的时候将 气泡信息弹出
    [_mapView selectAnnotation:annotation animated:YES];
        [_posArray addObject:annotation];
    }
}
//当点击annotationview弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView  annotationViewForBubble:(BMKAnnotationView *)view
{
    NSLog(@"点击annotation view弹出的泡泡");
}
//这个代理方法能够修改定位大头针的样式以及自定义气泡弹出框的样式，可根据自己的需要进行自定义
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation{
    NSString *AnnotationViewID = @"renameMark";
    BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    annotationView.image=[UIImage imageNamed:@"goto.png"];
    // 设置颜色
//    annotationView.pinColor = BMKPinAnnotationColorGreen;
    // 从天上掉下效果
    annotationView.animatesDrop = YES;
    // 设置可拖拽
    annotationView.draggable = YES;
//    annotationView.leftCalloutAccessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pos.png"]];
    [annotationView setSelected:YES animated:YES];
    return annotationView;
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
