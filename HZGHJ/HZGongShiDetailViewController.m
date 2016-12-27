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
#import "HZURL.h"
@interface HZGongShiDetailViewController ()<UIGestureRecognizerDelegate,UITextViewDelegate,UIImagePickerControllerDelegate>
{
    UIScrollView *bgScrollView;
    NSDictionary *returnData;
    NSMutableArray *imageAray;
     NSMutableArray *imageNameAray;
}


@end

@implementation HZGongShiDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回"style:UIBarButtonItemStyleBordered target:nil action:nil];
    switch (self.type) {
        case 1:
            self.title=@"公示详情(起始日)";
            break;
        case 2:
            self.title=@"公示详情(结束日)";
            break;
        case 3:
            self.title=@"时间1";
            break;
        case 4:
            self.title=@"时间2";
            break;
        default:
            break;
    }
    returnData=[[NSDictionary alloc]init];
    imageAray=[[NSMutableArray alloc]init];
    imageNameAray=[[NSMutableArray alloc]init];
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
        
        UIView* bgView=[[UIView alloc]initWithFrame:CGRectMake(0,40*4+120*i, Width, 80)];
        if (self.isGongShi==NO) {
            bgView.frame=CGRectMake(0,40*5+120*i, Width, 80);
        }
        bgView.backgroundColor=[UIColor whiteColor];
        bgView.userInteractionEnabled=YES;
        [bgScrollView addSubview:bgView];
        
        NSArray*imageNameArray1=@[@"icon_jj",@"icon_yj"];
        for (int j=0; j<2; j++) {
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(60, 5, 70, 70)];
            imageView.userInteractionEnabled=YES;
            if (j==1) {
                imageView.frame=CGRectMake(Width-130, 5, 70, 70);
            }
            if (i>2) {
                if (j==1) {
                    imageView.hidden=YES;
                }
                  imageView.frame=CGRectMake(Width/2-35, 5, 70, 70);
            }
            if (_isGongShi==NO) {
                if (i<3) {
                    imageView.tag=i*2+j;
                }else{
                    imageView.tag=3+i;
                }
                imageView.image=[UIImage imageNamed:[imageNameArray1 objectAtIndex:j]] ;
                UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(takePhoto:)];
                tap.delegate=self;
                tap.accessibilityValue=[NSString stringWithFormat:@"%d_%d",i+1,j+1];
                [imageView addGestureRecognizer:tap];
                [bgView addSubview:imageView];
            }else{
                NSMutableArray *imageNameArray2=[[NSMutableArray alloc]init];
                for (int m=0; m<imageAray.count; m++) {
                    NSDictionary *dic=[imageAray objectAtIndex:m];
                    if ([[dic objectForKey:@"type"]integerValue]==i+1) {
                        [imageNameArray2 addObject:dic];
                    }
                }
                NSString *serviceURL=nil;
                if (imageNameArray2.count==2) {
                    NSDictionary *item=[imageNameArray2 objectAtIndex:j];
                    serviceURL=[NSString stringWithFormat:@"%@%@?fileId=%@",kDemoBaseURL,kGetFileURL,[item objectForKey:@"imageId"]];
                    [imageView sd_setImageWithURL:[NSURL URLWithString:serviceURL]];
                }else{
                    if (imageNameArray2.count>0){
                    NSDictionary *item=[imageNameArray2 objectAtIndex:0];
                    serviceURL=[NSString stringWithFormat:@"%@%@?fileId=%@",kDemoBaseURL,kGetFileURL,[item objectForKey:@"imageId"]];
                    [imageView sd_setImageWithURL:[NSURL URLWithString:serviceURL]];
                      imageView.frame=CGRectMake(Width/2-35, 5, 70, 70);
                    }
                }
                
                UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bigPhoto:)];
                tap.delegate=self;
                 tap.accessibilityValue=serviceURL;
                [imageView addGestureRecognizer:tap];
                [bgView addSubview:imageView];
            }
        }
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
    MBProgressHUD *hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text=@"数据加载中，请稍候...";
    NSString *token=[[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString *type=[NSString stringWithFormat:@"%d",type];
    [HZLoginService GongShiCommitWithToken:token ProjectId:[self.listDic objectForKey:@"projectid"] Publicid:[self.listDic objectForKey:@"id"] Type:type imageObjectArray:imageAray imageNameArray:imageNameAray andBlock:^(NSDictionary *returnDic, NSError *error) {
            [hud hideAnimated:YES];
        if ([[returnDic objectForKey:@"code"]integerValue]==0) {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:[returnDic objectForKey:@"desc"] message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
-(void)takePhoto:(UITapGestureRecognizer *)sender{
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
        picker.allowsEditing=YES;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:Nil];
    }];
    [alert addAction:cameraAlert];
    UIAlertAction *pictureAlert=[UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController*picker = [[UIImagePickerController alloc] init];
        picker.accessibilityValue=sender.accessibilityValue;
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
    UIImage *scaleImage = [self scaleImage:originImage toScale:0.1];
//    UIImageView *button=[self.view viewWithTag:[picker.accessibilityValue integerValue]-1];
//    [button setBackgroundImage:scaleImage forState:UIControlStateNormal];
    NSData *data=UIImagePNGRepresentation(scaleImage);
    [imageNameAray addObject:picker.accessibilityValue];
    [imageAray addObject:data];
    NSLog(@"imageNameAray    %@  imageAray   %@",imageNameAray,imageAray);
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

        } else   if ([[returnDic objectForKey:@"code"]integerValue]==900||[[returnDic objectForKey:@"code"]integerValue]==1000) {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:[returnDic objectForKey:@"desc"] message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancelAlert];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            
        }
    }];
}
-(void)bigPhoto:(UITapGestureRecognizer*)sender{
    HZPictureViewController *picture=[[HZPictureViewController alloc]init];
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
