//
//  HZGongShiCommitViewController.h
//  HZGHJ
//
//  Created by zhang on 16/12/16.
//  Copyright © 2016年 FiveFu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HZGongShiCommitViewController : UIViewController
@property(nonatomic,strong)NSString*publicid;
@property(nonatomic,strong)NSDictionary*listDic;
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,assign)BOOL isGongShi;
@end