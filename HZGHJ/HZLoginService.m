//
//  HZLoginService.m
//  HZGHJ
//
//  Created by zhang on 16/12/7.
//  Copyright © 2016年 FiveFu. All rights reserved.
//

#import "HZLoginService.h"
#import "AFNetworking.h"
#import "HZURL.h"
@implementation HZLoginService
+(void)LoginWithUserName:(NSString *)username passwd:(NSString*)passwd andBlock:(ReturnData)LoginBlock{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *serviceURLString = [NSString stringWithFormat:@"%@%@",kDemoBaseURL,kLoginURL];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval=10.f;
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:username forKey:@"userid"];
    [parameters setObject:passwd forKey:@"pwd"];
    [session POST:serviceURLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSData *data =    [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"成功  %@",str);
        LoginBlock(dic,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        LoginBlock(nil,error);
    }];

}
//预约
//在线预约
+(void)YuYueWithToken:(NSString *)token pageIndex:(int)pageindex andBlock:(ReturnData)YuYueBlock{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *serviceURLString = [NSString stringWithFormat:@"%@%@",kDemoBaseURL,kHistorytaskURL];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval=10.f;
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:token forKey:@"token"];
    [parameters setObject:[NSString stringWithFormat:@"%d",pageindex] forKey:@"pageindex"];
      [parameters setObject:@"10" forKey:@"pagesize"];
    [session POST:serviceURLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSData *data =    [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"成功  %@",str);
        YuYueBlock(dic,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        YuYueBlock(nil,error);
    }];

}
//我的预约
+(void)WoDeYuYueWithToken:(NSString *)token pageIndex:(int)pageindex andBlock:(ReturnData)YuYueBlock{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *serviceURLString = [NSString stringWithFormat:@"%@%@",kDemoBaseURL,kMyReservationURL];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval=10.f;
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:token forKey:@"token"];
    [parameters setObject:[NSString stringWithFormat:@"%d",pageindex] forKey:@"pageindex"];
    [parameters setObject:@"10" forKey:@"pagesize"];
    [session POST:serviceURLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSData *data =    [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"成功  %@",str);
        YuYueBlock(dic,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        YuYueBlock(nil,error);
    }];

}
//预约详情
+(void)YuYueWithToken:(NSString *)token ReservationId:(NSString*)reservationid andBlock:(ReturnData)YuYueBlock{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *serviceURLString = [NSString stringWithFormat:@"%@%@",kDemoBaseURL,kHistoryTaskItemURL];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval=10.f;
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:token forKey:@"token"];
    [parameters setObject:reservationid forKey:@"reservationid"];
    [session POST:serviceURLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSData *data =    [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"预约详情成功  %@",str);
        YuYueBlock(dic,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        YuYueBlock(nil,error);
    }];

}
//获取我要预约数据
+(void)WoDeYuYueDataWithToken:(NSString *)token andBlock:(ReturnData)YuYueBlock{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *serviceURLString = [NSString stringWithFormat:@"%@%@",kDemoBaseURL,kReservationMissionURL];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval=10.f;
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:token forKey:@"token"];
    [session POST:serviceURLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSData *data =    [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"成功  %@",str);
        YuYueBlock(dic,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        YuYueBlock(nil,error);
    }];

}
//预约提交
+(void)YuYueWithToken:(NSString *)token unitcontact:(NSString*)unitcontact  unitcontactphone:(NSString*)unitcontactphone timeofappointment:(NSString*)timeofappointment designInstitutename:(NSString*)designInstitutename designInstitutephone:(NSString*)designInstitutephone hostdepartment:(NSString*)hostdepartment companymisstionid:(NSString*)companymisstionid projectid:(NSString*)projectid nodeId:(NSString*)nodeId andBlock:(ReturnData)YuYueBlock{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *serviceURLString = [NSString stringWithFormat:@"%@%@",kDemoBaseURL,kReservationURL];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval=10.f;
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:token forKey:@"token"];
     [parameters setObject:unitcontact forKey:@"unitcontact"];
     [parameters setObject:unitcontactphone forKey:@"unitcontactphone"];
     [parameters setObject:timeofappointment forKey:@"timeofappointment"];
     [parameters setObject:designInstitutename forKey:@"designInstitutename"];
     [parameters setObject:designInstitutename forKey:@"designInstitutename"];
    [parameters setObject:designInstitutephone forKey:@"designInstitutephone"];
     [parameters setObject:hostdepartment forKey:@"hostdepartment"];
     [parameters setObject:companymisstionid forKey:@"companymisstionid"];
     [parameters setObject:projectid forKey:@"projectid"];
     [parameters setObject:nodeId forKey:@"nodeId"];
    NSLog(@"parameters    %@",parameters);
    [session POST:serviceURLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSData *data =    [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"成功  %@",str);
        YuYueBlock(dic,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        YuYueBlock(nil,error);
    }];

}
//结束预约
+(void)YuYueFinishWithTaskId:(NSString *)taskId Status:(NSString*)status timeofappointment:(NSString*)timeofappointment andBlock:(ReturnData)YuYueBlock{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *serviceURLString = [NSString stringWithFormat:@"%@%@",kDemoBaseURL,kCompleTaskURL];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval=10.f;
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:taskId forKey:@"taskId"];
    [parameters setObject:status forKey:@"status"];
    [parameters setObject:timeofappointment forKey:@"timeofappointment"];
    [session POST:serviceURLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSData *data =    [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"成功  %@",str);
        YuYueBlock(dic,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        YuYueBlock(nil,error);
    }];

}
//重新预约（获取预约条件）
+(void)YuYueRefreshDataWithNodeId:(NSString *)nodeid  andBlock:(ReturnData)YuYueBlock{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *serviceURLString = [NSString stringWithFormat:@"%@%@",kDemoBaseURL,kFindPremiseConditionURL];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval=15.f;
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:nodeid forKey:@"nodeid"];
    [session POST:serviceURLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSData *data =    [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"成功  %@",str);
        YuYueBlock(dic,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        YuYueBlock(nil,error);
    }];
}
//重新预约
+(void)YuYueRefreshWithTaskId:(NSString *)taskId Status:(NSString*)status timeofappointment:(NSString*)timeofappointment andBlock:(ReturnData)YuYueBlock{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *serviceURLString = [NSString stringWithFormat:@"%@%@",kDemoBaseURL,kCompleTaskURL];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval=15.f;
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:taskId forKey:@"taskId"];
    [parameters setObject:status forKey:@"status"];
    [parameters setObject:timeofappointment forKey:@"timeofappointment"];
    [session POST:serviceURLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSData *data =    [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"成功  %@",str);
        YuYueBlock(dic,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        YuYueBlock(nil,error);
    }];
}
//取消预约
+(void)YuYueCancelWithId:(NSString*)Id andBlock:(ReturnData)YuYueBlock{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *serviceURLString = [NSString stringWithFormat:@"%@%@",kDemoBaseURL,kCancelURL];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval=10.f;
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:Id forKey:@"id"];
      [session POST:serviceURLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSData *data =    [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"成功  %@",str);
        YuYueBlock(dic,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        YuYueBlock(nil,error);
    }];

}


//消息通知列表
+(void)NoticeWithToken:(NSString *)token pageIndex:(int)pageindex andBlock:(ReturnData)NoticeBlock{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *serviceURLString = [NSString stringWithFormat:@"%@%@",kDemoBaseURL,kMessageListURL];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval=10.f;
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:token forKey:@"token"];
    [parameters setObject:[NSString stringWithFormat:@"%d",pageindex] forKey:@"pageindex"];
    [parameters setObject:@"10" forKey:@"pagesize"];
    [session POST:serviceURLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSData *data =    [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"成功  %@",str);
        NoticeBlock(dic,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        NoticeBlock(nil,error);
    }];

}
//消息通知详情
+(void)NoticeWithRecordId:(NSString*)recordid andBlock:(ReturnData)NoticeBlock{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *serviceURLString = [NSString stringWithFormat:@"%@%@",kDemoBaseURL,kMessageDetailURL];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval=10.f;
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:recordid forKey:@"recordid"];
    [session POST:serviceURLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSData *data =    [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"成功  %@  ",str);
        NoticeBlock(dic,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        NoticeBlock(nil,error);
    }];

}
//消息公告列表
+(void)NewsWithToken:(NSString *)token pageIndex:(int)pageindex andBlock:(ReturnData)NoticeBlock{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *serviceURLString = [NSString stringWithFormat:@"%@%@",kDemoBaseURL,kListAnnouncementURL];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval=10.f;
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:token forKey:@"token"];
    [parameters setObject:[NSString stringWithFormat:@"%d",pageindex] forKey:@"pageindex"];
    [parameters setObject:@"10" forKey:@"pagesize"];
    [session POST:serviceURLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSData *data =    [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"成功  %@",str);
        NoticeBlock(dic,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        NoticeBlock(nil,error);
    }];

}
//消息公告详情
+(void)NewsWithRecordId:(NSString*)recordid andBlock:(ReturnData)NoticeBlock{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *serviceURLString = [NSString stringWithFormat:@"%@%@",kDemoBaseURL,kDetailAnnouncementURL];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval=10.f;
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:recordid forKey:@"recordid"];
    [session POST:serviceURLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSData *data =    [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"成功  %@ ",str);
        NoticeBlock(dic,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        NoticeBlock(nil,error);
    }];

}

//消息推送   获取新通知
+(void)NavigationWithToken:(NSString *)token  andBlock:(ReturnData)NavigationBlock{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *serviceURLString = [NSString stringWithFormat:@"%@%@",kDemoBaseURL,kNoticeURL];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval=10.f;
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:token forKey:@"token"];
    [session POST:serviceURLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSData *data =    [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"成功  %@",str);
        NavigationBlock(dic,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        NavigationBlock(nil,error);
    }];

}
//已读标记
+(void)NavigationWithRecordId:(NSString*)recordid andBlock:(ReturnData)NavigationBlock{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *serviceURLString = [NSString stringWithFormat:@"%@%@",kDemoBaseURL,kReadURL];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval=10.f;
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:recordid forKey:@"recordid"];
    [session POST:serviceURLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSData *data =    [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"成功  %@  %@",str,dic);
        NavigationBlock(dic,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        NavigationBlock(nil,error);
    }];

}

//更换密码
+(void)PWWithNSw:(NSString *)opsw NSW:(NSString*)npsw andBlock:(ReturnData)NewSWBlock{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *serviceURLString = [NSString stringWithFormat:@"%@%@",kDemoBaseURL,kNewPswURL];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval=10.f;
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    NSString *username=[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    [parameters setObject:username forKey:@"userid"];
    [parameters setObject:opsw forKey:@"opsw"];
     [parameters setObject:npsw forKey:@"npsw"];
    [session POST:serviceURLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments|NSJSONReadingMutableContainers error:nil];
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"成功  %@",str);
        NewSWBlock(dic,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        NewSWBlock(nil,error);
    }];

}

//上报
//过程上报
+(void)ShangBaoWithToken:(NSString *)token pageIndex:(int)pageindex andBlock:(ReturnData)ShangBaoBlock{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *serviceURLString = [NSString stringWithFormat:@"%@%@",kDemoBaseURL,kFindCompanyHistoryURL];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval=10.f;
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:token forKey:@"token"];
    [parameters setObject:[NSString stringWithFormat:@"%d",pageindex] forKey:@"pageindex"];
    [parameters setObject:@"10" forKey:@"pagesize"];
    [session POST:serviceURLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"成功  %@",str);
        ShangBaoBlock(dic,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        ShangBaoBlock(nil,error);
    }];

}
//我的上报
+(void)WoDeShangBaoWithToken:(NSString *)token pageIndex:(int)pageindex andBlock:(ReturnData)ShangBaoBlock{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *serviceURLString = [NSString stringWithFormat:@"%@%@",kDemoBaseURL,kFindhistoryURL];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval=10.f;
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:token forKey:@"token"];
    [parameters setObject:[NSString stringWithFormat:@"%d",pageindex] forKey:@"pageindex"];
    [parameters setObject:@"10" forKey:@"pagesize"];
    [session POST:serviceURLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"成功  %@",str);
        ShangBaoBlock(dic,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        ShangBaoBlock(nil,error);
    }];

}
//项目上报
+(void)ShangBaoGetWithToken:(NSString *)token  andBlock:(ReturnData)ShangBaoBlock{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *serviceURLString = [NSString stringWithFormat:@"%@%@",kDemoBaseURL,kUploadProjectURL];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval=10.f;
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:token forKey:@"token"];
    [session POST:serviceURLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSData *data =    [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"成功  %@",str);
        ShangBaoBlock(dic,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        ShangBaoBlock(nil,error);
    }];

}
//上报提交
+(void)ShangBaoCommitWithToken:(NSString *)token ProjectId:(NSString*)projectId processId:(NSString *)processId details:(NSString*)details picture:(NSMutableArray *)imageData  andBlock:(ReturnData)ShangBaoBlock{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *serviceURLString = [NSString stringWithFormat:@"%@%@",kDemoBaseURL,kProjectProcessUploadURL];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval=10.f;
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:token forKey:@"token"];
    [parameters setObject:projectId forKey:@"projectId"];
    [parameters setObject:processId forKey:@"processId"];
    [parameters setObject:details forKey:@"details"];
    
    [session POST:serviceURLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i=0; i<imageData.count; i++) {
            UIImage *object=[imageData objectAtIndex:i];
            NSData *imageData=UIImageJPEGRepresentation(object, 0.1);
            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"image%d",i+1] fileName:[NSString stringWithFormat:@"image%d.png",i+1] mimeType:@"png/jpeg/jpg"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"成功  %@",str);
        ShangBaoBlock(dic,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        ShangBaoBlock(nil,error);
    }];

}
/*进度查询         */
//进度查询列表
+(void)JinDuGetWithToken:(NSString *)token pageIndex:(int)pageindex andBlock:(ReturnData)JinDuBlock{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *serviceURLString = [NSString stringWithFormat:@"%@%@",kDemoBaseURL,kProjectPaceURL];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval=10.f;
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:token forKey:@"token"];
   // [parameters setObject:[NSString stringWithFormat:@"%d",pageindex] forKey:@"pageindex"];
   // [parameters setObject:@"10" forKey:@"pagesize"];
    [session POST:serviceURLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSData *data =    [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"进度上报列表    %@  ",str);
        JinDuBlock(dic,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        JinDuBlock(nil,error);
    }];
    
}
//进度查询详情
+(void)JinDuDetailWithPublicid:(NSString*)publicid  andBlock:(ReturnData)JinDuBlock{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *serviceURLString = [NSString stringWithFormat:@"%@%@",kDemoBaseURL,kProjectPaceDetailURL];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval=10.f;
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:publicid forKey:@"projectid"];
    [session POST:serviceURLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"成功  %@  %@",str,dic);
        JinDuBlock(dic,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        JinDuBlock(nil,error);
    }];
    
}

//公示
//需公示方案列表
+(void)GongShiWithToken:(NSString *)token pageIndex:(int)pageindex andBlock:(ReturnData)GongShiBlock{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *serviceURLString = [NSString stringWithFormat:@"%@%@",kDemoBaseURL,kFindPublicListURL];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval=10.f;
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:token forKey:@"token"];
    [parameters setObject:[NSString stringWithFormat:@"%d",1] forKey:@"pageindex"];
    [parameters setObject:@"10" forKey:@"pagesize"];
    [session POST:serviceURLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSLog(@"成功  %@",resultJSON);
        GongShiBlock(dic,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        GongShiBlock(nil,error);
    }];

}
//已公示详情
+(void)GongShiDetailWithPublicid:(NSString*)publicid  andBlock:(ReturnData)GongShiBlock{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *serviceURLString = [NSString stringWithFormat:@"%@%@",kDemoBaseURL,kPublicUploadURL];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval=10.f;
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:publicid forKey:@"publicid"];
    [session POST:serviceURLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"成功  %@  %@",str,dic);
        GongShiBlock(dic,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        GongShiBlock(nil,error);
    }];

}

//公示记录列表
+(void)GongShiLstWithToken:(NSString *)token pageIndex:(int)pageindex ProjectName:(NSString*)projectname andBlock:(ReturnData)GongShiBlock{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *serviceURLString = [NSString stringWithFormat:@"%@%@",kDemoBaseURL,kFindPublicListHistoryURL];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval=10.f;
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:token forKey:@"token"];
     [parameters setObject:projectname forKey:@"projectname"];
    [parameters setObject:[NSString stringWithFormat:@"%d",pageindex] forKey:@"pageindex"];
    [parameters setObject:@"10" forKey:@"pagesize"];
    [session POST:serviceURLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSLog(@"成功  %@",str);
        GongShiBlock(dic,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        GongShiBlock(nil,error);
    }];

}
//公示提交
+(void)GongShiCommitWithToken:(NSString *)token ProjectId:(NSString*)projectId Publicid:(NSString*)publicid Type:(NSString*)type imageObjectArray:(NSMutableArray*)imageObjectArray imageNameArray:(NSMutableArray*)imageNameArray andBlock:(ReturnData)GongShiBlock{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *serviceURLString = [NSString stringWithFormat:@"%@%@",kDemoBaseURL,kFindPublicListCommitURL];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval=15.f;
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:token forKey:@"token"];
    [parameters setObject:projectId forKey:@"projectid"];
    [parameters setObject:publicid forKey:@"publicid"];
    [parameters setObject:type forKey:@"type"];
     NSLog(@"parameters  %@",parameters);
    [session POST:serviceURLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSLog(@"imageNameArray  %@  imageObjectArray  %@",imageNameArray,imageObjectArray);
       for (int i=0; i<imageObjectArray.count; i++) {
           UIImage * scaleImage=   [imageObjectArray objectAtIndex:i];
           NSData *imageData = UIImageJPEGRepresentation(scaleImage,1);
           NSString *imageName=[imageNameArray objectAtIndex:i];
            [formData appendPartWithFileData:imageData name:imageName fileName:imageName mimeType:@"png/jpeg/jpg"];
        }

    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"成功  %@",str);
        GongShiBlock(dic,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        GongShiBlock(nil,error);
    }];
}
@end
