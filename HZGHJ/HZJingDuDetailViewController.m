//
//  HZJingDuDetailViewController.m
//  HZGHJ
//
//  Created by zhang on 16/12/15.
//  Copyright © 2016年 FiveFu. All rights reserved.
//

#import "HZJingDuDetailViewController.h"
#import "MBProgressHUD.h"
#import "HZLoginService.h"
#import "UIView+Toast.h"
@interface HZJingDuDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableview;
}

@end

@implementation HZJingDuDetailViewController
@synthesize dataList;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    self.title=@"进度详情";
    dataList=[[NSMutableArray alloc]init];
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-44-20)];
    [tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    tableview.rowHeight=130;
    tableview.delegate=self;
    tableview.separatorColor=[UIColor clearColor];
    tableview.dataSource=self;
    [self.view addSubview:tableview];
    [self getDataSource];

}
-(void)getDataSource{
    NSLog(@"projectid %@",_projectid);
    MBProgressHUD *hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text=@"数据加载中，请稍候...";
    [HZLoginService JinDuDetailWithPublicid:self.projectid andBlock:^(NSDictionary *returnDic, NSError *error) {
        [hud hideAnimated:YES];
        if ([[returnDic objectForKey:@"code"]integerValue]==0) {
           NSArray *array=[returnDic objectForKey:@"list"];
            dataList=[NSMutableArray                                                                                                                                                                                                                                                                                                                                           arrayWithArray:array];
            [tableview reloadData];
        }else   if ([[returnDic objectForKey:@"code"]integerValue]==900) {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"您的账号已被其他设备登陆，请重新登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancelAlert];
            [self presentViewController:alert animated:YES completion:nil];
        }else   if ([[returnDic objectForKey:@"code"]integerValue]==1000) {
             [self.view makeToast:[returnDic objectForKey:@"desc"]];
        }else{
            [self.view makeToast:@"请求失败，请重新尝试"];
        }

    }];
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
    UIView* bgView=[[UIView alloc]initWithFrame:CGRectMake(50, 10, Width-20-Height/16, 110)];
    bgView.clipsToBounds=YES;
    bgView.layer.cornerRadius=5;
    bgView.layer.borderColor=blueCyan.CGColor;
    bgView.layer.borderWidth=1;
    bgView.backgroundColor=[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    [cell.contentView addSubview:bgView];
    UILabel *num=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, Height/17, Height/17)];
    num.clipsToBounds=YES;
    num.backgroundColor=[UIColor colorWithRed:23/255.0 green:177/255.0 blue:242/255.0 alpha:1];
    num.textColor=[UIColor whiteColor];
    num.layer.cornerRadius=Height/34;
    num.font=[UIFont systemFontOfSize:15];
    num.text=[NSString stringWithFormat:@"%d",(int)(indexPath.row+1)];
    num.textAlignment=NSTextAlignmentCenter;
    [cell.contentView addSubview:num];
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, Width-100, 40)];
    titleLabel.textColor=[UIColor blackColor];
    titleLabel.numberOfLines=2;
    titleLabel.textAlignment=NSTextAlignmentLeft;
    titleLabel.font=[UIFont systemFontOfSize:16];
    [bgView addSubview:titleLabel];
    UILabel*subTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 50, Width-100, 25)];
    subTitle.textColor=[UIColor grayColor];
    subTitle.textAlignment=NSTextAlignmentLeft;
    subTitle.font=[UIFont systemFontOfSize:15];
    [bgView addSubview:subTitle];
    UILabel*timeTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 80, Width-100, 25)];
    timeTitle.textColor=[UIColor grayColor];
    timeTitle.textAlignment=NSTextAlignmentLeft;
    timeTitle.font=[UIFont systemFontOfSize:15];
    [bgView addSubview:timeTitle];
    
    NSDictionary *dic=[dataList objectAtIndex:indexPath.row];
    NSDictionary *dbAUserDic=[dic objectForKey:@"dbAUser"];
    titleLabel.text=[NSString stringWithFormat:@"项目阶段：%@",[dic objectForKey:@"processName"]];
    subTitle.text=[NSString stringWithFormat:@"经办人: %@",[dbAUserDic objectForKey:@"name"]];

        NSString*str=[dic objectForKey:@"createtime"];//时间戳
        NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:[str integerValue]/1000];
        //实例化一个NSDateFormatter对象
        NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
      timeTitle.text=[NSString stringWithFormat:@"上报时间：%@",currentDateStr];
    
    return cell;
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
