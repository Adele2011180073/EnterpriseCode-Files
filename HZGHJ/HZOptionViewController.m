//
//  HZOptionViewController.m
//  HZGHJ
//
//  Created by zhang on 2017/6/28.
//  Copyright © 2017年 FiveFu. All rights reserved.
//

#import "HZOptionViewController.h"
#import "MBProgressHUD.h"
#import "UIViewController+BackButtonHandler.h"
#import "HZLocateDetailViewController.h"
#import "HZBanShiService.h"

@interface HZOptionViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableview;
    UIView *_searchView;//查询页面
    UISegmentedControl *segmented;
    NSMutableArray *_dataList;
    UIScrollView *_scrollCheckView;
    NSMutableArray *_checkBoxArray;
    NSInteger checkNum;
}


@end

@implementation HZOptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden=NO;
    self.view.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回"style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.title=@"请选择办理的窗口";
    
    _dataList=[[NSMutableArray alloc]init];
    _checkBoxArray=[[NSMutableArray alloc]init];
    [self getResourceData];
    _scrollCheckView=[[UIScrollView alloc]initWithFrame:CGRectMake(10, 40, Width-20, Height-44-260)];
    _scrollCheckView.userInteractionEnabled=YES;
    _scrollCheckView.layer.cornerRadius=8;
    _scrollCheckView.clipsToBounds=YES;
    _scrollCheckView.layer.borderColor=blueCyan.CGColor;
    _scrollCheckView.layer.borderWidth=1;
    [self.view addSubview:_scrollCheckView];

    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, Height-44-200, Width-60, 30)];
    titleLabel.textColor=[UIColor grayColor];
    titleLabel.text=@"提示：必须选择一个窗口才能办理";
    titleLabel.textAlignment=NSTextAlignmentLeft;
    titleLabel.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:titleLabel];
    
    UIButton *commit=[[UIButton alloc]initWithFrame:CGRectMake(Width/2-80,Height-44-140, 160, 40)];
    [commit addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    commit.backgroundColor=[UIColor colorWithRed:23/255.0 green:177/255.0 blue:242/255.0 alpha:1];
    commit.clipsToBounds=YES;
    commit.layer.cornerRadius=5;
    [commit setTitle:@"确定" forState:UIControlStateNormal];
    [self.view addSubview:commit];
}
-(void)getResourceData{
    [HZBanShiService BanShiWithAndBlock:^(NSDictionary *returnDic, NSError *error) {
        if (returnDic) {
            NSArray *obj=[returnDic objectForKey:@"obj"];
            _dataList=[NSMutableArray arrayWithArray:obj];
            [self addCheckBoxView];
        }
    }];
}
-(void)addCheckBoxView{
    _scrollCheckView.contentSize=CGSizeMake(Width-20, 40*_dataList.count);
    for (int i=0; i<_dataList.count; i++) {
        NSDictionary *smallDic=[_dataList objectAtIndex:i];
        UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, 10+40*i, Width-100, 20)];
        titleLabel.textColor=[UIColor blackColor];
        titleLabel.textAlignment=NSTextAlignmentLeft;
        titleLabel.font=[UIFont systemFontOfSize:16];
        [_scrollCheckView addSubview:titleLabel];
        UIButton *image=[[UIButton alloc]initWithFrame:CGRectMake(40,5+40*i, 30, 30)];
        [image addTarget:self action:@selector(checkBox:) forControlEvents:UIControlEventTouchUpInside];
        [image setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
        image.tag=10+i;
        [image setImage:[UIImage imageNamed:@"checkbox_fill"] forState:UIControlStateSelected];
        [_scrollCheckView addSubview:image];
        [_checkBoxArray addObject:image];
        NSString *text=[smallDic objectForKey:@"orgName"];
        titleLabel.text=[NSString stringWithFormat:@"%@",text];
    }
}
-(void)checkBox:(UIButton *)sender{
    for (int i=0; i<_checkBoxArray.count; i++) {
        UIButton *button=[_checkBoxArray objectAtIndex:i];
        button.selected=NO;
    }
    checkNum=sender.tag;
    sender.selected=YES;
}
-(void)commit{
    NSDictionary *orgDic=[_dataList objectAtIndex:checkNum-10];
    HZLocateDetailViewController *details=[[HZLocateDetailViewController alloc]init];
    details.qlsxcode=self.qlsxcode;
    details.orgDic=orgDic;
    NSLog(@"orgDic   %@",orgDic);
    details.PCODE=self.PCODE;
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
