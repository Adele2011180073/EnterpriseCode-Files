//
//  HZGongShiDetailViewController.m
//  HZGHJ
//
//  Created by zhang on 16/12/14.
//  Copyright © 2016年 FiveFu. All rights reserved.
//

#import "HZGongShiDetailViewController.h"
#import "MBProgressHUD.h"
#import "HZLoginService.h"
#import <AVFoundation/AVFoundation.h>
#import "HZPictureViewController.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "HZURL.h"
#import "UIView+Toast.h"
#import "HZLoginViewController.h"
@interface HZGongShiDetailViewController ()<UIGestureRecognizerDelegate,UITextViewDelegate,UIImagePickerControllerDelegate>
{
    UIScrollView *bgScrollView;
    NSDictionary *returnData;
    NSMutableArray *_nameArray; //名字
    NSMutableArray *_photoArray; //图片
    NSMutableArray *_requiredArray; //必选
    NSMutableArray *_remainImageArray; //保存图片数组
    NSMutableArray *imageAray;//获取显示图
    NSMutableArray *_pictureArray;//图片可顺序显示数组
    int _selectBtnIndex;
}


@end

@implementation HZGongShiDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回"style:UIBarButtonItemStyleBordered target:nil action:nil];
    switch (self.type) {
        case 1:{
            self.title=@"公示详情(起始日)";
            _requiredArray = [[NSMutableArray alloc] initWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
            _nameArray = [[NSMutableArray alloc] initWithObjects:@"1_1.jpg",@"1_2.jpg",@"2_1.jpg",@"2_2.jpg",@"3_1.jpg",@"3_2.jpg",@"4_1.jpg", nil];
            _photoArray = [[NSMutableArray alloc] initWithObjects:@"1",@"1",@"1",@"1",@"1",@"1",@"1", nil];
        }
            break;
        case 2:{
            self.title=@"公示详情(结束日)";
            _requiredArray = [[NSMutableArray alloc] initWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
            _nameArray = [[NSMutableArray alloc] initWithObjects:@"1_1.jpg",@"1_2.jpg",@"2_1.jpg",@"2_2.jpg",@"3_1.jpg",@"3_2.jpg",@"4_1.jpg", nil];
            _photoArray = [[NSMutableArray alloc] initWithObjects:@"1",@"1",@"1",@"1",@"1",@"1",@"1", nil];
        }
            break;
        case 3:{
            self.title=@"时间1";
            _requiredArray = [[NSMutableArray alloc] initWithObjects:@"0",@"0",@"0",@"0",@"0",@"0", nil];
            _nameArray = [[NSMutableArray alloc] initWithObjects:@"1_1.jpg",@"1_2.jpg",@"2_1.jpg",@"2_2.jpg",@"3_1.jpg",@"3_2.jpg", nil];
            _photoArray = [[NSMutableArray alloc] initWithObjects:@"1",@"1",@"1",@"1",@"1",@"1", nil];
        }
            break;
        case 4:{
            self.title=@"时间2";
            _requiredArray = [[NSMutableArray alloc] initWithObjects:@"0",@"0",@"0",@"0",@"0",@"0", nil];
            _nameArray = [[NSMutableArray alloc] initWithObjects:@"1_1.jpg",@"1_2.jpg",@"2_1.jpg",@"2_2.jpg",@"3_1.jpg",@"3_2.jpg", nil];
            _photoArray = [[NSMutableArray alloc] initWithObjects:@"1",@"1",@"1",@"1",@"1",@"1", nil];
        }
            break;
        default:
            break;
    }
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    NSString *key=[NSString stringWithFormat:@"%@%d",[self.listDic objectForKey:@"projectname"],self.type];
    NSData *imageData=[def objectForKey:key];
    if (imageData!=NULL&&imageData!=nil) {
        _remainImageArray=[NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:imageData]];
        NSLog(@"_remainImageArray  %@",_remainImageArray);
    }
     _pictureArray=[[NSMutableArray alloc]init];
    returnData=[[NSDictionary alloc]init];
    bgScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-44)];
    bgScrollView.contentSize=CGSizeMake(Width, 1000);
    bgScrollView.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    bgScrollView.userInteractionEnabled=YES;
    [self.view addSubview:bgScrollView];
    if (self.isGongShi==YES) {
           [self getDataSource];
    }else{
        [self addSubviews];
    }
       NSLog(@"self.listDic  %@",self.listDic);
}

-(void)addSubviews{
    NSArray *subArray=nil;
    NSArray *textArray=nil;
    if (self.isGongShi==YES) {
       subArray=@[@"建设单位",@"项目名称",@"公示上报人"];
        NSString *str1=[[NSUserDefaults standardUserDefaults]objectForKey:@"department"];
        NSString *str2=[self.listDic objectForKey:@"projectname"];
        NSString *str3=[[returnData objectForKey:@"obj"] objectForKey:@"username"];
        if (str1==NULL||str1==nil)  str1=@"";
        if (str2==NULL||str2==nil)  str2=@"";
        if (str3==NULL||str3==nil)  str3=@"";
          textArray=@[str1,str2,str3];
    }else{
        subArray=@[@"建设单位",@"项目名称",@"经办人",@"联系电话"];
        NSString *str1=[[NSUserDefaults standardUserDefaults]objectForKey:@"department"];
        NSString *str2=[self.listDic objectForKey:@"projectname"];
        NSString *str3=[self.listDic objectForKey:@"adminName"];
        NSString *str4=[self.listDic objectForKey:@"adminPhone"];
        if (str1==NULL||str1==nil)  str1=@"";
        if (str2==NULL||str2==nil)  str2=@"";
        if (str3==NULL||str3==nil)  str3=@"";
        if (str4==NULL||str4==nil)  str4=@"";
        textArray=@[str1,str2,str3,str4];
    }
 
    for (int i=0; i<textArray.count; i++) {
        UIView* bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 40*i, Width, 40)];
        bgView.backgroundColor=[UIColor whiteColor];
        bgView.userInteractionEnabled=YES;
        [bgScrollView addSubview:bgView];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, 99, 20)];
        label.textAlignment=NSTextAlignmentCenter;
        label.text=[subArray objectAtIndex:i];
        label.font=[UIFont systemFontOfSize:15];
        [bgView addSubview:label];
        
        UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(100, 10, 1, 20)];
        line.backgroundColor=[UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1.0];
        [bgView addSubview:line];
        
        UILabel *text=[[UILabel alloc]initWithFrame:CGRectMake(110, 0, Width -120, 40)];
        text.textAlignment=NSTextAlignmentLeft;
        text.text=[textArray objectAtIndex:i];
        text.numberOfLines=2;
        text.font=[UIFont systemFontOfSize:15];
        [bgView addSubview:text];

    }
    
    NSArray *labArray=nil;
    if (self.type==3||self.type==4) {
        labArray=@[@"社区公示",@"现场一",@"现场二"];
        if (self.isGongShi==YES) {
             bgScrollView.contentSize=CGSizeMake(Width, 600);
        }else{
             labArray=@[@"社区公示(必填)",@"现场一(必填)",@"现场二(必填)"];
             bgScrollView.contentSize=CGSizeMake(Width, 700);
        }
       
    }else  if (self.type==1||self.type==2) {
         labArray=@[@"社区公示",@"现场一",@"现场二",@"网络公示",@"报纸"];
        if (self.isGongShi==YES) {
            bgScrollView.contentSize=CGSizeMake(Width, 800);
        }else{
            labArray=@[@"社区公示(必填)",@"现场一(必填)",@"现场二(必填)",@"网络公示(必填)",@"报纸(选填)"];
            bgScrollView.contentSize=CGSizeMake(Width, 900);
        }
    }
    for (int i=0; i<labArray.count; i++) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(30, 120*i+130, 140, 20)];
        if (self.isGongShi==NO) {
            label.frame=CGRectMake(30, 120*i+170, 140, 20);
        }
        label.textAlignment=NSTextAlignmentLeft;
        label.text=[labArray objectAtIndex:i];
        label.textColor=[UIColor blackColor];
        label.font=[UIFont systemFontOfSize:16];
        [bgScrollView addSubview:label];
        
        //这里是图片显示的，只看获取图片的就行了，有三行和五行的
        UIView* bgView=[[UIView alloc]initWithFrame:CGRectMake(0,40*4+120*i, Width, 80)];
        if (self.isGongShi==NO) {//获取图片
            bgView.frame=CGRectMake(0,40*5+120*i, Width, 80);
            if (labArray.count==3) {   //3行
                NSArray*imageNameArray1=@[@"icon_jj",@"icon_yj"];
                for (int j=0; j<2; j++) {
                    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(60, 5, 70, 70)];
                    if (j==1) {
                            button.frame=CGRectMake(Width-130, 5, 70, 70);
                        }
                    button.tag=i*2+j+1;
                    [button setBackgroundImage:[UIImage imageNamed:[imageNameArray1 objectAtIndex:j]] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
                    //判断有无保存图片
                    if (![_remainImageArray isEqual:[NSNull null]]&&_remainImageArray!=nil&&[[_remainImageArray objectAtIndex:button.tag-1]isKindOfClass:[UIImage class]]) {
                        UIButton *imageView=[[UIButton alloc]init];
                        imageView.frame=CGRectMake(0, 0, 70, 70);
                        imageView.tag=button.tag;
                        [imageView setBackgroundImage:[_remainImageArray objectAtIndex:button.tag-1] forState:UIControlStateNormal];
                        [imageView addTarget:self action:@selector(bigImage:) forControlEvents:UIControlEventTouchUpInside];
                        [button addSubview:imageView];
                        //长按删除
                        UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
                        longPress.accessibilityValue=[NSString stringWithFormat:@"%ld",button.tag];
                        [imageView addGestureRecognizer:longPress];
                        [bgView addSubview:button];
                        [_photoArray replaceObjectAtIndex:button.tag-1 withObject:[_remainImageArray objectAtIndex:button.tag-1]];
                          [_requiredArray replaceObjectAtIndex:button.tag-1 withObject:@"1"];
                    }else{
                        [button setBackgroundImage:[UIImage imageNamed:[imageNameArray1 objectAtIndex:j]] forState:UIControlStateNormal];
                        [button addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    button.accessibilityValue=[NSString stringWithFormat:@"%d",i*2+j+1];
                    [bgView addSubview:button];
                }
            }else{   //5行
                if (i<3) {//前三行
                    NSArray*imageNameArray1=@[@"icon_jj",@"icon_yj"];
                    for (int j=0; j<2; j++) {
                        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(60, 5, 70, 70)];
                        if (j==1) {
                            button.frame=CGRectMake(Width-130, 5, 70, 70);
                        }
                        button.tag=i*2+j+1;
                        [button setBackgroundImage:[UIImage imageNamed:[imageNameArray1 objectAtIndex:j]] forState:UIControlStateNormal];
                        [button addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
                        //判断有无保存图片
                        if (![_remainImageArray isEqual:[NSNull null]]&&_remainImageArray!=nil&&[[_remainImageArray objectAtIndex:button.tag-1]isKindOfClass:[UIImage class]]) {
                            UIButton *imageView=[[UIButton alloc]init];
                            imageView.frame=CGRectMake(0, 0, 70, 70);
                            imageView.tag=button.tag;
                            [imageView setBackgroundImage:[_remainImageArray objectAtIndex:button.tag-1] forState:UIControlStateNormal];
                            [imageView addTarget:self action:@selector(bigImage:) forControlEvents:UIControlEventTouchUpInside];
                            [button addSubview:imageView];
                            //长按删除
                            UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
                            longPress.accessibilityValue=[NSString stringWithFormat:@"%ld",button.tag];
                            [imageView addGestureRecognizer:longPress];
                            [bgView addSubview:button];
                            [_photoArray replaceObjectAtIndex:button.tag-1 withObject:[_remainImageArray objectAtIndex:button.tag-1]];
                             [_requiredArray replaceObjectAtIndex:button.tag-1 withObject:@"1"];
                        }else{
                            [button setBackgroundImage:[UIImage imageNamed:[imageNameArray1 objectAtIndex:j]] forState:UIControlStateNormal];
                            [button addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
                        }
                        button.accessibilityValue=[NSString stringWithFormat:@"%d",i*2+j+1];
                        [bgView addSubview:button];
                    }
                }else{//后两行
                    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(Width/2-35, 5, 70, 70)];
                    button.tag=3+i+1;
                    button.accessibilityValue=[NSString stringWithFormat:@"%d",3+i];
                    [button setBackgroundImage:[UIImage imageNamed:@"add_photo"] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
                    //判断有无保存图片
                    if (button.tag==7) {
                        if (![_remainImageArray isEqual:[NSNull null]]&&_remainImageArray!=nil&&_remainImageArray.count>6&&[[_remainImageArray objectAtIndex:button.tag-1]isKindOfClass:[UIImage class]]) {
                            UIButton *imageView=[[UIButton alloc]init];
                            imageView.frame=CGRectMake(0, 0, 70, 70);
                            imageView.tag=button.tag;
                            [imageView setBackgroundImage:[_remainImageArray objectAtIndex:button.tag-1] forState:UIControlStateNormal];
                            [imageView addTarget:self action:@selector(bigImage:) forControlEvents:UIControlEventTouchUpInside];
                            [button addSubview:imageView];
                            
                                [_photoArray replaceObjectAtIndex:button.tag-1 withObject:[_remainImageArray objectAtIndex:button.tag-1]];
                               [_requiredArray replaceObjectAtIndex:button.tag-1 withObject:@"1"];
                        
                                [button addTarget:self action:@selector(bigImage:) forControlEvents:UIControlEventTouchUpInside];
                            }else{
                                [button setBackgroundImage:[UIImage imageNamed:@"add_photo"] forState:UIControlStateNormal];
                                [button addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
                            }
            
                    }else{
                        if (![_remainImageArray isEqual:[NSNull null]]&&_remainImageArray!=nil&&_remainImageArray.count==8&&[[_remainImageArray objectAtIndex:button.tag-1]isKindOfClass:[UIImage class]]) {
                            [button setBackgroundImage:[_remainImageArray objectAtIndex:button.tag-1] forState:UIControlStateNormal];
                            if (_photoArray.count==8) {
                                  [_photoArray replaceObjectAtIndex:button.tag-1 withObject:[_remainImageArray objectAtIndex:button.tag-1]];
                                  [_nameArray replaceObjectAtIndex:button.tag-1 withObject:@"5_1.jpg"];
                            }else{
                                [_photoArray addObject:[_remainImageArray objectAtIndex:button.tag-1]];
                                  [_nameArray addObject:@"5_1.jpg"];
                            }
                            UIButton *imageView=[[UIButton alloc]init];
                            imageView.frame=CGRectMake(0, 0, 70, 70);
                            imageView.tag=button.tag;
                            [imageView setBackgroundImage:[_remainImageArray objectAtIndex:button.tag-1] forState:UIControlStateNormal];
                            [imageView addTarget:self action:@selector(bigImage:) forControlEvents:UIControlEventTouchUpInside];
                            [button addSubview:imageView];
                            //长按删除
                            UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
                            longPress.accessibilityValue=[NSString stringWithFormat:@"%ld",button.tag];
                            [imageView addGestureRecognizer:longPress];
                            [bgView addSubview:button];
                            }else{
                                [button setBackgroundImage:[UIImage imageNamed:@"add_photo"] forState:UIControlStateNormal];
                                [button addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
                            }

                    }
                                        
                    [bgView addSubview:button];
                }
            }
        }else{     //显示图片
            if (labArray.count==3) {   //3行
                NSMutableArray *imageNameArray2=[[NSMutableArray alloc]init];
                for (int m=0; m<imageAray.count; m++) {
                    NSDictionary *dic=[imageAray objectAtIndex:m];
                    if ([[dic objectForKey:@"type"]integerValue]==i+1) {
                        [imageNameArray2 addObject:dic];
                    }
                }
                [_pictureArray addObjectsFromArray:imageNameArray2];
                for (int j=0; j<2; j++) {
                    NSString *serviceURL=nil;
                    NSDictionary *item=[imageNameArray2 objectAtIndex:j];
                    serviceURL=[NSString stringWithFormat:@"%@%@?fileId=%@",kDemoBaseURL,kGetFileURL,[item objectForKey:@"imageId"]];
                    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(60, 5, 70, 70)];
                    if (j==1) {
                        button.frame=CGRectMake(Width-130, 5, 70, 70);
                    }
                    [button sd_setImageWithURL:[NSURL URLWithString:serviceURL] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"img_default"]];
                        button.accessibilityValue=serviceURL;
                    button.tag=i*2+j+1;
                    [button addTarget:self action:@selector(bigPhoto:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [bgView addSubview:button];
                    
                }
            }else{   //5行
                NSMutableArray *imageNameArray2=[[NSMutableArray alloc]init];
                for (int m=0; m<imageAray.count; m++) {
                    NSDictionary *dic=[imageAray objectAtIndex:m];
                    if ([[dic objectForKey:@"type"]integerValue]==i+1) {
                        [imageNameArray2 addObject:dic];
                    }
                }
                [_pictureArray addObjectsFromArray:imageNameArray2];
                if (i<3) {//前三行
                    for (int j=0; j<2; j++) {
                         NSString *serviceURL=nil;
                        NSDictionary *item=[imageNameArray2 objectAtIndex:j];
                        serviceURL=[NSString stringWithFormat:@"%@%@?fileId=%@",kDemoBaseURL,kGetFileURL,[item objectForKey:@"imageId"]];
                        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(60, 5, 70, 70)];
                        if (j==1) {
                            button.frame=CGRectMake(Width-130, 5, 70, 70);
                        }
                        [button sd_setImageWithURL:[NSURL URLWithString:serviceURL] forState:UIControlStateNormal];
                        button.tag=i*2+j+1;
                        button.accessibilityValue=serviceURL;
                        [button addTarget:self action:@selector(bigPhoto:) forControlEvents:UIControlEventTouchUpInside];
                        
                        [bgView addSubview:button];
                        
                    }
                }else{//后两行
                    NSString *serviceURL=nil;
                    if (imageNameArray2.count<1) {
                        return;
                    }
                    NSDictionary *item=[imageNameArray2 objectAtIndex:0];
                    serviceURL=[NSString stringWithFormat:@"%@%@?fileId=%@",kDemoBaseURL,kGetFileURL,[item objectForKey:@"imageId"]];
                    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(Width/2-35, 5, 70, 70)];
                    button.tag=3+i+1;
                    [button sd_setImageWithURL:[NSURL URLWithString:serviceURL] forState:UIControlStateNormal];
                    button.accessibilityValue=serviceURL;
                    [button addTarget:self action:@selector(bigPhoto:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [bgView addSubview:button];
                }
            }
        }
        bgView.backgroundColor=[UIColor whiteColor];
        bgView.userInteractionEnabled=YES;
        [bgScrollView addSubview:bgView];
        }

    NSArray *btnLabelArray=@[@"保存",@"提交"];
    if (self.isGongShi==NO) {
        for (int i=0; i<2; i++) {
        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(40, 600,Width/2-60, 40)];
             if (self.type==1||self.type==2) {
                 if (i==1) {
                     button.frame=CGRectMake(Width-40-(Width/2-60), 800,Width/2-60, 40);
                 }else{
                     button.frame=CGRectMake(40, 800,Width/2-60, 40);
                 }
             }else{
                 if (i==1) {
                     button.frame=CGRectMake(Width-40-(Width/2-60), 600,Width/2-60, 40);
                 }
             }
          
        [button setTitle:[btnLabelArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor=[UIColor colorWithRed:23/255.0 green:177/255.0 blue:242/255.0 alpha:1];
            button.tag=100+i;
            [button addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
        
        [bgScrollView addSubview:button];
        }
    }

    
}
-(void)commit:(UIButton *)sender{
    if (sender.tag==100) {
        NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
                NSData *imageData=[NSKeyedArchiver archivedDataWithRootObject:_photoArray ];
        NSString *key=[NSString stringWithFormat:@"%@%d",[self.listDic objectForKey:@"projectname"],self.type];
        [def setObject:imageData forKey:key];
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"保存成功！" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:cancelAlert];
        [self presentViewController:alert animated:YES completion:nil];
        return;

    }else{
    NSString *token=[[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString *type=[NSString stringWithFormat:@"%d",self.type];
    for (NSString *str in _requiredArray) {
        if ([str isEqualToString:@"0"]) {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"请拍摄所有必选照片" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancelAlert];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
    }
    MBProgressHUD *hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text=@"数据加载中，请稍候...";
    [HZLoginService GongShiCommitWithToken:token ProjectId:[self.listDic objectForKey:@"projectid"] Publicid:[self.listDic objectForKey:@"id"] Type:type imageObjectArray:_photoArray imageNameArray:_nameArray andBlock:^(NSDictionary *returnDic, NSError *error) {
            [hud hideAnimated:YES];
        if ([[returnDic objectForKey:@"code"]integerValue]==0) {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提交成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:cancelAlert];
            [self presentViewController:alert animated:YES completion:nil];
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
            [self.view makeToast:@"请求不成功，请重新尝试" duration:2 position:CSToastPositionCenter];
        }
        
    }];
    }

}
-(void)takePhoto:(UIButton *)sender{
      _selectBtnIndex = (int)sender.tag;
    NSLog(@"_selectBtnIndex  %d",_selectBtnIndex);
    NSString * mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"请到设置-通用中允许使用相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"添加照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancelAlert];
    UIAlertAction *cameraAlert=[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        picker.accessibilityValue=sender.accessibilityValue;
    
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.showsCameraControls = YES;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:Nil];
    }];
    [alert addAction:cameraAlert];
//    UIAlertAction *pictureAlert=[UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        UIImagePickerController*picker = [[UIImagePickerController alloc] init];
//        
//        picker.delegate = self;
//        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//        //            picker.allowsEditing=YES;
//        [self presentViewController:picker animated:YES completion:Nil];
//    }];
//    [alert addAction:pictureAlert];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - Get Photoes Module
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *scaleImage = [self scaleImage:originImage toScale:0.3];
      UIButton *button=(UIButton*)[self.view viewWithTag:_selectBtnIndex];
    UIButton *imageView=[[UIButton alloc]init];
    imageView.frame=CGRectMake(0, 0, 70, 70);
    imageView.tag=button.tag;
    [imageView setBackgroundImage:scaleImage forState:UIControlStateNormal];
    [imageView addTarget:self action:@selector(bigImage:) forControlEvents:UIControlEventTouchUpInside];
    [button addSubview:imageView];
    if (_selectBtnIndex!=8) {
        //必选
        NSLog(@"_photoArray   %@",_photoArray);
        [_photoArray replaceObjectAtIndex:_selectBtnIndex-1 withObject:scaleImage];
        [_requiredArray replaceObjectAtIndex:_selectBtnIndex-1 withObject:@"1"];
    }
    else{
        //可选
        if (_nameArray.count > 7) {
            //已有第八张可选图片
            [_photoArray replaceObjectAtIndex:7 withObject:scaleImage];
            [_nameArray replaceObjectAtIndex:7 withObject:@"5_1.jpg"];
        }
        else{
            //未有第八张可选图片
            [_nameArray addObject:@"5_1.jpg"];
            [_photoArray addObject:scaleImage];
        }
    }
    //长按删除
    UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
     longPress.accessibilityValue=[NSString stringWithFormat:@"%ld",button.tag];
    [imageView addGestureRecognizer:longPress];
    
//    NSLog(@"_nameArray    %@  _photoArray   %@  _photoArray.count  %d",_nameArray,_photoArray,_photoArray.count);
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)bigImage:(UIButton*)bigImage{
    HZPictureViewController *picture=[[HZPictureViewController alloc]init];
    picture.isWeb=YES;
    NSMutableArray *array=[[NSMutableArray alloc]init];
    [array addObject:bigImage.currentBackgroundImage];
    picture.imageArray=array;
    picture.image=bigImage.currentBackgroundImage;
    NSInteger index=0;
    picture.indexOfImage=index;
    [self.navigationController pushViewController:picture animated:YES];
}

-(void)longPress:(UILongPressGestureRecognizer*)longPress{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确定删除此图片吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancelAlert];
    
    UIAlertAction *okAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [longPress.view removeFromSuperview];
        NSInteger index=[longPress.accessibilityValue integerValue];
         if (_selectBtnIndex!=8) {
        [_photoArray replaceObjectAtIndex:index-1 withObject:@"1"];
        [_requiredArray replaceObjectAtIndex:index-1 withObject:@"0"];
         }else{
               [_photoArray removeObjectAtIndex:index-1];
         }
    }];
    [alert addAction:okAlert];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

-(void)getDataSource{
    MBProgressHUD *hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text=@"数据加载中，请稍候...";
    [HZLoginService GongShiDetailWithPublicid:self.publicid andBlock:^(NSDictionary *returnDic, NSError *error) {
        [hud hideAnimated:YES];
        if ([[returnDic objectForKey:@"code"]integerValue]==0) {
            NSData *data =    [NSJSONSerialization dataWithJSONObject:returnDic options:NSJSONWritingPrettyPrinted error:nil];
            NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            returnData=returnDic;
            imageAray=[NSMutableArray arrayWithArray:[returnDic objectForKey:@"list"]];
            NSLog(@"公式详情   %@  %@",str,imageAray);

            [self addSubviews];

        } else   if ([[returnDic objectForKey:@"code"]integerValue]==900) {
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
            [self.view makeToast:@"请求失败，请重新尝试"];
        }
    }];
}
-(void)bigPhoto:(UIButton*)sender{
    HZPictureViewController *picture=[[HZPictureViewController alloc]init];
    picture.isWeb=NO;
    NSMutableArray*array=[[NSMutableArray alloc]init];
    for (int m=0; m<_pictureArray.count; m++) {
        NSDictionary *dic=[_pictureArray objectAtIndex:m];
        NSString *serviceURL=[NSString stringWithFormat:@"%@%@?fileId=%@",kDemoBaseURL,kGetFileURL,[dic objectForKey:@"imageId"]];
        [array addObject:serviceURL];
    }
    picture.imageArray=array;
    picture.image=sender.currentBackgroundImage;
    NSInteger index=[array indexOfObject:sender.accessibilityValue];
    picture.indexOfImage=index;
    picture.imageURL=sender.accessibilityValue;
    [self.navigationController pushViewController:picture animated:YES];
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
