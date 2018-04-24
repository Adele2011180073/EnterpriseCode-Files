//
//  HZZaiXianTianXieViewController3.m
//  HZGHJ
//
//  Created by zhang on 2017/7/31.
//  Copyright © 2017年 FiveFu. All rights reserved.
//

#import "HZZaiXianTianXieViewController9.h"
#import "HZIllustrateViewController1.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "BSRegexValidate.h"
#import "HZLocateContentViewController.h"
#import "UIViewController+BackButtonHandler.h"

@interface HZZaiXianTianXieViewController9 ()<UITextViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    UIButton *_rightBarBtn;
    UIScrollView *_mainBgView;//整个scrollview
    UIScrollView *_mainListView;//网格scrollview
    UITextView *_detailText1;
    UITextView *_detailText2;
    
    NSString* _issclx;//设计方案
  
}


@end

@implementation HZZaiXianTianXieViewController9

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
    titleLabel.text=@"建设工程方案设计审查申请表";
    
    NSLog(@" %@   %@",titleLabel.text,self.commitData);
    if ([[self.commitData objectForKey:@"sclx"]intValue]==1) {
        _issclx=[NSString stringWithFormat:@"%@",[self.commitData objectForKey:@"sclx"]];
    }else if ([[self.commitData objectForKey:@"sclx"]intValue]==2) {
        _issclx=[NSString stringWithFormat:@"%@",[self.commitData objectForKey:@"sclx"]];
    }else{
        _issclx=@"";
    }
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(downKeyboard)];
    tap.delegate=self;
    [_mainBgView addGestureRecognizer:tap];
    _rightBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 5, 80, 20)];
    [_rightBarBtn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [_rightBarBtn addTarget:self action:@selector(illustrate) forControlEvents:UIControlEventTouchUpInside];
    [_rightBarBtn setTitle:@"说明" forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBarBtn];
    self.navigationItem.rightBarButtonItem = leftItem;
    
    _mainBgView=[[UIScrollView alloc]init];
    _mainBgView.showsVerticalScrollIndicator=NO;
    _mainBgView.frame=CGRectMake(0, 40, Width, Height-44-40);
    _mainBgView.contentSize=CGSizeMake(Width, 900+120);
    _mainBgView.userInteractionEnabled=YES;
    [self.view addSubview:_mainBgView];
    _mainListView=[[UIScrollView alloc]init];
    _mainListView.frame=CGRectMake(5, 10, Width-10,900);
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
    NSArray *nameLabelaArray=@[@"申请人(全称) :",@"受托人 :",@"电话 :",@"手机 :",@"设计单位 :",@"设计人:",@"手机 :",@"工程名称 :"];
    NSString *str1=[self.commitData objectForKey:@"sqr"];
    NSString *str2=[self.commitData objectForKey:@"wtr"];
    NSString *str3=[self.commitData objectForKey:@"lxdh"];
    NSString *str4=[self.commitData objectForKey:@"sjh"];
    NSString *str5=[self.commitData objectForKey:@"sjdw"];
    NSString *str6=[self.commitData objectForKey:@"sjr"];
    NSString *str7=[self.commitData objectForKey:@"shrsj"];
    NSString *str8=[self.commitData objectForKey:@"xmmc"];
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
    }  if ([str7 isEqual:[NSNull null]]||str7==nil||str7==NULL||[str7 isEqualToString:@""]) {
        str7=@"";
    }
    if ([str8 isEqual:[NSNull null]]||str8==nil||str8==NULL||[str8 isEqualToString:@""]) {
        str8=@"";
    }
  
    NSArray *nameContentLabelArray=@[str1,str2,str3,str4,str5,str6,str7,str8];
    for (int i=0; i<nameContentLabelArray.count; i++) {
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
        UITextField *text=[[UITextField alloc]initWithFrame:CGRectMake(120, 0, Width -130, 50)];
        text.tag=10+i;
        //            text.keyboardType = UIKeyboardTypeNumberPad;
        text.delegate=self;
        //        text.placeholder=[placeholderArray objectAtIndex:i];
        text.font=[UIFont systemFontOfSize:15];
        NSString *content=[nameContentLabelArray objectAtIndex:i];
        text.text=[NSString stringWithFormat:@"%@",content];
        [nameLabelView1 addSubview:text];
    }
    NSArray *labelArray2=@[@"建设内容及规模：",@"需要补充说明的情况："];
    NSString *str21=[self.commitData objectForKey:@"jsnrjgm"];
    NSString *str22=[self.commitData objectForKey:@"xmsmqk"];
    if ([str21 isEqual:[NSNull null]]||str21==nil||str21==NULL||[str21 isEqualToString:@""]) {
        str21=@"";
    }
    if ([str22 isEqual:[NSNull null]]||str22==nil||str22==NULL||[str22 isEqualToString:@""]) {
        str22=@"";
    }
    NSArray *contentArray2=@[str21,str22];
    for (int i=0; i<2; i++) {
        UIView *textBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 400+340*i, Width-10, 160)];
        textBgView.backgroundColor=[UIColor whiteColor];
        textBgView.layer.borderColor=[UIColor lightGrayColor].CGColor;
        textBgView.layer.borderWidth=0.5;
        textBgView.userInteractionEnabled=YES;
        [_mainListView addSubview:textBgView];
        
        UILabel  *label1=[[UILabel alloc]initWithFrame:CGRectMake(20,  10, 200, 20)];
        label1.textAlignment=NSTextAlignmentLeft;
        label1.font=[UIFont systemFontOfSize:15];
        label1.textColor=[UIColor grayColor];
        label1.text=[labelArray2 objectAtIndex:i];
        [textBgView  addSubview:label1];
        
        if (i==0) {
            UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 20, 20)];
            imageview.image=[UIImage imageNamed:@"must_pic.png"];
            [textBgView addSubview:imageview];
            _detailText1=[[UITextView alloc]initWithFrame:CGRectMake(5, 40, Width-20, 115)];
            _detailText1.layer.borderWidth=0.5;
            _detailText1.layer.borderColor=blueCyan.CGColor;
            _detailText1.clipsToBounds=YES;
            _detailText1.layer.cornerRadius=5;
            _detailText1.delegate=self;
            NSString *content=[contentArray2 objectAtIndex:i];
            _detailText1.text=[NSString stringWithFormat:@"%@",content];
            _detailText1.clearsOnInsertion=YES;
            [_detailText1 resignFirstResponder];
            _detailText1.font=[UIFont systemFontOfSize:15];
            [textBgView addSubview:_detailText1];
            self.placehoderLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, _detailText1.frame.size.width-40, 30)];
            if (![_detailText1.text isEqualToString:@""]) {
                self.placehoderLabel1.hidden=YES;
            }
            self.placehoderLabel1.text = @"(长度不得超过200字)";
            self.placehoderLabel1.textColor=[UIColor grayColor];
            
            self.placehoderLabel1.font = [UIFont systemFontOfSize:14.0];
            
            [_detailText1 addSubview:self.placehoderLabel1];
        }else{
            _detailText2=[[UITextView alloc]initWithFrame:CGRectMake(5, 40, Width-20, 115)];
            _detailText2.layer.borderWidth=0.5;
            _detailText2.layer.borderColor=blueCyan.CGColor;
            _detailText2.clipsToBounds=YES;
            NSString *content=[contentArray2 objectAtIndex:i];
            _detailText2.text=[NSString stringWithFormat:@"%@",content];
            _detailText2.layer.cornerRadius=5;
            _detailText2.delegate=self;
            _detailText2.clearsOnInsertion=YES;
            [_detailText2 resignFirstResponder];
            _detailText2.font=[UIFont systemFontOfSize:15];
            [textBgView addSubview:_detailText2];
            self.placehoderLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, _detailText2.frame.size.width-40, 30)];
            if (![_detailText2.text isEqualToString:@""]) {
                self.placehoderLabel2.hidden=YES;
            }
            self.placehoderLabel2.text = @"(长度不得超过200字)";
            self.placehoderLabel2.textColor=[UIColor grayColor];
            
            self.placehoderLabel2.font = [UIFont systemFontOfSize:14.0];
            
            [_detailText2 addSubview:self.placehoderLabel2];
        }
        
    }
    
    NSArray *labelArray3=@[@"建设地址：",@"审查类型："];
    NSString *str31=[self.commitData objectForKey:@"jsdzq"];
    NSString *str32=[self.commitData objectForKey:@"jsdzl"];
    if ([str31 isEqual:[NSNull null]]||str31==nil||str31==NULL||[str31 isEqualToString:@""]) {
        str31=@"";
    }
    if ([str32 isEqual:[NSNull null]]||str32==nil||str32==NULL||[str32 isEqualToString:@""]) {
        str32=@"";
    }
    NSArray *contentArray3=@[str31,str32];
    NSArray *labelArray4=@[@"(区)",@"(路)"];
    
    NSArray *labelArray5=@[@"设计方案",@"方案设计、初步设计“二合一”"];
    //建设地址  论址报告
    for (int i=0; i<2; i++) {
        UIView *textBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 560+130*i, Width-10, 50)];
        textBgView.backgroundColor=[UIColor whiteColor];
        textBgView.layer.borderColor=[UIColor lightGrayColor].CGColor;
        textBgView.layer.borderWidth=0.5;
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
            for (int j=0; j<2; j++) {
                UILabel  *label2=[[UILabel alloc]initWithFrame:CGRectMake(100+(Width-110)/2-40+(Width-110)/2*j,  5, 40, 40)];
                label2.textAlignment=NSTextAlignmentCenter;
                label2.font=[UIFont systemFontOfSize:15];
                label2.text=[labelArray4 objectAtIndex:j];
                [textBgView  addSubview:label2];
                
                UITextField *text=[[UITextField alloc]initWithFrame:CGRectMake(100+(Width-110)/2*j, 5, (Width-110)/2-40, 40)];
                text.layer.borderColor=[UIColor lightGrayColor].CGColor;
                text.layer.borderWidth=0.5;
                text.tag=20+j;
                text.delegate=self;
                NSString *content=[contentArray3 objectAtIndex:j];
                text.text=[NSString stringWithFormat:@"%@",content];
                text.font=[UIFont systemFontOfSize:15];
                [textBgView addSubview:text];
            }
        }else{
            for (int j=0; j<2; j++) {
                UILabel  *label2=[[UILabel alloc]initWithFrame:CGRectMake(150+(Width-130)/2*j,  10, (Width-130)/2-60, 40)];
                label2.textAlignment=NSTextAlignmentLeft;
                label2.font=[UIFont systemFontOfSize:15];
                label2.adjustsFontSizeToFitWidth=YES;
                label2.text=[labelArray5 objectAtIndex:j];
                [textBgView  addSubview:label2];
                
                UIButton *text=[[UIButton alloc]initWithFrame:CGRectMake(120+(Width-130)/2*j, 10,30, 30)];
                [text addTarget:self action:@selector(checkBox:) forControlEvents:UIControlEventTouchUpInside];
                text.tag=30+j;
                if (j==1) {
                    text.frame=CGRectMake(70+(Width-130)/2*j, 10,30, 30);
                    label2.frame=CGRectMake(100+(Width-130)/2*j,  10, (Width-130)/2+20, 40);
                }
                if ([_issclx isEqualToString:@""]) {
                    
                }else  if ([_issclx intValue]==1&&i==0) {
                    text.selected=YES;
                }else  if ([_issclx intValue]==2&&i==1) {
                    text.selected=YES;
                }
                [text setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
                [text setImage:[UIImage imageNamed:@"checkbox_fill"] forState:UIControlStateSelected];
                text.titleLabel.font=[UIFont systemFontOfSize:15];
                [textBgView addSubview:text];
            }
        }
        
    }
    NSArray *labelArray6=@[@"东至:",@"南至:",@"西至:",@"北至:"];
    NSString *str61=[self.commitData objectForKey:@"zbdz"];
    NSString *str62=[self.commitData objectForKey:@"zbnz"];
    NSString *str63=[self.commitData objectForKey:@"zbxz"];
    NSString *str64=[self.commitData objectForKey:@"zbbz"];
    if ([str61 isEqual:[NSNull null]]||str61==nil||str61==NULL||[str61 isEqualToString:@""]) {
        str61=@"";
    }
    if ([str62 isEqual:[NSNull null]]||str62==nil||str62==NULL||[str62 isEqualToString:@""]) {
        str62=@"";
    }
    if ([str63 isEqual:[NSNull null]]||str63==nil||str63==NULL||[str63 isEqualToString:@""]) {
        str63=@"";
    }
    if ([str64 isEqual:[NSNull null]]||str64==nil||str64==NULL||[str64 isEqualToString:@""]) {
        str64=@"";
    }
    NSArray *contentArray6=@[str61,str62,str63,str64];
    //东西南北
    for (int i=0; i<4; i++) {
        UILabel  *label2=[[UILabel alloc]initWithFrame:CGRectMake(10+(Width-30)/2*(i%2),  610+40*(i/2), 50, 40)];
        label2.textAlignment=NSTextAlignmentCenter;
        label2.font=[UIFont systemFontOfSize:15];
        label2.text=[labelArray6 objectAtIndex:i];
        [_mainListView  addSubview:label2];
        
        UITextField *text=[[UITextField alloc]initWithFrame:CGRectMake(60+(Width-30)/2*(i%2),  615+40*(i/2), (Width-30)/2-50, 30)];
        text.layer.borderColor=[UIColor lightGrayColor].CGColor;
        text.layer.borderWidth=0.5;
        text.tag=40+i;
        text.delegate=self;
        NSString *content=[contentArray6 objectAtIndex:i];
        text.text=[NSString stringWithFormat:@"%@",content];
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
        _issclx=@"1";
    }else  if ([button2 isEqual:sender]){
        button2.selected=YES;
        button1.selected=NO;
        _issclx=@"2";
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
    
    UITextField *textfield41=[self.view viewWithTag:40];//东
    UITextField *textfield42=[self.view viewWithTag:41];//南
    UITextField *textfield43=[self.view viewWithTag:42];//西
    UITextField *textfield44=[self.view viewWithTag:43];//北
    
   if (textfield1.text==NULL||textfield2.text==NULL||textfield3.text==NULL||textfield4.text==NULL||textfield5.text==NULL||textfield6.text==NULL||_detailText1.text==NULL||_issclx==NULL||[_issclx isEqualToString:@""]) {
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
    [dic setObject:textfield2.text forKey:@"wtr"];
    [dic setObject:textfield3.text forKey:@"lxdh"];
    [dic setObject:textfield4.text forKey:@"sjh"];
    [dic setObject:textfield5.text forKey:@"sjdw"];
    [dic setObject:textfield6.text forKey:@"sjr"];
    [dic setObject:textfield7.text forKey:@"shrsj"];
    [dic setObject:textfield8.text forKey:@"xmmc"];
    
    [dic setObject:textfield21.text forKey:@"jsdzq"];
    [dic setObject:textfield22.text forKey:@"jsdzl"];
    
    [dic setObject:_issclx forKey:@"sclx"];
    [dic setObject:_detailText1.text forKey:@"jsnrjgm"];
    
    if (_detailText2.text==NULL) {
        [dic setObject:@"" forKey:@"xmsmqk"];
    }else{
        [dic setObject:_detailText2.text forKey:@"xmsmqk"];
    }
    if (textfield41.text==NULL) {
        [dic setObject:@"" forKey:@"zbdz"];
    }else{
        [dic setObject:textfield41.text forKey:@"zbdz"];
    }
    if (textfield42.text==NULL) {
        [dic setObject:@"" forKey:@"zbnz"];
    }else{
        [dic setObject:textfield42.text forKey:@"zbnz"];
    }
    if (textfield43.text==NULL) {
        [dic setObject:@"" forKey:@"zbxz"];
    }else{
        [dic setObject:textfield43.text forKey:@"zbxz"];
    }
    if (textfield44.text==NULL) {
        [dic setObject:@"" forKey:@"zbbz"];
    }else{
        [dic setObject:textfield44.text forKey:@"zbbz"];
    }
   
    
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
    
    UITextField *textfield41=[self.view viewWithTag:40];//东
    UITextField *textfield42=[self.view viewWithTag:41];//南
    UITextField *textfield43=[self.view viewWithTag:42];//西
    UITextField *textfield44=[self.view viewWithTag:43];//北
    
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    [dic setObject:[self getString:textfield1.text] forKey:@"sqr"];
    [dic setObject:[self getString:textfield2.text] forKey:@"wtr"];
    [dic setObject:[self getString:textfield3.text] forKey:@"lxdh"];
    [dic setObject:[self getString:textfield4.text] forKey:@"sjh"];
    [dic setObject:[self getString:textfield5.text] forKey:@"sjdw"];
    [dic setObject:[self getString:textfield6.text] forKey:@"sjr"];
    [dic setObject:[self getString:textfield7.text] forKey:@"shrsj"];
     [dic setObject:[self getString:textfield8.text] forKey:@"xmmc"];
    
    
    [dic setObject:[self getString:textfield21.text] forKey:@"jsdzq"];
    [dic setObject:[self getString:textfield22.text] forKey:@"jsdzl"];
    
    [dic setObject:[self getString:textfield41.text] forKey:@"zbdz"];
    [dic setObject:[self getString:textfield42.text] forKey:@"zbnz"];
    [dic setObject:[self getString:textfield43.text] forKey:@"zbxz"];
    [dic setObject:[self getString:textfield44.text] forKey:@"zbbz"];
    [dic setObject:_issclx forKey:@"sclx"];
    [dic setObject:[self getString:_detailText1.text] forKey:@"jsnrjgm"];
    [dic setObject:[self getString:_detailText2.text] forKey:@"xmsmqk"];
    
    [dic setObject:@"" forKey:@"tdgyfs"];
    [dic setObject:@"" forKey:@"resuuid"];
    [dic setObject:@"" forKey:@"ydqsqk"];
    [dic setObject:@"" forKey:@"sfqdfapf"];
    [dic setObject:@"" forKey:@"sfghtjbg"];
    [dic setObject:@"" forKey:@"tdcb"];
    [dic setObject:@"" forKey:@"tznrjly"];
    
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
