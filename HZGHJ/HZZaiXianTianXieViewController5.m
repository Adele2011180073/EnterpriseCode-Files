//
//  HZZaiXianTianXieViewController3.m
//  HZGHJ
//
//  Created by zhang on 2017/7/31.
//  Copyright © 2017年 FiveFu. All rights reserved.
//

#import "HZZaiXianTianXieViewController5.h"
#import "HZIllustrateViewController1.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "BSRegexValidate.h"
#import "HZLocateContentViewController.h"
#import "UIViewController+BackButtonHandler.h"

@interface HZZaiXianTianXieViewController5 ()<UITextViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    UIButton *_rightBarBtn;
    UIScrollView *_mainBgView;//整个scrollview
    UIScrollView *_mainListView;//网格scrollview
    UITextView *_detailText1;
    UITextView *_detailText2;
    
    NSString* _isBlxs;//办理形式
    NSString* _isXiuGai;//修改（或延期）事项名称
}


@end

@implementation HZZaiXianTianXieViewController5

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
    titleLabel.text=@"建设项目批后修改(延期)事项申请表";

    NSLog(@" %@   %@",titleLabel.text,self.commitData);
    if ([[self.commitData objectForKey:@"blxs"]intValue]==0) {
        _isBlxs=[NSString stringWithFormat:@"%@",[self.commitData objectForKey:@"blxs"]];
    }else if ([[self.commitData objectForKey:@"lzbg"]intValue]==1) {
        _isBlxs=[NSString stringWithFormat:@"%@",[self.commitData objectForKey:@"blxs"]];
    }else{
        _isBlxs=@"";
    }
    _isXiuGai=@"";
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
    _mainBgView.contentSize=CGSizeMake(Width, 940+30);
    _mainBgView.userInteractionEnabled=YES;
    [self.view addSubview:_mainBgView];
    _mainListView=[[UIScrollView alloc]init];
    _mainListView.frame=CGRectMake(5, 10, Width-10,840);
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
    NSArray *nameLabelaArray=@[@"申请人(全称) :",@"法定代表人 :",@"受托人 :",@"手机 :",@"项目名称 :",@"电话 :"];
    NSString *str1=[self.commitData objectForKey:@"sqryq"];
    NSString *str2=[self.commitData objectForKey:@"fddbryq"];
    NSString *str3=[self.commitData objectForKey:@"stryq"];
    NSString *str4=[self.commitData objectForKey:@"sjyq"];
    NSString *str5=[self.commitData objectForKey:@"xmmcyq"];
    NSString *str6=[self.commitData objectForKey:@"dhyq"];
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
  
    NSArray *nameContentLabelArray=@[str1,str2,str3,str4,str5,str6];
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
    NSArray *labelArray2=@[@"建设内容及规模：",@"修改（或延期）原因及内容："];
    NSString *str21=[self.commitData objectForKey:@"jsnrjgm"];
    NSString *str22=[self.commitData objectForKey:@"xghyqjnr"];
    if ([str21 isEqual:[NSNull null]]||str21==nil||str21==NULL||[str21 isEqualToString:@""]) {
        str21=@"";
    }
    if ([str22 isEqual:[NSNull null]]||str22==nil||str22==NULL||[str22 isEqualToString:@""]) {
        str22=@"";
    }
    NSArray *contentArray2=@[str21,str22];
    for (int i=0; i<2; i++) {
        UIView *textBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 300+380*i, Width-10, 160)];
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
            UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 20, 20)];
            imageview.image=[UIImage imageNamed:@"must_pic.png"];
            [textBgView addSubview:imageview];
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
    
    NSArray *labelArray3=@[@"办理形式：",@"建设地址："];
    NSString *str41=[self.commitData objectForKey:@"jsdzq"];
    NSString *str42=[self.commitData objectForKey:@"jsdzq"];
    if ([str41 isEqual:[NSNull null]]||str41==nil||str41==NULL||[str41 isEqualToString:@""]) {
        str41=@"";
    }
    if ([str42 isEqual:[NSNull null]]||str42==nil||str42==NULL||[str42 isEqualToString:@""]) {
        str42=@"";
    }
    NSArray *contentArray4=@[str41,str42];
    NSArray *labelArray4=@[@"修改",@"有效期内延期"];
    
    NSArray *labelArray5=@[@"(区)",@"(路)"];
    //建设地址  论址报告
    for (int i=0; i<2; i++) {
        UIView *textBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 460+50*i, Width-10, 50)];
        textBgView.backgroundColor=[UIColor whiteColor];
        textBgView.layer.borderColor=[UIColor lightGrayColor].CGColor;
        textBgView.layer.borderWidth=0.5;
        textBgView.userInteractionEnabled=YES;
        [_mainListView addSubview:textBgView];
        UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 15, 20, 20)];
        imageview.image=[UIImage imageNamed:@"must_pic.png"];
        [textBgView addSubview:imageview];
        
        UILabel  *label1=[[UILabel alloc]initWithFrame:CGRectMake(20,  15, 100, 20)];
        label1.textAlignment=NSTextAlignmentLeft;
        label1.font=[UIFont systemFontOfSize:15];
        label1.textColor=[UIColor blackColor];
        label1.text=[labelArray3 objectAtIndex:i];
        [textBgView  addSubview:label1];
        
        if (i==0) {
            for (int j=0; j<2; j++) {
                UILabel  *label2=[[UILabel alloc]initWithFrame:CGRectMake(150+(Width-130)/2*j,  5, (Width-130)/2-30, 40)];
                label2.adjustsFontSizeToFitWidth=YES;
                label2.textAlignment=NSTextAlignmentLeft;
                label2.font=[UIFont systemFontOfSize:15];
                label2.text=[labelArray4 objectAtIndex:j];
                [textBgView  addSubview:label2];
                
                UIButton *text=[[UIButton alloc]initWithFrame:CGRectMake(120+(Width-10-120)/2*j, 10, 30, 30)];
                [text addTarget:self action:@selector(checkBox:) forControlEvents:UIControlEventTouchUpInside];
                text.tag=20+j;
                if ([_isBlxs isEqualToString:@""]) {

                }else  if ([_isBlxs intValue]==1&&j==1) {
                    text.selected=YES;
                }else  if ([_isBlxs intValue]==0&&j==0) {
                    text.selected=YES;
                }
                [text setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
                [text setImage:[UIImage imageNamed:@"checkbox_fill"] forState:UIControlStateSelected];
                text.titleLabel.font=[UIFont systemFontOfSize:15];
                [textBgView addSubview:text];
            
        }
        }else{
            label1.frame=CGRectMake(20,  15, 80, 20);
            for (int j=0; j<2; j++) {
                UILabel  *label2=[[UILabel alloc]initWithFrame:CGRectMake(100+(Width-110)/2-40+(Width-110)/2*j,  5, 40, 40)];
                label2.textAlignment=NSTextAlignmentCenter;
                label2.font=[UIFont systemFontOfSize:15];
                label2.text=[labelArray5 objectAtIndex:j];
                [textBgView  addSubview:label2];
                
                UITextField *text=[[UITextField alloc]initWithFrame:CGRectMake(100+(Width-110)/2*j, 5, (Width-110)/2-40, 40)];
                text.tag=30+j;
                text.delegate=self;
                NSString *content=[contentArray4 objectAtIndex:j];
                text.text=[NSString stringWithFormat:@"%@",content];
                text.font=[UIFont systemFontOfSize:15];
                [textBgView addSubview:text];
            }
        }
        
    }
    NSArray *labelArray6=@[@"选址意见书",@"规划条件",@"用地规划许可证",@"方案设计审查",@"工程规划许可证",@"其他"];
    NSString *str61=[self.commitData objectForKey:@"xghyqsxmc"];
   
    if ([str61 isEqual:[NSNull null]]||str61==nil||str61==NULL||[str61 isEqualToString:@""]) {
        str61=@"";
    }
  
    //修改（或延期）事项名称：
    UILabel  *xiugailabel=[[UILabel alloc]initWithFrame:CGRectMake(10,  560, Width-20, 30)];
    xiugailabel.textAlignment=NSTextAlignmentCenter;
    xiugailabel.font=[UIFont systemFontOfSize:15];
    xiugailabel.text=@"修改（或延期）事项名称：";
    [_mainListView  addSubview:xiugailabel];
    for (int i=0; i<6; i++) {
        UIButton *text=[[UIButton alloc]initWithFrame:CGRectMake(10+(Width-30)/3*(i%3), 595+(i/3)*40, 30, 30)];
        [text addTarget:self action:@selector(checkxiugaiBox:) forControlEvents:UIControlEventTouchUpInside];
        text.tag=40+i;
        [text setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
        [text setImage:[UIImage imageNamed:@"checkbox_fill"] forState:UIControlStateSelected];
        text.titleLabel.font=[UIFont systemFontOfSize:15];
        [_mainListView addSubview:text];

        UILabel  *label2=[[UILabel alloc]initWithFrame:CGRectMake(40+(Width-30)/3*(i%3),  595+(i/3)*40, (Width-30)/3-40, 30)];
        label2.adjustsFontSizeToFitWidth=YES;
        label2.textAlignment=NSTextAlignmentLeft;
        label2.font=[UIFont systemFontOfSize:15];
        label2.text=[labelArray6 objectAtIndex:i];
        [_mainListView  addSubview:label2];
        if ([str61 isEqualToString:@""]) {
            text.selected=NO;
        }else  if ([str61 isEqualToString:label2.text]) {
            text.selected=YES;
        }else {
            text.selected=NO;
        }
    }

}

//办理形式
-(void)checkBox:(UIButton *)sender{
    UIButton *button1=[self.view viewWithTag:20];
    UIButton *button2=[self.view viewWithTag:21];
    if ([button1 isEqual:sender]) {
        button1.selected=YES;
        button2.selected=NO;
        _isBlxs=@"0";
    }else  if ([button2 isEqual:sender]){
        button2.selected=YES;
        button1.selected=NO;
        _isBlxs=@"1";
    }
}
//修改延期
-(void)checkxiugaiBox:(UIButton *)sender{
    for (int i=0; i<6; i++) {
        UIButton *button=(UIButton*)[self.view viewWithTag:40+i];
        if (sender==button) {
            button.selected=YES;
        }else{
            button.selected=NO;
        }
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
    
    UITextField *textfield31=[self.view viewWithTag:30];//区
    UITextField *textfield32=[self.view viewWithTag:31];//路
    
//    UITextField *textfield41=[self.view viewWithTag:40];//东
//    UITextField *textfield42=[self.view viewWithTag:41];//南
//    UITextField *textfield43=[self.view viewWithTag:42];//西
//    UITextField *textfield44=[self.view viewWithTag:43];//北
//
   if (textfield1.text==NULL||textfield2.text==NULL||textfield3.text==NULL||textfield4.text==NULL||textfield5.text==NULL||_detailText2.text==NULL||_isBlxs==NULL||[_isBlxs isEqualToString:@""]) {
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
    [dic setObject:textfield1.text forKey:@"sqryq"];
    [dic setObject:textfield2.text forKey:@"fddbryq"];
    [dic setObject:textfield3.text forKey:@"stryq"];
    [dic setObject:textfield4.text forKey:@"sjyq"];
    [dic setObject:textfield5.text forKey:@"xmmcyq"];
    [dic setObject:textfield6.text forKey:@"dhyq"];
    
    [dic setObject:textfield31.text forKey:@"jsdzq"];
    [dic setObject:textfield32.text forKey:@"jsdzl"];
    [dic setObject:_isBlxs forKey:@"blxs"];
    [dic setObject:_detailText2.text forKey:@"xghyqjnr"];
   
   
    if (_detailText1.text==NULL) {
        [dic setObject:@"" forKey:@"jsnrjgm"];
    }else{
        [dic setObject:_detailText1.text forKey:@"jsnrjgm"];
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
    
    UITextField *textfield31=[self.view viewWithTag:30];//区
    UITextField *textfield32=[self.view viewWithTag:31];//路

    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    [dic setObject:[self getString:textfield1.text] forKey:@"sqryq"];
    [dic setObject:[self getString:textfield2.text] forKey:@"fddbryq"];
    [dic setObject:[self getString:textfield3.text] forKey:@"stryq"];
    [dic setObject:[self getString:textfield4.text] forKey:@"sjyq"];
    [dic setObject:[self getString:textfield5.text] forKey:@"xmmcyq"];
    [dic setObject:[self getString:textfield6.text] forKey:@"dhyq"];
   
    [dic setObject:[self getString:textfield31.text] forKey:@"quyq"];
    [dic setObject:[self getString:textfield32.text] forKey:@"luyq"];
   
    [dic setObject:_isBlxs forKey:@"blxs"];
    [dic setObject:[self getString:_detailText1.text] forKey:@"jsnrjgmyq"];
    [dic setObject:[self getString:_detailText2.text] forKey:@"xghyqjnr"];

    
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
