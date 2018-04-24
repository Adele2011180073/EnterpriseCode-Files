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

// MARK:获取在线申请首页列表
+(void)BanShiHomeListWithUsreName:(NSString *)username GetBlock:(ReturnData)GetContent;
// MARK: 办事指南 获取列表内容
+(void)BanShiWithId:(NSString*)IsPId GetBlock:(ReturnData)GetContent;
// MARK: 常用表格
+(void)BiaoGeWithId:(NSString*)IsPId GetBlock:(ReturnData)GetContent;
// MARK: 在线办事

//MARK:请选择办理的窗口
+(void)BanShiWithAndBlock:(ReturnData)BanShiBlock;
// MARK: 在线办事进度查询
+(void)BanShiWithCompanyid:(NSString*)companyid  pageIndex:(int)pageindex AddBlock:(ReturnData)GetCommitBlock;
// MARK: 申请附件材料信息和修正材料附件信息
+(void)BanShiWithId:(NSString*)Id AddBlock:(ReturnData)GetCommitBlock;

// MARK: 2.在线办事提交
+(void)BanShiCommitWithTotalDic:(NSDictionary *)totalDic imageArray:(NSMutableArray *)imageArray imageNameArray:(NSArray *)imageNameArray AddBlock:(ReturnData)GetCommitBlock;

@end
