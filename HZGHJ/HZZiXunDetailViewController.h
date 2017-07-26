//
//  HZZiXunDetailViewController.h
//  HZGHJ
//
//  Created by zhang on 2017/7/26.
//  Copyright © 2017年 FiveFu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HZZiXunDetailViewController : UIViewController
@property(nonatomic,strong)NSString*reservationId;
@property(nonatomic,strong)NSDictionary*detailData;
@property(nonatomic,strong)NSMutableArray *dataList;
@property(nonatomic,assign)BOOL isMy;
@end
