//
//  HZYuYueViewController.m
//  HZGHJ
//
//  Created by zhang on 16/12/9.
//  Copyright © 2016年 FiveFu. All rights reserved.
//

#import "HZYuYueViewController.h"
#import "MBProgressHUD.h"
#import "SVPullToRefresh.h"
#import "HAYuYueDetailViewController.h"
#import "HZIYuYueViewController.h"
#import "HZLoginService.h"
#import "HAYuYueDetailViewController.h"
#import "HZYuYueDetailCell.h"
#import "UIView+Toast.h"

@interface HZYuYueViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int pageIndex;
    UITableView *tableview;
    UISegmentedControl *segmented;
    UIButton *pos;
}

@end

@implementation HZYuYueViewController
@synthesize dataList;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回"style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.view.backgroundColor=[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    self.title=@"在线预约";
    pos = [[UIButton alloc] initWithFrame                                                                      :CGRectMake(15, 5, 80, 20)];
    [pos setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [pos addTarget:self action:@selector(IYuYue) forControlEvents:UIControlEventTouchUpInside];
    [pos setTitle:@"我要预约" forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:pos];
    self.navigationItem.rightBarButtonItem = leftItem;

    pageIndex=1;
    dataList=[[NSMutableArray alloc]init];
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 55, Width, Height-44-55)];
    [tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    tableview.rowHeight=160;
    tableview.backgroundColor=[UIColor whiteColor];
    tableview.delegate=self;
    tableview.separatorColor=[UIColor clearColor];
    tableview.dataSource=self;
    tableview.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableview];
    [self getDataSource];
    NSArray *titleArray=@[@"在线预约",@"我的预约"];
    segmented=[[UISegmentedControl alloc]initWithItems:titleArray];
    segmented.frame=CGRectMake(5, 5, Width-10, 40);
    segmented.selectedSegmentIndex=0;
     [segmented setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} forState:UIControlStateNormal];
    [segmented addTarget:self action:@selector(choseSeg:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmented];
    __weak HZYuYueViewController *yuyue=self;
    [tableview addInfiniteScrollingWithActionHandler:^{
          pageIndex=pageIndex+1;
        [yuyue getDataSource];
    }];
    [tableview addPullToRefreshWithActionHandler:^{
        pageIndex=1;
        [yuyue getDataSource];
    }];
    [tableview.pullToRefreshView setTitle:@"下拉以刷新" forState:SVPullToRefreshStateTriggered];
    [tableview.pullToRefreshView setTitle:@"刷新完了哟" forState:SVPullToRefreshStateStopped];
    [tableview.pullToRefreshView setTitle:@"不要命的加载中..." forState:SVPullToRefreshStateLoading];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self getDataSource];
}
-(void)IYuYue{
    HZIYuYueViewController *iYuYue=[[HZIYuYueViewController alloc]init];
    [self.navigationController pushViewController:iYuYue animated:YES];
}
-(void)getDataSource{
     MBProgressHUD *hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text=@"数据加载中，请稍候...";
    [tableview.infiniteScrollingView stopAnimating];
    [tableview.pullToRefreshView stopAnimating];
    NSString *token=[[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    if (segmented.selectedSegmentIndex==0) {
    [HZLoginService YuYueWithToken:token pageIndex:pageIndex andBlock:^(NSDictionary *returnDic, NSError *error) {
        [hud hideAnimated:YES];
        if ([[returnDic objectForKey:@"code"]integerValue]==0) {
            NSArray *array=[returnDic objectForKey:@"reservationlist"];
            if (pageIndex==1) {
                dataList=[NSMutableArray                                                                                                                                                                                                                                                                                                                                           arrayWithArray:array];
            }else{
               [dataList addObjectsFromArray:array];
            }
            if (dataList.count<1||dataList==NULL) {
                [self.view makeToast:@"暂时没有数据" duration:2 position:CSToastPositionCenter];
            }
          
            NSData *data =    [NSJSONSerialization dataWithJSONObject:returnDic options:NSJSONWritingPrettyPrinted error:nil];
            NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            [tableview reloadData];
            NSLog(@"预约列表    %@  %@",str,returnDic);

        }else   if ([[returnDic objectForKey:@"code"]integerValue]==900) {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"您的账号已被其他设备登陆，请重新登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancelAlert];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
             [self.view makeToast:@"请求失败，请重新尝试" duration:2 position:CSToastPositionCenter];
        }

    }];
    }else{
        [HZLoginService WoDeYuYueWithToken:token pageIndex:pageIndex andBlock:^(NSDictionary *returnDic, NSError *error) {
             [hud hideAnimated:YES];
            if ([[returnDic objectForKey:@"code"]integerValue]==0) {
                NSArray *array=[returnDic objectForKey:@"list"];
                if (pageIndex==1) {
                    dataList=[NSMutableArray                                                                                                                                                                                                                                                                                                                                           arrayWithArray:array];
                }else{
                    [dataList addObjectsFromArray:array];
                }
                if (dataList.count<1||dataList==NULL) {
                   [self.view makeToast:@"暂时没有数据" duration:2 position:CSToastPositionBottom];
                }
                [tableview reloadData];

            }else   if ([[returnDic objectForKey:@"code"]integerValue]==900) {
                UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"您的账号已被其他设备登陆，请重新登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:cancelAlert];
                [self presentViewController:alert animated:YES completion:nil];
            }else{
                [self.view makeToast:@"请求不成功，请重新尝试" duration:2 position:CSToastPositionCenter];
            }

            NSLog(@"我的预约    %@",returnDic);
        }];
    }
    
}
-(void)choseSeg:(UISegmentedControl *)segmented{
    pageIndex=1;
      [self getDataSource];
 }
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell=[[UITableViewCell alloc]init];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    UIView* bgView=[[UIView alloc]initWithFrame:CGRectMake(10, 5, Width-20, 150)];
    bgView.backgroundColor=[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
    bgView.layer.borderWidth=1;
    bgView.layer.cornerRadius=5;
    bgView.layer.borderColor=[UIColor colorWithRed:23/255.0 green:177/255.0 blue:242/255.0 alpha:1].CGColor;
    [cell.contentView addSubview:bgView];
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, Width-40, 45)];
    titleLabel.textColor=[UIColor blackColor];
    titleLabel.numberOfLines=2;
    titleLabel.textAlignment=NSTextAlignmentLeft;
    titleLabel.font=[UIFont systemFontOfSize:17];
    [bgView addSubview:titleLabel];
    UILabel*subTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 45, Width-40, 20)];
    subTitle.textColor=[UIColor colorWithRed:237/255.0 green:129/255.0 blue:85/255.0 alpha:1];
    subTitle.textAlignment=NSTextAlignmentLeft;
    subTitle.font=[UIFont systemFontOfSize:15];
    [bgView addSubview:subTitle];
   UILabel*nameTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 65, Width-40, 17)];
   nameTitle.textColor=[UIColor darkGrayColor];
   nameTitle.textAlignment=NSTextAlignmentLeft;
   nameTitle.font=[UIFont systemFontOfSize:15];
    [bgView addSubview:nameTitle];
   UILabel* phoneLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 82, Width-40, 17)];
    phoneLabel.textColor=[UIColor darkGrayColor];
    phoneLabel.textAlignment=NSTextAlignmentLeft;
    phoneLabel.font=[UIFont systemFontOfSize:15];
    [bgView addSubview:phoneLabel];
   UILabel*timeTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 99, Width-40, 17)];
   timeTitle.textColor=[UIColor darkGrayColor];
   timeTitle.textAlignment=NSTextAlignmentLeft;
   timeTitle.font=[UIFont systemFontOfSize:15];
    [bgView addSubview:timeTitle];
   UILabel*statusLabel=[[UILabel alloc]initWithFrame:CGRectMake(110, 116, 80, 20)];
   statusLabel.textAlignment=NSTextAlignmentLeft;
   statusLabel.font=[UIFont systemFontOfSize:15];
   statusLabel.textColor=[UIColor colorWithRed:34/255.0 green:164/255.0 blue:255/255.0 alpha:1];
   [bgView addSubview:statusLabel];
   UILabel*subLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 116, 100, 20)];
   subLabel.text=@"预约状态";
    subLabel.textColor=[UIColor darkGrayColor];
   subLabel.textAlignment=NSTextAlignmentLeft;
   subLabel.font=[UIFont systemFontOfSize:15];
    [bgView addSubview:subLabel];
    
    NSDictionary *dic=[dataList objectAtIndex:indexPath.row];
    titleLabel.text=[NSString stringWithFormat:@"预约项目  %@",[dic objectForKey:@"projectName"]];
    subTitle.text=[NSString stringWithFormat:@"办理事项  %@",[dic objectForKey:@"nodeName"]];
    nameTitle.text=[NSString stringWithFormat:@"预约人  %@",[dic objectForKey:@"username"]];
    phoneLabel.text=[NSString stringWithFormat:@"电话  %@",[dic objectForKey:@"userphone"]];
    timeTitle.text=[NSString stringWithFormat:@"预约时间  %@",[dic objectForKey:@"timeofappointment"]];
    statusLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic=[dataList objectAtIndex:indexPath.row];
    HAYuYueDetailViewController *details=[[HAYuYueDetailViewController alloc]init];
    details.reservationId=[dic objectForKey:@"id"];
    details.detailData=dic;
    if (segmented.selectedSegmentIndex==1) {
        details.isMy=YES;
    }else{
        details.isMy=NO;
    }
    //    NSLog(@"%@",dic);
    [self.navigationController pushViewController:details animated:YES];
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
