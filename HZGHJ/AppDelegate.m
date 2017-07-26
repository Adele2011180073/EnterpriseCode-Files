//
//  AppDelegate.m
//  HZGHJ
//
//  Created by zhang on 16/12/6.
//  Copyright © 2016年 FiveFu. All rights reserved.
//

#import "AppDelegate.h"
#import "HZHomeViewController.h"
#import "HZLoginViewController.h"
#import <UserNotifications/UserNotifications.h>

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

BMKMapManager* _mapManager;

@interface AppDelegate ()<UNUserNotificationCenterDelegate,UIApplicationDelegate>{
}

@end
static NSString *BaiDuAK=@"P5OwjL02LUfDGEIslEMDGREsGkK9MtZI";

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
       // 使用 UNUserNotificationCenter 来管理通知
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    //监听回调事件
    
    center.delegate = self;
    
    //iOS 10 使用以下方法注册，才能得到授权
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              // Enable or disable features based on authorization.
                          }];
    
    //获取当前的通知设置，UNNotificationSettings 是只读对象，不能直接修改，只能通过以下方法获取
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        
    }];
    HZHomeViewController *home=[[HZHomeViewController alloc]init];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:home];
    [nav.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
       [nav.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:18],
       
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    nav.navigationItem.leftItemsSupplementBackButton = YES;
    self.window.rootViewController=nav;
    
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:BaiDuAK generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }

      return YES;
}
#pragma mark - UNUserNotificationCenterDelegate
//在展示通知前进行处理，即有机会在展示通知前再修改通知内容。
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    //1. 处理通知
    
    //2. 处理完成后条用 completionHandler ，用于指示在前台显示通知的形式
    completionHandler(UNNotificationPresentationOptionAlert);
}
- (void)processLocationNotification:(UILocalNotification *)localNotification{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"移动规划服务平台" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}


@end
