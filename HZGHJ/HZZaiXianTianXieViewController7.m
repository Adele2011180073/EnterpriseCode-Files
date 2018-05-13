//
//  HZZaiXianTianXieViewController3.m
//  HZGHJ
//
//  Created by zhang on 2017/7/31.
//  Copyright © 2017年 FiveFu. All rights reserved.
//

#import "HZZaiXianTianXieViewController7.h"
#import "HZIllustrateViewController1.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "BSRegexValidate.h"
#import "HZLocateContentViewController.h"
#import "UIViewController+BackButtonHandler.h"

@interface HZZaiXianTianXieViewController7 ()<UITextViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    UIButton *_rightBarBtn;
    UIScrollView *_mainBgView;//整个scrollview
    UIScrollView *_mainListView;//网格scrollview
    UITextView *_detailText1;
    UITextView *_detailText2;

}


@end

@implementation HZZaiXianTianXieViewController7

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回"style:UIBarButtonItemStylePlain target:nil action:nil];
    self.title=@"在线填写";
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, Width, 20)];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=[UIFont systemFontOfSize:16];
    [self.view addSubview:titleLabel];
    titleLabel.text=@" 建设工程规划许可证申请表（市政类项目）";
    
    NSLog(@" %@   %@",titleLabel.text,self.commitData);
  
    _rightBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 5, 80, 20)];
    [_rightBarBtn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [_rightBarBtn addTarget:self action:@selector(illustrate) forControlEvents:UIControlEventTouchUpInside];
    [_rightBarBtn setTitle:@"说明" forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBarBtn];
    self.navigationItem.rightBarButtonItem = leftItem;
    
    _mainBgView=[[UIScrollView alloc]init];
    _mainBgView.showsVerticalScrollIndicator=NO;
    _mainBgView.frame=CGRectMake(0, 40, Width, Height-44-40);
    _mainBgView.contentSize=CGSizeMake(Width, 1590+120);
    _mainBgView.userInteractionEnabled=YES;
    [self.view addSubview:_mainBgView];
    _mainListView=[[UIScrollView alloc]init];
    _mainListView.frame=CGRectMake(5, 10, Width-10,1590);
    _mainListView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _mainListView.layer.borderWidth=0.5;
    _mainListView.userInteractionEnabled=YES;
    [_mainBgView addSubview:_mainListView];
    if (self.commitData==NULL||self.commitData==nil) {
        self.commitData=[[NSDictionary alloc]init];
        //        [self addMainListView];
    }else{
    }
    [self addReMainListView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(downKeyboard)];
    tap.delegate=self;
    [_mainBgView addGestureRecognizer:tap];
    UIButton *commit=[[UIButton alloc]initWithFrame:CGRectMake(20, _mainListView.frame.origin.y+ _mainListView.frame.size.height+20, Width-40, 40)];
    [commit addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    commit.backgroundColor=[UIColor colorWithRed:23/255.0 green:177/255.0 blue:242/255.0 alpha:1];
    commit.clipsToBounds=YES;
    commit.layer.cornerRadius=8;
    [commit setTitle:@"确定" forState:UIControlStateNormal];
    [_mainBgView addSubview:commit];
}
//MARK:绘制已完成主表格视图
-(void)addReMainListView{
    NSArray *nameLabelaArray=@[@"申请人(全称) :",@"受托人 :",@"电话 :",@"手机 :",@"设计单位(盖章) :",@"设计人 :",@"手机 :",@"工程名称 :",@"工程地址 :",@"起点：",@"终点："];
    NSString *str1=[self.commitData objectForKey:@"sqr"];
    NSString *str2=[self.commitData objectForKey:@"wtr"];
    NSString *str3=[self.commitData objectForKey:@"lxdh"];
    NSString *str4=[self.commitData objectForKey:@"sjh"];
    NSString *str5=[self.commitData objectForKey:@"sjdw"];
    NSString *str6=[self.commitData objectForKey:@"sjr"];
    NSString *str7=[self.commitData objectForKey:@"shrsj"];
    NSString *str8=[self.commitData objectForKey:@"xmmc"];
    
    NSString *str9=[self.commitData objectForKey:@"jsdzq"];
    NSString *str10=[self.commitData objectForKey:@"jsdzl"];
    
    NSString *str11=[self.commitData objectForKey:@"qd"];
    NSString *str12=[self.commitData objectForKey:@"zd"];
    
    if ([str1 isEqual:[NSNull null]]||str1==nil||str1==NULL||[str1 isEqualToString:@""]) {
        str1=@"";
    }
    if ([str2 isEqual:[NSNull null]]||str2==nil||str2==NULL||[str2 isEqualToString:@""]) {
        str2=@"";
    }
    if ([str3 isEqual:[NSNull null]]||str3==nil||str3==NULL||[str3 isEqualToString:@""]) {
        str3=@"";
    }
    if ([str4 isEqual:[NSNull null]]||str4==nil||str4==NULL||[str4 isEqualToString:@""]) {
        str4=@"";
    }
    if ([str5 isEqual:[NSNull null]]||str5==nil||str5==NULL||[str5 isEqualToString:@""]) {
        str5=@"";
    }
    if ([str6 isEqual:[NSNull null]]||str6==nil||str6==NULL||[str6 isEqualToString:@""]) {
        str6=@"";
    }
    if ([str7 isEqual:[NSNull null]]||str7==nil||str7==NULL||[str7 isEqualToString:@""]) {
        str7=@"";
    }
    if ([str8 isEqual:[NSNull null]]||str8==nil||str8==NULL||[str8 isEqualToString:@""]) {
        str8=@"";
    }
    if ([str9 isEqual:[NSNull null]]||str9==nil||str9==NULL||[str9 isEqualToString:@""]) {
        str9=@"";
    }
    if ([str10 isEqual:[NSNull null]]||str10==nil||str10==NULL||[str10 isEqualToString:@""]) {
        str10=@"";
    }
    if ([str11 isEqual:[NSNull null]]||str11==nil||str11==NULL||[str11 isEqualToString:@""]) {
        str11=@"";
    }
    if ([str12 isEqual:[NSNull null]]||str12==nil||str12==NULL||[str12 isEqualToString:@""]) {
        str12=@"";
    }
  
    NSArray *nameContentLabelArray=@[str1,str2,str3,str4,str5,str6,str7,str8];
    for (int i=0; i<nameLabelaArray.count; i++) {
        UIView *nameLabelView1=[[UIView alloc]initWithFrame:CGRectMake(0, 50*i,Width-10, 50)];
        nameLabelView1.userInteractionEnabled=YES;
        nameLabelView1.layer.borderColor=[UIColor lightGrayColor].CGColor;
        nameLabelView1.layer.borderWidth=0.5;
        [_mainListView addSubview:nameLabelView1];
        
            UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 15, 20, 20)];
            imageview.image=[UIImage imageNamed:@"must_pic.png"];
            [nameLabelView1 addSubview:imageview];
        
        UILabel  *label1=[[UILabel alloc]initWithFrame:CGRectMake(20,  0, 100, 50)];
        label1.textAlignment=NSTextAlignmentLeft;
        label1.numberOfLines=2;
        label1.font=[UIFont systemFontOfSize:15];
        label1.text=[nameLabelaArray objectAtIndex:i];
        [nameLabelView1  addSubview:label1];
        if (i<8) {
            UITextField *text=[[UITextField alloc]initWithFrame:CGRectMake(120, 0, Width -130, 50)];
            text.tag=10+i;
            //            text.keyboardType = UIKeyboardTypeNumberPad;
            text.delegate=self;
            //        text.placeholder=[placeholderArray objectAtIndex:i];
            text.font=[UIFont systemFontOfSize:15];
            NSString *content=[nameContentLabelArray objectAtIndex:i];
            text.text=[NSString stringWithFormat:@"%@",content];
            [nameLabelView1 addSubview:text];
        }else if (i==8){
            NSArray *labelArray4=@[@"区",@"路(巷)"];
            NSArray *contentArray1=@[str9,str10];
            for (int j=0; j<2; j++) {
                UILabel  *label2=[[UILabel alloc]initWithFrame:CGRectMake(100+(Width-110)/2-40+(Width-110)/2*j,  5, 40, 40)];
                label2.textAlignment=NSTextAlignmentCenter;
                label2.adjustsFontSizeToFitWidth=YES;
                label2.font=[UIFont systemFontOfSize:15];
                label2.text=[labelArray4 objectAtIndex:j];
                [nameLabelView1  addSubview:label2];
                
                UITextField *text=[[UITextField alloc]initWithFrame:CGRectMake(100+(Width-110)/2*j, 5, (Width-110)/2-40, 40)];
                text.layer.borderColor=[UIColor lightGrayColor].CGColor;
                text.layer.borderWidth=0.5;
                text.tag=20+j;
                text.delegate=self;
                NSString *content=[contentArray1 objectAtIndex:j];
                text.text=[NSString stringWithFormat:@"%@",content];
                text.font=[UIFont systemFontOfSize:15];
                [nameLabelView1 addSubview:text];
            }
        }else if (i==9){//起点
                UILabel  *label2=[[UILabel alloc]initWithFrame:CGRectMake(Width-10-60,  5, 40, 40)];
                label2.textAlignment=NSTextAlignmentCenter;
                label2.adjustsFontSizeToFitWidth=YES;
                label2.font=[UIFont systemFontOfSize:15];
                label2.text=@"路(巷)";
                [nameLabelView1  addSubview:label2];
                
                UITextField *text=[[UITextField alloc]initWithFrame:CGRectMake(120, 10, Width-130-60, 30)];
                text.layer.borderColor=[UIColor lightGrayColor].CGColor;
                text.layer.borderWidth=0.5;
                text.tag=22;
                text.delegate=self;
                text.text=[NSString stringWithFormat:@"%@",str11];
                text.font=[UIFont systemFontOfSize:15];
                [nameLabelView1 addSubview:text];
        }else if (i==10){//终点
            UILabel  *label2=[[UILabel alloc]initWithFrame:CGRectMake(Width-10-60,  5, 40, 40)];
            label2.textAlignment=NSTextAlignmentCenter;
            label2.adjustsFontSizeToFitWidth=YES;
            label2.font=[UIFont systemFontOfSize:15];
            label2.text=@"路(巷)";
            [nameLabelView1  addSubview:label2];
            
            UITextField *text=[[UITextField alloc]initWithFrame:CGRectMake(120, 10, Width-130-60, 30)];
            text.layer.borderColor=[UIColor lightGrayColor].CGColor;
            text.layer.borderWidth=0.5;
            text.tag=23;
            text.delegate=self;
            text.text=[NSString stringWithFormat:@"%@",str12];
            text.font=[UIFont systemFontOfSize:15];
            [nameLabelView1 addSubview:text];
        }
       
    }
    NSString *str21=[self.commitData objectForKey:@"jsnrjgm"];
    if ([str21 isEqual:[NSNull null]]||str21==nil||str21==NULL||[str21 isEqualToString:@""]) {
        str21=@"";
    }
        UIView *textBgView1=[[UIView alloc]initWithFrame:CGRectMake(0, 550, Width-10, 160)];
        textBgView1.backgroundColor=[UIColor whiteColor];
        textBgView1.layer.borderColor=[UIColor lightGrayColor].CGColor;
        textBgView1.layer.borderWidth=0.5;
        textBgView1.userInteractionEnabled=YES;
        [_mainListView addSubview:textBgView1];
    
     UIImageView *imageview1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 20, 20)];
    imageview1.image=[UIImage imageNamed:@"must_pic.png"];
    [textBgView1 addSubview:imageview1];
        UILabel  *label1=[[UILabel alloc]initWithFrame:CGRectMake(30,  10, 200, 20)];
        label1.textAlignment=NSTextAlignmentLeft;
        label1.font=[UIFont systemFontOfSize:15];
        label1.textColor=[UIColor grayColor];
        label1.text=@"建设内容及规模：";
        [textBgView1  addSubview:label1];
        
            _detailText1=[[UITextView alloc]initWithFrame:CGRectMake(5, 40, Width-20, 115)];
            _detailText1.layer.borderWidth=0.5;
            _detailText1.layer.borderColor=blueCyan.CGColor;
            _detailText1.clipsToBounds=YES;
            _detailText1.layer.cornerRadius=5;
            _detailText1.delegate=self;
            _detailText1.text=[NSString stringWithFormat:@"%@",str21];
            _detailText1.clearsOnInsertion=YES;
            [_detailText1 resignFirstResponder];
            _detailText1.font=[UIFont systemFontOfSize:15];
            [textBgView1 addSubview:_detailText1];
            self.placehoderLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, _detailText1.frame.size.width-40, 30)];
            if (![_detailText1.text isEqualToString:@""]) {
                self.placehoderLabel1.hidden=YES;
            }
            self.placehoderLabel1.text = @"(长度不得超过200字)";
            self.placehoderLabel1.textColor=[UIColor grayColor];
            
            self.placehoderLabel1.font = [UIFont systemFontOfSize:14.0];
            
            [_detailText1 addSubview:self.placehoderLabel1];
    
    
    UILabel  *label2=[[UILabel alloc]initWithFrame:CGRectMake(20,  720, Width-40, 20)];
    label2.textAlignment=NSTextAlignmentLeft;
    label2.font=[UIFont systemFontOfSize:14];
    label2.textColor=[UIColor blackColor];
    label2.text=@"道路河道等工程";
    [_mainListView  addSubview:label2];

    UIView *textBgView2=[[UIView alloc]initWithFrame:CGRectMake(5, 750, Width-20, 480)];
    textBgView2.backgroundColor=[UIColor whiteColor];
    textBgView2.layer.borderColor=[UIColor lightGrayColor].CGColor;
    textBgView2.layer.borderWidth=0.5;
    textBgView2.userInteractionEnabled=YES;
    [_mainListView addSubview:textBgView2];
    
    UIImageView *imageview3=[[UIImageView alloc]initWithFrame:CGRectMake(0, 15, 20, 20)];
    imageview3.image=[UIImage imageNamed:@"must_pic.png"];
    [textBgView2 addSubview:imageview3];
    UILabel  *label3=[[UILabel alloc]initWithFrame:CGRectMake(30,  10, Width-40, 20)];
    label3.textAlignment=NSTextAlignmentLeft;
    label3.font=[UIFont systemFontOfSize:14];
    label3.textColor=[UIColor blackColor];
    label3.text=@"道路（公路）";
    [textBgView2  addSubview:label3];
    NSArray *labelArray3=@[@"长度（米）",@"宽度（米）",@"横断面布置(米)"];
    NSMutableArray *contentArray3=[[NSMutableArray alloc] initWithObjects:[self getString:[self.commitData objectForKey:@"dlglcd1"]],[self getString:[self.commitData objectForKey:@"dlglkd1"]],[self getString:[self.commitData objectForKey:@"dlglhdm1"]],[self getString:[self.commitData objectForKey:@"dlglcd2"]],[self getString:[self.commitData objectForKey:@"dlglkd2"]],[self getString:[self.commitData objectForKey:@"dlglhdm3"]], nil];
    if ([self.commitData objectForKey:@"dlgl"]!=NULL||[self.commitData objectForKey:@"dlgl"]!=nil) {
        contentArray3=[[NSMutableArray alloc]init];
        NSString *dlgl=[self.commitData objectForKey:@"dlgl"];
        NSRange startRange = [dlgl rangeOfString:@"["];
        NSRange endRange = [dlgl rangeOfString:@"]"];
        NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
        NSString *result = [dlgl substringWithRange:range];
        NSArray *resultArray=[result componentsSeparatedByString:@","];
        for (int m=0; m<resultArray.count; m++) {
            NSString *item1=[resultArray objectAtIndex:m];
            item1 = [item1 stringByReplacingOccurrencesOfString:@"{" withString:@""];
            item1 = [item1 stringByReplacingOccurrencesOfString:@"}" withString:@""];
            [contentArray3 addObject:item1];
        }
    }
    NSLog(@"contentArray3   %@",contentArray3);
    for (int i=0; i<3; i++) {
        UIView *textBgView=[[UIView alloc]initWithFrame:CGRectMake((Width-20)/3*i,40, (Width-20)/3, 40)];
        textBgView.backgroundColor=[UIColor whiteColor];
        textBgView.layer.borderColor=[UIColor lightGrayColor].CGColor;
        textBgView.layer.borderWidth=0.5;
        textBgView.userInteractionEnabled=YES;
        [textBgView2 addSubview:textBgView];
        
        UILabel  *label1=[[UILabel alloc]initWithFrame:CGRectMake(5,  5, (Width-20)/3-10, 30)];
        label1.textAlignment=NSTextAlignmentCenter;
        label1.numberOfLines=5;
        label1.adjustsFontSizeToFitWidth=YES;
        label1.font=[UIFont systemFontOfSize:14];
        label1.textColor=[UIColor blackColor];
        label1.text=[labelArray3 objectAtIndex:i];
        [textBgView  addSubview:label1];
        
        UITextField *text1=[[UITextField alloc]initWithFrame:CGRectMake((Width-20)/3*i, 80, (Width-20)/3, 40)];
        text1.layer.borderColor=[UIColor lightGrayColor].CGColor;
        text1.layer.borderWidth=0.5;
        text1.tag=30+i;
        //            text.keyboardType = UIKeyboardTypeNumberPad;
        text1.delegate=self;
        //        text.placeholder=[placeholderArray objectAtIndex:i];
        text1.font=[UIFont systemFontOfSize:15];
        NSString *content=[contentArray3 objectAtIndex:i];
        text1.text=[NSString stringWithFormat:@"%@",content];
        [textBgView2 addSubview:text1];
        
        
        UITextField *text2=[[UITextField alloc]initWithFrame:CGRectMake((Width-20)/3*i, 120, (Width-20)/3, 40)];
        text2.layer.borderColor=[UIColor lightGrayColor].CGColor;
        text2.layer.borderWidth=0.5;
        text2.tag=33+i;
        //            text.keyboardType = UIKeyboardTypeNumberPad;
        text2.delegate=self;
        //        text.placeholder=[placeholderArray objectAtIndex:i];
        text2.font=[UIFont systemFontOfSize:15];
        NSString *content2=[contentArray3 objectAtIndex:i+3];
        text2.text=[NSString stringWithFormat:@"%@",content2];
        [textBgView2 addSubview:text2];
    }
    
    UIImageView *imageview4=[[UIImageView alloc]initWithFrame:CGRectMake(0, 170, 20, 20)];
    imageview4.image=[UIImage imageNamed:@"must_pic.png"];
    [textBgView2 addSubview:imageview4];
    UILabel  *label4=[[UILabel alloc]initWithFrame:CGRectMake(30,  170, Width-40, 20)];
    label4.textAlignment=NSTextAlignmentLeft;
    label4.font=[UIFont systemFontOfSize:14];
    label4.textColor=[UIColor blackColor];
    label4.text=@"桥        梁";
    [textBgView2  addSubview:label4];
    NSArray *labelArray4=@[@"长度（米）",@"宽度（米）",@"梁底标高(米)",@"形式"];
     NSMutableArray *contentArray4=[[NSMutableArray alloc]initWithObjects:[self getString:[self.commitData objectForKey:@"qlcd1"]],[self getString:[self.commitData objectForKey:@"qlkd1"]],[self getString:[self.commitData objectForKey:@"qlldbg1"]],[self getString:[self.commitData objectForKey:@"qlxs1"]],[self getString:[self.commitData objectForKey:@"qlcd2"]],[self getString:[self.commitData objectForKey:@"qlkd2"]],[self getString:[self.commitData objectForKey:@"qlldbg2"]],[self getString:[self.commitData objectForKey:@"qlxs2"]], nil];
    if ([self.commitData objectForKey:@"ql"]!=NULL||[self.commitData objectForKey:@"ql"]!=nil) {
        contentArray4=[[NSMutableArray alloc]init];
        NSString *ql=[self.commitData objectForKey:@"ql"];
        NSRange startRange = [ql rangeOfString:@"["];
        NSRange endRange = [ql rangeOfString:@"]"];
        NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
        NSString *result = [ql substringWithRange:range];
        NSArray *resultArray=[result componentsSeparatedByString:@","];
        for (int m=0; m<resultArray.count; m++) {
            NSString *item1=[resultArray objectAtIndex:m];
            item1 = [item1 stringByReplacingOccurrencesOfString:@"{" withString:@""];
            item1 = [item1 stringByReplacingOccurrencesOfString:@"}" withString:@""];
            [contentArray4 addObject:item1];
        }
    }
    NSLog(@"contentArray4   %@",contentArray4);
    for (int i=0; i<4; i++) {
        UIView *textBgView=[[UIView alloc]initWithFrame:CGRectMake((Width-20)/4*i,200, (Width-20)/4, 40)];
        textBgView.backgroundColor=[UIColor whiteColor];
        textBgView.layer.borderColor=[UIColor lightGrayColor].CGColor;
        textBgView.layer.borderWidth=0.5;
        textBgView.userInteractionEnabled=YES;
        [textBgView2 addSubview:textBgView];
        
        UILabel  *label1=[[UILabel alloc]initWithFrame:CGRectMake(5,  5, (Width-20)/4-10, 30)];
        label1.textAlignment=NSTextAlignmentCenter;
        label1.numberOfLines=5;
        label1.adjustsFontSizeToFitWidth=YES;
        label1.font=[UIFont systemFontOfSize:14];
        label1.textColor=[UIColor blackColor];
        label1.text=[labelArray4 objectAtIndex:i];
        [textBgView  addSubview:label1];
        
        UITextField *text1=[[UITextField alloc]initWithFrame:CGRectMake((Width-20)/4*i, 240, (Width-20)/4, 40)];
        text1.layer.borderColor=[UIColor lightGrayColor].CGColor;
        text1.layer.borderWidth=0.5;
        text1.tag=40+i;
        //            text.keyboardType = UIKeyboardTypeNumberPad;
        text1.delegate=self;
        //        text.placeholder=[placeholderArray objectAtIndex:i];
        text1.font=[UIFont systemFontOfSize:15];
        NSString *content1=[contentArray4 objectAtIndex:i];
        text1.text=[NSString stringWithFormat:@"%@",content1];
        [textBgView2 addSubview:text1];
        
        
        UITextField *text2=[[UITextField alloc]initWithFrame:CGRectMake((Width-20)/4*i, 280, (Width-20)/4, 40)];
        text2.layer.borderColor=[UIColor lightGrayColor].CGColor;
        text2.layer.borderWidth=0.5;
        text2.tag=44+i;
        //            text.keyboardType = UIKeyboardTypeNumberPad;
        text2.delegate=self;
        //        text.placeholder=[placeholderArray objectAtIndex:i];
        text2.font=[UIFont systemFontOfSize:15];
        NSString *content2=[contentArray4 objectAtIndex:i+4];
        text2.text=[NSString stringWithFormat:@"%@",content2];
        [textBgView2 addSubview:text2];
    }
    UIImageView *imageview5=[[UIImageView alloc]initWithFrame:CGRectMake(0, 330, 20, 20)];
    imageview5.image=[UIImage imageNamed:@"must_pic.png"];
    [textBgView2 addSubview:imageview5];
    UILabel  *label5=[[UILabel alloc]initWithFrame:CGRectMake(30,  330, Width-40, 20)];
    label5.textAlignment=NSTextAlignmentLeft;
    label5.font=[UIFont systemFontOfSize:14];
    label5.textColor=[UIColor blackColor];
    label5.text=@"驳　      坎";
    [textBgView2  addSubview:label5];
    NSArray *labelArray5=@[@"长度（米）",@"（二级驳坎）克顶标高(米)"];
     NSMutableArray *contentArray5=[[NSMutableArray alloc]initWithObjects:[self getString:[self.commitData objectForKey:@"bkcd1"]],[self getString:[self.commitData objectForKey:@"bkbg1"]],[self getString:[self.commitData objectForKey:@"bkcd2"]],[self getString:[self.commitData objectForKey:@"bkbg2"]], nil];
    if ([self.commitData objectForKey:@"bk"]!=NULL||[self.commitData objectForKey:@"bk"]!=nil) {
        contentArray5=[[NSMutableArray alloc]init];
        NSString *bk=[self.commitData objectForKey:@"bk"];
        NSRange startRange = [bk rangeOfString:@"["];
        NSRange endRange = [bk rangeOfString:@"]"];
        NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
        NSString *result = [bk substringWithRange:range];
        NSArray *resultArray=[result componentsSeparatedByString:@","];
        for (int m=0; m<resultArray.count; m++) {
            NSString *item1=[resultArray objectAtIndex:m];
            item1 = [item1 stringByReplacingOccurrencesOfString:@"{" withString:@""];
            item1 = [item1 stringByReplacingOccurrencesOfString:@"}" withString:@""];
            [contentArray5 addObject:item1];
        }
    }
    NSLog(@"contentArray5   %@",contentArray5);
    for (int i=0; i<2; i++) {
        UIView *textBgView=[[UIView alloc]initWithFrame:CGRectMake((Width-20)/2*i,360, (Width-20)/2, 40)];
        textBgView.backgroundColor=[UIColor whiteColor];
        textBgView.layer.borderColor=[UIColor lightGrayColor].CGColor;
        textBgView.layer.borderWidth=0.5;
        textBgView.userInteractionEnabled=YES;
        [textBgView2 addSubview:textBgView];
        
        UILabel  *label1=[[UILabel alloc]initWithFrame:CGRectMake(5,  5, (Width-20)/2-10, 30)];
        label1.textAlignment=NSTextAlignmentCenter;
        label1.numberOfLines=5;
        label1.adjustsFontSizeToFitWidth=YES;
        label1.font=[UIFont systemFontOfSize:14];
        label1.textColor=[UIColor blackColor];
        label1.text=[labelArray5 objectAtIndex:i];
        [textBgView  addSubview:label1];
        
        UITextField *text1=[[UITextField alloc]initWithFrame:CGRectMake((Width-20)/2*i, 400, (Width-20)/2, 40)];
        text1.layer.borderColor=[UIColor lightGrayColor].CGColor;
        text1.layer.borderWidth=0.5;
        text1.tag=50+i;
        //            text.keyboardType = UIKeyboardTypeNumberPad;
        text1.delegate=self;
        //        text.placeholder=[placeholderArray objectAtIndex:i];
        text1.font=[UIFont systemFontOfSize:15];
        NSString *content1=[contentArray5 objectAtIndex:i];
        text1.text=[NSString stringWithFormat:@"%@",content1];
        [textBgView2 addSubview:text1];
        
        
        UITextField *text2=[[UITextField alloc]initWithFrame:CGRectMake((Width-20)/2*i, 440, (Width-20)/2, 40)];
        text2.layer.borderColor=[UIColor lightGrayColor].CGColor;
        text2.layer.borderWidth=0.5;
        text2.tag=52+i;
        //            text.keyboardType = UIKeyboardTypeNumberPad;
        text2.delegate=self;
        //        text.placeholder=[placeholderArray objectAtIndex:i];
        text2.font=[UIFont systemFontOfSize:15];
                NSString *content2=[contentArray5 objectAtIndex:i+2];
                text2.text=[NSString stringWithFormat:@"%@",content2];
        [textBgView2 addSubview:text2];
    }
    UILabel  *label6=[[UILabel alloc]initWithFrame:CGRectMake(20,  1240, Width-40, 20)];
    label6.textAlignment=NSTextAlignmentLeft;
    label6.font=[UIFont systemFontOfSize:14];
    label6.textColor=[UIColor blackColor];
    label6.text=@"管线工程";
    [_mainListView  addSubview:label6];
    UIView *textBgView3=[[UIView alloc]initWithFrame:CGRectMake(5, 1270, Width-20, 160)];
    textBgView3.backgroundColor=[UIColor whiteColor];
    textBgView3.layer.borderColor=[UIColor lightGrayColor].CGColor;
    textBgView3.layer.borderWidth=0.5;
    textBgView3.userInteractionEnabled=YES;
    [_mainListView addSubview:textBgView3];
    
    UILabel  *mingchen=[[UILabel alloc]initWithFrame:CGRectMake(5,  5, 60, 30)];
    mingchen.textAlignment=NSTextAlignmentLeft;
    mingchen.adjustsFontSizeToFitWidth=YES;
    mingchen.font=[UIFont systemFontOfSize:14];
    mingchen.textColor=[UIColor blackColor];
    mingchen.text=@"名称：";
    [textBgView3  addSubview:mingchen];
    NSMutableArray *contentArray6=[[NSMutableArray alloc]initWithObjects:[self getString:[self.commitData objectForKey:@"gxgcmc"]],[self getString:[self.commitData objectForKey:@"gxgccd1"]],[self getString:[self.commitData objectForKey:@"gxgcgg"]],[self getString:[self.commitData objectForKey:@"gxgccd2"]],[self getString:[self.commitData objectForKey:@"gxgcgw"]],[self getString:[self.commitData objectForKey:@"gxgcbz"]], nil];
    if ([self.commitData objectForKey:@"gxgc"]!=NULL||[self.commitData objectForKey:@"gxgc"]!=nil) {
        contentArray6=[[NSMutableArray alloc]init];
        NSString *gxgc=[self.commitData objectForKey:@"gxgc"];
        NSRange startRange = [gxgc rangeOfString:@"{"];
        NSRange endRange = [gxgc rangeOfString:@"}"];
        NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
        NSString *result = [gxgc substringWithRange:range];
        NSArray *resultArray=[result componentsSeparatedByString:@","];
        for (int m=0; m<resultArray.count; m++) {
            NSString *item1=[resultArray objectAtIndex:m];
            [contentArray6 addObject:item1];
        }
    }
    NSLog(@"contentArray6   %@",contentArray6);
    UITextField *mingchenText=[[UITextField alloc]initWithFrame:CGRectMake(70, 0, Width-20-80, 40)];
    mingchenText.tag=60;
    //            text.keyboardType = UIKeyboardTypeNumberPad;
    mingchenText.delegate=self;
    //        text.placeholder=[placeholderArray objectAtIndex:i];
    mingchenText.font=[UIFont systemFontOfSize:15];
    NSString *content=[contentArray6 objectAtIndex:0];
    mingchenText.text=[NSString stringWithFormat:@"%@",content];
    [textBgView3 addSubview:mingchenText];
    
    NSArray *labelArray6=@[@"架空管线：",@"地下管线："];
    for (int i=0; i<2; i++) {
        UIView *textBgView=[[UIView alloc]initWithFrame:CGRectMake(0,40+40*i, (Width-20), 40)];
        textBgView.backgroundColor=[UIColor whiteColor];
        textBgView.layer.borderColor=[UIColor lightGrayColor].CGColor;
        textBgView.layer.borderWidth=0.5;
        textBgView.userInteractionEnabled=YES;
        [textBgView3 addSubview:textBgView];
        
        UILabel  *label1=[[UILabel alloc]initWithFrame:CGRectMake(5,  5, 70, 30)];
        label1.textAlignment=NSTextAlignmentLeft;
        label1.adjustsFontSizeToFitWidth=YES;
        label1.font=[UIFont systemFontOfSize:14];
        label1.textColor=[UIColor blackColor];
        label1.text=[labelArray6 objectAtIndex:i];
        [textBgView  addSubview:label1];
        
        UILabel  *changdu=[[UILabel alloc]initWithFrame:CGRectMake(80,  5, 40, 30)];
        changdu.textAlignment=NSTextAlignmentLeft;
        changdu.adjustsFontSizeToFitWidth=YES;
        changdu.font=[UIFont systemFontOfSize:14];
        changdu.textColor=[UIColor blackColor];
        changdu.text=@"长度";
        [textBgView  addSubview:changdu];
        UITextField *text1=[[UITextField alloc]initWithFrame:CGRectMake(120, 5, 100, 30)];
        text1.layer.borderColor=[UIColor lightGrayColor].CGColor;
        text1.layer.borderWidth=0.5;
        text1.tag=61+i;
        //            text.keyboardType = UIKeyboardTypeNumberPad;
        text1.delegate=self;
        //        text.placeholder=[placeholderArray objectAtIndex:i];
        text1.font=[UIFont systemFontOfSize:15];
        NSString *content1=[contentArray6 objectAtIndex:i+1];
        text1.text=[NSString stringWithFormat:@"%@",content1];
        [textBgView addSubview:text1];
        
        UILabel  *guige=[[UILabel alloc]initWithFrame:CGRectMake(220,  5, 40, 30)];
        guige.textAlignment=NSTextAlignmentLeft;
        guige.adjustsFontSizeToFitWidth=YES;
        guige.font=[UIFont systemFontOfSize:14];
        guige.textColor=[UIColor blackColor];
        if (i==0) {
              guige.text=@"规格";
        }else{
              guige.text=@"管位";
        }
      
        [textBgView  addSubview:guige];
        UITextField *text2=[[UITextField alloc]initWithFrame:CGRectMake(260, 5, Width-20-260-5, 30)];
        text2.layer.borderColor=[UIColor lightGrayColor].CGColor;
        text2.layer.borderWidth=0.5;
        text2.tag=63+i;
        //            text.keyboardType = UIKeyboardTypeNumberPad;
        text2.delegate=self;
        //        text.placeholder=[placeholderArray objectAtIndex:i];
        text2.font=[UIFont systemFontOfSize:15];
                NSString *content2=[contentArray6 objectAtIndex:i+3];
                text2.text=[NSString stringWithFormat:@"%@",content2];
        [textBgView addSubview:text2];
    }
    UILabel  *beizhu=[[UILabel alloc]initWithFrame:CGRectMake(5,  130, 60, 20)];
    beizhu.textAlignment=NSTextAlignmentLeft;
    beizhu.adjustsFontSizeToFitWidth=YES;
    beizhu.font=[UIFont systemFontOfSize:14];
    beizhu.textColor=[UIColor blackColor];
    beizhu.text=@"备注：";
    [textBgView3  addSubview:beizhu];
    
    UITextField *beizhuText=[[UITextField alloc]initWithFrame:CGRectMake(70, 120, Width-20-80, 40)];
    beizhuText.tag=65;
    //            text.keyboardType = UIKeyboardTypeNumberPad;
    beizhuText.delegate=self;
    //        text.placeholder=[placeholderArray objectAtIndex:i];
    beizhuText.font=[UIFont systemFontOfSize:15];
    NSString *beizhuTextcontent=[contentArray6 objectAtIndex:5];
    beizhuText.text=[NSString stringWithFormat:@"%@",beizhuTextcontent];
    [textBgView3 addSubview:beizhuText];
    
    UILabel  *jiansegc=[[UILabel alloc]initWithFrame:CGRectMake(20,  1440, Width-40, 20)];
    jiansegc.textAlignment=NSTextAlignmentLeft;
    jiansegc.font=[UIFont systemFontOfSize:14];
    jiansegc.textColor=[UIColor blackColor];
    jiansegc.text=@"建设工程";
    [_mainListView  addSubview:jiansegc];
    
    UIView *textBgView5=[[UIView alloc]initWithFrame:CGRectMake(5, 1470, Width-20, 120)];
    textBgView5.backgroundColor=[UIColor whiteColor];
    textBgView5.layer.borderColor=[UIColor lightGrayColor].CGColor;
    textBgView5.layer.borderWidth=0.5;
    textBgView5.userInteractionEnabled=YES;
    [_mainListView addSubview:textBgView5];
    NSArray *labelArray7=@[@"结构种类",@"层数",@"幢数",@"高度(m)",@"占地面积"];
     NSMutableArray *contentArray7=[[NSMutableArray alloc]initWithObjects:[self getString:[self.commitData objectForKey:@"jsgcjgzl1"]],[self getString:[self.commitData objectForKey:@"jsgccs1"]],[self getString:[self.commitData objectForKey:@"jsgcds1"]],[self getString:[self.commitData objectForKey:@"jsgcgd1"]],[self getString:[self.commitData objectForKey:@"jsgczdmj1"]],[self getString:[self.commitData objectForKey:@"jsgcjgzl2"]],[self getString:[self.commitData objectForKey:@"jsgccs2"]],[self getString:[self.commitData objectForKey:@"jsgcds2"]],[self getString:[self.commitData objectForKey:@"jsgcgd2"]],[self getString:[self.commitData objectForKey:@"jsgczdmj2"]], nil];
    if ([self.commitData objectForKey:@"jsgc"]!=NULL||[self.commitData objectForKey:@"jsgc"]!=nil) {
        contentArray7=[[NSMutableArray alloc]init];
        NSString *jsgc=[self.commitData objectForKey:@"jsgc"];
        NSRange startRange = [jsgc rangeOfString:@"["];
        NSRange endRange = [jsgc rangeOfString:@"]"];
        NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
        NSString *result = [jsgc substringWithRange:range];
        NSArray *resultArray=[result componentsSeparatedByString:@","];
        for (int m=0; m<resultArray.count; m++) {
            NSString *item1=[resultArray objectAtIndex:m];
            item1 = [item1 stringByReplacingOccurrencesOfString:@"{" withString:@""];
            item1 = [item1 stringByReplacingOccurrencesOfString:@"}" withString:@""];
            [contentArray7 addObject:item1];
        }
    }
    NSLog(@"contentArray7   %@",contentArray7);
    for (int i=0; i<5; i++) {
        UIView *textBgView=[[UIView alloc]initWithFrame:CGRectMake((Width-20)/5*i,0, (Width-20)/5, 40)];
        textBgView.backgroundColor=[UIColor whiteColor];
        textBgView.layer.borderColor=[UIColor lightGrayColor].CGColor;
        textBgView.layer.borderWidth=0.5;
        textBgView.userInteractionEnabled=YES;
        [textBgView5 addSubview:textBgView];
        
        UILabel  *label1=[[UILabel alloc]initWithFrame:CGRectMake(5,  5, (Width-20)/5-10, 30)];
        label1.textAlignment=NSTextAlignmentCenter;
        label1.numberOfLines=5;
        label1.adjustsFontSizeToFitWidth=YES;
        label1.font=[UIFont systemFontOfSize:14];
        label1.textColor=[UIColor blackColor];
        label1.text=[labelArray7 objectAtIndex:i];
        [textBgView  addSubview:label1];
        
        UITextField *text1=[[UITextField alloc]initWithFrame:CGRectMake((Width-20)/5*i, 40, (Width-20)/5, 40)];
        text1.layer.borderColor=[UIColor lightGrayColor].CGColor;
        text1.layer.borderWidth=0.5;
        text1.tag=70+i;
        //            text.keyboardType = UIKeyboardTypeNumberPad;
        text1.delegate=self;
        //        text.placeholder=[placeholderArray objectAtIndex:i];
        text1.font=[UIFont systemFontOfSize:15];
                NSString *content1=[contentArray7 objectAtIndex:i];
                text1.text=[NSString stringWithFormat:@"%@",content1];
        [textBgView5 addSubview:text1];
        
        
        UITextField *text2=[[UITextField alloc]initWithFrame:CGRectMake((Width-20)/5*i, 80, (Width-20)/5, 40)];
        text2.layer.borderColor=[UIColor lightGrayColor].CGColor;
        text2.layer.borderWidth=0.5;
        text2.tag=75+i;
        //            text.keyboardType = UIKeyboardTypeNumberPad;
        text2.delegate=self;
        //        text.placeholder=[placeholderA  rray objectAtIndex:i];
        text2.font=[UIFont systemFontOfSize:15];
        NSString *content2=[contentArray7 objectAtIndex:i+5];
        text2.text=[NSString stringWithFormat:@"%@",content2];
        [textBgView5 addSubview:text2];
    }
}

-(void)illustrate{
    HZIllustrateViewController1 *illustrate=[[HZIllustrateViewController1 alloc]init];
    [self.navigationController pushViewController:illustrate animated:YES];
}
//MARK:判空
-(NSString *)getString:(NSString *)currentStr{
    if ([currentStr isEqual:[NSNull null]]||currentStr==nil||currentStr==NULL||[currentStr isEqualToString:@""]) {
        currentStr=@"";
    }
    return currentStr;
}
#pragma mark - UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView isEqual:_detailText1]) {
        _mainBgView.contentOffset=CGPointMake(0, 160);
    }else{
        _mainBgView.contentOffset=CGPointMake(0, 560);
    }
    
}
-(void)textViewDidChange:(UITextView *)textView{
    if ([textView isEqual:_detailText1]) {
        self.placehoderLabel1.hidden=YES;
    }else{
        self.placehoderLabel2.hidden=YES;
    }
    
    
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    _mainBgView.contentOffset=CGPointMake(0, 0);
    [self.view endEditing:YES];
    
    if (textView.text==NULL||[textView.text isEqualToString:@""]) {
        if ([textView isEqual:_detailText1]) {
            self.placehoderLabel1.hidden=NO;
        }else if ([textView isEqual:_detailText2]){
            self.placehoderLabel2.hidden=NO;
        }
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([textView.text length]>=200)
    {
        textView.text = [textView.text substringToIndex:199];
    }
    else
    {
        return YES;
    }
    
    return YES;
}

-(void)commit{
    UITextField *textfield1=[self.view viewWithTag:10];
    UITextField *textfield2=[self.view viewWithTag:11];
    UITextField *textfield3=[self.view viewWithTag:12];
    UITextField *textfield4=[self.view viewWithTag:13];
    UITextField *textfield5=[self.view viewWithTag:14];
    UITextField *textfield6=[self.view viewWithTag:15];
    UITextField *textfield7=[self.view viewWithTag:16];
    UITextField *textfield8=[self.view viewWithTag:17];
    
    UITextField *textfield21=[self.view viewWithTag:20];//区
    UITextField *textfield22=[self.view viewWithTag:21];//路
    
    UITextField *textfield23=[self.view viewWithTag:22];//起点
    UITextField *textfield24=[self.view viewWithTag:23];//终点
    
    //道路（公路）
    UITextField *textfield31=[self.view viewWithTag:30];//长度（米
    UITextField *textfield32=[self.view viewWithTag:31];//宽度
    UITextField *textfield33=[self.view viewWithTag:32];//横断面布置(
    UITextField *textfield34=[self.view viewWithTag:33];//长度（米
    UITextField *textfield35=[self.view viewWithTag:34];//宽度
    UITextField *textfield36=[self.view viewWithTag:35];//横断面布置(
    
    //桥        梁
    UITextField *textfield41=[self.view viewWithTag:40];//长度
    UITextField *textfield42=[self.view viewWithTag:41];//宽度
    UITextField *textfield43=[self.view viewWithTag:42];//梁底标高(
    UITextField *textfield44=[self.view viewWithTag:43];//形式
    UITextField *textfield45=[self.view viewWithTag:44];//长度
    UITextField *textfield46=[self.view viewWithTag:45];///宽度
    UITextField *textfield47=[self.view viewWithTag:46];//梁底标高(
    UITextField *textfield48=[self.view viewWithTag:47];//形式
    
    //驳　      坎
    UITextField *textfield51=[self.view viewWithTag:50];//长度
    UITextField *textfield52=[self.view viewWithTag:51];//二级驳坎）克顶标高
    UITextField *textfield53=[self.view viewWithTag:52];//长度
    UITextField *textfield54=[self.view viewWithTag:53];//二级驳坎）克顶标高
    
    //管线工程
    UITextField *textfield61=[self.view viewWithTag:60];//名称
    UITextField *textfield62=[self.view viewWithTag:61];//架空管线
    UITextField *textfield63=[self.view viewWithTag:62];//地下管线
    UITextField *textfield64=[self.view viewWithTag:63];//架空管线
    UITextField *textfield65=[self.view viewWithTag:64];//地下管线
    UITextField *textfield66=[self.view viewWithTag:65];//备注
    
    //建设工程
    UITextField *textfield70=[self.view viewWithTag:70];//
    UITextField *textfield71=[self.view viewWithTag:71];//
    UITextField *textfield72=[self.view viewWithTag:72];//
    UITextField *textfield73=[self.view viewWithTag:73];//
    UITextField *textfield74=[self.view viewWithTag:74];//
    UITextField *textfield75=[self.view viewWithTag:75];//
    UITextField *textfield76=[self.view viewWithTag:76];//
    UITextField *textfield77=[self.view viewWithTag:77];//
    UITextField *textfield78=[self.view viewWithTag:78];//
    UITextField *textfield79=[self.view viewWithTag:79];//
    
    
   if ([textfield1.text length]==0||[textfield2.text length]==0||[textfield3.text length]==0||[textfield4.text length]==0||[textfield5.text length]==0||[textfield6.text length]==0||[textfield7.text length]==0||[textfield8.text length]==0||[textfield21.text length]==0||[textfield22.text length]==0||[textfield23.text length]==0||[textfield24.text length]==0||[_detailText1.text length]==0) {
        [self.view makeToast:@"请把带*标记的必填项目填写完整" duration:2 position:CSToastPositionCenter];
        return;
    }
    if ([textfield31.text length]==0||[textfield32.text length]==0||[textfield33.text length]==0||[textfield34.text length]==0||[textfield35.text length]==0||[textfield36.text length]==0) {
        [self.view makeToast:@"请把带*标记的必填项目填写完整" duration:2 position:CSToastPositionCenter];
        return;
    }
    if ([textfield41.text length]==0||[textfield42.text length]==0||[textfield43.text length]==0||[textfield44.text length]==0||[textfield45.text length]==0||[textfield46.text length]==0||[textfield47.text length]==0||[textfield48.text length]==0) {
        [self.view makeToast:@"请把带*标记的必填项目填写完整" duration:2 position:CSToastPositionCenter];
        return;
    }
    if ([textfield51.text length]==0||[textfield52.text length]==0||[textfield53.text length]==0||[textfield54.text length]==0) {
        [self.view makeToast:@"请把带*标记的必填项目填写完整" duration:2 position:CSToastPositionCenter];
        return;
    }
    
 
    if ([BSRegexValidate stringContainsEmoji:_detailText1.text]||[BSRegexValidate stringContainsEmoji:_detailText2.text]) {
        [self.view makeToast:@"不能输入表情" duration:2 position:CSToastPositionCenter];
        return;
    }
    if (![BSRegexValidate validateTelephone:textfield4.text]) {
        [self.view makeToast:@"手机号码格式不正确" duration:2 position:CSToastPositionCenter];
        return;
    }
    if (![BSRegexValidate validateTelephone:textfield7.text]) {
        [self.view makeToast:@"设计人手机号码格式不正确" duration:2 position:CSToastPositionCenter];
        return;
    }
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    [dic setObject:textfield1.text forKey:@"sqr"];
    [dic setObject:textfield2.text forKey:@"wtr"];
    [dic setObject:textfield3.text forKey:@"lxdh"];
    [dic setObject:textfield4.text forKey:@"sjh"];
    [dic setObject:textfield5.text forKey:@"sjdw"];
    [dic setObject:textfield6.text forKey:@"sjr"];
    [dic setObject:textfield7.text forKey:@"shrsj"];
    [dic setObject:textfield8.text forKey:@"xmmc"];
    
    [dic setObject:textfield21.text forKey:@"jsdzq"];
    [dic setObject:textfield22.text forKey:@"jsdzl"];
    [dic setObject:textfield23.text forKey:@"qd"];
    [dic setObject:textfield24.text forKey:@"zd"];
    
    [dic setObject:_detailText1.text forKey:@"jsnrjgm"];
   //道路公路
    NSString *dlglcd1=textfield31.text;
    [dic setObject:dlglcd1 forKey:@"dlglcd1"];
    NSString *dlglkd1=textfield32.text;
    [dic setObject:dlglkd1 forKey:@"dlglkd1"];
    NSString *dlglhdm1=textfield33.text;
     [dic setObject:dlglhdm1 forKey:@"dlglhdm1"];
    NSString *dlglcd2=textfield34.text;
     [dic setObject:dlglcd2 forKey:@"dlglcd2"];
    NSString *dlglkd2=textfield35.text;
     [dic setObject:dlglkd2 forKey:@"dlglkd2"];
    NSString *dlglhdm3=textfield36.text;
     [dic setObject:dlglhdm3 forKey:@"dlglhdm3"];
    NSString *dlgl=[NSString stringWithFormat:@"[{%@,%@,%@},{%@,%@,%@}]",dlglcd1,dlglkd1,dlglhdm1,dlglcd2,dlglkd2,dlglhdm3];
    [dic setObject:dlgl forKey:@"dlgl"];
    //桥梁
    NSString *qlcd1=textfield41.text;
    [dic setObject:qlcd1 forKey:@"qlcd1"];
    NSString *qlkd1=textfield42.text;
    [dic setObject:qlkd1 forKey:@"qlkd1"];
    NSString *qlldbg1=textfield43.text;
    [dic setObject:qlldbg1 forKey:@"qlldbg1"];
    NSString *qlxs1=textfield44.text;
    [dic setObject:qlxs1 forKey:@"qlxs1"];
    NSString *qlcd2=textfield45.text;
    [dic setObject:qlcd2 forKey:@"qlcd2"];
    NSString *qlkd2=textfield46.text;
    [dic setObject:qlkd2 forKey:@"qlkd2"];
    NSString *qlldbg2=textfield47.text;
    [dic setObject:qlldbg2 forKey:@"qlldbg2"];
    NSString *qlxs2=textfield48.text;
    [dic setObject:qlxs2 forKey:@"qlxs2"];
    
    NSString *ql=[NSString stringWithFormat:@"[{%@,%@,%@,%@},{%@,%@,%@,%@}]",textfield41.text,textfield42.text,textfield43.text,textfield44.text,textfield45.text,textfield46.text,textfield47.text,textfield48.text];
    [dic setObject:ql forKey:@"ql"];
     //驳坎
    NSString *bkcd1=textfield51.text;
    [dic setObject:bkcd1 forKey:@"bkcd1"];
    NSString *bkbg1=textfield52.text;
    [dic setObject:bkbg1 forKey:@"bkbg1"];
    NSString *bkcd2=textfield53.text;
    [dic setObject:bkcd2 forKey:@"bkcd2"];
    NSString *bkbg2=textfield54.text;
    [dic setObject:bkbg2 forKey:@"bkbg2"];
    
    NSString *bk=[NSString stringWithFormat:@"[{%@,%@},{%@,%@}]",textfield51.text,textfield52.text,textfield53.text,textfield54.text];
    [dic setObject:bk forKey:@"bk"];
    
    //管线工程
    NSString *gxgcmc=@"";//名称
    if (textfield61.text==NULL) {
        [dic setObject:@"" forKey:@"gxgcmc"];
    }else{
        [dic setObject:textfield61.text forKey:@"gxgcmc"];
        gxgcmc=textfield61.text;
    }
    NSString *gxgccd1=@"";//长度1
    if (textfield62.text==NULL) {
        [dic setObject:@"" forKey:@"gxgccd1"];
    }else{
        [dic setObject:textfield62.text forKey:@"gxgccd1"];
        gxgccd1=textfield62.text;
    }
    NSString *gxgcgg=@"";//规格
    if (textfield63.text==NULL) {
        [dic setObject:@"" forKey:@"gxgcgg"];
    }else{
        [dic setObject:textfield63.text forKey:@"gxgcgg"];
         gxgcgg=textfield63.text;
    }
    NSString *gxgccd2=@"";//长度2
    if (textfield64.text==NULL) {
        [dic setObject:@"" forKey:@"gxgccd2"];
    }else{
        [dic setObject:textfield64.text forKey:@"gxgccd2"];
        gxgccd2=textfield64.text;
    }
    NSString *gxgcgw=@"";//管位
    if (textfield65.text==NULL) {
        [dic setObject:@"" forKey:@"gxgcgw"];
    }else{
        [dic setObject:textfield65.text forKey:@"gxgcgw"];
         gxgcgw=textfield65.text;
    }
    NSString *gxgcbz=@"";//备注
    if (textfield66.text==NULL) {
        [dic setObject:@"" forKey:@"gxgcbz"];
    }else{
        [dic setObject:textfield66.text forKey:@"gxgcbz"];
        gxgcbz=textfield66.text;
    }
    NSString *gxgc= [NSString stringWithFormat:@"{%@,%@,%@,%@,%@,%@}",gxgcmc,gxgccd1,gxgcgg,gxgccd2,gxgcgw,gxgcbz];
    [dic setObject:gxgc forKey:@"gxgc"];
    
    //建设工程
    NSString *jsgcjgzl1=@"";
    if (textfield70.text==NULL) {
        [dic setObject:@"" forKey:@"jsgcjgzl1"];
    }else{
        [dic setObject:textfield70.text forKey:@"jsgcjgzl1"];
        jsgcjgzl1=textfield70.text;
    }
    NSString *jsgccs1=@"";//
    if (textfield71.text==NULL) {
        [dic setObject:@"" forKey:@"jsgccs1"];
    }else{
        [dic setObject:textfield71.text forKey:@"jsgccs1"];
        jsgccs1=textfield71.text;
    }
    NSString *jsgcds1=@"";
    if (textfield72.text==NULL) {
        [dic setObject:@"" forKey:@"jsgcds1"];
    }else{
        [dic setObject:textfield72.text forKey:@"jsgcds1"];
        jsgcds1=textfield72.text;
    }
    NSString *jsgcgd1=@"";//高度
    if (textfield73.text==NULL) {
        [dic setObject:@"" forKey:@"jsgcgd1"];
    }else{
        [dic setObject:textfield73.text forKey:@"jsgcgd1"];
        jsgcgd1=textfield73.text;
    }
    NSString *jsgczdmj1=@"";//占地面积
    if (textfield74.text==NULL) {
        [dic setObject:@"" forKey:@"jsgczdmj1"];
    }else{
        [dic setObject:textfield74.text forKey:@"jsgczdmj1"];
        jsgczdmj1=textfield74.text;
    }
    NSString *jsgcjgzl2=@"";
    if (textfield75.text==NULL) {
        [dic setObject:@"" forKey:@"jsgcjgzl2"];
    }else{
        [dic setObject:textfield75.text forKey:@"jsgcjgzl2"];
        jsgcjgzl2=textfield75.text;
    }
    NSString *jsgccs2=@"";//
    if (textfield76.text==NULL) {
        [dic setObject:@"" forKey:@"jsgccs2"];
    }else{
        [dic setObject:textfield76.text forKey:@"jsgccs2"];
        jsgccs2=textfield76.text;
    }
    NSString *jsgcds2=@"";
    if (textfield77.text==NULL) {
        [dic setObject:@"" forKey:@"jsgcds2"];
    }else{
        [dic setObject:textfield77.text forKey:@"jsgcds2"];
        jsgcds2=textfield77.text;
    }
    NSString *jsgcgd2=@"";//高度
    if (textfield78.text==NULL) {
        [dic setObject:@"" forKey:@"jsgcgd2"];
    }else{
        [dic setObject:textfield78.text forKey:@"jsgcgd2"];
        jsgcgd2=textfield78.text;
    }
    NSString *jsgczdmj2=@"";//占地面积
    if (textfield79.text==NULL) {
        [dic setObject:@"" forKey:@"jsgczdmj2"];
    }else{
        [dic setObject:textfield79.text forKey:@"jsgczdmj2"];
        jsgczdmj2=textfield79.text;
    }
    NSString *jsgc= [NSString stringWithFormat:@"[{%@,%@,%@,%@,%@},{%@,%@,%@,%@,%@}]",textfield70.text,textfield71.text,textfield72.text,textfield73.text,textfield74.text,textfield75.text,textfield76.text,textfield77.text,textfield78.text,textfield79.text];
    [dic setObject:jsgc forKey:@"jsgc"];
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"保存成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray *vcArray = self.navigationController.viewControllers;
        for(UIViewController *vc in vcArray)
        {
            if ([vc isKindOfClass:[HZLocateContentViewController class]])
            {
                HZLocateContentViewController *content=(HZLocateContentViewController *)vc;
                content.saveDic=dic;
                content.commitData=dic;
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
        
    }];
    [alert addAction:cancelAlert];
    [self presentViewController:alert animated:YES completion:nil];
    NSLog(@"saveDic   %@",dic);
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)downKeyboard{
    [self.view endEditing:YES];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    //道路（公路）
    UITextField *textfield31=[self.view viewWithTag:30];//长度（米
    UITextField *textfield32=[self.view viewWithTag:31];//宽度
    UITextField *textfield33=[self.view viewWithTag:32];//横断面布置(
    UITextField *textfield34=[self.view viewWithTag:33];//长度（米
    UITextField *textfield35=[self.view viewWithTag:34];//宽度
    UITextField *textfield36=[self.view viewWithTag:35];//横断面布置(
    if (textfield31==textField||textfield32==textField||textfield33==textField||textfield34==textField||textfield35==textField||textfield36==textField) {
      _mainListView.contentOffset=CGPointMake(0, 300);
    }
    
    //桥        梁
    UITextField *textfield41=[self.view viewWithTag:40];//长度
    UITextField *textfield42=[self.view viewWithTag:41];//宽度
    UITextField *textfield43=[self.view viewWithTag:42];//梁底标高(
    UITextField *textfield44=[self.view viewWithTag:43];//形式
    UITextField *textfield45=[self.view viewWithTag:44];//长度
    UITextField *textfield46=[self.view viewWithTag:45];///宽度
    UITextField *textfield47=[self.view viewWithTag:46];//梁底标高(
    UITextField *textfield48=[self.view viewWithTag:47];//形式
    if (textfield41==textField||textfield42==textField||textfield43==textField||textfield44==textField||textfield45==textField||textfield46==textField||textfield47==textField||textfield48==textField) {
       _mainListView.contentOffset=CGPointMake(0, 300);
    }
    
    //驳　      坎
    UITextField *textfield51=[self.view viewWithTag:50];//长度
    UITextField *textfield52=[self.view viewWithTag:51];//二级驳坎）克顶标高
    UITextField *textfield53=[self.view viewWithTag:52];//长度
    UITextField *textfield54=[self.view viewWithTag:53];//二级驳坎）克顶标高
    if (textfield51==textField||textfield52==textField||textfield53==textField||textfield54==textField) {
       _mainListView.contentOffset=CGPointMake(0, 400);
    }
    //管线工程
    UITextField *textfield61=[self.view viewWithTag:60];//名称
    UITextField *textfield62=[self.view viewWithTag:61];//架空管线
    UITextField *textfield63=[self.view viewWithTag:62];//地下管线
    UITextField *textfield64=[self.view viewWithTag:63];//架空管线
    UITextField *textfield65=[self.view viewWithTag:64];//地下管线
    UITextField *textfield66=[self.view viewWithTag:65];//备注
    if (textfield61==textField||textfield62==textField||textfield63==textField||textfield64==textField||textfield65==textField||textfield66==textField) {
        _mainListView.contentOffset=CGPointMake(0, 300);
    }
    //建设工程
    UITextField *textfield70=[self.view viewWithTag:70];//
    UITextField *textfield71=[self.view viewWithTag:71];//
    UITextField *textfield72=[self.view viewWithTag:72];//
    UITextField *textfield73=[self.view viewWithTag:73];//
    UITextField *textfield74=[self.view viewWithTag:74];//
    UITextField *textfield75=[self.view viewWithTag:75];//
    UITextField *textfield76=[self.view viewWithTag:76];//
    UITextField *textfield77=[self.view viewWithTag:77];//
    UITextField *textfield78=[self.view viewWithTag:78];//
    UITextField *textfield79=[self.view viewWithTag:79];//
    if (textfield70==textField||textfield71==textField||textfield72==textField||textfield73==textField||textfield74==textField||textfield75==textField||textfield76==textField||textfield77==textField||textfield78==textField||textfield79==textField) {
        _mainListView.contentOffset=CGPointMake(0, 300);
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
     _mainListView.contentOffset=CGPointMake(0, 0);
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
-(BOOL)navigationShouldPopOnBackButton{
    UITextField *textfield1=[self.view viewWithTag:10];
    UITextField *textfield2=[self.view viewWithTag:11];
    UITextField *textfield3=[self.view viewWithTag:12];
    UITextField *textfield4=[self.view viewWithTag:13];
    UITextField *textfield5=[self.view viewWithTag:14];
    UITextField *textfield6=[self.view viewWithTag:15];
    UITextField *textfield7=[self.view viewWithTag:16];
    UITextField *textfield8=[self.view viewWithTag:17];
    
    UITextField *textfield21=[self.view viewWithTag:20];//区
    UITextField *textfield22=[self.view viewWithTag:21];//路
    
    UITextField *textfield23=[self.view viewWithTag:22];//起点
    UITextField *textfield24=[self.view viewWithTag:23];//终点
    
    //道路（公路）
    UITextField *textfield31=[self.view viewWithTag:30];//长度（米
    UITextField *textfield32=[self.view viewWithTag:31];//宽度
    UITextField *textfield33=[self.view viewWithTag:32];//横断面布置(
    UITextField *textfield34=[self.view viewWithTag:33];//长度（米
    UITextField *textfield35=[self.view viewWithTag:34];//宽度
    UITextField *textfield36=[self.view viewWithTag:35];//横断面布置(
    
    //桥        梁
    UITextField *textfield41=[self.view viewWithTag:40];//长度
    UITextField *textfield42=[self.view viewWithTag:41];//宽度
    UITextField *textfield43=[self.view viewWithTag:42];//梁底标高(
    UITextField *textfield44=[self.view viewWithTag:43];//形式
    UITextField *textfield45=[self.view viewWithTag:44];//长度
    UITextField *textfield46=[self.view viewWithTag:45];///宽度
    UITextField *textfield47=[self.view viewWithTag:46];//梁底标高(
    UITextField *textfield48=[self.view viewWithTag:47];//形式
    
    //驳　      坎
    UITextField *textfield51=[self.view viewWithTag:50];//长度
    UITextField *textfield52=[self.view viewWithTag:51];//二级驳坎）克顶标高
    UITextField *textfield53=[self.view viewWithTag:52];//长度
    UITextField *textfield54=[self.view viewWithTag:53];//二级驳坎）克顶标高
    
    //管线工程
    UITextField *textfield61=[self.view viewWithTag:60];//名称
    UITextField *textfield62=[self.view viewWithTag:61];//架空管线
    UITextField *textfield63=[self.view viewWithTag:62];//地下管线
    UITextField *textfield64=[self.view viewWithTag:63];//架空管线
    UITextField *textfield65=[self.view viewWithTag:64];//地下管线
    UITextField *textfield66=[self.view viewWithTag:65];//备注
    
    //建设工程
    UITextField *textfield70=[self.view viewWithTag:70];//
    UITextField *textfield71=[self.view viewWithTag:71];//
    UITextField *textfield72=[self.view viewWithTag:72];//
    UITextField *textfield73=[self.view viewWithTag:73];//
    UITextField *textfield74=[self.view viewWithTag:74];//
    UITextField *textfield75=[self.view viewWithTag:75];//
    UITextField *textfield76=[self.view viewWithTag:76];//
    UITextField *textfield77=[self.view viewWithTag:77];//
    UITextField *textfield78=[self.view viewWithTag:78];//
    UITextField *textfield79=[self.view viewWithTag:79];//
    
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    [dic setObject:[self getString:textfield1.text] forKey:@"sqr"];
    [dic setObject:[self getString:textfield2.text] forKey:@"wtr"];
    [dic setObject:[self getString:textfield3.text] forKey:@"lxdh"];
    [dic setObject:[self getString:textfield4.text] forKey:@"sjh"];
    [dic setObject:[self getString:textfield5.text] forKey:@"sjdw"];
    [dic setObject:[self getString:textfield6.text] forKey:@"sjr"];
    [dic setObject:[self getString:textfield7.text] forKey:@"shrsj"];
      [dic setObject:[self getString:textfield8.text] forKey:@"xmmc"];
    
     [dic setObject:[self getString:_detailText1.text] forKey:@"jsnrjgm"];
    
    [dic setObject:[self getString:textfield21.text] forKey:@"jsdzq"];
    [dic setObject:[self getString:textfield22.text] forKey:@"jsdzl"];
    
    [dic setObject:[self getString:textfield23.text] forKey:@"qd"];
    [dic setObject:[self getString:textfield24.text] forKey:@"zd"];
    
    
    //道路公路
    [dic setObject:[self getString:textfield31.text] forKey:@"dlglcd1"];
    [dic setObject:[self getString:textfield32.text] forKey:@"dlglkd1"];
      [dic setObject:[self getString:textfield33.text] forKey:@"dlglhdm1"];
      [dic setObject:[self getString:textfield34.text] forKey:@"dlglcd2"];
     [dic setObject:[self getString:textfield35.text] forKey:@"dlglkd2"];
     [dic setObject:[self getString:textfield36.text] forKey:@"dlglhdm3"];
  
    //桥梁
    [dic setObject:[self getString:textfield41.text] forKey:@"qlcd1"];
    [dic setObject:[self getString:textfield42.text] forKey:@"qlkd1"];
    [dic setObject:[self getString:textfield43.text] forKey:@"qlldbg1"];
    [dic setObject:[self getString:textfield44.text] forKey:@"qlxs1"];
    [dic setObject:[self getString:textfield45.text] forKey:@"qlcd2"];
    [dic setObject:[self getString:textfield46.text] forKey:@"qlkd2"];
    [dic setObject:[self getString:textfield47.text] forKey:@"qlldbg2"];
    [dic setObject:[self getString:textfield48.text] forKey:@"qlxs2"];
    
    
    //驳坎
    [dic setObject:[self getString:textfield51.text] forKey:@"bkcd1"];
    [dic setObject:[self getString:textfield52.text] forKey:@"bkbg1"];
    [dic setObject:[self getString:textfield53.text] forKey:@"bkcd2"];
    [dic setObject:[self getString:textfield54.text] forKey:@"bkbg2"];
    
    //管线工程
    [dic setObject:[self getString:textfield61.text] forKey:@"gxgcmc"];
    [dic setObject:[self getString:textfield62.text] forKey:@"gxgccd1"];
    [dic setObject:[self getString:textfield63.text] forKey:@"gxgcgg"];
    [dic setObject:[self getString:textfield64.text] forKey:@"gxgccd2"];
    [dic setObject:[self getString:textfield65.text] forKey:@"gxgcgw"];
    [dic setObject:[self getString:textfield66.text] forKey:@"gxgcbz"];
  
    //建设工程
    [dic setObject:[self getString:textfield70.text] forKey:@"jsgcjgzl1"];
    [dic setObject:[self getString:textfield71.text] forKey:@"jsgccs1"];
    [dic setObject:[self getString:textfield72.text] forKey:@"jsgcds1"];
    [dic setObject:[self getString:textfield73.text] forKey:@"jsgcgd1"];
    [dic setObject:[self getString:textfield74.text] forKey:@"jsgczdmj1"];
    [dic setObject:[self getString:textfield75.text] forKey:@"jsgcjgzl2"];
    [dic setObject:[self getString:textfield76.text] forKey:@"jsgccs2"];
    [dic setObject:[self getString:textfield77.text] forKey:@"jsgcds2"];
    [dic setObject:[self getString:textfield78.text] forKey:@"jsgcgd2"];
    [dic setObject:[self getString:textfield79.text] forKey:@"jsgczdmj2"];
    
    NSArray *vcArray = self.navigationController.viewControllers;
    for(UIViewController *vc in vcArray)
    {
        if ([vc isKindOfClass:[HZLocateContentViewController class]])
        {
            HZLocateContentViewController *content=(HZLocateContentViewController *)vc;
            content.commitData=dic;
            NSLog(@"dic    %@   content.commitData    %@",dic,content.commitData);
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
    
    return NO;
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
