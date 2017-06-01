//
//  HZURL.h
//  HZGHJ
//
//  Created by zhang on 16/12/7.
//  Copyright © 2016年 FiveFu. All rights reserved.
//

#ifndef HZURL_h
#define HZURL_h
static NSString * const kDemoBaseURL                = @"http://192.168.0.113:8085";
//static NSString * const kDemoBaseURL                = @"http://220.191.210.76:80";
//static NSString * const kDemoBaseURL                = @"http://192.168.0.188:80";

//static NSString * const kBaseURL                = @"http://220.191.210.76:8080";

//登录
static NSString * const kLoginURL                = @"/servicesweb/login/login.action";
/*在线预约*/
//在线预约列表
static NSString * const kHistorytaskURL                = @"/servicesweb/reservation/historytask.action";
//我的预约列表
static NSString * const kMyReservationURL                = @"/servicesweb/reservation/getMyReservationAll.action";
//预约详情
static NSString * const kHistoryTaskItemURL                = @"/servicesweb/reservation/findHistoryTaskItem.action";
//获取我要预约数据
static NSString * const kReservationMissionURL                = @"/servicesweb/reservation/getReservationMission.action";
//结束预约//重新预约
static NSString * const kCompleTaskURL                = @"/servicesweb/reservation/compleTask.action";


//重新预约（获取预约条件）
static NSString * const kFindPremiseConditionURL                = @"/servicesweb/reservation/findPremiseCondition.action";
//取消预约
static NSString * const kCancelURL                = @"/servicesweb/reservation/cancel.action";

//获取单位联系人
static NSString * const kUserByComanyURL                = @"/servicesweb/login/getUserByComany.action";
//预约提交
static NSString * const kReservationURL                = @"/servicesweb/reservation/compileReservation.action";
/*进度查询         */
//进度查询列表
static NSString * const kProjectPaceURL                = @"/servicesweb/projectPace/list.action";
//进度查询详情
static NSString * const kProjectPaceDetailURL                = @"/servicesweb/projectPace/pace.action";
/*过程上报         */
//过程上报列表
static NSString * const kFindCompanyHistoryURL                = @"/servicesweb/projectprocess/findcompanyhistory.action";
//我的上报列表
static NSString * const kFindhistoryURL                = @"/servicesweb/projectprocess/findhistory.action";
//获取过程上报数据
static NSString * const kUploadProjectURL                = @"/servicesweb/projectprocess/getUploadProject.action";
//上报提交
static NSString * const kProjectProcessUploadURL                = @"/servicesweb/projectprocess/projectProcessUpload.action";
/*公示登记        */
//需公示方案列表
static NSString * const kFindPublicListURL                = @"/servicesweb/publicupload/findPublicList.action";
//已公示详情
static NSString * const kPublicUploadURL                = @"/servicesweb/publicupload/getItem.action";
//公示记录列表
static NSString * const kFindPublicListHistoryURL                = @"/servicesweb/publicupload/findPublicListHistory.action";
//公示提交
static NSString * const kFindPublicListCommitURL                = @"/servicesweb/publicupload/public.action";

//办事指南
static NSString * const kBsznListURL                = @"http://www.hzplanning.gov.cn/ghjwap/bsznlist.html";

//消息通知列表
static NSString * const kMessageListURL                = @"/servicesweb/message/list.action";
//消息通知详情
static NSString * const kMessageDetailURL                = @"/servicesweb/message/detail.action";


//消息公告列表
static NSString * const kListAnnouncementURL                = @"/servicesweb/message/listAnnouncement.action";
//消息公告详情
static NSString * const kDetailAnnouncementURL                = @"/servicesweb/message/detail.action";

//密码修改
static NSString * const kNewPswURL                = @"/servicesweb/login/newPsw.action";
//获取新通知
static NSString * const kNoticeURL                = @"/servicesweb/message/notice.action";
//已读标记
static NSString * const kReadURL                = @"/servicesweb/message/read.action";

//图片下载
static NSString * const kGetFileURL                = @"/servicesweb/file/getfile.action";
//MARK:办事指南
static NSString * const kWorkGuidURL                = @"/servicesweb/workguid/list.action";
//改密码
#endif /* HZURL_h */
