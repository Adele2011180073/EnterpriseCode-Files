//
//  HZProjectViewController.m
//  HZGHJ
//
//  Created by zhang on 16/12/13.
//  Copyright © 2016年 FiveFu. All rights reserved.
//

#import "HZProjectViewController.h"
#import "MBProgressHUD.h"
#import "SVPullToRefresh.h"
#import "HZLoginService.h"
#import <AVFoundation/AVFoundation.h>
#import "HZPictureViewController.h"

@interface HZProjectViewController ()<UIGestureRecognizerDelegate,UITextViewDelegate,UIImagePickerControllerDelegate>{
    UIScrollView *bgScrollView;
    NSArray *projectNameArray;
    UILabel *projectName;
     UITextView *detailText;
    UIScrollView *bgBigClassView;
    BOOL isBigClass;
    NSInteger number;
}

@end

@implementation HZProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional   after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    self.title=@"项目过程上报";
     self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回"style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    bgScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-44)];
    bgScrollView.contentSize=CGSizeMake(Width, 680);
    bgScrollView.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    bgScrollView.userInteractionEnabled=YES;
    [self.view addSubview:bgScrollView];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tap.delegate=self;
    tap.accessibilityValue=[NSString stringWithFormat:@"resign"];
    [bgScrollView addGestureRecognizer:tap];
    
    number=0;
    bgBigClassView=[[UIScrollView alloc]init];
    self.imageArray=[[NSMutableArray alloc]init];
    projectNameArray=[[NSMutableArray alloc]init];
    [self getDataSource];
//    [self addSubviews];
}
-(void)getDataSource{
    MBProgressHUD *hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text=@"数据加载中，请稍候...";
    NSString *token=[[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    [HZLoginService ShangBaoGetWithToken:token andBlock:^(NSDictionary *returnDic, NSError *error) {
         [hud hideAnimated:YES];
        if ([[returnDic objectForKey:@"code"]integerValue]==0) {
            NSArray *array=[returnDic objectForKey:@"list"];
            projectNameArray=[NSMutableArray arrayWithArray:array];
            [self addSubviews];
//            NSLog(@"预约列表    %@  %@",str,returnDic);
            
        }else   if ([[returnDic objectForKey:@"code"]integerValue]==900||[[returnDic objectForKey:@"code"]integerValue]==1000) {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:[returnDic objectForKey:@"desc"] message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancelAlert];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            
        }
    }];
}
-(void)tap:(UITapGestureRecognizer*)tap{
    if ([tap.accessibilityValue isEqualToString:@"resign"]) {
        [detailText resignFirstResponder];
        [bgBigClassView removeFromSuperview];
    }else if ([tap.accessibilityValue isEqualToString:@"nameList"]) {
        isBigClass=!isBigClass;
        if (isBigClass==YES) {
            bgBigClassView=[[UIScrollView alloc]init];
            if (50*projectNameArray.count>Height-160) {
                bgBigClassView.frame=CGRectMake(0, 90, Width, Height-160);
            }else{
                bgBigClassView.frame=CGRectMake(0, 90, Width, 50*projectNameArray.count);
            }
        bgBigClassView.contentSize=CGSizeMake(Width-140, 50*projectNameArray.count);
        bgBigClassView.userInteractionEnabled=YES;
        bgBigClassView.backgroundColor=[UIColor whiteColor];
        
        [bgScrollView addSubview:bgBigClassView];
        
        for (int i=0; i<projectNameArray.count; i++) {
            NSDictionary *dic=[projectNameArray objectAtIndex:i];
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(0,50*i, Width, 50);
            button.tag=80+i;
            button.titleLabel.textAlignment=NSTextAlignmentCenter;
            button.titleLabel.font=[UIFont systemFontOfSize:17];
            [button setTitle:[dic objectForKey:@"projectName"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.adjustsImageWhenHighlighted=YES;
            [button addTarget:self action:@selector(listBtn:) forControlEvents:UIControlEventTouchUpInside];
            [bgBigClassView addSubview:button];
            
            UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,49*i, Width, 1)];
            lineLabel.backgroundColor=[UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0];
            [bgBigClassView addSubview:lineLabel];
        }
        }
        else{
            [bgBigClassView removeFromSuperview];
        }

    }
}
-(void)listBtn:(UIButton *)button{
    [bgBigClassView removeFromSuperview];
    number=button.tag-80;
//    projectName.text=[projectNameArray objectAtIndex:button.tag-80];
    [self addSubviews];
}
-(void)addSubviews{
    for (UIView *view in bgScrollView.subviews) {
        [view removeFromSuperview];
    }
    bgScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-44)];
    bgScrollView.contentSize=CGSizeMake(Width, 700);
    bgScrollView.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    bgScrollView.userInteractionEnabled=YES;
    [self.view addSubview:bgScrollView];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tap.delegate=self;
    tap.accessibilityValue=[NSString stringWithFormat:@"resign"];
    [bgScrollView addGestureRecognizer:tap];

    
    NSArray *subArray=@[@"选择项目名称",@"",@"添加照片",@"添加文字"];
    if (projectNameArray==nil||projectNameArray==NULL) return;
    NSDictionary *messageDic=[projectNameArray objectAtIndex:number];
    NSString *str=[messageDic objectForKey:@"projectName"];
    NSString *str1=[messageDic objectForKey:@"address"];
    NSString *str2=[messageDic objectForKey:@"processName"];
    NSString *str3=[messageDic objectForKey:@"adminName"];
    NSString *str4=[messageDic objectForKey:@"adminPhone"];
    if (str1==NULL||str1==nil)  str1=@"";
    if (str2==NULL||str2==nil)  str2=@"";
    if (str3==NULL||str3==nil)  str3=@"";
    if (str4==NULL||str4==nil)  str4=@"";
    for (int i=0; i<4; i++) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(30, 80*i, 140, 40)];
        label.textAlignment=NSTextAlignmentLeft;
        label.text=[subArray objectAtIndex:i];

        if (i==1) {
            label.frame=CGRectMake(0, 190, Width, 40);
             label.textAlignment=NSTextAlignmentRight;
            label.text=[NSString stringWithFormat:@"经办人：%@ 联系电话：%@",str3,str4];
        }else   if (i==2) {
             label.frame=CGRectMake(30, 230, 140, 40);
        }else   if (i==3) {
            label.frame=CGRectMake(30, 370, 140, 40);
        }

        label.textColor=[UIColor darkGrayColor];
        label.font=[UIFont systemFontOfSize:16];
        [bgScrollView addSubview:label];
    }
       for (int i=0; i<5; i++) {
           UIView* bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 40)];
           bgView.backgroundColor=[UIColor whiteColor];
           bgView.userInteractionEnabled=YES;
           [bgScrollView addSubview:bgView];
           
           if (i==0) {
               bgView.frame=CGRectMake(0, 40, Width, 40);
               projectName=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, Width-50, 40)];
               projectName.textAlignment=NSTextAlignmentLeft;
               projectName.text=str;
               projectName.numberOfLines=2;
               projectName.font=[UIFont systemFontOfSize:16];
               [bgView addSubview:projectName];
               UILabel *imageTitle=[[UILabel alloc]initWithFrame:CGRectMake(Width-30, 5, 20, 20)];
               imageTitle.textColor=blueCyan;
               imageTitle.text=@"\U0000e62e";
               imageTitle.font=[UIFont fontWithName:@"iconfont" size:16];
               [bgView addSubview:imageTitle];
               UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
               tap.delegate=self;
               tap.accessibilityValue=[NSString stringWithFormat:@"nameList"];
               [bgView addGestureRecognizer:tap];
           }else  if (i==1) {
               bgView.frame=CGRectMake(0, 100, Width, 40);
               UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, 99, 20)];
               label.textAlignment=NSTextAlignmentCenter;
               label.text=@"项目地址";
               label.font=[UIFont systemFontOfSize:15];
               [bgView addSubview:label];
               
               UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(100, 10, 1, 20)];
               line.backgroundColor=[UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1.0];
               [bgView addSubview:line];
               
               UILabel *text=[[UILabel alloc]initWithFrame:CGRectMake(110, 10, Width -120, 20)];
               text.textAlignment=NSTextAlignmentLeft;
               text.text=str1;
               text.font=[UIFont systemFontOfSize:15];
               [bgView addSubview:text];
           }else  if (i==2) {
               bgView.frame=CGRectMake(0, 150, Width, 40);
               UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, 99, 20)];
               label.textAlignment=NSTextAlignmentCenter;
               label.text=@"项目阶段";
               label.font=[UIFont systemFontOfSize:15];
               [bgView addSubview:label];
               
               UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(100, 10, 1, 20)];
               line.backgroundColor=[UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1.0];
               [bgView addSubview:line];
               
               UILabel *text=[[UILabel alloc]initWithFrame:CGRectMake(110, 10, Width -120, 20)];
               text.textAlignment=NSTextAlignmentLeft;
               text.text=str2;
               text.font=[UIFont systemFontOfSize:15];
               [bgView addSubview:text];
           }else  if (i==3) {
                bgView.frame=CGRectMake(0, 270, Width, 100);
               UIButton *imageView=[[UIButton alloc]initWithFrame:CGRectMake(20, 10, 80, 80)];
               imageView.tag=10;
               [imageView setBackgroundImage:[UIImage imageNamed:@"add_photo"] forState:UIControlStateNormal];
               [imageView addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
               [bgView addSubview:imageView];
           }else  if (i==4) {
               bgView.frame=CGRectMake(0, 420, Width, 130);
               detailText=[[UITextView alloc]initWithFrame:CGRectMake(0, 0, Width, 130)];
               detailText.delegate=self;
               detailText.clearsOnInsertion=YES;
                [detailText resignFirstResponder];
               detailText.font=[UIFont systemFontOfSize:15];
               [bgView addSubview:detailText];
               self.placehoderLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, detailText.frame.size.width-40, 30)];
               
               self.placehoderLabel.backgroundColor = [UIColor whiteColor];
               
               self.placehoderLabel.text = @"请输入文字汇报内容(不得超过200字)";
               self.placehoderLabel.textColor=[UIColor grayColor];
               
               self.placehoderLabel.font = [UIFont systemFontOfSize:15.0];
               
               [detailText addSubview:self.placehoderLabel];
               self.numLabel = [[UILabel alloc] initWithFrame:CGRectMake(detailText.frame.size.width-90, detailText.frame.size.height-30, 60, 20)];
               
               self.numLabel.backgroundColor = [UIColor whiteColor];
               self.numLabel.textColor=[UIColor grayColor];
               
               self.numLabel.text = @"0/200";
               
               self.numLabel.font = [UIFont systemFontOfSize:15.0];
               
               [bgView addSubview:self.numLabel];
           }
       }
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(40, 620,Width-80, 40)];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor=[UIColor colorWithRed:23/255.0 green:177/255.0 blue:242/255.0 alpha:1];
    [button addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    
    [bgScrollView addSubview:button];
    
}
-(void)takePhoto:(UIButton *)sender{
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
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.showsCameraControls = YES;
        picker.allowsEditing=YES;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:Nil];
    }];
    [alert addAction:cameraAlert];
    UIAlertAction *pictureAlert=[UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController*picker = [[UIImagePickerController alloc] init];
        
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        //            picker.allowsEditing=YES;
        [self presentViewController:picker animated:YES completion:Nil];
    }];
    [alert addAction:pictureAlert];

    [self presentViewController:alert animated:YES completion:nil];
  }
#pragma mark - Get Photoes Module
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *scaleImage = [self scaleImage:originImage toScale:0.5];
    UIButton *button=[self.view viewWithTag:10];
    UIButton *imageView=[[UIButton alloc]init];
    imageView.frame=button.frame;
    [imageView setBackgroundImage:scaleImage forState:UIControlStateNormal];
    [imageView addTarget:self action:@selector(bigPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [button.superview addSubview:imageView];
    button.frame=CGRectMake(button.frame.origin.x+100, 10, 80, 80);
    [self.imageArray addObject:scaleImage];
    if (self.imageArray.count==3) {
        button.hidden=YES;
        button.userInteractionEnabled=NO;
    }
    
    //长按删除
    NSInteger index=[self.imageArray indexOfObject:imageView.currentBackgroundImage];
    UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    longPress.accessibilityValue=[NSString stringWithFormat:@"%ld",index];
    [imageView addGestureRecognizer:longPress];
    [picker dismissViewControllerAnimated:YES completion:nil];
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
-(void)bigPhoto:(UIButton*)bigImage{
    HZPictureViewController *picture=[[HZPictureViewController alloc]init];
    picture.isWeb=YES;
    picture.imageArray=self.imageArray;
    picture.image=bigImage.currentBackgroundImage;
    NSInteger index=[self.imageArray indexOfObject:picture.image];
    picture.indexOfImage=index;
    [self.navigationController pushViewController:picture animated:YES];
}
-(void)longPress:(UILongPressGestureRecognizer*)longPress{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确定删除此图片吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancelAlert];

    UIAlertAction *okAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIButton *button=[self.view viewWithTag:10];
        button.frame=CGRectMake(button.frame.origin.x-100, 10, 80, 80);
        button.hidden=NO;
        button.userInteractionEnabled=YES;
        NSInteger index=[longPress.accessibilityValue integerValue];
        [longPress.view removeFromSuperview];
        [self.imageArray removeObjectAtIndex:index];
       
    }];
    [alert addAction:okAlert];
       [self presentViewController:alert animated:YES completion:nil];
   
}
-(void)commit{
    MBProgressHUD *hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text=@"数据加载中，请稍候...";
    NSString *token=[[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSDictionary *messageDic=[projectNameArray objectAtIndex:number];
    NSString *str=[messageDic objectForKey:@"projectId"];
    NSString *str1=[messageDic objectForKey:@"processId"];
    if (str1==NULL||str1==nil)  str1=@"";
    if (str==NULL||str==nil)  str=@"";
    if (self.imageArray.count==0) {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"请至少添加一张图片" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:cancelAlert];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if ([detailText.text isEqualToString:@""]) {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"请填写意见" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:cancelAlert];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    [HZLoginService ShangBaoCommitWithToken:token ProjectId:str processId:str1 details:detailText.text picture:self.imageArray andBlock:^(NSDictionary *returnDic, NSError *error) {
        [hud hideAnimated:YES];
        if ([[returnDic objectForKey:@"code"]integerValue]==0) {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提交成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:cancelAlert];
            [self presentViewController:alert animated:YES completion:nil];
        }else   if ([[returnDic objectForKey:@"code"]integerValue]==900||[[returnDic objectForKey:@"code"]integerValue]==1000) {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:[returnDic objectForKey:@"desc"] message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancelAlert];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            
        }

    }];
}
#pragma mark - UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
       bgScrollView.contentOffset=CGPointMake(0, 360);
}
-(void)textViewDidChange:(UITextView *)textView{
        self.placehoderLabel.hidden=YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
        self.numLabel.text =[NSString stringWithFormat:@"%d/200",(int)[textView.text length]];
        bgScrollView.contentOffset=CGPointMake(0, 0);
        
        if (textView.text==NULL||[textView.text isEqualToString:@""]) {
            self.placehoderLabel.hidden=NO;
        }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
        if ([textView.text length]>=200)
        {
             textView.text = [textView.text substringToIndex:199];
        }
        else
        {
            self.numLabel.text =[NSString stringWithFormat:@"%d/200",(int)[textView.text length]];
            return YES;
        }
    
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
