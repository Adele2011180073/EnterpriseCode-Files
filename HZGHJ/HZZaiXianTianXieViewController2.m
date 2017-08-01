//
//  HZZaiXianTianXieViewController2.m
//  HZGHJ
//
//  Created by zhang on 2017/7/31.
//  Copyright © 2017年 FiveFu. All rights reserved.
//

#import "HZZaiXianTianXieViewController2.h"
#import "HZIllustrateViewController1.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "BSRegexValidate.h"
#import "HZLocateContentViewController.h"
#import "UIViewController+BackButtonHandler.h"
@interface HZZaiXianTianXieViewController2 ()<UITextViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    UIButton *_rightBarBtn;
    UIScrollView *_mainBgView;//整个scrollview
    UIScrollView *_mainListView;//网格scrollview
    UITextView *_detailText1;
    UITextView *_detailText2;
    
    NSString* _isCheck;
    NSArray *_listArray;
    UIScrollView *_listView;
}


@end

@implementation HZZaiXianTianXieViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回"style:UIBarButtonItemStyleBordered target:nil action:nil];
    NSArray *array=@[@"选址申请表",@"选址失效申请表",@"选址建议变更申请表",@"选址延期申请表",@"用地申请表",@"临时用地申请表",@"规划条件申请表",@"规划条件变更申请表"];
    self.title=[array objectAtIndex:self.PCODE];
    
    NSLog(@"选址申请表   %@",self.commitData);
    _isCheck=@"";
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
        self.commitData=[[NSDictionary alloc]init];
        //        [self addMainListView];
    }else{
    }
    [self addReMainListView];
    
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
    NSString *str1=[self.commitData objectForKey:@"sqr"];
    NSString *str2=[self.commitData objectForKey:@"fddbr"];
    NSString *str3=[self.commitData objectForKey:@"wtr"];
    NSString *str4=[self.commitData objectForKey:@"sjh"];
    NSString *str5=[self.commitData objectForKey:@"xmmc"];
    NSString *str6=[self.commitData objectForKey:@"lxdh"];
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
        NSString *content=[nameContentLabelArray objectAtIndex:i];
        text.text=[NSString stringWithFormat:@"%@",content];
        [nameLabelView1 addSubview:text];
    }
    NSArray *labelArray2=@[@"用地性质及规模：",@"项目情况说明："];
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
            _detailText2.layer.borderWidth=1;
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
    
    NSArray *labelArray3=@[@"建设地址：",@"土地供应方式："];
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
    
    NSString *str51=[self.commitData objectForKey:@"tdgyfs"];
    if ([str51 isEqual:[NSNull null]]||str51==nil||str51==NULL||[str51 isEqualToString:@""]) {
        str51=@"";
    }
    NSArray *labelArray5=@[@"划拨",@"出让"];
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
                NSString *content=[contentArray3 objectAtIndex:i];
                text.text=[NSString stringWithFormat:@"%@",content];
                text.font=[UIFont systemFontOfSize:15];
                [textBgView addSubview:text];
            }
        }else{
            for (int i=0; i<2; i++) {
                UILabel  *label2=[[UILabel alloc]initWithFrame:CGRectMake(170+(Width-180)/2*i,  5, 50, 40)];
                label2.textAlignment=NSTextAlignmentCenter;
                label2.font=[UIFont systemFontOfSize:15];
                label2.text=[labelArray5 objectAtIndex:i];
                [textBgView  addSubview:label2];
                
                UIButton *text=[[UIButton alloc]initWithFrame:CGRectMake(120+(Width-180)/2*i, 5, (Width-180)/2-50, 40)];
                [text addTarget:self action:@selector(checkBox:) forControlEvents:UIControlEventTouchUpInside];
                text.tag=30+i;
                if ([str51 isEqualToString:@""]) {
                    
                }else  if ([str51 isEqualToString:@"划拨"]&&i==0) {
                    text.selected=YES;
                }else  if ([str51 isEqualToString:@"出让"]&&i==1) {
                    text.selected=YES;
                }
                [text setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
                [text setImage:[UIImage imageNamed:@"checkbox_fill"] forState:UIControlStateSelected];
                text.titleLabel.font=[UIFont systemFontOfSize:15];
                [textBgView addSubview:text];
            }
        }
        
    }
    NSArray *labelArray6=@[@"用地权属情况：",@"是否已取得方案审查批复"];
    NSString *str61=[self.commitData objectForKey:@"ydqsqk"];
    NSString *str62=[self.commitData objectForKey:@"sfqdfapf"];
    
    if ([str61 isEqual:[NSNull null]]||str61==nil||str61==NULL||[str61 isEqualToString:@""]) {
        str61=@"";
    }
    if ([str62 isEqual:[NSNull null]]||str62==nil||str62==NULL||[str62 isEqualToString:@""]) {
        str62=@"";
    }
       NSArray *contentArray6=@[str61,str62];
    //否已取得方案审查批复
    for (int i=0; i<2; i++) {
        UILabel  *label2=[[UILabel alloc]initWithFrame:CGRectMake(10,  510+40*i, 110, 40)];
        if (i==1) {
            label2.frame=CGRectMake(10,  550, 180, 40);
        }
        label2.textAlignment=NSTextAlignmentLeft;
        label2.font=[UIFont systemFontOfSize:15];
        label2.text=[labelArray6 objectAtIndex:i];
        [_mainListView  addSubview:label2];
        
        UIButton *text=[[UIButton alloc]initWithFrame:CGRectMake(140,  510+40*i, Width-30-140, 40)];
        if (i==1) {
            text.frame=CGRectMake(190,  510+40*i, Width-30-190, 40);
        }
        text.layer.borderWidth=0.5;
        text.layer.borderColor=blueCyan.CGColor;
         [text setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        text.tag=40+i;
        NSString *content=[contentArray6 objectAtIndex:i];
        if ([content isEqualToString:@""]) {
            
        }else{
            [text setTitle:content forState:UIControlStateNormal];
        }
        [text addTarget:self action:@selector(quanshu:) forControlEvents:UIControlEventTouchUpInside];
        text.titleLabel.font=[UIFont systemFontOfSize:15];
        [_mainListView addSubview:text];
    }
    
}
//用地权属
-(void)quanshu:(UIButton*)sender{
//    UIButton *button1=[self.view viewWithTag:40];
//    UIButton *button2=[self.view viewWithTag:41];
    [_listView removeFromSuperview];
    _listView=[[UIScrollView alloc]init];
    _listView.backgroundColor=littleGray;
    _listView.layer.borderColor=blueCyan.CGColor;
    _listView.layer.borderWidth=0.5;
    _listView.userInteractionEnabled=YES;
    [_mainListView addSubview:_listView];
    if (sender.tag==40) {
        _listArray=[[NSArray alloc]initWithObjects:@" ",@"全部自有",@"部分新征",@"全部新征", nil];
         _listView.frame=CGRectMake(sender.frame.origin.x, 550, sender.frame.size.width, 50*_listArray.count);
        for (int i=0; i<_listArray.count; i++) {
            UIButton *text=[[UIButton alloc]initWithFrame:CGRectMake(0, 50*i, sender.frame.size.width, 50)];
            text.tag=400+i;
            NSString *content=[_listArray objectAtIndex:i];
                [text setTitle:content forState:UIControlStateNormal];
              [text setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [text addTarget:self action:@selector(listBtn:) forControlEvents:UIControlEventTouchUpInside];
            text.titleLabel.font=[UIFont systemFontOfSize:16];
            [_listView addSubview:text];
        }
    }else if (sender.tag==41) {
        _listArray=[[NSArray alloc]initWithObjects:@" ",@"是",@"否", nil];
         _listView.frame=CGRectMake(sender.frame.origin.x, 590, sender.frame.size.width, 50*_listArray.count);
        for (int i=0;i< _listArray.count; i++) {
            UIButton *text=[[UIButton alloc]initWithFrame:CGRectMake(0, 50*i, sender.frame.size.width, 50)];
            text.tag=410+i;
            NSString *content=[_listArray objectAtIndex:i];
            [text setTitle:content forState:UIControlStateNormal];
             [text setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [text addTarget:self action:@selector(listBtn:) forControlEvents:UIControlEventTouchUpInside];
            text.titleLabel.font=[UIFont systemFontOfSize:16];
            [_listView addSubview:text];
        }

    }
    
}
-(void)listBtn:(UIButton *)sender{
    UIButton *button1=[self.view viewWithTag:40];
    UIButton *button2=[self.view viewWithTag:41];
     [_listView removeFromSuperview];
    if (sender.tag/10==40) {
        NSString *content=[_listArray objectAtIndex:sender.tag-400];
        [button1 setTitle:content forState:UIControlStateNormal];
    }else if (sender.tag/10==41) {
        NSString *content=[_listArray objectAtIndex:sender.tag-410];
        [button2 setTitle:content forState:UIControlStateNormal];
    }
}
-(void)checkBox:(UIButton *)sender{
    UIButton *button1=[self.view viewWithTag:30];
    UIButton *button2=[self.view viewWithTag:31];
    if ([button1 isEqual:sender]) {
        button1.selected=YES;
        button2.selected=NO;
        _isCheck=@"划拨";
    }else{
        button2.selected=YES;
        button1.selected=NO;
        _isCheck=@"出让";
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
    
    UITextField *textfield21=[self.view viewWithTag:20];//区
    UITextField *textfield22=[self.view viewWithTag:21];//路
    
    UIButton *textfield41=[self.view viewWithTag:40];//用地权属情况
    UIButton *textfield42=[self.view viewWithTag:41];//已取得方案审查批复
    
    
    if (textfield1.text==NULL||textfield2.text==NULL||textfield3.text==NULL||textfield4.text==NULL||textfield5.text==NULL||_detailText2.text==NULL||_isCheck==NULL||[_isCheck isEqualToString:@""]) {
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
    [dic setObject:_isCheck forKey:@"tdgyfs"];
    [dic setObject:_detailText2.text forKey:@"xmsmqk"];
    if (textfield6.text==NULL) {
        [dic setObject:@"" forKey:@"lxdh"];
    }else{
        [dic setObject:textfield6.text forKey:@"lxdh"];
    }
    if (_detailText1.text==NULL) {
        [dic setObject:@"" forKey:@"jsnrjgm"];
    }else{
        [dic setObject:_detailText1.text forKey:@"jsnrjgm"];
    }
    if (textfield41.titleLabel.text==NULL) {
        [dic setObject:@"" forKey:@"ydqsqk"];
    }else{
        [dic setObject:textfield41.titleLabel.text forKey:@"ydqsqk"];
    }
    if (textfield42.titleLabel.text==NULL) {
        [dic setObject:@"" forKey:@"sfqdfapf"];
    }else{
        [dic setObject:textfield42.titleLabel.text forKey:@"sfqdfapf"];
    }
    
    [dic setObject:@"" forKey:@"lzbg"];
    [dic setObject:@"" forKey:@"zbdz"];
    [dic setObject:@"" forKey:@"zbnz"];
    [dic setObject:@"" forKey:@"zbxz"];
    [dic setObject:@"" forKey:@"zbbz"];
    [dic setObject:@"" forKey:@"filecode"];
    [dic setObject:@"" forKey:@"resuuid"];
    [dic setObject:@"" forKey:@"sfghtjbg"];
    [dic setObject:@"" forKey:@"tdcb"];
    [dic setObject:@"" forKey:@"tznrjly"];
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"保存成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray *vcArray = self.navigationController.viewControllers;
        for(UIViewController *vc in vcArray)
        {
            if ([vc isKindOfClass:[HZLocateContentViewController class]])
            {
                HZLocateContentViewController *content=(HZLocateContentViewController *)vc;
                content.saveDic=dic;
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
    
    UITextField *textfield21=[self.view viewWithTag:20];//区
    UITextField *textfield22=[self.view viewWithTag:21];//路
    
    UIButton *textfield41=[self.view viewWithTag:40];//用地权属情况
    UIButton *textfield42=[self.view viewWithTag:41];//已取得方案审查批复
    
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    [dic setObject:[self getString:textfield1.text] forKey:@"sqr"];
    [dic setObject:[self getString:textfield2.text] forKey:@"fddbr"];
    [dic setObject:[self getString:textfield3.text] forKey:@"wtr"];
    [dic setObject:[self getString:textfield4.text] forKey:@"sjh"];
    [dic setObject:[self getString:textfield5.text] forKey:@"xmmc"];
    [dic setObject:[self getString:textfield6.text] forKey:@"lxdh"];
    [dic setObject:[self getString:textfield21.text] forKey:@"jsdzq"];
    [dic setObject:[self getString:textfield22.text] forKey:@"jsdzl"];
    [dic setObject:[self getString:textfield41.titleLabel.text] forKey:@"ydqsqk"];
    [dic setObject:[self getString:textfield42.titleLabel.text] forKey:@"sfqdfapf"];
    [dic setObject:_isCheck forKey:@"tdgyfs"];
    [dic setObject:[self getString:_detailText1.text] forKey:@"jsnrjgm"];
    [dic setObject:[self getString:_detailText2.text] forKey:@"xmsmqk"];
    
    [dic setObject:@"" forKey:@"lzbg"];
    [dic setObject:@"" forKey:@"zbdz"];
    [dic setObject:@"" forKey:@"zbnz"];
    [dic setObject:@"" forKey:@"zbxz"];
    [dic setObject:@"" forKey:@"zbbz"];
    [dic setObject:@"" forKey:@"filecode"];
    [dic setObject:@"" forKey:@"resuuid"];
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
