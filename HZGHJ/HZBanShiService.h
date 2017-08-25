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

// MARK: 办事指南 获取列表内容
+(void)BanShiWithId:(NSString*)IsPId GetBlock:(ReturnData)GetContent;
// MARK: 常用表格
+(void)BiaoGeWithId:(NSString*)IsPId GetBlock:(ReturnData)GetContent;
// MARK: 在线办事

//在线办事
+(void)BanShiWithAndBlock:(ReturnData)BanShiBlock;
// MARK: 在线办事进度查询
+(void)BanShiWithCompanyid:(NSString*)companyid  pageIndex:(int)pageindex AddBlock:(ReturnData)GetCommitBlock;
// MARK: 申请附件材料信息和修正材料附件信息
+(void)BanShiWithId:(NSString*)Id AddBlock:(ReturnData)GetCommitBlock;

// MARK: 2.在线办事提交
+(void)BanShiWithCompanyid:(NSString*)companyid  userid:(NSString*)userid  qlsxcode:(NSString*)qlsxcode uuid:(NSString*)uuid uploadtime:(NSString*)uploadtime synctime:(NSString*)synctime linerange:(NSString*)linerange tzdm:(NSString*)tzdm tdgyfs:(NSString*)tdgyfs  qlsxzx:(NSString*)qlsxzx  lxwh:(NSString*)lxwh  sqr:(NSString*)sqr  xmmc:(NSString*)xmmc  fddbr:(NSString*)fddbr lxdh:(NSString*)lxdh  wtr:(NSString*)wtr  sjh:(NSString*)sjh  jsnrjgm:(NSString*)jsnrjgm  jsdzq:(NSString*)jsdzq  jsdzl:(NSString*)jsdzl zbdz:(NSString*)zbdz  zbnz:(NSString*)zbnz  zbxz:(NSString*)zbxz zbbz:(NSString*)zbbz  lzbg:(NSString*)lzbg sxslh:(NSString*)sxslh applysource:(NSString*)applysource xmsmqk:(NSString*)xmsmqk filecode:(NSString*)filecode businessId:(NSString*)businessId resuuid:(NSString*)resuuid ydqsqk:(NSString*)ydqsqk sfqdfapf:(NSString*)sfqdfapf sfghtjbg:(NSString*)sfghtjbg tdcb:(NSString*)tdcb tznrjly:(NSString*)tznrjly modifiedTag:(NSString*)modifiedTag orgId:(NSString*)orgId imageArray:(NSMutableArray *)imageArray imageNameArray:(NSArray *)imageNameArray AddBlock:(ReturnData)GetCommitBlock;

@end
