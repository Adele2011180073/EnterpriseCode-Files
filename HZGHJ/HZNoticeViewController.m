//
//  HZNoticeViewController.m
//  HZGHJ
//
//  Created by zhang on 16/12/9.
//  Copyright © 2016年 FiveFu. All rights reserved.
//

#import "HZNoticeViewController.h"
#import "HZNoticeDetailViewController.h"
#import "NoticeCell.h"
#import "SVPullToRefresh.h"
#import "MBProgressHUD.h"
#import "HZLoginService.h"

@interface HZNoticeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableview;
    NSMutableArray *dataList;
     int pageIndex;
}


@end

@implementation HZNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after  loading the view from its nib.
     self.navigationController.navigationBarHidden=NO;
    self.view.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回"style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.title=@"消息通知";
    dataList=[[NSMutableArray alloc]init];
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-44)];
    [tableview registerClass:[NoticeCell class] forCellReuseIdentifier:@"cell"];
    tableview.rowHeight=60;
    tableview.delegate=self;
//    tableview.separatorColor=[UIColor clearColor];
    tableview.dataSource=self;
    [self.view addSubview:tableview];
    pageIndex=1;
    [self getDataSource];

    __weak HZNoticeViewController *yuyue=self;
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
-(void)getDataSource{
    MBProgressHUD *hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text=@"数据加载中，请稍候...";
    [tableview.infiniteScrollingView stopAnimating];
    [tableview.pullToRefreshView stopAnimating];
    NSString *token=[[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    [HZLoginService NoticeWithToken:token pageIndex:pageIndex andBlock:^(NSDictionary *returnDic, NSError *error) {
            [hud hideAnimated:YES];
            if ([[returnDic objectForKey:@"code"]integerValue]==0) {
                NSArray *array=[returnDic objectForKey:@"list"];
                if (pageIndex==1) {
                    dataList=[NSMutableArray                                                                                                                                                                                                                                                                                                                                           arrayWithArray:array];
                }else{
                    [dataList addObjectsFromArray:array];
                }
                NSData *data =    [NSJSONSerialization dataWithJSONObject:returnDic options:NSJSONWritingPrettyPrinted error:nil];
                NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                [tableview reloadData];
//                NSLog(@"预约列表    %@ ",str);
//                NSLog(@"预约列表      %@",returnDic);
                
            }else   if ([[returnDic objectForKey:@"code"]integerValue]==900||[[returnDic objectForKey:@"code"]integerValue]==1000) {
                UIAlertController *alert=[UIAlertController alertControllerWithTitle:[returnDic objectForKey:@"desc"] message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:cancelAlert];
                [self presentViewController:alert animated:YES completion:nil];
            }else{
                
            }

        }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataList.count;
}
-(NoticeCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell=[[NoticeCell alloc]init];
    }
    NSDictionary *dic=[dataList objectAtIndex:indexPath.row];
      NSLog(@"预约列表      %@",dic);
    cell.titleLabel.text=[dic objectForKey:@"title"];
    
    cell.subLabel.text=[NSString stringWithFormat:@"推送人：%@",[dic objectForKey:@"sendPerson"]];
    NSString*str=[dic objectForKey:@"sendtime"];//时间戳
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:[str integerValue]/1000];
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
         cell.timeLabel.text=currentDateStr;
//    //    NSString *
//    //    cell.nameTitle.text=[NSString stringWithFormat:@"预约人  %@",[dic objectForKey:@"projectName"]];
//    cell.subTitle.text=[NSString stringWithFormat:@"预约项目  %@",[dic objectForKey:@"projectName"]];cell.subTitle.text=[NSString stringWithFormat:@"预约项目  %@",[dic objectForKey:@"projectName"]];
//    cell.subTitle.text=[NSString stringWithFormat:@"预约项目  %@",[dic objectForKey:@"projectName"]];
//    cell.subTitle.text=[NSString stringWithFormat:@"预约项目  %@",[dic objectForKey:@"projectName"]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        NSDictionary *dic=[dataList objectAtIndex:indexPath.row];
    HZNoticeDetailViewController *details=[[HZNoticeDetailViewController alloc]init];
    details.recordid=[dic objectForKey:@"recordid"];
        NSLog(@"%@",details.recordid);
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
