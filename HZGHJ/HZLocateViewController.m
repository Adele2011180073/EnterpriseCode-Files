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
#import "HZBanShiService.h"
#import "HZOptionViewController.h"
#import "SVPullToRefresh.h"
#import "UIView+Toast.h"
#import "HZLoginViewController.h"
#import "HZReasonWebViewController.h"
#import "HZLocateContentViewController.h"

@interface HZLocateViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableview;
    UIScrollView *_searchView;//查询页面
    UISegmentedControl *segmented;
    NSArray *qlsxcodeArray;
    int pageIndex;
    NSMutableArray *_dataSearchArray;
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
    
     pageIndex=1;
    _dataSearchArray=[[NSMutableArray alloc]init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getResourceData];
         });
    [self getInlineRequestView];
}
-(void)getResourceData{
//    MBProgressHUD *hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.label.text=@"数据加载中，请稍候...";
    [tableview.infiniteScrollingView stopAnimating];
    [tableview.pullToRefreshView stopAnimating];
    NSString *companyid=[[NSUserDefaults standardUserDefaults]objectForKey:@"companyid"];
  [HZBanShiService BanShiWithCompanyid:companyid pageIndex:pageIndex AddBlock:^(NSDictionary *returnDic, NSError *error) {
//       [hud hideAnimated:YES];
      if ([[returnDic objectForKey:@"code"]integerValue]==0) {
          NSArray *array=[returnDic objectForKey:@"obj"];
          if (pageIndex==1) {
              _dataSearchArray=[NSMutableArray                                                                                                                                                                                                                                                                                                                                           arrayWithArray:array];
          }else{
              [_dataSearchArray addObjectsFromArray:array];
          }
          if (_dataSearchArray.count<1||_dataSearchArray==NULL) {
              [self.view makeToast:@"暂时没有数据" duration:2 position:CSToastPositionCenter];
          }
          if (segmented.selectedSegmentIndex==1) {
              [tableview reloadData];
          }
      }else if ([[returnDic objectForKey:@"code"]integerValue]==900) {
          UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"您的账号已被其他设备登陆，请重新登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
          UIAlertAction *okAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
              HZLoginViewController *login=[[HZLoginViewController alloc]init];
              [self.navigationController pushViewController:login animated:YES];
          }];
          [alert addAction:okAlert];
          UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          }];
          [alert addAction:cancelAlert];
          [self presentViewController:alert animated:YES completion:nil];
      }else{
          [self.view makeToast:[returnDic objectForKey:@"desc"] duration:2 position:CSToastPositionCenter];
      }

  }];
}
//MARK:分段选择
-(void)choseSeg:(UISegmentedControl *)segmented{
    if (segmented.selectedSegmentIndex==0) {
        [self getInlineRequestView];
    }else{
         pageIndex=1;
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
    _searchView=[[UIScrollView alloc]init];
    _searchView.frame=CGRectMake(0, 60, Width, Height-64-60);
    _searchView.backgroundColor=[UIColor whiteColor];
//    _searchView.contentSize=CGSizeMake(Width, 1280);
    _searchView.userInteractionEnabled=YES;
    [self.view addSubview:_searchView];
      NSArray *statusLabelArray=@[@"序号",@"项目名称",@"办理事项",@"提交时间",@"申请进度"];
    UIView *nameLabelView1=[[UIView alloc]initWithFrame:CGRectMake(5, 10,Width-10, 40)];
    nameLabelView1.userInteractionEnabled=YES;
    nameLabelView1.layer.borderColor=blueCyan.CGColor;
    nameLabelView1.layer.borderWidth=0.5;
    [_searchView addSubview:nameLabelView1];
    for (int i=0; i<statusLabelArray.count; i++) {
        UILabel  *label1=[[UILabel alloc]initWithFrame:CGRectMake(50+(Width-60)/4*(i-1),  0, (Width-60)/4, 40)];
        if (i==0) {
            label1.frame=CGRectMake(0,  0, 50, 40);
        }
        label1.layer.borderColor=blueCyan.CGColor;
        label1.layer.borderWidth=0.5;
        label1.textAlignment=NSTextAlignmentCenter;
        label1.numberOfLines=10;
        label1.font=[UIFont systemFontOfSize:15];
        label1.text=[NSString stringWithFormat:@"%@",[statusLabelArray objectAtIndex:i]] ;
        [nameLabelView1  addSubview:label1];
}
    
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 50, Width, Height-64-60)];
    tableview.tag=11;
    [tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
//    tableview.rowHeight=120;
    tableview.backgroundColor=[UIColor whiteColor];
    tableview.delegate=self;
    tableview.separatorColor=[UIColor clearColor];
    tableview.dataSource=self;
    tableview.tableFooterView = [[UIView alloc] init];
    [_searchView addSubview:tableview];
    __weak HZLocateViewController *locate=self;
    [tableview addInfiniteScrollingWithActionHandler:^{
        pageIndex=pageIndex+1;
        [locate getResourceData];
    }];
    [tableview addPullToRefreshWithActionHandler:^{
        pageIndex=1;
        [locate getResourceData];
    }];
    [tableview.pullToRefreshView setTitle:@"下拉以刷新" forState:SVPullToRefreshStateTriggered];
    [tableview.pullToRefreshView setTitle:@"刷新完了哟" forState:SVPullToRefreshStateStopped];
    [tableview.pullToRefreshView setTitle:@"不要命的加载中..." forState:SVPullToRefreshStateLoading];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableview.tag==10) {
        return dataList.count;
    }else{
         return _dataSearchArray.count;
    }
    return dataList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableview.tag==10) {
        return 120;
    }else{
        NSDictionary *dic=[_dataSearchArray objectAtIndex:indexPath.row];
        NSString *qlsxcode=[dic objectForKey:@"qlsxcode"];
        NSInteger pcode=[qlsxcodeArray indexOfObject:qlsxcode];
        NSString *qlsxcodeString=[dataList objectAtIndex:pcode];
        CGFloat height1=[self sizeWithSt:qlsxcodeString font:[UIFont systemFontOfSize:15]];
        CGFloat height2;
        if ([[dic objectForKey:@"issync"]integerValue]==1) {
            height2=90;
        }else if ([[dic objectForKey:@"issync"]integerValue]==2) {
            height2=130;
        }else{
            height2=50;
        }
        CGFloat height=height1>height2?height1:height2;
        return height;
    
    }
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
        if (!cell) {
            cell=[[UITableViewCell alloc]init];
        }else{
            for (UIView *view in cell.contentView.subviews) {
                [view removeFromSuperview];
            }
        }
        cell.backgroundColor=[UIColor whiteColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        NSDictionary *dic=[_dataSearchArray objectAtIndex:indexPath.row];
        NSString *xmmc=[dic objectForKey:@"xmmc"];
        NSString *qlsxcode=[dic objectForKey:@"qlsxcode"];
        NSInteger pcode=[qlsxcodeArray indexOfObject:qlsxcode];
        NSString *qlsxcodeString=[dataList objectAtIndex:pcode];
        NSString*str=[dic objectForKey:@"uploadtime"];//时间戳
        NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:[str integerValue]/1000];
        //实例化一个NSDateFormatter对象
        NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
        NSArray *statusLabelArray=@[[NSString stringWithFormat:@"%d",indexPath.row],xmmc,qlsxcodeString,currentDateStr];
        for (int i=0; i<statusLabelArray.count; i++) {
            UILabel  *label1=[[UILabel alloc]initWithFrame:CGRectMake(55+(Width-60)/4*(i-1),  0, (Width-60)/4, cell.frame.size.height)];
            if (i==0) {
                label1.frame=CGRectMake(5,  0, 50, cell.frame.size.height);
            }
            label1.layer.borderColor=blueCyan.CGColor;
            label1.layer.borderWidth=0.5;
            label1.textAlignment=NSTextAlignmentCenter;
            label1.numberOfLines=10;
            label1.font=[UIFont systemFontOfSize:15];
            label1.text=[statusLabelArray objectAtIndex:i];
            [cell.contentView  addSubview:label1];
        }
        NSString *issync;
        if ([[dic objectForKey:@"issync"]integerValue]==101) {
            issync=@"提交中";
        }else if ([[dic objectForKey:@"issync"]integerValue]==102) {
           issync=@"提交完成";
        }else if ([[dic objectForKey:@"issync"]integerValue]==103) {
           issync=@"提交失败";
        }else if ([[dic objectForKey:@"issync"]integerValue]==104) {
            issync=@"提交失败";
        }else if ([[dic objectForKey:@"issync"]integerValue]==0) {
           issync=@"已受理";
        }else if ([[dic objectForKey:@"issync"]integerValue]==1) {
           issync=@"不予受理";
        }else if ([[dic objectForKey:@"issync"]integerValue]==2) {
            issync=@"补正";
        }else{
           issync=@"";
        }
        UIView *nameLabelView1=[[UIView alloc]initWithFrame:CGRectMake(55+(Width-60)/4*3, 0,(Width-60)/4, cell.frame.size.height)];
        nameLabelView1.userInteractionEnabled=YES;
        nameLabelView1.layer.borderColor=blueCyan.CGColor;
        nameLabelView1.layer.borderWidth=0.5;
        [cell.contentView addSubview:nameLabelView1];
        UILabel  *label1=[[UILabel alloc]initWithFrame:CGRectMake(0,  5, (Width-60)/4, 30)];
       label1.textAlignment=NSTextAlignmentCenter;
        label1.font=[UIFont systemFontOfSize:15];
        label1.text=[NSString stringWithFormat:@"%@",issync] ;
        [nameLabelView1  addSubview:label1];
        if ([[dic objectForKey:@"issync"]integerValue]==1) {
            UIButton *imageBtn=[[UIButton alloc]initWithFrame:CGRectMake(5,40, (Width-60)/4-10, 30)];
            imageBtn.titleLabel.font=[UIFont systemFontOfSize:15];
            imageBtn.tag=20;
            imageBtn.accessibilityValue=[NSString stringWithFormat:@"%@",[dic objectForKey:@"resuuid"]];
            [imageBtn addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
            [imageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            imageBtn.backgroundColor=blueCyan;
            [imageBtn setTitle:@"查看原因" forState:UIControlStateNormal];
            [nameLabelView1 addSubview:imageBtn];
        }else if ([[dic objectForKey:@"issync"]integerValue]==2) {
            UIButton *imageBtn=[[UIButton alloc]initWithFrame:CGRectMake(5,40, (Width-60)/4-10, 30)];
            imageBtn.tag=20;
            imageBtn.titleLabel.font=[UIFont systemFontOfSize:15];
            imageBtn.accessibilityValue=[NSString stringWithFormat:@"%@",[dic objectForKey:@"resuuid"]];
            [imageBtn addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
            [imageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            imageBtn.backgroundColor=blueCyan;
            [imageBtn setTitle:@"查看原因" forState:UIControlStateNormal];
            [nameLabelView1 addSubview:imageBtn];
            UIButton *imageBtn1=[[UIButton alloc]initWithFrame:CGRectMake(5,75, (Width-60)/4-10, 30)];
            imageBtn1.tag=21;
            imageBtn1.titleLabel.font=[UIFont systemFontOfSize:15];
            imageBtn1.accessibilityValue=[NSString stringWithFormat:@"%@",[dic objectForKey:@"uuid"]];
            [imageBtn1 addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
            [imageBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            imageBtn1.backgroundColor=blueCyan;
            [imageBtn1 setTitle:@"再次提交" forState:UIControlStateNormal];
            [nameLabelView1 addSubview:imageBtn1];

        }
    }
    return cell;
}
//MARK:定义成方法方便多个label调用 增加代码的复用性
- (CGFloat)sizeWithSt:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake((Width-60)/4, 8000)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    
    return rect.size.height+24;
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
-(void)commit:(UIButton *)sender{
    if (sender.tag==20) {
        HZReasonWebViewController *reason=[[HZReasonWebViewController alloc]init];
        reason.resuuid=sender.accessibilityValue;
        [self.navigationController pushViewController:reason animated:YES];
    }else if (sender.tag==21) {
        HZLocateContentViewController *content=[[HZLocateContentViewController alloc]init];
        for (int i=0; i<_dataSearchArray.count; i++) {
            NSDictionary *dic=[_dataSearchArray objectAtIndex:i];
            if ([[dic objectForKey:@"uuid"]isEqualToString:sender.accessibilityValue]) {
                NSArray * allkeys = [dic allKeys];
                NSMutableDictionary *dicmutable=[[NSMutableDictionary alloc]init];
                for (int i = 0; i < allkeys.count; i++)
                {
                    NSString * key = [allkeys objectAtIndex:i];
                    //如果你的字典中存储的多种不同的类型,那么最好用id类型去接受它
                    id obj  = [dic objectForKey:key];
                    if (obj==nil||obj==NULL||[obj isEqual:[NSNull null]]) {
                        obj=@"";
                    }
                    NSString *value=[NSString stringWithFormat:@"%@",obj];
                    [dicmutable setObject:value forKey:key];
                }
                content.saveDic=[[NSDictionary alloc]initWithDictionary:dicmutable];
                content.commitData=content.saveDic;
//                        NSLog(@"content.saveDic  %@",content.saveDic);
                content.uuid=sender.accessibilityValue;
                [self.navigationController pushViewController:content animated:YES];
            }
        }
        
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
