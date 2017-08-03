//
//  HZHomeViewController.m
//  HZGHJ
//
//  Created by zhang on 16/12/6.
//  Copyright © 2016年 FiveFu. All rights reserved.
//

#import "HZHomeViewController.h"
#import "HZURL.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "CollectionViewCell.h"
#import "HZLoginService.h"
#import "HZNoticeViewController.h"
#import "HZLoginViewController.h"
#import <UserNotifications/UserNotifications.h>
#define KEY_NOTIFICATION @"this is a key for notification"

@interface HZHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate,UNUserNotificationCenterDelegate>{
    UICollectionView *collectionview;
    NSMutableArray *dataSourceArray;
    NSString *_tongzhidesc;
    NSString *_tongzhiRecordid;
    int _tongzhiCount;
    NSDictionary *sendDic;
}
@property (nonatomic, weak) NSTimer *timer;

@end 

@implementation HZHomeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    if ([def objectForKey:@"username"]) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:180.0f
                                                  target:self
                                                selector:@selector(timerFire:)
                                                userInfo:nil
                                                 repeats:YES];
        [_timer fire];
        if (_tongzhidesc!=NULL) {
            self.noticeLabel.text=_tongzhidesc;
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
            tap.delegate=self;
            [self.noticeLabel addGestureRecognizer:tap];
        }else{
            self.noticeLabel.text=@"暂无最新通知";
            
        }
    }else{
        self.noticeLabel.text=@"暂无最新通知";
    }

  }
-(void)tap{
        [[UNUserNotificationCenter currentNotificationCenter]removeAllPendingNotificationRequests];
    HZNoticeViewController *notice=[[HZNoticeViewController alloc]init];
    notice.sendDic=sendDic;
    [self.navigationController pushViewController:notice animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回"style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [self.navigationController                                                                                                                                                                                                                                                                                                                                                                                         .navigationBar setBackgroundImage:[UIImage imageNamed:@"title_bgg.png"] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
  
    //UNNotificationSettings,新的替代类,但是目前里面的属性都是readOnly
    UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound categories:nil];
    [[UIApplication sharedApplication]registerUserNotificationSettings:setting];
    self.delegate=self;
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    collectionview=[[UICollectionView alloc]initWithFrame:CGRectMake(0,self.noticeView.frame.origin.y+self.noticeView.frame.size.height+30, Width, Height-(self.noticeView.frame.origin.y+self.noticeView.frame.size.height+30)) collectionViewLayout:layout];
    [collectionview registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    collectionview.backgroundColor=[UIColor whiteColor];
    collectionview.dataSource=self;
    collectionview.delegate=self;
    collectionview.showsVerticalScrollIndicator=NO;
    collectionview.showsHorizontalScrollIndicator=NO;
    [self.view addSubview:collectionview];
    
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    NSString *username;
    if ([def objectForKey:@"username"]) {
        username=[def objectForKey:@"username"];
        [self getDataSource];
        
    }else{
        username=@"";
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"BottomMenuItems2" ofType:@"plist"];
        NSArray* dataArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
        dataSourceArray=[NSMutableArray arrayWithArray:dataArray];
        
            NSLog(@"datasourcearray   %@",dataSourceArray);
        
        [collectionview reloadData];
    }
    self.userName.text=[NSString stringWithFormat:@"欢迎您，%@",username];
}
-(void)getNoti{
    //3
    [[UNUserNotificationCenter currentNotificationCenter]removeAllPendingNotificationRequests];
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    
    //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:@"移动规划" arguments:nil];
    content.body = [NSString localizedUserNotificationStringForKey:@"查询到最新消息！"
                                                         arguments:nil];
    content.sound = [UNNotificationSound defaultSound];
    
    // 在 alertTime 后推送本地推送
    UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                                                  triggerWithTimeInterval:1 repeats:NO];
    
    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:@"FiveSecond"
                                                                          content:content trigger:trigger];
    //添加推送成功后的处理！
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    }];
}
#pragma mark - UNUserNotificationCenterDelegate
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    //1. 处理通知
    HZNoticeViewController *notice=[[HZNoticeViewController alloc]init];
    notice.sendDic=sendDic;
    [self.navigationController pushViewController:notice animated:YES];
 
    //2. 处理完成后条用 completionHandler ，用于指示在前台显示通知的形式
    completionHandler(UNNotificationPresentationOptionAlert);
}

-(void)timerFire:(id)userinfo {
     NSString *token=[[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    [HZLoginService NavigationWithToken:token andBlock:^(NSDictionary *returnDic, NSError *error) {
         if ([[returnDic objectForKey:@"code"]integerValue]==0) {
             _tongzhidesc=[returnDic objectForKey:@"desc"];
             _tongzhiCount=[[returnDic objectForKey:@"count"]intValue];
             sendDic=[returnDic objectForKey:@"obj"];
               self.noticeLabel.text=@"查询到有最新通知";
             self.noticeLabel.userInteractionEnabled=YES;
             UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
             tap.delegate=self;
             [self.noticeLabel addGestureRecognizer:tap];
             if (self.delegate && [self.delegate respondsToSelector:@selector(getNoti)]) {
                 [self.delegate getNoti];
             }
             [collectionview reloadData];
         }else  if ([[returnDic objectForKey:@"code"]integerValue]==900||[[returnDic objectForKey:@"code"]integerValue]==1000){
                [_timer invalidate];
                _timer=nil;
                self.noticeLabel.text=@"暂无最新通知";
             self.noticeLabel.userInteractionEnabled=NO;
             _tongzhidesc=NULL;
             _tongzhiCount=0;
             sendDic=NULL;
              [collectionview reloadData];
//             UIAlertController *alert=[UIAlertController alertControllerWithTitle:[returnDic objectForKey:@"desc"] message:nil preferredStyle:UIAlertControllerStyleAlert];
//             UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//             }];
//             [alert addAction:cancelAlert];
//             [self presentViewController:alert animated:YES completion:nil];
         }else{
                [_timer invalidate];
         }
    }];
}
-(void)dealloc{
    [_timer invalidate];
    _timer=nil;
}
-(void)getDataSource{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HZLoginService CheckWithUserName:@"" andBlock:^(NSDictionary *returnDic, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *obj=[returnDic objectForKey:@"obj"];
        if ([[obj objectForKey:@"useable"]intValue]==1&&[[obj objectForKey:@"registerstatus"]intValue]==2) {
            NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"BottomMenuItems" ofType:@"plist"];
            NSArray* dataArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
            dataSourceArray=[NSMutableArray arrayWithArray:dataArray];
            
                NSLog(@"datasourcearray   %@",dataSourceArray);
            [collectionview reloadData];
        }else  if ([[obj objectForKey:@"useable"]intValue]==2) {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"remember"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"您的账号已被禁用，请重新登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                HZLoginViewController *login=[[HZLoginViewController alloc]init];
                [self.navigationController pushViewController:login animated:YES];
            }];
            [alert addAction:cancelAlert];
            [self presentViewController:alert animated:YES completion:nil];
        }else  if ([[obj objectForKey:@"useable"]intValue]==1&&[[obj objectForKey:@"registerstatus"]intValue]==1) {
            NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"BottomMenuItems1" ofType:@"plist"];
            NSArray* dataArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
            dataSourceArray=[NSMutableArray arrayWithArray:dataArray];
            //    NSLog(@"datasourcearray   %@",dataSourceArray);
            [collectionview reloadData];
        }
    }];
    

}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataSourceArray.count;
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionview registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    CollectionViewCell*cell=(CollectionViewCell *)[collectionview dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *dic=[dataSourceArray objectAtIndex:indexPath.row];
        cell.titleLabel.text=[dic objectForKey:@"title"];
    cell.image.image=[UIImage imageNamed:[dic objectForKey:@"image"]];
    if ( _tongzhiCount>0) {
        if ([cell.titleLabel.text isEqualToString:@"消息通知"]) {
            cell.numLabel.hidden=NO;
            cell.numLabel.text=[NSString stringWithFormat:@"%d",_tongzhiCount];
        }else{
            cell.numLabel.hidden=YES;
        }
    }else{
         cell.numLabel.hidden=YES;
    }
//    NSLog(@"cell  %@   %@",[dic objectForKey:@"image"],[dic objectForKey:@"title"]);
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath

{
    return CGSizeMake(Width/3.5, Height/8+60);
    
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0, Width/6-Width/7, 0,Width/6-Width/7);
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic=[dataSourceArray objectAtIndex:indexPath.row];
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    if ([def objectForKey:@"username"]) {
     if ([[dic objectForKey:@"controller"]isEqualToString:@""]) {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确定退出吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            exit(0);
        }];
        [alert addAction:okAlert];
        UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:cancelAlert];
        [self presentViewController:alert animated:YES completion:nil];
    }else if ([[dic objectForKey:@"title"]isEqualToString:@"消息通知"]){
        if (sendDic!=NULL&&sendDic!=nil) {
                [[UNUserNotificationCenter currentNotificationCenter]removeAllPendingNotificationRequests];
            HZNoticeViewController *notice=[[HZNoticeViewController alloc]init];
            notice.sendDic=sendDic;
            [self.navigationController pushViewController:notice animated:YES];
        }else{
            HZNoticeViewController *notice=[[HZNoticeViewController alloc]init];
            [self.navigationController pushViewController:notice animated:YES];
        }
    }
    else{
    Class clazz = NSClassFromString([dic objectForKey:@"controller"]);
    if (!clazz) clazz = NSClassFromString([dic objectForKey:@"controller"]);
    UIViewController *controller = nil;
    controller = [[clazz alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    }
        
    }else{
        if ([[dic objectForKey:@"title"]isEqualToString:@"在线办理"]){
        HZLoginViewController *login=[[HZLoginViewController alloc]init];
        [self.navigationController pushViewController:login animated:YES];
    }else if ([[dic objectForKey:@"controller"]isEqualToString:@""]) {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确定退出吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            exit(0);
        }];
        [alert addAction:okAlert];
        UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:cancelAlert];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        Class clazz = NSClassFromString([dic objectForKey:@"controller"]);
        if (!clazz) clazz = NSClassFromString([dic objectForKey:@"controller"]);
        UIViewController *controller = nil;
        controller = [[clazz alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
    }
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    //判断应用程序状态来决定是否弹框
    if (application.applicationState == UIApplicationStateActive) {
    }else if (application.applicationState == UIApplicationStateInactive)
    {
        //        NSLog(@"UIApplicationStateInactive");
    }else{
        NSLog(@"UIApplicationStateBackground");
    }
    
    
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
