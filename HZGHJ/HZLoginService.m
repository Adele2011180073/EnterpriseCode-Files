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
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
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
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
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
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"成功  %@",str);
        YuYueBlock(dic,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        YuYueBlock(nil,error);
    }];

}
//我要预约
+(void)YuYueWithToken:(NSString *)token  andBlock:(ReturnData)YuYueBlock{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *serviceURLString = [NSString stringWithFormat:@"%@%@",kDemoBaseURL,kReservationMissionURL];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval=10.f;
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:token forKey:@"token"];
    [session POST:serviceURLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
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
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
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
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
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
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//        [str stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
//        [str stringByReplacingOccurrencesOfString:@"null" withString:@""];
//        NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"成功  %@  %@",str,dic);
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
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
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
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        //        [str stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        //        [str stringByReplacingOccurrencesOfString:@"null" withString:@""];
        //        NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"成功  %@  %@",str,dic);
        NoticeBlock(dic,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        NoticeBlock(nil,error);
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
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
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
    [parameters setObject:[NSString stringWithFormat:@"%d",pageindex] forKey:@"pageindex"];
    [parameters setObject:@"10" forKey:@"pagesize"];
    [session POST:serviceURLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"成功  %@",str);
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
+(void)GongShiCommitWithToken:(NSString *)token ProjectId:(NSString*)projectId Publicid:(NSString*)publicid Type:(NSString*)type  andBlock:(ReturnData)GongShiBlock{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *serviceURLString = [NSString stringWithFormat:@"%@%@",kDemoBaseURL,kProjectProcessUploadURL];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval=10.f;
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:token forKey:@"token"];
    [parameters setObject:projectId forKey:@"projectId"];
    [parameters setObject:publicid forKey:@"publicid"];
    [parameters setObject:type forKey:@"type"];
    
    [session POST:serviceURLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
