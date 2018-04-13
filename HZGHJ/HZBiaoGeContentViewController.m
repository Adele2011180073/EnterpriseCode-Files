//
//  HZBiaoGeContentViewController.m
//  HZGHJ
//
//  Created by zhang on 2017/8/24.
//  Copyright © 2017年 FiveFu. All rights reserved.
//

#import "HZBiaoGeContentViewController.h"
#import "MBProgressHUD.h"
#import "HZBanShiService.h"
#import "HZBiaoGeContentWebViewController.h"

@interface HZBiaoGeContentViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *tableview;
}


@end

@implementation HZBiaoGeContentViewController
@synthesize dataList;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回"style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.title=@"常用表格";
    
    [self getReturnData];
    dataList=[[NSMutableArray alloc]init];
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-64)];
    [tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    tableview.rowHeight=100;
    tableview.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    tableview.delegate=self;
    tableview.separatorColor=[UIColor clearColor];
    tableview.dataSource=self;
    tableview.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableview];
    
}
-(void)getReturnData{
    NSString *Pid=[self.sourceData objectForKey:@"id"];
    [HZBanShiService BiaoGeWithId:Pid GetBlock:^(NSDictionary *returnDic, NSError *error) {
        if ([[returnDic objectForKey:@"code"]intValue]==0) {
            NSArray *array=[returnDic objectForKey:@"obj"];
            [dataList addObjectsFromArray:array];
            [tableview reloadData];
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
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    UIView* bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, Width, 80)];
    bgView.backgroundColor=[UIColor whiteColor];
    [cell.contentView addSubview:bgView];
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, Width-60, 60)];
    titleLabel.textColor=[UIColor blackColor];
    titleLabel.numberOfLines=5;
    titleLabel.textAlignment=NSTextAlignmentLeft;
    titleLabel.font=[UIFont systemFontOfSize:16];
    [bgView addSubview:titleLabel];
    
    NSDictionary *dic=[dataList objectAtIndex:indexPath.row];
    titleLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"text"]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic=[dataList objectAtIndex:indexPath.row];
    if ([[dic objectForKey:@"isparent"]isEqualToString:@"yes"]) {
        HZBiaoGeContentViewController *details=[[HZBiaoGeContentViewController alloc]init];
        details.sourceData=dic;
        [self.navigationController pushViewController:details animated:YES];
    }else{
        HZBiaoGeContentWebViewController *details=[[HZBiaoGeContentWebViewController alloc]init];
        details.sourceData=dic;
        [self.navigationController pushViewController:details animated:YES];
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
