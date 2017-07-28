//
//  HZLocateViewController.m
//  HZGHJ
//
//  Created by zhang on 2017/5/9.
//  Copyright © 2017年 FiveFu. All rights reserved.
//

#import "HZLocateViewController.h"
#import "MBProgressHUD.h"
#import "HZURL.h"
#import "UIViewController+BackButtonHandler.h"
#import "HZLocateDetailViewController.h"
#import "HZLoginService.h"
#import "HZOptionViewController.h"


@interface HZLocateViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableview;
    UIView *_searchView;//查询页面
    UISegmentedControl *segmented;
    NSArray *qlsxcodeArray;
    
   }


@end

@implementation HZLocateViewController
@synthesize dataList;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden=NO;
    self.view.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回"style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.title=@"在线办事";
    
    qlsxcodeArray=[[NSArray alloc]initWithObjects:@"EAF31D8225045AE8CFA4E04C961F5D86",@"1FE087B8241745F16C0133ABB4832B8C",@"06C6B52BF5142FB69BA0113DFD08C77B",@"0496B51F3AB9B5135F85F31B8F255857",@"716c0ebb-d774-42f5-84da-54b0b143bc06",@"c0865333-0cbd-4440-86da-3386defefdba",@"0ef7e0ce-bb77-4979-8cc3-166d08712b96",@"b8e6c1ea-6f89-4a2d-af17-78183b3e8a9f", nil];
     dataList=[[NSMutableArray alloc]initWithObjects:@"建设项目选址审批：一般建设项目新建、基本变更（选址位置、用地规模、建设规模）",@"建设项目选址审批：一般建设项目证书失效重新核发",@"建设项目选址审批：一般建设项目简易变更（项目名称、建设单位）",@"建设项目选址审批：一般建设项目延期", @"建设用地规划许可",@"临时建设用地规划许可",@"规划条件审定",@"规划条件变更审批",nil];
    NSArray *titleArray=@[@"在线申请",@"进度查询"];
    segmented=[[UISegmentedControl alloc]initWithItems:titleArray];
    segmented.frame=CGRectMake(5, 5, Width-10, 40);
    segmented.selectedSegmentIndex=0;
    [segmented setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} forState:UIControlStateNormal];
    [segmented addTarget:self action:@selector(choseSeg:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmented];
    
    [self getResourceData];
    [self getInlineRequestView];
}
-(void)getResourceData{
  
}
//MARK:分段选择
-(void)choseSeg:(UISegmentedControl *)segmented{
    if (segmented.selectedSegmentIndex==0) {
        [self getInlineRequestView];
    }else{
        [self addSearchView];
    }
}
-(void)getInlineRequestView{
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 50, Width, Height-44-55)];
    tableview.tag=10;
    [tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    tableview.rowHeight=120;
    tableview.backgroundColor=[UIColor whiteColor];
    tableview.delegate=self;
    tableview.separatorColor=[UIColor clearColor];
    tableview.dataSource=self;
    tableview.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableview];
}
-(void)addSearchView{
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 50, Width, Height-44-55)];
    tableview.tag=11;
    [tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
//    tableview.rowHeight=120;
    tableview.backgroundColor=[UIColor whiteColor];
    tableview.delegate=self;
    tableview.separatorColor=[UIColor clearColor];
    tableview.dataSource=self;
    tableview.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableview];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableview.tag==10) {
        return dataList.count;
    }else{
         return 0;
    }
    return dataList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell=[[UITableViewCell alloc]init];
    }
    if (tableview.tag==10) {
    cell.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    UIView* bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, Width, 100)];
    bgView.backgroundColor=[UIColor whiteColor];
    [cell.contentView addSubview:bgView];
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, Width-60, 80)];
    titleLabel.textColor=[UIColor blackColor];
    titleLabel.numberOfLines=5;
    titleLabel.textAlignment=NSTextAlignmentLeft;
    titleLabel.font=[UIFont systemFontOfSize:16];
    [bgView addSubview:titleLabel];
    
    NSString *text=[dataList objectAtIndex:indexPath.row];
    titleLabel.text=[NSString stringWithFormat:@"%@",text];
    }
    else{
        
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     if (tableview.tag==10) {
    HZOptionViewController *details=[[HZOptionViewController alloc]init];
    details.qlsxcode=[qlsxcodeArray objectAtIndex:indexPath.row];
    details.PCODE=indexPath.row;
    [self.navigationController pushViewController:details animated:YES];
     }else{
         
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
