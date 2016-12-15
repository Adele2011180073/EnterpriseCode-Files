//
//  HZGongShiListViewController.m
//  HZGHJ
//
//  Created by zhang on 16/12/13.
//  Copyright © 2016年 FiveFu. All rights reserved.
//

#import "HZGongShiListViewController.h"
#import "MBProgressHUD.h"
#import "SVPullToRefresh.h"
#import "HZLoginService.h"
#import "HZGongShiDetailViewController.h"
@interface HZGongShiListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int pageIndex;
    UITableView *tableview;
    UISegmentedControl *segmented;
    UIButton *pos;
    UITextField *textField;

}


@end

@implementation HZGongShiListViewController
@synthesize dataList;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    self.title=@"公示记录";
    
    textField=[[UITextField alloc]initWithFrame:CGRectMake(10, 5, Width-120, 40)];
    textField.backgroundColor=[UIColor whiteColor];
    textField.placeholder=@"请输入项目名称进行查询";
    textField.layer.borderWidth=1;
    textField.clearsOnBeginEditing=YES;
    textField.layer.cornerRadius=5;
    textField.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [self.view addSubview:textField];
    
    UIButton *search=[[UIButton alloc]initWithFrame:CGRectMake(Width-80, 5, 60, 40)];
    search.backgroundColor=[UIColor whiteColor];
    [search setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [search setTitle:@"搜索" forState:UIControlStateNormal];
    search.layer.cornerRadius=5;
    search.layer.borderColor=[UIColor lightGrayColor].CGColor;
    search.layer.borderWidth=1;
    [search addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:search];
    
    pageIndex=1;
    dataList=[[NSMutableArray alloc]init];
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 55, Width, Height-44-55)];
    [tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    tableview.rowHeight=110;
    tableview.delegate=self;
    tableview.separatorColor=[UIColor clearColor];
    tableview.dataSource=self;
    [self.view addSubview:tableview];
    [self getDataSource];
    __weak HZGongShiListViewController *yuyue=self;
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
- (void)search:(UIButton *)sender {
    pageIndex=0;
    [self getDataSource];
}
-(void)getDataSource{
    MBProgressHUD *hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text=@"数据加载中，请稍候...";
    [tableview.infiniteScrollingView stopAnimating];
    [tableview.pullToRefreshView stopAnimating];
    NSString *token=[[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    [HZLoginService GongShiLstWithToken:token pageIndex:pageIndex ProjectName:self.projectname andBlock:^(NSDictionary *returnDic, NSError *error) {
            [hud hideAnimated:YES];
            if ([[returnDic objectForKey:@"code"]integerValue]==0) {
                NSArray *array=[returnDic objectForKey:@"list"];
                NSData *data =    [NSJSONSerialization dataWithJSONObject:returnDic options:NSJSONWritingPrettyPrinted error:nil];
                NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"过程上报列表    %@  %@",str,returnDic);

                if (pageIndex==1) {
                    dataList=[NSMutableArray                                                                                                                                                                                                                                                                                                                                           arrayWithArray:array];
                }else{
                    [dataList addObjectsFromArray:array];
                }
                [tableview reloadData];
                
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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell=[[UITableViewCell alloc]init];
    }
    cell.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    UIView* bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 5, Width, 100)];
    bgView.backgroundColor=[UIColor whiteColor];
    [cell.contentView addSubview:bgView];
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, Width-40, 40)];
    titleLabel.textColor=[UIColor blackColor];
    titleLabel.numberOfLines=2;
    titleLabel.textAlignment=NSTextAlignmentLeft;
    titleLabel.font=[UIFont systemFontOfSize:16];
    [bgView addSubview:titleLabel];
    UILabel*subTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 40, Width-40, 20)];
    subTitle.textColor=[UIColor grayColor];
    subTitle.textAlignment=NSTextAlignmentLeft;
    subTitle.font=[UIFont systemFontOfSize:15];
    [bgView addSubview:subTitle];
    UILabel*nameTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 60, Width-40, 20)];
    nameTitle.textColor=[UIColor grayColor];
    nameTitle.textAlignment=NSTextAlignmentLeft;
    nameTitle.font=[UIFont systemFontOfSize:15];
    [bgView addSubview:nameTitle];
    UILabel* phoneLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 80, 60, 20)];
    phoneLabel.textColor=[UIColor grayColor];
    phoneLabel.textAlignment=NSTextAlignmentLeft;
    phoneLabel.font=[UIFont systemFontOfSize:15];
    [bgView addSubview:phoneLabel];
    UILabel*timeTitle=[[UILabel alloc]initWithFrame:CGRectMake(80, 80, 100, 20)];
    timeTitle.textColor=[UIColor blueColor];
    timeTitle.textAlignment=NSTextAlignmentLeft;
    timeTitle.font=[UIFont systemFontOfSize:15];
    [bgView addSubview:timeTitle];
    
    NSDictionary *dic=[dataList objectAtIndex:indexPath.row];
    titleLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"projectname"]];
//
    subTitle.text=[NSString stringWithFormat:@"上报人：%@",[dic objectForKey:@"username"]];
    NSString*str=[dic objectForKey:@"createtime"];//时间戳
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:[str integerValue]/1000];
    //实例化一个NSDateFormatter对象
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
    nameTitle.text=[NSString stringWithFormat:@"上报日期：%@",currentDateStr];
    phoneLabel.text=[NSString stringWithFormat:@"备注: "];
    NSString*type;
    if ([[dic objectForKey:@"type"]integerValue]==1) {
        type=@"起始日";
    }else  if ([[dic objectForKey:@"type"]integerValue]==2) {
        type=@"结束日";
    }else  if ([[dic objectForKey:@"type"]integerValue]==3) {
        type=@"时间1";
    }else  if ([[dic objectForKey:@"type"]integerValue]==4) {
        type=@"时间2";
    }
    timeTitle.text=[NSString stringWithFormat:@"%@",type];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HZGongShiDetailViewController *detail=[[HZGongShiDetailViewController alloc]init];
//    detail.returnDic=[dataList objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
