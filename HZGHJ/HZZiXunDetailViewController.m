//
//  HZZiXunDetailViewController.m
//  HZGHJ
//
//  Created by zhang on 2017/7/26.
//  Copyright © 2017年 FiveFu. All rights reserved.
//

#import "HZZiXunDetailViewController.h"
#import "MBProgressHUD.h"
#import "HZLoginService.h"
#import "HZYuYueReViewController.h"
#import "BSRegexValidate.h"
#import "UIView+Toast.h"
#import "HZLoginViewController.h"
#import "HZZiXunReViewController.h"


@interface HZZiXunDetailViewController ()
{
    UIScrollView *bgScrollView;
    
    NSDictionary *_totalDic;
}


@end

@implementation HZZiXunDetailViewController
@synthesize dataList;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self getDataSource];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回"style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.title=@"咨询预约详情";
    
    bgScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-64)];
    bgScrollView.contentSize=CGSizeMake(Width, 800);
    bgScrollView.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    bgScrollView.userInteractionEnabled=YES;
    [self.view addSubview:bgScrollView];
    
    if (_isMy==YES) {
        NSString *taskid=[self.detailData objectForKey:@"taskid"];
        if (![taskid isEqual:[NSNull null]]) {
            bgScrollView.frame=CGRectMake(0, 60, Width, Height-44-20-60);
            bgScrollView.contentSize=CGSizeMake(Width, 860);
            NSArray *btnLabelArray=@[@"再次咨询",@"结束咨询"];
            for (int i=0; i<2; i++) {
                UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(40, 10,Width/2-60, 40)];
                if (i==1) {
                    button.frame=CGRectMake(Width-20-(Width/2-20), 10,Width/2-20, 40);
                }else{
                    button.frame=CGRectMake(10, 10,Width/2-20, 40);
                }
                button.clipsToBounds=YES;
                button.layer.cornerRadius=5;
                [button setTitle:[btnLabelArray objectAtIndex:i] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.backgroundColor=[UIColor colorWithRed:23/255.0 green:177/255.0 blue:242/255.0 alpha:1];
                button.tag=100+i;
                [button addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
                
                [self.view addSubview:button];
            }
            
        }
    }
    
}
-(void)getDataSource{
    MBProgressHUD *hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text=@"数据加载中，请稍候...";
    NSString *token=[[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    [HZLoginService YuYueWithToken:token ReservationId:self.reservationId andBlock:^(NSDictionary *returnDic, NSError *error) {
        [hud hideAnimated:YES];
        if ([[returnDic objectForKey:@"code"]integerValue]==0) {
            NSDictionary *dic=[returnDic objectForKey:@"list"];
            _totalDic=[[NSDictionary alloc]init];
            _totalDic=(NSDictionary *)dic;
                // 刷新指定行
                [self addSubviews];
        }else   if ([[returnDic objectForKey:@"code"]integerValue]==900) {
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
        }else   if ([[returnDic objectForKey:@"code"]integerValue]==1000) {
            [self.view makeToast:[returnDic objectForKey:@"desc"]];
        }else{
            [self.view makeToast:@"请求失败，请重新尝试"];
        }
        
    }];
}
-(void)addSubviews{
    for (UIView *view in bgScrollView.subviews) {
        [view removeFromSuperview];
    }
    NSArray *titleArray=@[@"咨询项目：",@"经办人：",@"联系电话：",@"所属分局："];
    NSArray *contentArray=@[[_totalDic objectForKey:@"projectName"],[_totalDic objectForKey:@"adminName"],[_totalDic objectForKey:@"adminPhone"],[_totalDic objectForKey:@"hostdepartment"]];
    UIView *wrapperView=[[UIView alloc]initWithFrame:CGRectMake(10, 10, Width-20, 120)];
    wrapperView.backgroundColor=[UIColor whiteColor];
    [bgScrollView addSubview:wrapperView];
    for (int i=0; i<titleArray.count; i++) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 30*i, 100, 30)];
        label.textAlignment=NSTextAlignmentLeft;
        label.font=[UIFont systemFontOfSize:16];
        label.textColor=blueCyan;
        label.text=[NSString stringWithFormat:@"%@",[titleArray objectAtIndex:i]];
        [wrapperView addSubview:label];
        
        UILabel *content=[[UILabel alloc]initWithFrame:CGRectMake(110, 30*i, Width-130, 30)];
        content.textAlignment=NSTextAlignmentLeft;
        content.font=[UIFont systemFontOfSize:16];
        content.textColor=[UIColor darkGrayColor];
        content.text=[NSString stringWithFormat:@"%@",[contentArray objectAtIndex:i]];
        [wrapperView addSubview:content];
    }
    NSMutableArray *detailArray=[[NSMutableArray alloc]init];
    NSMutableArray *varibalevalueArray=[[NSMutableArray alloc]init];
    NSMutableArray *statusArray=[[NSMutableArray alloc]init];
    NSMutableArray *timeArray=[[NSMutableArray alloc]init];
    NSMutableArray *nameArray=[[NSMutableArray alloc]init];
    NSArray *runTaskResult=[_totalDic objectForKey:@"runTaskResult"];
    if (runTaskResult.count>0) {
        for (int i=0; i<runTaskResult.count; i++) {
            NSDictionary *dic1=[runTaskResult objectAtIndex:i];
            NSArray *variblesArray=[dic1 objectForKey:@"varibles"];
            if (variblesArray.count>0) {
                [detailArray addObject:dic1];
                [timeArray addObject:[dic1 objectForKey:@"endtime"]];
                [nameArray addObject:[dic1 objectForKey:@"name"]];
                for (int j=0; j<variblesArray.count; j++) {
                    NSDictionary *dic2=[variblesArray objectAtIndex:j];
                    if ([[dic2 objectForKey:@"variablekey"]isEqualToString:@"details"]) {
                        [varibalevalueArray addObject:[dic2 objectForKey:@"varibalevalue"]];
                    }
                    if ([[dic2 objectForKey:@"variablekey"]isEqualToString:@"status"]) {
                        [statusArray addObject:[dic2 objectForKey:@"varibalevalue"]];
                    }
                }
            }
        }
    }
    
    for (int i=0; i<detailArray.count; i++) {
        //           NSDictionary *dic1=[detailArray objectAtIndex:i];
        NSString *statusString=[statusArray objectAtIndex:i];
        NSString *contentString=[varibalevalueArray objectAtIndex:i];
        NSString *timeString=[timeArray objectAtIndex:i];
        NSString *nameString=[nameArray objectAtIndex:i];
        UIView *wrapperView=[[UIView alloc]initWithFrame:CGRectMake(10, 160, Width-40, 160)];
        wrapperView.backgroundColor=[UIColor whiteColor];
        wrapperView.tag=10+i;
        [bgScrollView addSubview:wrapperView];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 30)];
        if([statusString rangeOfString:@"咨询"].location !=NSNotFound)//_roaldSearchText
        {
            titleLabel.text = @"咨询内容";
        }
        else
        {
            titleLabel.text = @"回复内容";
        }
        
        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor=[UIColor lightGrayColor];
        [wrapperView addSubview:titleLabel];
        
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 30)];
        contentLabel.text = contentString;
        contentLabel.numberOfLines=0;
        contentLabel.textColor=[UIColor darkGrayColor];
        contentLabel.layer.borderColor=blueCyan.CGColor;
        contentLabel.layer.borderWidth=0.3;
        contentLabel.font=[UIFont systemFontOfSize:15];
        contentLabel.frame=CGRectMake(10, 35, Width-40, [self sizeWithSt:contentLabel.text font:contentLabel.font]+5);
        contentLabel.textAlignment = NSTextAlignmentLeft;
        [wrapperView addSubview:contentLabel];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, contentLabel.frame.origin.y+[self sizeWithSt:contentLabel.text font:contentLabel.font]+10, Width-60, 30)];
        nameLabel.text = nameString;
        nameLabel.font=[UIFont systemFontOfSize:15];
        nameLabel.textColor=[UIColor darkGrayColor];
        nameLabel.textAlignment = NSTextAlignmentRight;
        [wrapperView addSubview:nameLabel];
        
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, nameLabel.frame.origin.y+30, Width-60, 30)];
        NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:[timeString integerValue]/1000];
        //实例化一个NSDateFormatter对象
        NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
        timeLabel.text = currentDateStr;
        timeLabel.font=[UIFont systemFontOfSize:15];
        timeLabel.textColor=[UIColor darkGrayColor];
        timeLabel.textAlignment = NSTextAlignmentRight;
        [wrapperView addSubview:timeLabel];
        
        wrapperView.frame=CGRectMake(10, 150, Width-20, timeLabel.frame.origin.y+30);
        if (i>0) {
            UIView *view=[self.view viewWithTag:9+i];
            wrapperView.frame=CGRectMake(10, view.frame.origin.y+view.frame.size.height+10, Width-20, timeLabel.frame.origin.y+30);
        }
    }
    UIView *view=[self.view viewWithTag:9+detailArray.count];
    bgScrollView.contentSize=CGSizeMake(Width, view.frame.origin.y+view.frame.size.height+30);
}
//MARK:定义成方法方便多个label调用 增加代码的复用性
- (CGFloat)sizeWithSt:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(Width-40, 8000)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    
    return rect.size.height;
}

-(void)commit:(UIButton*)sender{
    if (sender.tag==100) {
        NSString *taskid=[self.detailData objectForKey:@"taskid"];
        HZZiXunReViewController *re=[[HZZiXunReViewController alloc]init];
        re.taskid=taskid;
        [self.navigationController pushViewController:re animated:YES];
    }else  if (sender.tag==101) {
        NSString *taskid=[self.detailData objectForKey:@"taskid"];
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"结束咨询" message:@"您确定要结束咨询吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [HZLoginService ZiXunCancelWithTaskId:taskid andBlock:^(NSDictionary *returnDic, NSError *error) {
                if ([[returnDic objectForKey:@"code"]integerValue]==0) {
                     [self.view makeToast:[returnDic objectForKey:@"desc"]];
                    [self.navigationController popViewControllerAnimated:YES];
                }else   if ([[returnDic objectForKey:@"code"]integerValue]==900) {
                    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"您的账号已被其他设备登陆，请重新登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    }];
                    [alert addAction:cancelAlert];
                    [self presentViewController:alert animated:YES completion:nil];
                }else{
                    [self.view makeToast:@"请求失败，请重新尝试"];
                }
            }];
        }];
        [alert addAction:okAlert];
        UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:cancelAlert];
        [self presentViewController:alert animated:YES completion:nil];
        
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
