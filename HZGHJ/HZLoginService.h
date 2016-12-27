//
//  HZLoginService.h
//  HZGHJ
//
//  Created by zhang on 16/12/7.
//  Copyright © 2016年 FiveFu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HZLoginService : NSObject
typedef void (^ReturnData)(NSDictionary *returnDic, NSError *error);

//登录
+(void)LoginWithUserName:(NSString *)username passwd:(NSString*)passwd andBlock:(ReturnData)LoginBlock;

//预约
//在线预约
+(void)YuYueWithToken:(NSString *)token pageIndex:(int)pageindex andBlock:(ReturnData)YuYueBlock;
//我的预约
+(void)WoDeYuYueWithToken:(NSString *)token pageIndex:(int)pageindex andBlock:(ReturnData)YuYueBlock;
//预约详情
+(void)YuYueWithToken:(NSString *)token ReservationId:(NSString*)reservationid andBlock:(ReturnData)YuYueBlock;

//获取我要预约数据
+(void)WoDeYuYueDataWithToken:(NSString *)token andBlock:(ReturnData)YuYueBlock;
//预约提交
+(void)YuYueWithToken:(NSString *)token unitcontact:(NSString*)unitcontact  unitcontactphone:(NSString*)unitcontactphone timeofappointment:(NSString*)timeofappointment designInstitutename:(NSString*)designInstitutename designInstitutephone:(NSString*)designInstitutephone hostdepartment:(NSString*)hostdepartment companymisstionid:(NSString*)companymisstionid projectid:(NSString*)projectid nodeId:(NSString*)nodeId andBlock:(ReturnData)YuYueBlock;

//上报
//过程上报
+(void)ShangBaoWithToken:(NSString *)token pageIndex:(int)pageindex andBlock:(ReturnData)ShangBaoBlock;
//我的上报
+(void)WoDeShangBaoWithToken:(NSString *)token pageIndex:(int)pageindex andBlock:(ReturnData)ShangBaoBlock;
//项目上报
+(void)ShangBaoGetWithToken:(NSString *)token  andBlock:(ReturnData)ShangBaoBlock;
//上报提交
+(void)ShangBaoCommitWithToken:(NSString *)token ProjectId:(NSString*)projectId processId:(NSString *)processId details:(NSString*)details picture:(NSMutableArray *)imageData  andBlock:(ReturnData)ShangBaoBlock;

/*进度查询         */
//进度查询列表
+(void)JinDuGetWithToken:(NSString *)token pageIndex:(int)pageindex andBlock:(ReturnData)JinDuBlock;
//进度查询详情
+(void)JinDuDetailWithPublicid:(NSString*)publicid  andBlock:(ReturnData)JinDuBlock;


//公示
//需公示方案列表
+(void)GongShiWithToken:(NSString *)token pageIndex:(int)pageindex andBlock:(ReturnData)GongShiBlock;
//已公示详情
+(void)GongShiDetailWithPublicid:(NSString*)publicid  andBlock:(ReturnData)GongShiBlock;
//公示记录列表
+(void)GongShiLstWithToken:(NSString *)token pageIndex:(int)pageindex ProjectName:(NSString*)projectname andBlock:(ReturnData)GongShiBlock;
//公示提交
+(void)GongShiCommitWithToken:(NSString *)token ProjectId:(NSString*)projectId Publicid:(NSString*)publicid Type:(NSString*)type imageObjectArray:(NSMutableArray*)imageObjectArray imageNameArray:(NSMutableArray*)imageNameArray andBlock:(ReturnData)GongShiBlock;

//消息通知列表
+(void)NoticeWithToken:(NSString *)token pageIndex:(int)pageindex andBlock:(ReturnData)NoticeBlock;
//消息通知详情
+(void)NoticeWithRecordId:(NSString*)recordid andBlock:(ReturnData)NoticeBlock;

//消息公告列表
+(void)NewsWithToken:(NSString *)token pageIndex:(int)pageindex andBlock:(ReturnData)NoticeBlock;
//消息公告详情
+(void)NewsWithRecordId:(NSString*)recordid andBlock:(ReturnData)NoticeBlock;

//更换密码
+(void)PWWithNSw:(NSString *)opsw NSW:(NSString*)npsw andBlock:(ReturnData)NewSWBlock;

@end
