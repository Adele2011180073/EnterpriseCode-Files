//
//  HZLocateContentViewController.m
//  HZGHJ
//
//  Created by zhang on 2017/5/9.
//  Copyright © 2017年 FiveFu. All rights reserved.
//

#import "HZLocateContentViewController.h"
#import "HZIllustrateViewController.h"
#import "HZYangBiaoViewController.h"
#import "HZPictureViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "HZMapServiceViewController.h"
#import "MBProgressHUD.h"
#import "HZBanShiService.h"
#import "UIViewController+BackButtonHandler.h"
#import "UIView+Toast.h"
#import "HZLoginViewController.h"
#import "HZLocateViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import "UIImageView+WebCache.h"
#import "UIImage+MultiFormat.h"
#import "HZURL.h"
#import "HZZaiXianTianXieViewController.h"
#import "HZZaiXianTianXieViewController1.h"
#import "HZZaiXianTianXieViewController2.h"
#import "HZZaiXianTianXieViewController3.h"
#import "HZZaiXianTianXieViewController4.h"
#import "HZZaiXianTianXieViewController5.h"
#import "HZZaiXianTianXieViewController6.h"
#import "HZZaiXianTianXieViewController7.h"
#import "HZZaiXianTianXieViewController8.h"
#import "HZZaiXianTianXieViewController9.h"

@interface HZLocateContentViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UINavigationBarDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>{
    UIButton *_rightBarBtn;
     UIScrollView *_mainBgView;//整个scrollview
    UIScrollView *_mainListView;//网格scrollview
    
    NSArray *statusLabelArray;//必要性
    NSArray *nameLabelaArray;
    
    NSMutableDictionary * _imageAllArray;//所有图片数组
    UITextField *_textfield;
    NSMutableArray*_imageNameArray;//上传图片名称数组
    NSMutableArray*_imageCommitArray;//上传图片数组
//    NSMutableArray*_imageReCommitArray;//获取的已上传图片数组数据
    NSMutableArray *_MATERArray;
    UIImagePickerController* _picker;
}

@end

@implementation HZLocateContentViewController
@synthesize saveDic;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden=NO;
    self.view.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回"style:UIBarButtonItemStylePlain target:nil action:nil];
    self.title=@"申报材料";
    
    _rightBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 5, 80, 20)];
    [_rightBarBtn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [_rightBarBtn addTarget:self action:@selector(illustrate) forControlEvents:UIControlEventTouchUpInside];
    [_rightBarBtn setTitle:@"填表说明" forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBarBtn];
    self.navigationItem.rightBarButtonItem = leftItem;
    
    _mainBgView=[[UIScrollView alloc]init];
    _mainBgView.frame=CGRectMake(0, 0, Width, Height-44);
    _mainBgView.contentSize=CGSizeMake(Width, 1280);
    _mainBgView.userInteractionEnabled=YES;
    [self.view addSubview:_mainBgView];
    _mainListView=[[UIScrollView alloc]init];
    _mainListView.frame=CGRectMake(5, 10, Width-10,1260);
//     _mainBgView.contentSize=CGSizeMake(520-6, 1350);
    _mainListView.userInteractionEnabled=YES;
    [_mainBgView addSubview:_mainListView];
    _imageCommitArray=[[NSMutableArray alloc]init];
    _imageNameArray=[[NSMutableArray alloc]init];
    _imageAllArray=[[NSMutableDictionary alloc]init];
    _MATERArray=[[NSMutableArray alloc]init];
    
    
    [self getImageNameArray];
    [self addMainListView];
    if (self.uuid==NULL||self.uuid==nil) {
        self.commitData=[[NSDictionary alloc]init];
    }else{
        NSLog(@"self.commitData   %@",self.commitData);
        [self getResourceData];
     
    }

   
}
//MARK:获取已提交信息
-(void)getResourceData{
    MBProgressHUD *hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text=@"请求中...";
    [HZBanShiService BanShiWithId:self.uuid AddBlock:^(NSDictionary *returnDic, NSError *error) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[returnDic objectForKey:@"code"]integerValue]==0) {
            NSArray *array=[returnDic objectForKey:@"obj"];
            NSLog(@"returnDic  %@",returnDic);
            for (int i=0; i<array.count; i++) {
                NSDictionary *dic=[array objectAtIndex:i];
                for (int j=0; j<_MATERArray.count; j++) {
                    NSString *templateidpurename=[NSString stringWithFormat:@"%@_%@",[dic objectForKey:@"templateid"],[dic objectForKey:@"purename"]];
                 if([templateidpurename rangeOfString:[_MATERArray objectAtIndex:j]].location !=NSNotFound) {
                        NSMutableArray *array=[[NSMutableArray alloc]init];
                        UIImage *image=[UIImage sd_imageWithData:[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?fileId=%@",kDemoBaseURL,kGetFileURL,[dic objectForKey:@"id"]]]]];
                        [array addObject:image];
                     [_imageAllArray setObject:array forKey:[NSString stringWithFormat:@"%d",j+1]];
                        [_imageCommitArray addObject:image];
                        NSString *imagename=[_MATERArray objectAtIndex:j];
                        [_imageNameArray addObject:imagename];
                    }
                }
            }
             [self addMainListView];
        }else{
            [self.view makeToast:[returnDic objectForKey:@"desc"] duration:2 position:CSToastPositionCenter];
        }

    }];
}
//获取图片名
-(void)getImageNameArray{
    NSArray *array1=[[NSArray alloc]initWithObjects:@"CC23D9E6DF1F431588CB61FC2C46A808",@"EABB51B0F6BC4E549F8A16F2565E3F02_a$",@"EABB51B0F6BC4E549F8A16F2565E3F02_b$",@"EABB51B0F6BC4E549F8A16F2565E3F02_c$",@"994491EC29784BD0AA0C5FBDBB5A91FC",@"11F995DF0DDA47EA82E76E75C6D5423D",@"62D10DD3F5F1493BA39F80AF272A5C19",@"A126BD364D77479DB4C5C4DE11683078", nil];
        NSArray *array2=[[NSArray alloc]initWithObjects:@"171A82814CC34B6AA2125303A9BAE81C",@"DC5AB54D37D847208AD4E7652A26DEC6_a$",@"DC5AB54D37D847208AD4E7652A26DEC6_b$",@"DC5AB54D37D847208AD4E7652A26DEC6_c$",@"AF0FFA6881CA416DB4FA36735C0E8BE0",@"3A762AA2B9B644A7BDECE2F0EEA1B2DB",@"562B56FDE73A4BDDA493B8DE5970F31E",@"EC6CE19DA8EB46C48250132AF40306C3",@"A9C26C85E9C24539952CAA3383754B0C", nil];
      NSArray *array3=[[NSArray alloc]initWithObjects:@"171A82814CC34B6AA2125303A9BAE81C",@"DC5AB54D37D847208AD4E7652A26DEC6_a$",@"DC5AB54D37D847208AD4E7652A26DEC6_b$",@"DC5AB54D37D847208AD4E7652A26DEC6_c$",@"AF0FFA6881CA416DB4FA36735C0E8BE0",@"3A762AA2B9B644A7BDECE2F0EEA1B2DB",@"0DFE90E72D32479285864CA36E4F86F0",@"562B56FDE73A4BDDA493B8DE5970F31E",@"EC6CE19DA8EB46C48250132AF40306C3",@"A9C26C85E9C24539952CAA3383754B0C", nil];
    NSArray *array4=[[NSArray alloc]initWithObjects:@"1736932C8C0C44D9AF9D72B1BA411832",@"8401F317CEA1453597D93FFD23BD3BCB_a$",@"8401F317CEA1453597D93FFD23BD3BCB_b$",@"8401F317CEA1453597D93FFD23BD3BCB_c$",@"A362794986CE464B9FC37834EB49750D",@"0E66C235BE6D4C1D8DA568947ED447AC",@"734BA930F91B4E8A8AD08717BAE8B6E8",@"9D5325FD6D59484F997897085B9F0675",@"3783734074F94D21BA4DD7010C427290", nil];
    
     NSArray *array5=[[NSArray alloc]initWithObjects:@"CC23D9E6DF1F431588CB61FC2C46A808",@"EABB51B0F6BC4E549F8A16F2565E3F02_a$",@"EABB51B0F6BC4E549F8A16F2565E3F02_b$",@"EABB51B0F6BC4E549F8A16F2565E3F02_c$",@"994491EC29784BD0AA0C5FBDBB5A91FC",@"11F995DF0DDA47EA82E76E75C6D5423D",@"62D10DD3F5F1493BA39F80AF272A5C19",@"A126BD364D77479DB4C5C4DE11683078",@"E26708522C3646D2BF473120CAB702EB", nil];
    NSArray *array6=[[NSArray alloc]initWithObjects:@"076CD67496C948C59227FBC9AB03C70B",@"10F44FEE45ED426593F5DBAFEEB0C5F6_a$",@"10F44FEE45ED426593F5DBAFEEB0C5F6_b$",@"10F44FEE45ED426593F5DBAFEEB0C5F6_c$",@"936A909C76E24C1A83AD5AC3FD13E5BB",@"4CA55780FE5C4B99855E51B60B062564",@"51FA30FFB9894056AEE6F18AD799C072",@"D73BB1BE2C0944698DADEF470EBD3353",@"1BC70D8318D742918B640B6F9F0DF1B3",@"7F640059B99446F1B7E5DDCE86248C56",@"5CC2B588F74040ECB30BF05BFC6C8A0C",@"96A3F36972D94652AAD1362651A5A6F8",@"99E0CE42690F4A2B9B14181E5D68B9A7",@"691AFAB158F9441F99F00764C27949AB", nil];
     NSArray *array7=[[NSArray alloc]initWithObjects:@"18CAF499343B41A9A417F57CB4A100BB",@"237CAA84BF274703935F18016609A8A9_a$",@"237CAA84BF274703935F18016609A8A9_b$",@"237CAA84BF274703935F18016609A8A9_c$",@"7984B95DC0E5442CA66C93493C0C6BB2",@"936A909C76E24C1A83AD5AC3FD13E5BB",@"193D22D468FA449E981CDB1887913D1F",@"3530D17F48BE407A8824A859B6659970",@"249AA856E5C040CD83A8B4D7FE1A6364", nil];
   NSArray *array8=[[NSArray alloc]initWithObjects:@"503BF785B4D0C569E05326FF1FAC18DA",@"503BF785B4C4C569E05326FF1FAC18DA_a$",@"503BF785B4C4C569E05326FF1FAC18DA_b$",@"503BF785B4C4C569E05326FF1FAC18DA_c$",@"503BF785B4C5C569E05326FF1FAC18DA",@"503BF785B4C6C569E05326FF1FAC18DA",@"503BF785B4C7C569E05326FF1FAC18DA",@"503BF785B4C8C569E05326FF1FAC18DA",@"503BF785B4C9C569E05326FF1FAC18DA",@"503BF785B4CAC569E05326FF1FAC18DA",@"503BF785B4CBC569E05326FF1FAC18DA",@"503BF785B4CCC569E05326FF1FAC18DA",@"503BF785B4CDC569E05326FF1FAC18DA",@"503BF785B4CEC569E05326FF1FAC18DA",@"503BF785B4CFC569E05326FF1FAC18DA", nil];
    NSArray *array9=[[NSArray alloc]initWithObjects:@"CD7967B3FEEB4D1EB82084BDEA1AD394",@"F0F0E30CADC94A378F2E248D14E8CFB5_a$",@"F0F0E30CADC94A378F2E248D14E8CFB5_b$",@"F0F0E30CADC94A378F2E248D14E8CFB5_c$",@"758B45540C584311BAE9C9232A177C4B",@"66F0FCE05A3F4165949DB7EAD85DA8E5",@"D7AB5B8FD4BE4783B6F4BFB8CAA20E0F",@"4728F75FEBC045DEA196FBDE25656ABA",@"B1A7E10F7D9F4BE783671F20B6FD5CBF",@"79DBCCDA934F4ADAA9E705B40F3C9A3B", nil];
     NSArray *array10=[[NSArray alloc]initWithObjects:@"BED7FDEFCB864D1E82229F3FA829B7DC",@"DCCB368A17C145CCA28079596801B1DA_a$",@"DCCB368A17C145CCA28079596801B1DA_b$",@"DCCB368A17C145CCA28079596801B1DA_c$",@"03CBD62659CF463CBCB7AAE4224917A6",@"3B1F8718CB6144E89A73D0EF5F5C6D7A",@"9D755613E96949218E967FE27F4362B8",@"A35D37438AF54A82BFAFED8BA4F80C59",@"15D3F38B40574DA4955548B74753F6D5",@"B543A8053B7A4331B34DA52043D6E5CC",@"3C740017CF3049EF97AC0FDED6F6B28F",@"ED7A94EEB6ED4126B3C20A0D491F43C8", nil];
   
    NSString *qlsxcode=[self.qlsxcodeDic objectForKey:@"qlsxcode"];
    if (self.uuid==NULL||self.uuid==nil) {
        qlsxcode=[self.qlsxcodeDic objectForKey:@"qlsxcode"];
    }else{
        qlsxcode=[self.reCommitData objectForKey:@"qlsxcode"];
    }
    if ([qlsxcode isEqualToString:@"EAF31D8225045AE8CFA4E04C961F5D86"]||[qlsxcode isEqualToString:@"1FE087B8241745F16C0133ABB4832B8C"]||[qlsxcode isEqualToString:@"06C6B52BF5142FB69BA0113DFD08C77B"]||[qlsxcode isEqualToString:@"0496B51F3AB9B5135F85F31B8F255857"]) {
         [_MATERArray addObjectsFromArray:array1];
    }else if ([qlsxcode isEqualToString:@"716c0ebb-d774-42f5-84da-54b0b143bc06"]) {
          [_MATERArray addObjectsFromArray:array2];
    }else if ([qlsxcode isEqualToString:@"c0865333-0cbd-4440-86da-3386defefdba"]) {
        [_MATERArray addObjectsFromArray:array3];
    }else if ([qlsxcode isEqualToString:@"0ef7e0ce-bb77-4979-8cc3-166d08712b96"]||[qlsxcode isEqualToString:@"b8e6c1ea-6f89-4a2d-af17-78183b3e8a9f"]) {
        [_MATERArray addObjectsFromArray:array4];
    }else if ([qlsxcode isEqualToString:@"31104F35575B4CB91AA7D5C014E730B1"]||[qlsxcode isEqualToString:@"F16BFFA466D5374C9D991F026936438F"]||[qlsxcode isEqualToString:@"42CBF39D427712000C357F3E7494007B"]||[qlsxcode isEqualToString:@"51760F1375EB1CF64A180319B743C392"]) {//风景名胜区
        [_MATERArray addObjectsFromArray:array5];
    }else if ([qlsxcode isEqualToString:@"598ea023-d3cc-4168-b3fb-529ffff53d8d"] ){//建设工程规划类许可证核发
        if ([self.type isEqualToString:@"建筑类"]) {
               [_MATERArray addObjectsFromArray:array6];
        }else if ([self.type isEqualToString:@"市政类"]) {
               [_MATERArray addObjectsFromArray:array7];
        }
        if ([[self.commitData objectForKey:@"businessId"]intValue]==107) {
             [_MATERArray addObjectsFromArray:array6];
        }else if ([[self.commitData objectForKey:@"businessId"]intValue]==115){
              [_MATERArray addObjectsFromArray:array7];
        }
     
    }else if ([qlsxcode isEqualToString:@"6241e908-79a4-4782-b5de-204178602601"] ){//临时建设工程规划许可证核发
         [_MATERArray addObjectsFromArray:array8];
    }else if ([qlsxcode isEqualToString:@"87ed0a9d-856b-45d3-8e4a-2fa4e32715f5"] ){//建设工程竣工规划核实
        [_MATERArray addObjectsFromArray:array9];
    }else if ([qlsxcode isEqualToString:@"3e9b0641-3a76-4cfe-9666-72350d2385d8"] ){//建设工程设计方案（修建性详细规划）审查
        [_MATERArray addObjectsFromArray:array10];
    }
    for (int i=0; i<_MATERArray.count; i++) {
        [_imageAllArray setObject:@"张" forKey:[NSString stringWithFormat:@"%d",i+1]];
    }
     NSLog(@"_imageAllArray    %@",_MATERArray);
    NSLog(@"_imageAllArray    %@",_imageAllArray);
}

-(void)longPress:(UILongPressGestureRecognizer*)longPressGesture{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确定删除此图片吗？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancelAlert];
    UIAlertAction *okAlert=[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIButton *button=(UIButton *)longPressGesture.view;
        [button removeFromSuperview];
        int index=[longPressGesture.accessibilityValue intValue];
        NSMutableArray *array=[_imageAllArray objectForKey:[NSString stringWithFormat:@"%d",(index/100-10+1)]];
        [array removeObject:button.currentBackgroundImage];
        if (array==nil||array==NULL||array.count==0||[array isEqual:[NSNull null]]) {
            [_imageAllArray setObject:@"张" forKey:[NSString stringWithFormat:@"%d",(index/100-10+1)]];
        }
        NSInteger num=[_imageCommitArray indexOfObject:button.currentBackgroundImage];
        [_imageNameArray removeObjectAtIndex:num];
        [_imageCommitArray removeObjectAtIndex:num];
            [self addMainListView];
    }];
    [alert addAction:okAlert];
    
    [self presentViewController:alert animated:YES completion:nil];
}
//MARK:绘制主表格视图
-(void)addMainListView{
    for (UIView *view in _mainListView.subviews) {
        [view removeFromSuperview];
    }
    nameLabelaArray=[[NSArray alloc]init];
    statusLabelArray=[[NSArray alloc]init];
    NSString * qlsxcode=[self.qlsxcodeDic objectForKey:@"qlsxcode"];
    if (self.uuid==NULL||self.uuid==nil) {
        qlsxcode=[self.qlsxcodeDic objectForKey:@"qlsxcode"];
    }else{
        qlsxcode=[self.reCommitData objectForKey:@"qlsxcode"];
    }
    NSString *placeholder;
    if ([qlsxcode isEqualToString:@"EAF31D8225045AE8CFA4E04C961F5D86"]||[qlsxcode isEqualToString:@"1FE087B8241745F16C0133ABB4832B8C"]) {
        nameLabelaArray=@[@"材料名称",@"《建设项目选址意见书申请表》",@"工商营业执照或组织机构代码证复印件（加盖单位公章）",@"授权委托书（须提供原件核对)",@"委托身份证明（须提供原件核对",@"项目建议书批复（启用审批新流程项目可用发改项目收件单及项目建议书文本、电子文件）或项目备案文件（须提供原件核对）",@"拟建位置1/1000带规划控制线地形图1份",@"有效土地权属证明（须提供原件核对",@"选址论证报告批复文件及报告文本（成果稿）、电子光盘"];
        statusLabelArray=@[@"必要性",@"必要",@"必要",@"必要",@"必要",@"必要",@"必要",@"非必要",@"非必要"];
         placeholder=@"受理号或控规地块";
    }else  if ([qlsxcode isEqualToString:@"06C6B52BF5142FB69BA0113DFD08C77B"]||[qlsxcode isEqualToString:@"0496B51F3AB9B5135F85F31B8F255857"]) {
        nameLabelaArray=@[@"材料名称",@"《建设项目批后修改(延期)事项申请表》",@"工商营业执照或组织机构代码证复印件（加盖单位公章）",@"授权委托书（须提供原件核对)",@"委托身份证明（须提供原件核对)",@"项目建议书批复（启用审批新流程项目可用发改项目收件单及项目建议书文本、电子文件）或项目备案文件（须提供原件核对）",@"拟建位置1/1000带规划控制线地形图1份",@"有效土地权属证明（须提供原件核对",@"选址论证报告批复文件及报告文本（成果稿）、电子光盘"];
        statusLabelArray=@[@"必要性",@"必要",@"必要",@"必要",@"必要",@"必要",@"必要",@"非必要",@"非必要"];
         placeholder=@"受理号或控规地块";
    }  else if ([qlsxcode isEqualToString:@"716c0ebb-d774-42f5-84da-54b0b143bc06"]){
        nameLabelaArray=@[@"材料名称",@"《建设用地规划许可证申请表》",@"工商营业执照或组织机构代码证复印件（加盖单位公章）",@"授权委托书（须提供原件核对)",@"委托身份证明（须提供原件核对)",@"项目批准、核准或备案文件（批准文件为发改部门的可行性研究报告批复）",@"拟建位置1/1000带规划控制线地形图1份",@"出让土地项目提供土地出让合同（须提供原件核对）、勘测定界成果",@"划拔土地项目提供建设项目选址意见书（包括附图）复印件、国土部门用地预审意见（须提供原件核对）及勘测定界成果，涉及使用集体土地项目同步出具属地村民委员会书面同意意见(不含征收集体土地项目)",@"涉及受让主体变更的需提供主体变更材料"];
        statusLabelArray=@[@"必要性",@"必要",@"必要",@"必要",@"必要",@"必要",@"必要",@"非必要（出让土地项目提供）",@"非必要（划拨土地项目提供）",@"非必要(只针对申请变更的项目)"];
         placeholder=@"受理号或控规地块";
    } else if ([qlsxcode isEqualToString:@"c0865333-0cbd-4440-86da-3386defefdba"]){
        nameLabelaArray=@[@"材料名称",@"《建设用地规划许可证申请表》",@"工商营业执照或组织机构代码证复印件（加盖单位公章）",@"授权委托书（须提供原件核对)",@"委托身份证明（须提供原件核对)",@"项目批准、核准或备案文件（批准文件为发改部门的可行性研究报告批复）",@"拟建位置1/1000带规划控制线地形图1份",@"申请临时建设用地规划许可证需提供因建设项目施工或者地质勘查需要临时使用土地的有关证明文件",@"出让土地项目提供土地出让合同（须提供原件核对）、勘测定界成果",@"划拔土地项目提供建设项目选址意见书（包括附图）复印件、国土部门用地预审意见（须提供原件核对）及勘测定界成果，涉及使用集体土地项目同步出具属地村民委员会书面同意意见(不含征收集体土地项目)",@"涉及受让主体变更的需提供主体变更材料"];
        statusLabelArray=@[@"必要性",@"必要",@"必要",@"必要",@"必要",@"必要",@"必要",@"非必要（申请临时建设用地规划许可提供)",@"非必要（出让土地项目提供）",@"非必要（划拨土地项目提供）",@"非必要(只针对申请变更的项目)"];
        placeholder=@"受理号或控规地块";
    }else if ([qlsxcode isEqualToString:@"0ef7e0ce-bb77-4979-8cc3-166d08712b96"]||[qlsxcode isEqualToString:@"b8e6c1ea-6f89-4a2d-af17-78183b3e8a9f"]){
        nameLabelaArray=@[@"材料名称",@"《建设项目规划条件申请表》",@"工商营业执照或组织机构代码证复印件（加盖单位公章）",@"授权委托书（须提供原件核对)",@"委托身份证明（须提供原件核对)",@"项目批准、核准、备案文件、服务联系单、项目建议书批复或储备土地出让前期计划文件(须提供原件核对)",@"拟建位置1/1000带规划控制线地形图1份",@"选址论证报告批复文件及报告文本（成果稿）、电子光盘(要求编制选址论址报告的项目提供)",@"自有用地项目提供有效土地权属证明、房产权属证明（须提供原件核对）及原规划批准文件（视不同情况提供，须提供原件核对)",@"涉及外立面装修类项目不需立项，但须提供房产权属证明、土地权属证明及彩色现状照片、供参考的彩色实景效果图1份"];
        statusLabelArray=@[@"必要性",@"必要",@"必要",@"必要",@"必要",@"必要",@"必要",@"非必要(要求编制选址论证报告的项目)",@"非必要(自有用地项目提供)",@"非必要(针对立面装修项目)"];
        placeholder=@"受理号或控规地块";
    }else if ([qlsxcode isEqualToString:@"31104F35575B4CB91AA7D5C014E730B1"]||[qlsxcode isEqualToString:@"F16BFFA466D5374C9D991F026936438F"]||[qlsxcode isEqualToString:@"42CBF39D427712000C357F3E7494007B"]||[qlsxcode isEqualToString:@"51760F1375EB1CF64A180319B743C392"]){//风景名胜区建设项目新报、基本变更（选址位置、用地规模、建设规模）//风景名胜区建设项目证书失效重新核发//风景名胜区建设项目简易变更（项目名称、建设单位）//风景名胜区建设项目延期
       placeholder=@"四线受理号";
        nameLabelaArray=@[@"材料名称",@"书面申请书（《建设项目选址申请书》（一般建设项目新报））",@"工商营业执照或组织机构代码证复印件（加盖单位公章）",@"授权委托书（须提供原件核对）",@"委托身份证明（须提供原件核对）",@"项目建议书批复（启用审批新流程项目可用发改项目收件单及项目建议书文本、电子文件）或行政许可申请材料补正告知书（须提供原件核对）",@"标明拟选址位置的地形图（拟建位置1/1000带规划控制线地形图1份用铅笔标明拟用地位置）",@"有效土地权属证明（自有用地项目提供）（须提供原件核对）",@"选址论证报告批复文件及报告文本(成果稿)、电子光盘（要求编制选址论证报告的项目提供）",@"西湖风景名胜区项目需提供立项回复单、选址申报书、项目相关的会议纪要和政府研究批文（如涉及该项目本阶段事宜的需提供）"];
        statusLabelArray=@[@"必要性",@"必要",@"必要",@"必要",@"必要",@"必要",@"必要",@"非必要",@"非必要(要求编制选址论证报告的项目提供)",@"非必要(西湖风景区项目提供)"];
    }else if ([qlsxcode isEqualToString:@"598ea023-d3cc-4168-b3fb-529ffff53d8d"]){//建设工程规划许可证核发
        if ([self.type isEqualToString:@"建筑类"]) {
            nameLabelaArray=@[@"材料名称",@"《建设工程规划许可证申请表》（建筑类）",@"工商营业执照或组织机构代码证复印件（加盖单位公章）",@"授权委托书（须提供原件核对）",@"委托身份证明（须提供原件核对）",@"方案、扩初联合审查意见及批复意见（含有初步设计项目提供），经复核同意的方案总平面图",@"相应资质的设计单位设计的建筑施工图（平、立、剖面图一套），1/500（范围较大时1/1000）总平面蓝图四份（总平面蓝图加盖预定位章）、成果电子文件一份（含三维电子模型）",@"有效土地权属证明（建设用地批准书或土地证，须提供原件核对），国有土地出让合同（出让项目提供，须提供原件核对）",@"建设行政主管部门出具的民用建筑节能意见（须提供原件核对）",@"需公示项目的公示材料，包括现场公示图片，社区反馈意见。（较原批方案有调整时提交再次公示的材料原件，较原批方案没调整时提交方案审批时提供材料的复印件）",@"经复核的日照分析报告（按照《杭州市建筑工程日照分析技术管理规则》要求需进行日照分析的项目提供）",@"景观分析报告（拟批建设项目处于城市规划确定的景观控制区时提供，较原批方案有调整时提交修改的景观分析报告原件，较原批方案没调整时提交方案审批时提供材料的复印件）",@"国家、省、市重点建设项目以及其他公共设施建设项目，其建筑间距达不到国家和地方规定的日照标准要求的，提供取得受影响建筑所有权人同意达成的日照补偿协议",@"变更规划条件涉及补缴土地出让金的，应提供补缴证明",@"违法补办项目提供处罚决定书"];
            statusLabelArray=@[@"必要性",@"必要（建筑类）",@"必要",@"必要",@"必要",@"必要",@"必要",@"必要",@"必要",@"必要",@"非必要",@"非必要",@"非必要",@"非必要",@"非必要"];
        }else if ([self.type isEqualToString:@"市政类"]) {
            nameLabelaArray=@[@"材料名称",@"《建设工程规划许可证申请表》（市政类）",@"工商营业执照或组织机构代码证复印件（加盖单位公章）",@"授权委托书（须提供原件核对）",@"委托身份证明（须提供原件核对）",@"建设项目选址意见书或规划条件（包括附图）复印件（须提供原件核对）",@"方案、扩初联合审查意见及批复意见（含有初步设计项目提供），经复核同意的方案总平面图",@"相应资质的设计单位设计的建筑施工图（平、立、剖面图一套），1/500（范围较大时1/1000）总平面蓝图四份（总平面蓝图加盖预定位章）、成果电子文件一份（含三维电子模型）",@"有效土地权属证明（建设用地批准书或土地证，须提供原件核对），国有土地出让合同（出让项目提供，须提供原件核对）",@"需公示项目的公示材料，包括现场公示图片，社区反馈意见。（较原批方案有调整时提交再次公示的材料原件，较原批方案没调整时提交方案审批时提供材料的复印件）"];
            statusLabelArray=@[@"必要性",@"必要（市政类）",@"必要",@"必要",@"必要",@"必要",@"必要",@"必要",@"必要",@"必要"];
        }
        if ([[self.commitData objectForKey:@"businessId"]intValue]==107) {
            nameLabelaArray=@[@"材料名称",@"《建设工程规划许可证申请表》（建筑类）",@"工商营业执照或组织机构代码证复印件（加盖单位公章）",@"授权委托书（须提供原件核对）",@"委托身份证明（须提供原件核对）",@"方案、扩初联合审查意见及批复意见（含有初步设计项目提供），经复核同意的方案总平面图",@"相应资质的设计单位设计的建筑施工图（平、立、剖面图一套），1/500（范围较大时1/1000）总平面蓝图四份（总平面蓝图加盖预定位章）、成果电子文件一份（含三维电子模型）",@"有效土地权属证明（建设用地批准书或土地证，须提供原件核对），国有土地出让合同（出让项目提供，须提供原件核对）",@"建设行政主管部门出具的民用建筑节能意见（须提供原件核对）",@"需公示项目的公示材料，包括现场公示图片，社区反馈意见。（较原批方案有调整时提交再次公示的材料原件，较原批方案没调整时提交方案审批时提供材料的复印件）",@"经复核的日照分析报告（按照《杭州市建筑工程日照分析技术管理规则》要求需进行日照分析的项目提供）",@"景观分析报告（拟批建设项目处于城市规划确定的景观控制区时提供，较原批方案有调整时提交修改的景观分析报告原件，较原批方案没调整时提交方案审批时提供材料的复印件）",@"国家、省、市重点建设项目以及其他公共设施建设项目，其建筑间距达不到国家和地方规定的日照标准要求的，提供取得受影响建筑所有权人同意达成的日照补偿协议",@"变更规划条件涉及补缴土地出让金的，应提供补缴证明",@"违法补办项目提供处罚决定书"];
            statusLabelArray=@[@"必要性",@"必要（建筑类）",@"必要",@"必要",@"必要",@"必要",@"必要",@"必要",@"必要",@"必要",@"非必要",@"非必要",@"非必要",@"非必要",@"非必要"];
        }else if ([[self.commitData objectForKey:@"businessId"]intValue]==115){
            nameLabelaArray=@[@"材料名称",@"《建设工程规划许可证申请表》（市政类）",@"工商营业执照或组织机构代码证复印件（加盖单位公章）",@"授权委托书（须提供原件核对）",@"委托身份证明（须提供原件核对）",@"建设项目选址意见书或规划条件（包括附图）复印件（须提供原件核对）",@"方案、扩初联合审查意见及批复意见（含有初步设计项目提供），经复核同意的方案总平面图",@"相应资质的设计单位设计的建筑施工图（平、立、剖面图一套），1/500（范围较大时1/1000）总平面蓝图四份（总平面蓝图加盖预定位章）、成果电子文件一份（含三维电子模型）",@"有效土地权属证明（建设用地批准书或土地证，须提供原件核对），国有土地出让合同（出让项目提供，须提供原件核对）",@"需公示项目的公示材料，包括现场公示图片，社区反馈意见。（较原批方案有调整时提交再次公示的材料原件，较原批方案没调整时提交方案审批时提供材料的复印件）"];
            statusLabelArray=@[@"必要性",@"必要（市政类）",@"必要",@"必要",@"必要",@"必要",@"必要",@"必要",@"必要",@"必要"];
        }
        
    }else if ([qlsxcode isEqualToString:@"6241e908-79a4-4782-b5de-204178602601"]){//临时建设工程规划许可证核发
        nameLabelaArray=@[@"材料名称",@"建设工程规划许可证申请表",@"工商营业执照或组织机构代码证复印件（加盖单位公章）",@"授权委托书（须提供原件核对）",@"委托身份证明（须提供原件核对）",@"方案、扩初联合审查意见及批复意见（含有初步设计项目提供），经复核同意的方案总平面图",@"相应资质的设计单位设计的建筑施工图（平、立、剖面图一套），1/500（范围较大时1/1000）总平面蓝图四份（总平面蓝图加盖预定位章）、成果电子文件一份（含三维电子模型）",@"有效土地权属证明（建设用地批准书或土地证，须提供原件核对），国有土地出让合同（出让项目提供，须提供原件核对）",@"建设行政主管部门出具的民用建筑节能意见（须提供原件核对）",@"需公示项目的公示材料，包括现场公示图片，社区反馈意见。（较原批方案有调整时提交再次公示的材料原件，较原批方案没调整时提交方案审批时提供材料的复印件）",@"经复核的日照分析报告（按照《杭州市建筑工程日照分析技术管理规则》要求需进行日照分析的项目提供）",@"景观分析报告（拟批建设项目处于城市规划确定的景观控制区时提供，较原批方案有调整时提交修改的景观分析报告原件，较原批方案没调整时提交方案审批时提供材料的复印件）",@"国家、省、市重点建设项目以及其他公共设施建设项目，其建筑间距达不到国家和地方规定的日照标准要求的，提供取得受影响建筑所有权人同意达成的日照补偿协议",@"变更规划条件涉及补缴土地出让金的，应提供补缴证明",@"临时建设影响交通、市容、安全等的，提供相应行政主管部门意见",@"违法补办项目提供处罚决定书"];
        statusLabelArray=@[@"必要性",@"必要",@"必要",@"必要",@"必要",@"必要",@"必要",@"必要",@"必要",@"必要",@"非必要",@"非必要",@"非必要",@"非必要",@"非必要",@"非必要"];
    }else if ([qlsxcode isEqualToString:@"87ed0a9d-856b-45d3-8e4a-2fa4e32715f5"]){//建设工程竣工规划核实
        nameLabelaArray=@[@"材料名称",@"《建设工程竣工规划核实申请表》",@"工商营业执照或组织机构代码证复印件（加盖单位公章）",@"授权委托书（须提供原件核对）",@"委托身份证明（须提供原件核对）",@"建设项目选址意见书或规划条件（包括附图）复印件（须提供原件核对）",@"建设用地规划许可证、建设工程规划许可证及附件、附图和施工许可证(复印件须提供原件核对）",@"经加盖竣工章的建设工程竣工总平面图二份和平、立、剖面图一套",@"有相应测绘资质等级的勘测单位出具的竣工测绘成果",@"建设项目批后管理跟踪表或盖有规划分局公章的批后跟踪意见书",@"如有违法建设情况，需提供处罚凭证"];
        statusLabelArray=@[@"必要性",@"必要",@"必要",@"必要",@"必要",@"必要",@"必要",@"必要",@"必要",@"必要",@"非必要"];
    }else if ([qlsxcode isEqualToString:@"3e9b0641-3a76-4cfe-9666-72350d2385d8"]){//建设工程设计方案（修建性详细规划）审查
        nameLabelaArray=@[@"材料名称",@"《建设工程方案设计审查申请表》",@"工商营业执照或组织机构代码证复印件（加盖单位公章）",@"授权委托书（须提供原件核对）",@"委托身份证明（须提供原件核对）",@"项目立项批准文件（须提供原件核对）",@"建设项目选址意见书或规划条件（包括附图），出让土地项目同步提供含规划条件的土地出让合同（须提供原件核对）",@"有效土地权属证明（存量土地提供土地证、新征土地视情况提供用地规划许可证）（须提供原件核对)",@"方案设计1/500（范围较大时1/1000）总平面蓝图二份",@"相应资质的设计单位编制的含方案说明书、效果图、总平面图、建筑方案图等的设计方案文本一套（同时提交电子文件一份）",@"日照分析成果（按照《杭州市建筑工程日照分析技术管理规则》要求需进行日照分析的项目提供）",@"景观分析报告（拟批建设项目处于城市规划确定的景观控制区时提供）",@"规划公示材料，包括现场公示图片、社区反馈意见"];
        statusLabelArray=@[@"必要性",@"必要",@"必要",@"必要",@"必要",@"必要",@"必要",@"必要",@"必要",@"必要",@"非必要",@"非必要",@"必要"];
    }
    for (int i=0; i<statusLabelArray.count; i++) {
        UIView *nameLabelView1=[[UIView alloc]initWithFrame:CGRectMake(0, 60+120*(i-1),160, 120)];
        nameLabelView1.userInteractionEnabled=YES;
        nameLabelView1.tag=300+i;
        nameLabelView1.layer.borderColor=blueCyan.CGColor;
        nameLabelView1.layer.borderWidth=0.5;
        [_mainListView addSubview:nameLabelView1];
        UIView *statusLabelView2=[[UIView alloc]initWithFrame:CGRectMake(160, nameLabelView1.frame.origin.y, 50, nameLabelView1.frame.size.height)];
        statusLabelView2.userInteractionEnabled=YES;
        statusLabelView2.layer.borderColor=blueCyan.CGColor;
        statusLabelView2.layer.borderWidth=0.5;
        [_mainListView addSubview:statusLabelView2];
        UIScrollView *contentView3=[[UIScrollView alloc]initWithFrame:CGRectMake(210, nameLabelView1.frame.origin.y, Width-10-210, nameLabelView1.frame.size.height)];
        contentView3.tag=1+i;
        contentView3.userInteractionEnabled=YES;
        contentView3.layer.borderColor=blueCyan.CGColor;
        contentView3.layer.borderWidth=0.5;
        [_mainListView addSubview:contentView3];
       
        CGSize size = CGSizeMake(160, MAXFLOAT);//设置高度宽度的最大限度
        CGRect rect = [[nameLabelaArray objectAtIndex:i] boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil];
        UILabel  *label1=[[UILabel alloc]initWithFrame:CGRectMake(0,  0, 160, rect.size.height+10)];
        label1.textAlignment=NSTextAlignmentCenter;
        label1.numberOfLines=10;
        label1.textColor=[UIColor darkGrayColor];
        label1.font=[UIFont systemFontOfSize:14];
        label1.text=[nameLabelaArray objectAtIndex:i];
      

        [nameLabelView1  addSubview:label1];
        UILabel  *label2=[[UILabel alloc]initWithFrame:CGRectMake(0,  0, 50, rect.size.height+40)];
        label2.textAlignment=NSTextAlignmentCenter;
        label2.numberOfLines=10;
        label2.adjustsFontSizeToFitWidth=YES;
        label2.font=[UIFont systemFontOfSize:14];
        label2.textColor=[UIColor darkGrayColor];
        label2.text=[statusLabelArray objectAtIndex:i];
        [statusLabelView2  addSubview:label2];
        
        if (i==0) {
            nameLabelView1.frame=CGRectMake(0, 0,160, 60);
            statusLabelView2.frame=CGRectMake(160, 0,50, 60);
            contentView3.frame=CGRectMake(210, 0,Width-220, 60);
            label1.frame=CGRectMake(0,  0, 160, 60);
            label2.frame=CGRectMake(0,  0, 50, 60);
            UILabel  *label3=[[UILabel alloc]initWithFrame:CGRectMake(0,  0, Width-220, 60)];
            label3.textAlignment=NSTextAlignmentCenter;
            label3.font=[UIFont systemFontOfSize:14];
            label3.text=@"操作";
            [contentView3  addSubview:label3];
        }
        if (i>1) {
            UIView *lastbgview=[self.view viewWithTag:300+i-1];
            nameLabelView1.frame=CGRectMake(0, lastbgview.frame.origin.y+lastbgview.frame.size.height,160, label1.frame.size.height+30);
            statusLabelView2.frame=CGRectMake(160, lastbgview.frame.origin.y+lastbgview.frame.size.height,50, label1.frame.size.height+30);
            contentView3.frame=CGRectMake(210, lastbgview.frame.origin.y+lastbgview.frame.size.height,Width-220, label1.frame.size.height+30);
            if ([label1.text containsString:@"拟建位置1/1000带规划控制线地形图1份"]) {
                nameLabelView1.frame=CGRectMake(0, lastbgview.frame.origin.y+lastbgview.frame.size.height,160, 180);
                statusLabelView2.frame=CGRectMake(160, lastbgview.frame.origin.y+lastbgview.frame.size.height,50, 180);
                contentView3.frame=CGRectMake(210, lastbgview.frame.origin.y+lastbgview.frame.size.height,Width-220, 180);
                _textfield=[[UITextField alloc]initWithFrame:CGRectMake(5, 5, Width-230, 30)];
                _textfield.layer.borderColor=blueCyan.CGColor;
                _textfield.layer.borderWidth=1;
                _textfield.placeholder=placeholder;
                _textfield.delegate=self;
                if (![[self.saveDic objectForKey:@"sxslh"]isEqual:[NSNull null]]&&self.uuid&&self.uuid!=NULL) {
                    _textfield.text=[self.saveDic objectForKey:@"sxslh"];
                }
                _textfield.font=[UIFont systemFontOfSize:15];
                [contentView3 addSubview:_textfield];
                UILabel  *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(5,  40, Width-230, 30)];
                contentLabel.textAlignment=NSTextAlignmentLeft;
                contentLabel.font=[UIFont systemFontOfSize:15];
                contentLabel.text=@"控规地块拍照：";
                [contentView3  addSubview:contentLabel];
                
                UIButton *mapBtn=[[UIButton alloc]initWithFrame:CGRectMake(10,140, 30, 30)];
                [mapBtn addTarget:self action:@selector(map:) forControlEvents:UIControlEventTouchUpInside];
                mapBtn.titleLabel.font=[UIFont fontWithName:@"iconfont" size:32];
                [mapBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                [mapBtn setTitle:@"\U0000e620" forState:UIControlStateNormal];
                [contentView3 addSubview:mapBtn];
            }
            
            
        }

        if (![label2.text containsString:@"非必要"]&&i>0) {
            UIButton *yangbiao=[[UIButton alloc]initWithFrame:CGRectMake(160-60,nameLabelView1.frame.size.height-30, 60, 30)];
            [yangbiao addTarget:self action:@selector(yangbiao:) forControlEvents:UIControlEventTouchUpInside];
            yangbiao.backgroundColor=[UIColor whiteColor];
            yangbiao.accessibilityValue=[NSString stringWithFormat:@"%@",[nameLabelaArray objectAtIndex:i]];
            yangbiao.layer.borderColor=blueCyan.CGColor;
            yangbiao.layer.borderWidth=0.5;
            yangbiao.tag=100+i;
            yangbiao.titleLabel.font=[UIFont systemFontOfSize:15];
            [yangbiao setTitleColor:blueCyan forState:UIControlStateNormal];
            [yangbiao setTitle:@"样表" forState:UIControlStateNormal];
            [nameLabelView1 addSubview:yangbiao];
        }
        if (i==1) {
            UIButton *zaixiantianxie=[[UIButton alloc]initWithFrame:CGRectMake(0,nameLabelView1.frame.size.height-30, 80, 30)];
            [zaixiantianxie addTarget:self action:@selector(zaixiantianxie:) forControlEvents:UIControlEventTouchUpInside];
            zaixiantianxie.backgroundColor=[UIColor whiteColor];
            zaixiantianxie.layer.borderColor=blueCyan.CGColor;
            zaixiantianxie.layer.borderWidth=0.5;
            zaixiantianxie.titleLabel.font=[UIFont systemFontOfSize:15];
            [zaixiantianxie setTitleColor:blueCyan forState:UIControlStateNormal];
            [zaixiantianxie setTitle:@"在线填写" forState:UIControlStateNormal];
            [nameLabelView1 addSubview:zaixiantianxie];
        }
        if (i>0) {
            UIButton *imageBtn=[[UIButton alloc]initWithFrame:CGRectMake(0,(contentView3.frame.size.height-60)/2, 60, 60)];
         
            if ([label1.text containsString:@"拟建位置1/1000带规划控制线地形图1份"]) {
                imageBtn.frame=CGRectMake(0,70, 60, 60) ;
            }
            imageBtn.tag=200+i;
            [imageBtn addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
            imageBtn.titleLabel.font=[UIFont fontWithName:@"iconfont" size:42];
            [imageBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [imageBtn setTitle:@"\U0000e652" forState:UIControlStateNormal];
            [contentView3 addSubview:imageBtn];
        }
        
        if(i==0){
            
        }
       else  if (i==1) {
            //显示图片
            //限制只能拍三张
            NSMutableArray *newImageArray=[[NSMutableArray alloc]init];
            id imageArray=[_imageAllArray objectForKey:[NSString stringWithFormat:@"%d",i]];
            NSLog(@"imageArray    %@",imageArray);
            NSLog(@"_imageAllArray    %@",_imageAllArray);
            if ([imageArray isKindOfClass:[NSString class]]) {

            }else{
                imageArray=(NSMutableArray *) [_imageAllArray objectForKey:[NSString stringWithFormat:@"%d",i]];
                [newImageArray addObjectsFromArray:imageArray];
                UIButton *imageButton=[self.view viewWithTag:200+i];
                imageButton.frame=CGRectMake(10+70*newImageArray.count, imageButton.frame.origin.y, 60, 60);
                contentView3.contentSize=CGSizeMake(60+80*newImageArray.count, contentView3.frame.size.height);
                for (int j=0; j<newImageArray.count; j++) {
                    UIButton *imageBtn=[[UIButton alloc]initWithFrame:CGRectMake(10+70*j,imageButton.frame.origin.y, 60, 60)];
                    imageBtn.tag=1000+i;
                    [imageBtn addTarget:self action:@selector(bigPhoto:) forControlEvents:UIControlEventTouchUpInside];
                    [imageBtn setBackgroundImage:[imageArray objectAtIndex:j] forState:UIControlStateNormal];
                    [contentView3 addSubview:imageBtn];
                    
                    UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
                    longPress.accessibilityValue=[NSString stringWithFormat:@"%d",(int)imageBtn.tag];
                    longPress.delegate=self;
                    [imageBtn addGestureRecognizer:longPress];
                }
                if (newImageArray.count==3) {
                    [imageButton removeFromSuperview];
                }

            }
        }
        else {
            NSMutableArray *newImageArray=[[NSMutableArray alloc]init];
            id imageArray=[_imageAllArray objectForKey:[NSString stringWithFormat:@"%d",i]];
            NSLog(@"imageArray    %@",imageArray);
            NSLog(@"_imageAllArray    %@",_imageAllArray);
            if ([imageArray isKindOfClass:[NSString class]]) {
                
            }else{
                imageArray=(NSMutableArray *) [_imageAllArray objectForKey:[NSString stringWithFormat:@"%d",i]];
                [newImageArray addObjectsFromArray:imageArray];
                UIButton *imageButton=[self.view viewWithTag:200+i];
                imageButton.frame=CGRectMake(10+70*newImageArray.count, imageButton.frame.origin.y, 60, 60);
                contentView3.contentSize=CGSizeMake(60+80*newImageArray.count, contentView3.frame.size.height);
                for (int j=0; j<newImageArray.count; j++) {
                    UIButton *imageBtn=[[UIButton alloc]initWithFrame:CGRectMake(10+70*j,imageButton.frame.origin.y, 60, 60)];
                    imageBtn.tag=(i-1)*100+1000+j;
                    [imageBtn addTarget:self action:@selector(bigPhoto:) forControlEvents:UIControlEventTouchUpInside];
                    [imageBtn setBackgroundImage:[imageArray objectAtIndex:j] forState:UIControlStateNormal];
                    [contentView3 addSubview:imageBtn];
                    
                    UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
                    longPress.accessibilityValue=[NSString stringWithFormat:@"%d",(int)imageBtn.tag];
                    longPress.delegate=self;
                    [imageBtn addGestureRecognizer:longPress];
                }
            if (newImageArray.count==10) {
                [imageButton removeFromSuperview];
            }
        }
    }
    }
     UIView *lastbgview=[self.view viewWithTag:300+nameLabelaArray.count-1];
    _mainListView.frame=CGRectMake(5, 10, Width-10,lastbgview.frame.origin.y+lastbgview.frame.size.height);
    _mainBgView.contentSize=CGSizeMake(Width,_mainListView.frame.origin.y+ _mainListView.frame.size.height+160);

    UIButton *commit=[[UIButton alloc]init];
    commit.frame=CGRectMake(20,_mainListView.frame.size.height+_mainListView.frame.origin.y+30, Width-40, 45);
    [commit addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    commit.backgroundColor=[UIColor colorWithRed:23/255.0 green:177/255.0 blue:242/255.0 alpha:1];
    commit.clipsToBounds=YES;
    commit.layer.cornerRadius=10;
    [_mainBgView addSubview:commit];
     if (self.uuid==NULL||self.uuid==nil) {
      [commit setTitle:@"提交" forState:UIControlStateNormal];
     }else{
        [commit setTitle:@"补正提交" forState:UIControlStateNormal];
     }
    
}
//MARK:样表
-(void)yangbiao:(UIButton*)sender{
    if ([sender.accessibilityValue containsString:@"拟建位置1/1000带规划控制线地形图1份"]) {
        HZYangBiaoViewController *yangbiao=[[HZYangBiaoViewController alloc]init];
        [self.navigationController pushViewController:yangbiao animated:YES];
    }
}
//MARK:在线填写
-(void)zaixiantianxie:(UIButton*)sender{
    self.isBackWarn=YES;
     NSString* qlsxcode=[self.qlsxcodeDic objectForKey:@"qlsxcode"];
    if (self.uuid==NULL||self.uuid==nil) {
        qlsxcode=[self.qlsxcodeDic objectForKey:@"qlsxcode"];
    }else{
        qlsxcode=[self.reCommitData objectForKey:@"qlsxcode"];
    }
    if ([qlsxcode isEqualToString:@"EAF31D8225045AE8CFA4E04C961F5D86"]||[qlsxcode isEqualToString:@"1FE087B8241745F16C0133ABB4832B8C"]) {
        HZZaiXianTianXieViewController *tianxie=[[HZZaiXianTianXieViewController alloc]init];
//        if (self.uuid==NULL||self.uuid==nil) {
//            tianxie.commitData=self.commitData;
//        }else{
            tianxie.commitData=self.commitData;
            tianxie.saveDic=saveDic;
//        }
        tianxie.qlsxcode=qlsxcode;
        [self.navigationController pushViewController:tianxie animated:YES];
    }else  if ([qlsxcode isEqualToString:@"06C6B52BF5142FB69BA0113DFD08C77B"]||[qlsxcode isEqualToString:@"0496B51F3AB9B5135F85F31B8F255857"]) {
        HZZaiXianTianXieViewController1 *tianxie=[[HZZaiXianTianXieViewController1 alloc]init];
//        if (self.uuid==NULL||self.uuid==nil) {
            tianxie.commitData=self.commitData;
//        }else{
//            tianxie.commitData=self.commitData;
//            tianxie.saveDic=saveDic;
//        }
        tianxie.qlsxcode=qlsxcode;
        [self.navigationController pushViewController:tianxie animated:YES];
    }  else if ([qlsxcode isEqualToString:@"716c0ebb-d774-42f5-84da-54b0b143bc06"]||[qlsxcode isEqualToString:@"c0865333-0cbd-4440-86da-3386defefdba"]){
        HZZaiXianTianXieViewController2 *tianxie=[[HZZaiXianTianXieViewController2 alloc]init];
//        if (self.uuid==NULL||self.uuid==nil) {
//            tianxie.commitData=self.commitData;
//        }else{
            tianxie.commitData=self.commitData;
            tianxie.saveDic=saveDic;
//        }
        tianxie.qlsxcode=qlsxcode;
        [self.navigationController pushViewController:tianxie animated:YES];
    } else if ([qlsxcode isEqualToString:@"0ef7e0ce-bb77-4979-8cc3-166d08712b96"]||[qlsxcode isEqualToString:@"b8e6c1ea-6f89-4a2d-af17-78183b3e8a9f"]){
        HZZaiXianTianXieViewController3 *tianxie=[[HZZaiXianTianXieViewController3 alloc]init];
//        if (self.uuid==NULL||self.uuid==nil) {
//            tianxie.commitData=self.commitData;
//        }else{
            tianxie.commitData=self.commitData;
            tianxie.saveDic=saveDic;
//        }
         tianxie.qlsxcode=qlsxcode;
        [self.navigationController pushViewController:tianxie animated:YES];
    }else if ([qlsxcode isEqualToString:@"31104F35575B4CB91AA7D5C014E730B1"]){//风景名胜区建设项目新报、基本变更（选址位置、用地规模、建设规模）
        HZZaiXianTianXieViewController4 *tianxie=[[HZZaiXianTianXieViewController4 alloc]init];
//        if (self.uuid==NULL||self.uuid==nil) {
//            tianxie.commitData=self.commitData;
//        }else{
            tianxie.commitData=self.commitData;
            tianxie.saveDic=saveDic;
//        }
         tianxie.qlsxcode=qlsxcode;
        [self.navigationController pushViewController:tianxie animated:YES];
    }else if ([qlsxcode isEqualToString:@"F16BFFA466D5374C9D991F026936438F"]||[qlsxcode isEqualToString:@"42CBF39D427712000C357F3E7494007B"]||[qlsxcode isEqualToString:@"51760F1375EB1CF64A180319B743C392"]){//风景名胜区建设项目证书失效重新核发//风景名胜区建设项目简易变更（项目名称、建设单位）//风景名胜区建设项目延期
        HZZaiXianTianXieViewController5 *tianxie=[[HZZaiXianTianXieViewController5 alloc]init];
//        if (self.uuid==NULL||self.uuid==nil) {
//            tianxie.commitData=self.commitData;
//        }else{
            tianxie.commitData=self.commitData;
            tianxie.saveDic=saveDic;
//        }
         tianxie.qlsxcode=qlsxcode;
        [self.navigationController pushViewController:tianxie animated:YES];
    }else if ([qlsxcode isEqualToString:@"598ea023-d3cc-4168-b3fb-529ffff53d8d"]){//建设工程规划许可证核发
        if ([self.type isEqualToString:@"建筑类"]) {
                    HZZaiXianTianXieViewController6 *tianxie=[[HZZaiXianTianXieViewController6 alloc]init];
//                    if (self.uuid==NULL||self.uuid==nil) {
//                        tianxie.commitData=self.commitData;
//                    }else{
                        tianxie.commitData=self.commitData;
                        tianxie.saveDic=saveDic;
//                    }
                     tianxie.qlsxcode=qlsxcode;
                    [self.navigationController pushViewController:tianxie animated:YES];
        }else  if ([self.type isEqualToString:@"市政类"]) {
                    HZZaiXianTianXieViewController7 *tianxie=[[HZZaiXianTianXieViewController7 alloc]init];
//                    if (self.uuid==NULL||self.uuid==nil) {
//                        tianxie.commitData=self.commitData;
//                    }else{
                        tianxie.commitData=self.commitData;
                        tianxie.saveDic=saveDic;
//                    }
                     tianxie.qlsxcode=qlsxcode;
                    [self.navigationController pushViewController:tianxie animated:YES];
        }
    }else if ([qlsxcode isEqualToString:@"6241e908-79a4-4782-b5de-204178602601"]){//临时建设工程规划许可证核发
        HZZaiXianTianXieViewController7 *tianxie=[[HZZaiXianTianXieViewController7 alloc]init];
//        if (self.uuid==NULL||self.uuid==nil) {
//            tianxie.commitData=self.commitData;
//        }else{
            tianxie.commitData=self.commitData;
            tianxie.saveDic=saveDic;
//        }
         tianxie.qlsxcode=qlsxcode;
        [self.navigationController pushViewController:tianxie animated:YES];
    }else if ([qlsxcode isEqualToString:@"87ed0a9d-856b-45d3-8e4a-2fa4e32715f5"]){//建设工程竣工规划核实
        HZZaiXianTianXieViewController8 *tianxie=[[HZZaiXianTianXieViewController8 alloc]init];
//        if (self.uuid==NULL||self.uuid==nil) {
//            tianxie.commitData=self.commitData;
//        }else{
            tianxie.commitData=self.commitData;
            tianxie.saveDic=saveDic;
//        }
        tianxie.qlsxcode=qlsxcode;
        [self.navigationController pushViewController:tianxie animated:YES];
    }else if ([qlsxcode isEqualToString:@"3e9b0641-3a76-4cfe-9666-72350d2385d8"]){//建设工程设计方案（修建性详细规划）审查
        HZZaiXianTianXieViewController9 *tianxie=[[HZZaiXianTianXieViewController9 alloc]init];
//        if (self.uuid==NULL||self.uuid==nil) {
//            tianxie.commitData=self.commitData;
//        }else{
            tianxie.commitData=self.commitData;
            tianxie.saveDic=saveDic;
//        }
         tianxie.qlsxcode=qlsxcode;
        [self.navigationController pushViewController:tianxie animated:YES];
    }
    
}
//MARK:调取相机
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
        _picker = [[UIImagePickerController alloc] init];
        _picker.accessibilityValue=[NSString stringWithFormat:@"%d",(int)sender.tag];
        _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        _picker.showsCameraControls = YES;
        //        picker.videoQuality=UIImagePickerControllerQualityTypeLow;
        _picker.delegate = self;
        [self presentViewController:_picker animated:YES completion:Nil];
    }];
    [alert addAction:cameraAlert];
    UIAlertAction *pictureAlert=[UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _picker = [[UIImagePickerController alloc] init];
        //         picker.videoQuality=UIImagePickerControllerQualityTypeLow;
        _picker.delegate = self;
        _picker.accessibilityValue=[NSString stringWithFormat:@"%d",(int)sender.tag];
        _picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:_picker animated:YES completion:Nil];
    }];
    [alert addAction:pictureAlert];
    
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - Get Photoes Module
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [_picker dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
//    NSData *imageData=UIImageJPEGRepresentation(originImage, 1);
//    float length=[imageData length]/1024;
    //    NSData *scaleImageData=UIImagePNGRepresentation(scaleImage);
    //    float length1=[scaleImageData length]/1024;
    //    NSLog(@"图片大小   %f  M   %f  M",length,length1);
    int imageBtnNum=[picker.accessibilityValue intValue];
    UIImage *scaleImage = [self imageWithImage:originImage scaledToSize:CGSizeMake(320*1.5, 480*1.5)];
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *imagename=[NSString stringWithFormat:@"%@_%1.0f.png",[_MATERArray objectAtIndex:imageBtnNum-201],interval];
    [_imageCommitArray addObject:scaleImage];
    [_imageNameArray addObject:imagename];
//        NSLog(@"图片   %@ ",imagename);

    //限制只能拍三张
    if (imageBtnNum==201) {
        NSMutableArray *newImageArray=[[NSMutableArray alloc]init];
        id imageArray=[_imageAllArray objectForKey:[NSString stringWithFormat:@"%d",imageBtnNum-201+1]];
        NSLog(@"imageArray    %@",imageArray);
        NSLog(@"_imageAllArray    %@",_imageAllArray);
        if ([imageArray isKindOfClass:[NSString class]]) {
            imageArray=[[NSMutableArray alloc]init];
            [imageArray addObject:scaleImage];
            [_imageAllArray setObject:imageArray forKey:[NSString stringWithFormat:@"%d",imageBtnNum-201+1]];
        }else{
            imageArray=(NSMutableArray *) [_imageAllArray objectForKey:[NSString stringWithFormat:@"%d",imageBtnNum-201+1]];
            [imageArray addObject:scaleImage];
             [_imageAllArray setObject:imageArray forKey:[NSString stringWithFormat:@"%d",imageBtnNum-201+1]];
        }
        [newImageArray addObjectsFromArray:imageArray];
        UIScrollView *bgview=[self.view viewWithTag:2];
        bgview.contentSize=CGSizeMake(60+80*newImageArray.count, bgview.frame.size.height);
        UIButton *imageButton=[self.view viewWithTag:201];
            imageButton.frame=CGRectMake(10+70*newImageArray.count, imageButton.frame.origin.y, 60, 60);
            for (int i=0; i<newImageArray.count; i++) {
                UIButton *imageBtn=[[UIButton alloc]initWithFrame:CGRectMake(10+70*i,imageButton.frame.origin.y, 60, 60)];
                imageBtn.tag=1000+i;
                [imageBtn addTarget:self action:@selector(bigPhoto:) forControlEvents:UIControlEventTouchUpInside];
                [imageBtn setBackgroundImage:[imageArray objectAtIndex:i] forState:UIControlStateNormal];
                [bgview addSubview:imageBtn];
                
                UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
                longPress.accessibilityValue=[NSString stringWithFormat:@"%d",(int)imageBtn.tag];
                longPress.delegate=self;
                [imageBtn addGestureRecognizer:longPress];
            }
        if (newImageArray.count==3) {
            [imageButton removeFromSuperview];
        }

    }
    else{
        NSMutableArray *newImageArray=[[NSMutableArray alloc]init];
        id imageArray=[_imageAllArray objectForKey:[NSString stringWithFormat:@"%d",imageBtnNum-201+1]];
        if ([imageArray isKindOfClass:[NSString class]]) {
            imageArray=[[NSMutableArray alloc]init];
            [imageArray addObject:scaleImage];
            [_imageAllArray setObject:imageArray forKey:[NSString stringWithFormat:@"%d",imageBtnNum-201+1]];
        }else{
            imageArray=(NSMutableArray *) [_imageAllArray objectForKey:[NSString stringWithFormat:@"%d",imageBtnNum-201+1]];
            [imageArray addObject:scaleImage];
            [_imageAllArray setObject:imageArray forKey:[NSString stringWithFormat:@"%d",imageBtnNum-201+1]];
        }
        [newImageArray addObjectsFromArray:imageArray];
        UIScrollView *bgview=[self.view viewWithTag:imageBtnNum-199];
        bgview.contentSize=CGSizeMake(80*newImageArray.count+60, bgview.frame.size.height);
        UIButton *imageButton=[self.view viewWithTag:imageBtnNum];
        imageButton.frame=CGRectMake(10+70*newImageArray.count, imageButton.frame.origin.y, 60, 60);
        for (int i=0; i<newImageArray.count; i++) {
            UIButton *imageBtn=[[UIButton alloc]initWithFrame:CGRectMake(10+70*i, imageButton.frame.origin.y, 60, 60)];
            imageBtn.tag=(imageBtnNum-201)*100+1000+i;
            [imageBtn addTarget:self action:@selector(bigPhoto:) forControlEvents:UIControlEventTouchUpInside];
            [imageBtn setBackgroundImage:[imageArray objectAtIndex:i] forState:UIControlStateNormal];
            [bgview addSubview:imageBtn];
            
            UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
            longPress.accessibilityValue=[NSString stringWithFormat:@"%d",(int)imageBtn.tag];
            longPress.delegate=self;
            [imageBtn addGestureRecognizer:longPress];
        }
        if (newImageArray.count==10) {
            [imageButton removeFromSuperview];
        }

    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (UIImage *)imageWithImage:(UIImage*)image
               scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
//MARK:扩大图片
-(void)bigPhoto:(UIButton*)bigImage{
    HZPictureViewController *picture=[[HZPictureViewController alloc]init];
    picture.isWeb=YES;
    NSMutableArray *imageArray=[_imageAllArray objectForKey:[NSString stringWithFormat:@"%d",(int)(bigImage.tag/100-10+1)]];
    NSLog(@"imageArray    %@",imageArray);
    NSLog(@"_imageAllArray    %@",_imageAllArray);
    picture.imageArray=imageArray;
    picture.image=bigImage.currentBackgroundImage;
    NSInteger index=[imageArray indexOfObject:picture.image];
    picture.indexOfImage=index;
    [self.navigationController pushViewController:picture animated:YES];
}

-(void)map:(UIButton*)sender{
    HZMapServiceViewController *illustrate=[[HZMapServiceViewController alloc]init];
     if (self.uuid==NULL||self.uuid==nil) {
        
     }else{
           illustrate.linerange=[self.reCommitData objectForKey:@"linerange"];
     }
  
    [self.navigationController pushViewController:illustrate animated:YES];
}
//MARK:提交
-(void)commit{
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    NSString *companyid=[def objectForKey:@"companyid"];
    NSString *userid=[def objectForKey:@"userid"];
    NSString *uuid;
       if (self.uuid==NULL||self.uuid==nil) {
           uuid=@"";
       }else{
           uuid=self.uuid;
       }
    if (self.saveDic==NULL||self.saveDic==nil) {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"请进入在线填写页面，把表格填写完整"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];

        return;
    }
    for (int i=0; i<_MATERArray.count; i++) {
         id imageArray=[_imageAllArray objectForKey:[NSString stringWithFormat:@"%d",i+1]];
        NSString *status=[statusLabelArray objectAtIndex:i+1];
//        NSLog(@"imageArray   %@  status   %@",imageArray,status);
         if ([imageArray isKindOfClass:[NSString class]]) {
             if (![status containsString:@"非必要"]) {
                 UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"第%d行为必要信息，图片不能为空",i+1] preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction *defaultAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                     
                 }];
                 [alert addAction:defaultAction];
                 [self presentViewController:alert animated:YES completion:nil];
                 return;
             }
             
         }else{
             
         }
    }
    for (int i=0; i<nameLabelaArray.count; i++) {
        NSString *nameLabel=[nameLabelaArray objectAtIndex:i];
        if ([nameLabel containsString:@"拟建位置1/1000带规划控制线地形图1份"]) {
            if (_textfield==NULL||[_textfield.text isEqual:[NSNull null]]||[_textfield.text isEqualToString:@""]||_textfield==nil) {
//                NSArray *
//                if (imageArray.count>0) {
//                }else{
//                    if (self.posArray.count>0) {
//
//                    }else{
//                        [self.view makeToast:@"拟建位置1/1000带规划控制线地形图至少上传一份文件" duration:2 position:CSToastPositionCenter];
//                        return;
//                    }
//                }
//
            }
        }
    }
    
    NSString *linerange=nil;
    if (self.posArray.count>0) {
        NSMutableArray *array=[[NSMutableArray alloc]init];
        for (int i=0; i<self.posArray.count; i++) {
            BMKPointAnnotation* annotation=[self.posArray objectAtIndex:i];
            NSString *str=[NSString stringWithFormat:@"{\"x\":%f,\"y\":%f}",annotation.coordinate.latitude,annotation.coordinate.longitude];
            [array addObject:str];
        }
        linerange=[NSString stringWithFormat:@"[%@]",[array componentsJoinedByString:@","]];
    }else{
        linerange=@"";
    }
    if ([self.saveDic objectForKey:@"linerange"]) {
        linerange=[self.saveDic objectForKey:@"linerange"];
    }
    MBProgressHUD *hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text=@"数据加载中，请稍候...";
    NSString *qlsxcode=[self.qlsxcodeDic objectForKey:@"qlsxcode"];
    
    NSString *businessId=[self.qlsxcodeDic objectForKey:@"businessId"];
    NSMutableDictionary *totalDic=[[NSMutableDictionary alloc]init];

    if (self.uuid==NULL||self.uuid==nil) {
        businessId=[self.qlsxcodeDic objectForKey:@"businessId"];
        if ([self.type isEqualToString:@"建筑类"]) {
            businessId=@"107";
        }else if ([self.type isEqualToString:@"市政类"]) {
            businessId=@"115";
        }
        [totalDic setObject:self.orgId forKey:@"orgId"];

    }else{
        qlsxcode=[self.reCommitData objectForKey:@"qlsxcode"];
        businessId=[self.reCommitData objectForKey:@"businessId"];
         [totalDic setObject:[self.reCommitData objectForKey:@"orgId"] forKey:@"orgId"];
    }
    [totalDic setObject:qlsxcode forKey:@"qlsxcode"];
    [totalDic setObject:companyid forKey:@"companyid"];
     [totalDic setObject:userid forKey:@"userid"];
     [totalDic setObject:uuid forKey:@"resuuid"];
     [totalDic setObject:businessId forKey:@"businessId"];
    
     [totalDic setObject:linerange forKey:@"linerange"];
    
    NSString *modifiedTag=[self getmodifiedTag];
    [totalDic setObject:modifiedTag forKey:@"modifiedTag"];
    NSString *tzdm=@"";
    if ([self.saveDic objectForKey:@"tzdm"]) {
        tzdm=[self.saveDic objectForKey:@"tzdm"];
    }
    [totalDic setObject:tzdm forKey:@"tzdm"];
    NSString *tdgyfs=@"";
    if ([self.saveDic objectForKey:@"tdgyfs"]) {
        tdgyfs=[self.saveDic objectForKey:@"tdgyfs"];
    }
    [totalDic setObject:tdgyfs forKey:@"tdgyfs"];
    NSString *qlsxzx=@"";
    if ([self.saveDic objectForKey:@"qlsxzx"]) {
        qlsxzx=[self.saveDic objectForKey:@"qlsxzx"];
    }
    [totalDic setObject:qlsxzx forKey:@"qlsxzx"];
    NSString *lxwh=@"";
    if ([self.saveDic objectForKey:@"lxwh"]) {
        lxwh=[self.saveDic objectForKey:@"lxwh"];
    }
    [totalDic setObject:lxwh forKey:@"lxwh"];
    NSString *sqr=@"";
    if ([self.saveDic objectForKey:@"sqr"]) {
        sqr=[self.saveDic objectForKey:@"sqr"];
    }
     [totalDic setObject:sqr forKey:@"sqr"];
    NSString *xmmc=@"";
    if ([self.saveDic objectForKey:@"xmmc"]) {
        xmmc=[self.saveDic objectForKey:@"xmmc"];
    }
     [totalDic setObject:xmmc forKey:@"xmmc"];
    NSString *fddbr=@"";
    if ([self.saveDic objectForKey:@"fddbr"]) {
        fddbr=[self.saveDic objectForKey:@"fddbr"];
    }
    [totalDic setObject:fddbr forKey:@"fddbr"];
    NSString *lxdh=@"";
    if ([self.saveDic objectForKey:@"lxdh"]) {
        lxdh=[self.saveDic objectForKey:@"lxdh"];
    }
    [totalDic setObject:lxdh forKey:@"lxdh"];
    NSString *wtr=@"";
    if ([self.saveDic objectForKey:@"wtr"]) {
        wtr=[self.saveDic objectForKey:@"wtr"];
    }
     [totalDic setObject:wtr forKey:@"wtr"];
    NSString *sjh=@"";
    if ([self.saveDic objectForKey:@"sjh"]) {
        sjh=[self.saveDic objectForKey:@"sjh"];
    }
     [totalDic setObject:sjh forKey:@"sjh"];
    NSString *jsnrjgm=@"";
    if ([self.saveDic objectForKey:@"jsnrjgm"]) {
        jsnrjgm=[self.saveDic objectForKey:@"jsnrjgm"];
    }
     [totalDic setObject:jsnrjgm forKey:@"jsnrjgm"];
    NSString *jsdzq=@"";
    if ([self.saveDic objectForKey:@"jsdzq"]) {
        jsdzq=[self.saveDic objectForKey:@"jsdzq"];
    }
    [totalDic setObject:jsdzq forKey:@"jsdzq"];
    NSString *jsdzl=@"";
    if ([self.saveDic objectForKey:@"jsdzl"]) {
        jsdzl=[self.saveDic objectForKey:@"jsdzl"];
    }
     [totalDic setObject:jsdzl forKey:@"jsdzl"];
    NSString *zbdz=@"";
    if ([self.saveDic objectForKey:@"zbdz"]) {
        zbdz=[self.saveDic objectForKey:@"zbdz"];
    }
     [totalDic setObject:zbdz forKey:@"zbdz"];
    NSString *zbnz=@"";
    if ([self.saveDic objectForKey:@"zbnz"]) {
        zbnz=[self.saveDic objectForKey:@"zbnz"];
    }
     [totalDic setObject:zbnz forKey:@"zbnz"];
    NSString *zbxz=@"";
    if ([self.saveDic objectForKey:@"zbxz"]) {
        zbxz=[self.saveDic objectForKey:@"zbxz"];
    }
     [totalDic setObject:zbxz forKey:@"zbxz"];
    NSString *zbbz=@"";
    if ([self.saveDic objectForKey:@"zbbz"]) {
        zbbz=[self.saveDic objectForKey:@"zbbz"];
    }
    [totalDic setObject:zbbz forKey:@"zbbz"];
    NSString *lzbg=@"";
    if ([self.saveDic objectForKey:@"lzbg"]) {
        lzbg=[self.saveDic objectForKey:@"lzbg"];
    }
     [totalDic setObject:lzbg forKey:@"lzbg"];
    NSString *sxslh=@"";
    if (_textfield.text==NULL||[_textfield.text isEqualToString:@""]||_textfield==nil||_textfield.text==nil) {
        sxslh=@"";
    }else{
        sxslh=_textfield.text;
    }
     [totalDic setObject:sxslh forKey:@"sxslh"];
    NSString *xmsmqk=@"";
    if ([self.saveDic objectForKey:@"xmsmqk"]) {
        xmsmqk=[self.saveDic objectForKey:@"xmsmqk"];
    }
    [totalDic setObject:xmsmqk forKey:@"xmsmqk"];
    NSString *ydqsqk=@"";
    if ([self.saveDic objectForKey:@"ydqsqk"]) {
        ydqsqk=[self.saveDic objectForKey:@"ydqsqk"];
    }
     [totalDic setObject:ydqsqk forKey:@"ydqsqk"];
    NSString *sfqdfapf=@"";
    if ([self.saveDic objectForKey:@"sfqdfapf"]) {
        sfqdfapf=[self.saveDic objectForKey:@"sfqdfapf"];
    }
      [totalDic setObject:sfqdfapf forKey:@"sfqdfapf"];
    NSString *sfghtjbg=@"";
    if ([self.saveDic objectForKey:@"sfghtjbg"]) {
        sfghtjbg=[self.saveDic objectForKey:@"sfghtjbg"];
    }
     [totalDic setObject:sfghtjbg forKey:@"sfghtjbg"];
    NSString *tdcb=@"";
    if ([self.saveDic objectForKey:@"tdcb"]) {
        tdcb=[self.saveDic objectForKey:@"tdcb"];
    }
     [totalDic setObject:tdcb forKey:@"tdcb"];
    NSString *tznrjly=@"";
    if ([self.saveDic objectForKey:@"tznrjly"]) {
        tznrjly=[self.saveDic objectForKey:@"tznrjly"];
    }
      [totalDic setObject:tznrjly forKey:@"tznrjly"];
    NSString *filecode=@"";
    if ([self.saveDic objectForKey:@"filecode"]) {
        filecode=[self.saveDic objectForKey:@"filecode"];
    }
     [totalDic setObject:filecode forKey:@"filecode"];
    NSString *sqryq=@"";
    if ([self.saveDic objectForKey:@"sqryq"]) {
        sqryq=[self.saveDic objectForKey:@"sqryq"];
    }
    [totalDic setObject:sqryq forKey:@"sqryq"];
    NSString *fddbryq=@"";
    if ([self.saveDic objectForKey:@"fddbryq"]) {
        fddbryq=[self.saveDic objectForKey:@"fddbryq"];
    }
    [totalDic setObject:fddbryq forKey:@"fddbryq"];
    NSString *stryq=@"";
    if ([self.saveDic objectForKey:@"stryq"]) {
        stryq=[self.saveDic objectForKey:@"stryq"];
    }
     [totalDic setObject:stryq forKey:@"stryq"];
    NSString *sjyq=@"";
    if ([self.saveDic objectForKey:@"sjyq"]) {
        sjyq=[self.saveDic objectForKey:@"sjyq"];
    }
     [totalDic setObject:sjyq forKey:@"sjyq"];
    NSString *dhyq=@"";
    if ([self.saveDic objectForKey:@"dhyq"]) {
        dhyq=[self.saveDic objectForKey:@"dhyq"];
    }
        [totalDic setObject:dhyq forKey:@"dhyq"];
    NSString *xmmcyq=@"";
    if ([self.saveDic objectForKey:@"xmmcyq"]) {
        xmmcyq=[self.saveDic objectForKey:@"xmmcyq"];
    }
      [totalDic setObject:xmmcyq forKey:@"xmmcyq"];
    NSString *jsnrjgmyq=@"";
    if ([self.saveDic objectForKey:@"jsnrjgmyq"]) {
        jsnrjgmyq=[self.saveDic objectForKey:@"jsnrjgmyq"];
    }
     [totalDic setObject:jsnrjgmyq forKey:@"jsnrjgmyq"];
    NSString *quyq=@"";
    if ([self.saveDic objectForKey:@"quyq"]) {
        quyq=[self.saveDic objectForKey:@"quyq"];
    }
     [totalDic setObject:quyq forKey:@"quyq"];
    NSString *luyq=@"";
    if ([self.saveDic objectForKey:@"luyq"]) {
        luyq=[self.saveDic objectForKey:@"luyq"];
    }
     [totalDic setObject:luyq forKey:@"luyq"];
    NSString *blxs=@"";
    if ([self.saveDic objectForKey:@"blxs"]) {
        blxs=[self.saveDic objectForKey:@"blxs"];
    }
     [totalDic setObject:blxs forKey:@"blxs"];
    NSString *xghyqsxmc=@"";
    if ([self.saveDic objectForKey:@"xghyqsxmc"]) {
        xghyqsxmc=[self.saveDic objectForKey:@"xghyqsxmc"];
    }
      [totalDic setObject:xghyqsxmc forKey:@"xghyqsxmc"];
    NSString *xghyqjnr=@"";
    if ([self.saveDic objectForKey:@"xghyqjnr"]) {
        xghyqjnr=[self.saveDic objectForKey:@"xghyqjnr"];
    }
     [totalDic setObject:xghyqjnr forKey:@"xghyqjnr"];
    NSString *sjdw=@"";
    if ([self.saveDic objectForKey:@"sjdw"]) {
        sjdw=[self.saveDic objectForKey:@"sjdw"];
    }
     [totalDic setObject:sjdw forKey:@"sjdw"];
    NSString *sjr=@"";
    if ([self.saveDic objectForKey:@"sjr"]) {
        sjr=[self.saveDic objectForKey:@"sjr"];
    }
      [totalDic setObject:sjr forKey:@"sjr"];
    NSString *shrsj=@"";
    if ([self.saveDic objectForKey:@"shrsj"]) {
        shrsj=[self.saveDic objectForKey:@"shrsj"];
    }
     [totalDic setObject:shrsj forKey:@"shrsj"];
    NSString *gcmcsx=@"";
    if ([self.saveDic objectForKey:@"gcmcsx"]) {
        gcmcsx=[self.saveDic objectForKey:@"gcmcsx"];
    }
     [totalDic setObject:gcmcsx forKey:@"gcmcsx"];
    NSString *qd=@"";
    if ([self.saveDic objectForKey:@"qd"]) {
        qd=[self.saveDic objectForKey:@"qd"];
    }
     [totalDic setObject:qd forKey:@"qd"];
    NSString *zd=@"";
    if ([self.saveDic objectForKey:@"zd"]) {
        zd=[self.saveDic objectForKey:@"zd"];
    }
     [totalDic setObject:zd forKey:@"zd"];
    NSString *dlgl=@"";
    if ([self.saveDic objectForKey:@"dlgl"]) {
        dlgl=[self.saveDic objectForKey:@"dlgl"];
    }
     [totalDic setObject:dlgl forKey:@"dlgl"];
    NSString *ql=@"";
    if ([self.saveDic objectForKey:@"ql"]) {
        ql=[self.saveDic objectForKey:@"ql"];
    }
      [totalDic setObject:ql forKey:@"ql"];
    NSString *bk=@"";
    if ([self.saveDic objectForKey:@"bk"]) {
        bk=[self.saveDic objectForKey:@"bk"];
    }
     [totalDic setObject:bk forKey:@"bk"];
    NSString *gxgc=@"";
    if ([self.saveDic objectForKey:@"gxgc"]) {
        gxgc=[self.saveDic objectForKey:@"gxgc"];
    }
      [totalDic setObject:gxgc forKey:@"gxgc"];
    NSString *jsgc=@"";
    if ([self.saveDic objectForKey:@"jsgc"]) {
        jsgc=[self.saveDic objectForKey:@"jsgc"];
    }
      [totalDic setObject:jsgc forKey:@"jsgc"];
    NSString *gcghxkzh=@"";
    if ([self.saveDic objectForKey:@"gcghxkzh"]) {
        gcghxkzh=[self.saveDic objectForKey:@"gcghxkzh"];
    }
      [totalDic setObject:gcghxkzh forKey:@"gcghxkzh"];
    NSString *xknr=@"";
    if ([self.saveDic objectForKey:@"xknr"]) {
        xknr=[self.saveDic objectForKey:@"xknr"];
    }
      [totalDic setObject:xknr forKey:@"xknr"];
    NSString *sgxcql=@"";
    if ([self.saveDic objectForKey:@"sgxcql"]) {
        sgxcql=[self.saveDic objectForKey:@"sgxcql"];
    }
      [totalDic setObject:sgxcql forKey:@"sgxcql"];
    NSString *yqccjz=@"";
    if ([self.saveDic objectForKey:@"yqccjz"]) {
        yqccjz=[self.saveDic objectForKey:@"yqccjz"];
    }
    [totalDic setObject:yqccjz forKey:@"yqccjz"];
    NSString *jrczxt=@"";
    if ([self.saveDic objectForKey:@"jrczxt"]) {
        jrczxt=[self.saveDic objectForKey:@"jrczxt"];
    }
     [totalDic setObject:jrczxt forKey:@"jrczxt"];
    NSString *sclx=@"";
    if ([self.saveDic objectForKey:@"sclx"]) {
        sclx=[self.saveDic objectForKey:@"sclx"];
    }
     [totalDic setObject:sclx forKey:@"sclx"];
    [HZBanShiService BanShiCommitWithTotalDic:totalDic imageArray:_imageCommitArray imageNameArray:_imageNameArray AddBlock:^(NSDictionary *returnDic, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[returnDic objectForKey:@"code"]integerValue]==0) {
              [self.view makeToast:[returnDic objectForKey:@"desc"] duration:2 position:CSToastPositionCenter];
            NSArray *vcArray = self.navigationController.viewControllers;
            for(UIViewController *vc in vcArray)
            {
                if ([vc isKindOfClass:[HZLocateViewController class]])
                {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
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
        }else{
            [self.view makeToast:@"请求失败，请重新尝试" duration:2 position:CSToastPositionCenter];
        }

    }];
}
//MARK:判空
-(NSString *)getString:(NSString *)currentStr{
    if ([currentStr isEqual:[NSNull null]]||currentStr==nil||currentStr==NULL||[currentStr isEqualToString:@""]) {
        currentStr=@"";
    }
    return currentStr;
}
-(NSString *)getmodifiedTag{
    NSString * qlsxcode=[self.qlsxcodeDic objectForKey:@"qlsxcode"];
    NSString *modifiedTag=@"0";
    if ([qlsxcode isEqualToString:@"EAF31D8225045AE8CFA4E04C961F5D86"]) {
        modifiedTag=@"0";
    }else if ([qlsxcode isEqualToString:@"1FE087B8241745F16C0133ABB4832B8C"]) {
        modifiedTag=@"0";
    }else if ([qlsxcode isEqualToString:@"06C6B52BF5142FB69BA0113DFD08C77B"]) {
        modifiedTag=@"1";
    }else if ([qlsxcode isEqualToString:@"0496B51F3AB9B5135F85F31B8F255857"]) {
        modifiedTag=@"1";
    }else if ([qlsxcode isEqualToString:@"31104F35575B4CB91AA7D5C014E730B1"]) {
        modifiedTag=@"0";
    }else if ([qlsxcode isEqualToString:@"F16BFFA466D5374C9D991F026936438F"]) {
        modifiedTag=@"0";
    }else if ([qlsxcode isEqualToString:@"42CBF39D427712000C357F3E7494007B"]) {
        modifiedTag=@"1";
    }else if ([qlsxcode isEqualToString:@"51760F1375EB1CF64A180319B743C392"]) {
        modifiedTag=@"1";
    }else if ([qlsxcode isEqualToString:@"716c0ebb-d774-42f5-84da-54b0b143bc06"]) {
        modifiedTag=@"0";
    }else if ([qlsxcode isEqualToString:@"c0865333-0cbd-4440-86da-3386defefdba"]) {
        modifiedTag=@"0";
    }else if ([qlsxcode isEqualToString:@"598ea023-d3cc-4168-b3fb-529ffff53d8d"]) {
        modifiedTag=@"0";
    }else if ([qlsxcode isEqualToString:@"6241e908-79a4-4782-b5de-204178602601"]) {
        modifiedTag=@"0";
    }else if ([qlsxcode isEqualToString:@"0ef7e0ce-bb77-4979-8cc3-166d08712b96"]) {
        modifiedTag=@"0";
    }else if ([qlsxcode isEqualToString:@"87ed0a9d-856b-45d3-8e4a-2fa4e32715f5"]) {
        modifiedTag=@"0";
    }else if ([qlsxcode isEqualToString:@"b8e6c1ea-6f89-4a2d-af17-78183b3e8a9f"]) {
        modifiedTag=@"1";
    }else if ([qlsxcode isEqualToString:@"3e9b0641-3a76-4cfe-9666-72350d2385d8"]) {
        modifiedTag=@"0";
    }
    return modifiedTag;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self.view endEditing:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
     [self.view endEditing:YES];
    return YES;
}
-(BOOL)navigationShouldPopOnBackButton{
    if (self.isBackWarn==YES) {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"返回将导致你所填写的信息丢失" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:okAlert];
        UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:cancelAlert];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)illustrate{
    HZIllustrateViewController *illustrate=[[HZIllustrateViewController alloc]init];
    [self.navigationController pushViewController:illustrate animated:YES];
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
