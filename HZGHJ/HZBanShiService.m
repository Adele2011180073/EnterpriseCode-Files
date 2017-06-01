

//
//  HZBanShiService.m
//  HZGHJ
//
//  Created by zhang on 2017/5/25.
//  Copyright © 2017年 FiveFu. All rights reserved.
//

#import "HZBanShiService.h"
#import "AFNetworking.h"
#import "HZURL.h"

@implementation HZBanShiService
//获取列表内容
+(void)BanShiWithId:(NSString*)IsPId GetBlock:(ReturnData)GetContent{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *serviceURLString = [NSString stringWithFormat:@"%@%@",kDemoBaseURL,kWorkGuidURL];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval=10.f;
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:IsPId forKey:@"id"];
    [session POST:serviceURLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSData *data =    [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"成功  %@",str);
        GetContent(dic,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        GetContent(nil,error);
    }];
    
}
@end
