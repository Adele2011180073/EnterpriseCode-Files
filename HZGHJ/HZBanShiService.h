//
//  HZBanShiService.h
//  HZGHJ
//
//  Created by zhang on 2017/5/25.
//  Copyright © 2017年 FiveFu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HZBanShiService : NSObject
typedef void (^ReturnData)(NSDictionary *returnDic ,NSError *error);

//获取列表内容
+(void)BanShiWithId:(NSString*)IsPId GetBlock:(ReturnData)GetContent;

@end
