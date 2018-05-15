//
//  HZLocateContentViewController.h
//  HZGHJ
//
//  Created by zhang on 2017/5/9.
//  Copyright © 2017年 FiveFu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

@interface HZLocateContentViewController : UIViewController
@property(nonatomic,retain)NSString *uuid;//已提交
@property(nonatomic,strong)NSDictionary *reCommitData;//补正提交保存Dic


@property(nonatomic,strong)NSDictionary *saveDic;//保存Dic
@property(nonatomic,strong)NSDictionary *commitData;//已提交保存Dic


@property(nonatomic,retain)NSDictionary *qlsxcodeDic;
@property(nonatomic,retain)NSString* orgId;
@property(nonatomic,retain)NSString *type;//判断是否是建筑类 市政类

@property(nonatomic,strong)NSString *linerange;

@property(nonatomic,assign)BOOL isBackWarn;//返回提示
@end
