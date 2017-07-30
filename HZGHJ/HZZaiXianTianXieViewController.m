//
//  HZZaiXianTianXieViewController.m
//  HZGHJ
//
//  Created by zhang on 2017/7/4.
//  Copyright © 2017年 FiveFu. All rights reserved.
//

#import "HZZaiXianTianXieViewController.h"
#import "HZIllustrateViewController1.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "BSRegexValidate.h"

@interface HZZaiXianTianXieViewController ()<UITextViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    UIButton *_rightBarBtn;
    UIScrollView *_mainBgView;//整个scrollview
     UIScrollView *_mainListView;//网格scrollview
     UITextView *_detailText1;
     UITextView *_detailText2;
    
    NSString* _isCheck;
}
@end

@implementation HZZaiXianTianXieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回"style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.title=@"选址申请表填写";
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(downKeyboard)];
    tap.delegate=self;
    [_mainBgView addGestureRecognizer:tap];
    _rightBarBtn = [[UIButton alloc] initWithFrame                                                                      :CGRectMake(15, 5, 80, 20)];
    [_rightBarBtn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [_rightBarBtn addTarget:self action:@selector(illustrate) forControlEvents:UIControlEventTouchUpInside];
    [_rightBarBtn setTitle:@"说明" forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBarBtn];
    self.navigationItem.rightBarButtonItem = leftItem;

    _mainBgView=[[UIScrollView alloc]init];
    _mainBgView.showsVerticalScrollIndicator=NO;
    _mainBgView.frame=CGRectMake(0, 0, Width, Height-44);
    _mainBgView.contentSize=CGSizeMake(Width, 940);
    _mainBgView.userInteractionEnabled=YES;
    [self.view addSubview:_mainBgView];
    _mainListView=[[UIScrollView alloc]init];
    _mainListView.frame=CGRectMake(5, 10, Width-10,800);
    _mainListView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _mainListView.layer.borderWidth=1;
    _mainListView.userInteractionEnabled=YES;
    [_mainBgView addSubview:_mainListView];
    if (self.commitData==NULL||self.commitData==nil) {
        [self addMainListView];
    }else{
        [self addReMainListView];
    }
    
    UIButton *commit=[[UIButton alloc]initWithFrame:CGRectMake(20,840, Width-40, 40)];
    [commit addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    commit.backgroundColor=[UIColor colorWithRed:23/255.0 green:177/255.0 blue:242/255.0 alpha:1];
    commit.clipsToBounds=YES;
    commit.layer.cornerRadius=8;
    [commit setTitle:@"确定" forState:UIControlStateNormal];
    [_mainBgView addSubview:commit];
}
//MARK:绘制已完成主表格视图
-(void)addReMainListView{
    NSArray *nameLabelaArray=@[@"申请人(全称) :",@"法定代表人 :",@"受托人 :",@"手机 :",@"项目名称 :",@"电话 :"];
    NSUserDefaults  *def=[NSUserDefaults standardUserDefaults];
    for (int i=0; i<6; i++) {
        UIView *nameLabelView1=[[UIView alloc]initWithFrame:CGRectMake(0, 50*i,Width-10, 50)];
        nameLabelView1.userInteractionEnabled=YES;
        nameLabelView1.layer.borderColor=[UIColor lightGrayColor].CGColor;
        nameLabelView1.layer.borderWidth=1;
        [_mainListView addSubview:nameLabelView1];
        
        if (i<5) {
            UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 15, 20, 20)];
            imageview.image=[UIImage imageNamed:@"must_pic.png"];
            [nameLabelView1 addSubview:imageview];
        }
        UILabel  *label1=[[UILabel alloc]initWithFrame:CGRectMake(20,  0, 100, 50)];
        label1.textAlignment=NSTextAlignmentLeft;
        label1.numberOfLines=2;
        label1.font=[UIFont systemFontOfSize:15];
        label1.text=[nameLabelaArray objectAtIndex:i];
        [nameLabelView1  addSubview:label1];
        UITextField *text=[[UITextField alloc]initWithFrame:CGRectMake(120, 0, Width -130, 50)];
        text.tag=10+i;
        //            text.keyboardType = UIKeyboardTypeNumberPad;
        text.delegate=self;
        //        text.placeholder=[placeholderArray objectAtIndex:i];
        text.font=[UIFont systemFontOfSize:15];
        [nameLabelView1 addSubview:text];
    }
    NSArray *labelArray2=@[@"建设内容及规模：",@"项目情况说明："];
    for (int i=0; i<2; i++) {
        UIView *textBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 300+340*i, Width-10, 160)];
        textBgView.backgroundColor=[UIColor whiteColor];
        textBgView.layer.borderColor=[UIColor lightGrayColor].CGColor;
        textBgView.layer.borderWidth=1;
        textBgView.userInteractionEnabled=YES;
        [_mainListView addSubview:textBgView];
        
        UILabel  *label1=[[UILabel alloc]initWithFrame:CGRectMake(20,  10, 200, 20)];
        label1.textAlignment=NSTextAlignmentLeft;
        label1.font=[UIFont systemFontOfSize:15];
        label1.textColor=[UIColor grayColor];
        label1.text=[labelArray2 objectAtIndex:i];
        [textBgView  addSubview:label1];
        
        if (i==0) {
            _detailText1=[[UITextView alloc]initWithFrame:CGRectMake(5, 40, Width-20, 115)];
            _detailText1.layer.borderWidth=1;
            _detailText1.layer.borderColor=blueCyan.CGColor;
            _detailText1.clipsToBounds=YES;
            _detailText1.layer.cornerRadius=5;
            _detailText1.delegate=self;
            _detailText1.clearsOnInsertion=YES;
            [_detailText1 resignFirstResponder];
            _detailText1.font=[UIFont systemFontOfSize:15];
            [textBgView addSubview:_detailText1];
            self.placehoderLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, _detailText1.frame.size.width-40, 30)];
            self.placehoderLabel1.text = @"(长度不得超过200字)";
            self.placehoderLabel1.textColor=[UIColor grayColor];
            
            self.placehoderLabel1.font = [UIFont systemFontOfSize:14.0];
            
            [_detailText1 addSubview:self.placehoderLabel1];
        }else{
            UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 20, 20)];
            imageview.image=[UIImage imageNamed:@"must_pic.png"];
            [textBgView addSubview:imageview];
            _detailText2=[[UITextView alloc]initWithFrame:CGRectMake(5, 40, Width-20, 115)];
            _detailText2.layer.borderWidth=1;
            _detailText2.layer.borderColor=blueCyan.CGColor;
            _detailText2.clipsToBounds=YES;
            _detailText2.layer.cornerRadius=5;
            _detailText2.delegate=self;
            _detailText2.clearsOnInsertion=YES;
            [_detailText2 resignFirstResponder];
            _detailText2.font=[UIFont systemFontOfSize:15];
            [textBgView addSubview:_detailText2];
            self.placehoderLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, _detailText2.frame.size.width-40, 30)];
            self.placehoderLabel2.text = @"(长度不得超过200字)";
            self.placehoderLabel2.textColor=[UIColor grayColor];
            
            self.placehoderLabel2.font = [UIFont systemFontOfSize:14.0];
            
            [_detailText2 addSubview:self.placehoderLabel2];
        }
        
    }
    
    NSArray *labelArray3=@[@"建设地址：",@"选址论证报告："];
    NSArray *labelArray4=@[@"(区)",@"(路)"];
    NSArray *labelArray5=@[@"有",@"无"];
    //建设地址  论址报告
    for (int i=0; i<2; i++) {
        UIView *textBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 460+130*i, Width-10, 50)];
        textBgView.backgroundColor=[UIColor whiteColor];
        textBgView.layer.borderColor=[UIColor lightGrayColor].CGColor;
        textBgView.layer.borderWidth=1;
        textBgView.userInteractionEnabled=YES;
        [_mainListView addSubview:textBgView];
        UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 15, 20, 20)];
        imageview.image=[UIImage imageNamed:@"must_pic.png"];
        [textBgView addSubview:imageview];
        
        UILabel  *label1=[[UILabel alloc]initWithFrame:CGRectMake(20,  15, 120, 20)];
        label1.textAlignment=NSTextAlignmentLeft;
        label1.font=[UIFont systemFontOfSize:15];
        label1.textColor=[UIColor blackColor];
        label1.text=[labelArray3 objectAtIndex:i];
        [textBgView  addSubview:label1];
        
        if (i==0) {
            label1.frame=CGRectMake(20,  15, 80, 20);
            for (int i=0; i<2; i++) {
                UILabel  *label2=[[UILabel alloc]initWithFrame:CGRectMake(100+(Width-110)/2-40+(Width-110)/2*i,  5, 40, 40)];
                label2.textAlignment=NSTextAlignmentCenter;
                label2.font=[UIFont systemFontOfSize:15];
                label2.text=[labelArray4 objectAtIndex:i];
                [textBgView  addSubview:label2];
                
                UITextField *text=[[UITextField alloc]initWithFrame:CGRectMake(100+(Width-110)/2*i, 5, (Width-110)/2-40, 40)];
                text.tag=20+i;
                text.delegate=self;
                text.font=[UIFont systemFontOfSize:15];
                [textBgView addSubview:text];
            }
        }else{
            for (int i=0; i<2; i++) {
                UILabel  *label2=[[UILabel alloc]initWithFrame:CGRectMake(150+(Width-180)/2*i,  5, 50, 40)];
                label2.textAlignment=NSTextAlignmentCenter;
                label2.font=[UIFont systemFontOfSize:15];
                label2.text=[labelArray5 objectAtIndex:i];
                [textBgView  addSubview:label2];
                
                UIButton *text=[[UIButton alloc]initWithFrame:CGRectMake(120+(Width-180)/2*i, 5, (Width-180)/2-50, 40)];
                [text addTarget:self action:@selector(checkBox:) forControlEvents:UIControlEventTouchUpInside];
                text.tag=30+i;
                [text setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
                [text setImage:[UIImage imageNamed:@"checkbox_fill"] forState:UIControlStateSelected];
                text.titleLabel.font=[UIFont systemFontOfSize:15];
                [textBgView addSubview:text];
            }
        }
        
    }
    NSArray *labelArray6=@[@"东至:",@"南至:",@"西至:",@"北至:"];
    //东西南北
    for (int i=0; i<4; i++) {
        UILabel  *label2=[[UILabel alloc]initWithFrame:CGRectMake(10+(Width-30)/2*(i%2),  510+40*(i/2), 50, 40)];
        label2.textAlignment=NSTextAlignmentCenter;
        label2.font=[UIFont systemFontOfSize:15];
        label2.text=[labelArray6 objectAtIndex:i];
        [_mainListView  addSubview:label2];
        
        UITextField *text=[[UITextField alloc]initWithFrame:CGRectMake(60+(Width-30)/2*(i%2),  510+40*(i/2), (Width-30)/2-50, 40)];
        text.tag=40+i;
        text.delegate=self;
        text.font=[UIFont systemFontOfSize:15];
        [_mainListView addSubview:text];
    }

}
//MARK:绘制主表格视图
-(void)addMainListView{
    NSArray *nameLabelaArray=@[@"申请人(全称) :",@"法定代表人 :",@"受托人 :",@"手机 :",@"项目名称 :",@"电话 :"];
    NSUserDefaults  *def=[NSUserDefaults standardUserDefaults];
    for (int i=0; i<6; i++) {
        UIView *nameLabelView1=[[UIView alloc]initWithFrame:CGRectMake(0, 50*i,Width-10, 50)];
        nameLabelView1.userInteractionEnabled=YES;
        nameLabelView1.layer.borderColor=[UIColor lightGrayColor].CGColor;
        nameLabelView1.layer.borderWidth=1;
        [_mainListView addSubview:nameLabelView1];
        
        if (i<5) {
            UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 15, 20, 20)];
            imageview.image=[UIImage imageNamed:@"must_pic.png"];
            [nameLabelView1 addSubview:imageview];
        }
        UILabel  *label1=[[UILabel alloc]initWithFrame:CGRectMake(20,  0, 100, 50)];
        label1.textAlignment=NSTextAlignmentLeft;
        label1.numberOfLines=2;
        label1.font=[UIFont systemFontOfSize:15];
        label1.text=[nameLabelaArray objectAtIndex:i];
        [nameLabelView1  addSubview:label1];
        UITextField *text=[[UITextField alloc]initWithFrame:CGRectMake(120, 0, Width -130, 50)];
        text.tag=10+i;
//            text.keyboardType = UIKeyboardTypeNumberPad;
        text.delegate=self;
//        text.placeholder=[placeholderArray objectAtIndex:i];
        text.font=[UIFont systemFontOfSize:15];
        [nameLabelView1 addSubview:text];
    }
    NSArray *labelArray2=@[@"建设内容及规模：",@"项目情况说明："];
    for (int i=0; i<2; i++) {
    UIView *textBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 300+340*i, Width-10, 160)];
    textBgView.backgroundColor=[UIColor whiteColor];
    textBgView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    textBgView.layer.borderWidth=1;
    textBgView.userInteractionEnabled=YES;
    [_mainListView addSubview:textBgView];
        
        UILabel  *label1=[[UILabel alloc]initWithFrame:CGRectMake(20,  10, 200, 20)];
        label1.textAlignment=NSTextAlignmentLeft;
        label1.font=[UIFont systemFontOfSize:15];
        label1.textColor=[UIColor grayColor];
        label1.text=[labelArray2 objectAtIndex:i];
        [textBgView  addSubview:label1];
        
        if (i==0) {
            _detailText1=[[UITextView alloc]initWithFrame:CGRectMake(5, 40, Width-20, 115)];
            _detailText1.layer.borderWidth=1;
            _detailText1.layer.borderColor=blueCyan.CGColor;
            _detailText1.clipsToBounds=YES;
            _detailText1.layer.cornerRadius=5;
            _detailText1.delegate=self;
            _detailText1.clearsOnInsertion=YES;
            [_detailText1 resignFirstResponder];
            _detailText1.font=[UIFont systemFontOfSize:15];
            [textBgView addSubview:_detailText1];
            self.placehoderLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, _detailText1.frame.size.width-40, 30)];
            self.placehoderLabel1.text = @"(长度不得超过200字)";
            self.placehoderLabel1.textColor=[UIColor grayColor];
            
            self.placehoderLabel1.font = [UIFont systemFontOfSize:14.0];
            
            [_detailText1 addSubview:self.placehoderLabel1];
        }else{
            UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 20, 20)];
            imageview.image=[UIImage imageNamed:@"must_pic.png"];
            [textBgView addSubview:imageview];
            _detailText2=[[UITextView alloc]initWithFrame:CGRectMake(5, 40, Width-20, 115)];
            _detailText2.layer.borderWidth=1;
            _detailText2.layer.borderColor=blueCyan.CGColor;
            _detailText2.clipsToBounds=YES;
            _detailText2.layer.cornerRadius=5;
            _detailText2.delegate=self;
            _detailText2.clearsOnInsertion=YES;
            [_detailText2 resignFirstResponder];
            _detailText2.font=[UIFont systemFontOfSize:15];
            [textBgView addSubview:_detailText2];
            self.placehoderLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, _detailText2.frame.size.width-40, 30)];
            self.placehoderLabel2.text = @"(长度不得超过200字)";
            self.placehoderLabel2.textColor=[UIColor grayColor];
            
            self.placehoderLabel2.font = [UIFont systemFontOfSize:14.0];
            
            [_detailText2 addSubview:self.placehoderLabel2];
        }
        
    }
    
     NSArray *labelArray3=@[@"建设地址：",@"选址论证报告："];
    NSArray *labelArray4=@[@"(区)",@"(路)"];
    NSArray *labelArray5=@[@"有",@"无"];
    //建设地址  论址报告
    for (int i=0; i<2; i++) {
        UIView *textBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 460+130*i, Width-10, 50)];
        textBgView.backgroundColor=[UIColor whiteColor];
        textBgView.layer.borderColor=[UIColor lightGrayColor].CGColor;
        textBgView.layer.borderWidth=1;
        textBgView.userInteractionEnabled=YES;
        [_mainListView addSubview:textBgView];
            UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 15, 20, 20)];
            imageview.image=[UIImage imageNamed:@"must_pic.png"];
            [textBgView addSubview:imageview];

        UILabel  *label1=[[UILabel alloc]initWithFrame:CGRectMake(20,  15, 120, 20)];
        label1.textAlignment=NSTextAlignmentLeft;
        label1.font=[UIFont systemFontOfSize:15];
        label1.textColor=[UIColor blackColor];
        label1.text=[labelArray3 objectAtIndex:i];
        [textBgView  addSubview:label1];
        
        if (i==0) {
            label1.frame=CGRectMake(20,  15, 80, 20);
            for (int i=0; i<2; i++) {
                UILabel  *label2=[[UILabel alloc]initWithFrame:CGRectMake(100+(Width-110)/2-40+(Width-110)/2*i,  5, 40, 40)];
                label2.textAlignment=NSTextAlignmentCenter;
                label2.font=[UIFont systemFontOfSize:15];
                label2.text=[labelArray4 objectAtIndex:i];
                [textBgView  addSubview:label2];
                
                UITextField *text=[[UITextField alloc]initWithFrame:CGRectMake(100+(Width-110)/2*i, 5, (Width-110)/2-40, 40)];
                text.tag=20+i;
                text.delegate=self;
                text.font=[UIFont systemFontOfSize:15];
                [textBgView addSubview:text];
            }
        }else{
            for (int i=0; i<2; i++) {
                UILabel  *label2=[[UILabel alloc]initWithFrame:CGRectMake(150+(Width-180)/2*i,  5, 50, 40)];
                label2.textAlignment=NSTextAlignmentCenter;
                label2.font=[UIFont systemFontOfSize:15];
                label2.text=[labelArray5 objectAtIndex:i];
                [textBgView  addSubview:label2];
                
                UIButton *text=[[UIButton alloc]initWithFrame:CGRectMake(120+(Width-180)/2*i, 5, (Width-180)/2-50, 40)];
                [text addTarget:self action:@selector(checkBox:) forControlEvents:UIControlEventTouchUpInside];
                text.tag=30+i;
                [text setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
                [text setImage:[UIImage imageNamed:@"checkbox_fill"] forState:UIControlStateSelected];
                text.titleLabel.font=[UIFont systemFontOfSize:15];
                [textBgView addSubview:text];
            }
        }
        
    }
    NSArray *labelArray6=@[@"东至:",@"南至:",@"西至:",@"北至:"];
    //东西南北
    for (int i=0; i<4; i++) {
        UILabel  *label2=[[UILabel alloc]initWithFrame:CGRectMake(10+(Width-30)/2*(i%2),  510+40*(i/2), 50, 40)];
        label2.textAlignment=NSTextAlignmentCenter;
        label2.font=[UIFont systemFontOfSize:15];
        label2.text=[labelArray6 objectAtIndex:i];
        [_mainListView  addSubview:label2];
        
        UITextField *text=[[UITextField alloc]initWithFrame:CGRectMake(60+(Width-30)/2*(i%2),  510+40*(i/2), (Width-30)/2-50, 40)];
        text.tag=40+i;
        text.delegate=self;
        text.font=[UIFont systemFontOfSize:15];
        [_mainListView addSubview:text];
    }
    
}
-(void)checkBox:(UIButton *)sender{
    UIButton *button1=[self.view viewWithTag:30];
    UIButton *button2=[self.view viewWithTag:31];
    if ([button1 isEqual:sender]) {
        button1.selected=YES;
        button2.selected=NO;
        _isCheck=@"1";
    }else{
        button2.selected=YES;
        button1.selected=NO;
         _isCheck=@"0";
    }
}
-(void)illustrate{
    HZIllustrateViewController1 *illustrate=[[HZIllustrateViewController1 alloc]init];
    [self.navigationController pushViewController:illustrate animated:YES];
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
    
    UITextField *textfield21=[self.view viewWithTag:20];//区
    UITextField *textfield22=[self.view viewWithTag:21];//路
    
    UITextField *textfield41=[self.view viewWithTag:40];//东
    UITextField *textfield42=[self.view viewWithTag:41];//南
    UITextField *textfield43=[self.view viewWithTag:42];//西
    UITextField *textfield44=[self.view viewWithTag:43];//北
    
    if (textfield1.text==NULL||textfield2.text==NULL||textfield3.text==NULL||textfield4.text==NULL||textfield5.text==NULL||_detailText2.text==NULL||_isCheck==NULL) {
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
       NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    [dic setObject:textfield1.text forKey:@"sqr"];
    [dic setObject:textfield2.text forKey:@"fddbr"];
    [dic setObject:textfield3.text forKey:@"wtr"];
    [dic setObject:textfield4.text forKey:@"sjh"];
    [dic setObject:textfield5.text forKey:@"xmmc"];
     [dic setObject:textfield21.text forKey:@"jsdzq"];
     [dic setObject:textfield22.text forKey:@"jsdzl"];
    [dic setObject:_isCheck forKey:@"lzbg"];
    [dic setObject:_detailText2.text forKey:@"xmsmqk"];
    if (textfield6.text==NULL) {
        [dic setObject:@" " forKey:@"lxdh"];
    }else{
        [dic setObject:textfield6.text forKey:@"lxdh"];
    }
    if (_detailText1.text==NULL) {
        [dic setObject:@" " forKey:@"jsnrjgm"];
    }else{
        [dic setObject:_detailText1.text forKey:@"jsnrjgm"];
    }
    if (textfield41.text==NULL) {
        [dic setObject:@" " forKey:@"zbdz"];
    }else{
        [dic setObject:textfield41.text forKey:@"zbdz"];
    }
    if (textfield42.text==NULL) {
        [dic setObject:@" " forKey:@"zbnz"];
    }else{
        [dic setObject:textfield42.text forKey:@"zbnz"];
    }
    if (textfield43.text==NULL) {
        [dic setObject:@" " forKey:@"zbxz"];
    }else{
        [dic setObject:textfield43.text forKey:@"zbxz"];
    }
    if (textfield44.text==NULL) {
        [dic setObject:@" " forKey:@"zbbz"];
    }else{
        [dic setObject:textfield44.text forKey:@"zbbz"];
    }
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"保存成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults]setObject:dic forKey:@"saveDic"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }];
    [alert addAction:cancelAlert];
    [self presentViewController:alert animated:YES completion:nil];
       NSLog(@"saveDic   %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"saveDic"]);
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)downKeyboard{
    [self.view endEditing:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
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
