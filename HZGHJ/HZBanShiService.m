

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
// MARK:获取在线申请首页列表
+(void)BanShiHomeListWithUsreName:(NSString *)username GetBlock:(ReturnData)GetContent{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *serviceURLString = [NSString stringWithFormat:@"%@%@",kDemoBaseURL,kInLineHomeListURL];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval=10.f;
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:username forKey:@"username"];
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
// MARK: 常用表格
+(void)BiaoGeWithId:(NSString*)IsPId GetBlock:(ReturnData)GetContent{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *serviceURLString = [NSString stringWithFormat:@"%@%@",kDemoBaseURL,kCommonTablesURL];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval=10.f;
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:IsPId forKey:@"fileId"];
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
//MARK:请选择办理的窗口
+(void)BanShiWithAndBlock:(ReturnData)BanShiBlock{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *serviceURLString = [NSString stringWithFormat:@"%@%@",kDemoBaseURL,kQueryOrgURL];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval=10.f;
    [session POST:serviceURLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"成功  %@",str);
        BanShiBlock(dic,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        BanShiBlock(nil,error);
    }];
    
    
}
// MARK: 在线办事进度查询
+(void)BanShiWithCompanyid:(NSString*)companyid  pageIndex:(int)pageindex AddBlock:(ReturnData)GetCommitBlock{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *serviceURLString = [NSString stringWithFormat:@"%@%@",kDemoBaseURL,kQueryListURL];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval=30.f;
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:companyid forKey:@"companyid"];
    [parameters setObject:[NSString stringWithFormat:@"%d",pageindex] forKey:@"pageindex"];
     [parameters setObject:@"10" forKey:@"pagesize"];
    [session POST:serviceURLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSData *data =    [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        printf("办事提交 %s \n",[[NSString stringWithFormat:@"%@",str]UTF8String]);
        GetCommitBlock(dic,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        GetCommitBlock(nil,error);
    }];

}
// MARK: 申请附件材料信息和修正材料附件信息
+(void)BanShiWithId:(NSString*)Id AddBlock:(ReturnData)GetCommitBlock{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *serviceURLString = [NSString stringWithFormat:@"%@%@",kDemoBaseURL,kQueryAttachmentListURL];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval=30.f;
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:Id forKey:@"id"];
    [session POST:serviceURLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSData *data =    [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        printf("办事提交 %s \n",[[NSString stringWithFormat:@"%@",str]UTF8String]);
        GetCommitBlock(dic,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        GetCommitBlock(nil,error);
    }];

}
// MARK: 2.在线办事提交
+(void)BanShiCommitWithTotalDic:(NSDictionary *)totalDic imageArray:(NSMutableArray *)imageArray imageNameArray:(NSArray *)imageNameArray AddBlock:(ReturnData)GetCommitBlock{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *serviceURLString = [NSString stringWithFormat:@"%@%@",kDemoBaseURL,kUploadApprovalURL];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval=100.f;
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:[totalDic objectForKey:@"linerange"] forKey:@"linerange"];
    [parameters setObject:[totalDic objectForKey:@"tzdm"] forKey:@"tzdm"];
    [parameters setObject:[totalDic objectForKey:@"tdgyfs"] forKey:@"tdgyfs"];
    [parameters setObject:[totalDic objectForKey:@"qlsxzx"] forKey:@"qlsxzx"];
    [parameters setObject:[totalDic objectForKey:@"lxwh"] forKey:@"lxwh"];
    [parameters setObject:[totalDic objectForKey:@"sqr"] forKey:@"sqr"];
    [parameters setObject:[totalDic objectForKey:@"xmmc"] forKey:@"xmmc"];
    [parameters setObject:[totalDic objectForKey:@"fddbr"] forKey:@"fddbr"];
    [parameters setObject:[totalDic objectForKey:@"lxdh"] forKey:@"lxdh"];
    [parameters setObject:[totalDic objectForKey:@"wtr"] forKey:@"wtr"];
    [parameters setObject:[totalDic objectForKey:@"sjh"] forKey:@"sjh"];
    [parameters setObject:[totalDic objectForKey:@"jsnrjgm"] forKey:@"jsnrjgm"];
    [parameters setObject:[totalDic objectForKey:@"jsdzq"] forKey:@"jsdzq"];
    [parameters setObject:[totalDic objectForKey:@"jsdzl"] forKey:@"jsdzl"];
    [parameters setObject:[totalDic objectForKey:@"zbdz"] forKey:@"zbdz"];
    [parameters setObject:[totalDic objectForKey:@"zbnz"] forKey:@"zbnz"];
    [parameters setObject:[totalDic objectForKey:@"zbxz"] forKey:@"zbxz"];
    [parameters setObject:[totalDic objectForKey:@"zbbz"] forKey:@"zbbz"];
    [parameters setObject:[totalDic objectForKey:@"lzbg"] forKey:@"lzbg"];
    [parameters setObject:[totalDic objectForKey:@"sxslh"] forKey:@"sxslh"];
    [parameters setObject:[totalDic objectForKey:@"xmsmqk"] forKey:@"xmsmqk"];
    [parameters setObject:[totalDic objectForKey:@"userid"] forKey:@"userid"];
    [parameters setObject:[totalDic objectForKey:@"qlsxcode"] forKey:@"qlsxcode"];
    [parameters setObject:[totalDic objectForKey:@"businessId"] forKey:@"businessId"];
    [parameters setObject:[totalDic objectForKey:@"resuuid"] forKey:@"resuuid"];
    [parameters setObject:[totalDic objectForKey:@"ydqsqk"] forKey:@"ydqsqk"];
    [parameters setObject:[totalDic objectForKey:@"sfqdfapf"] forKey:@"sfqdfapf"];
    [parameters setObject:[totalDic objectForKey:@"sfghtjbg"] forKey:@"sfghtjbg"];
    [parameters setObject:[totalDic objectForKey:@"tdcb"] forKey:@"tdcb"];
    [parameters setObject:[totalDic objectForKey:@"tznrjly"] forKey:@"tznrjly"];
    [parameters setObject:[totalDic objectForKey:@"modifiedTag"] forKey:@"modifiedTag"];
    [parameters setObject:[totalDic objectForKey:@"orgId"] forKey:@"orgId"];
    [parameters setObject:[totalDic objectForKey:@"filecode"] forKey:@"filecode"];
    [parameters setObject:[totalDic objectForKey:@"companyid"] forKey:@"companyid"];
    [parameters setObject:[totalDic objectForKey:@"sqryq"] forKey:@"sqryq"];
    [parameters setObject:[totalDic objectForKey:@"fddbryq"] forKey:@"fddbryq"];
    [parameters setObject:[totalDic objectForKey:@"stryq"] forKey:@"stryq"];
    [parameters setObject:[totalDic objectForKey:@"sjyq"] forKey:@"sjyq"];
    [parameters setObject:[totalDic objectForKey:@"dhyq"] forKey:@"dhyq"];
    [parameters setObject:[totalDic objectForKey:@"xmmcyq"] forKey:@"xmmcyq"];
    [parameters setObject:[totalDic objectForKey:@"jsnrjgmyq"] forKey:@"jsnrjgmyq"];
    [parameters setObject:[totalDic objectForKey:@"quyq"] forKey:@"quyq"];
    [parameters setObject:[totalDic objectForKey:@"luyq"] forKey:@"luyq"];
    [parameters setObject:[totalDic objectForKey:@"blxs"] forKey:@"blxs"];
    [parameters setObject:[totalDic objectForKey:@"xghyqsxmc"] forKey:@"xghyqsxmc"];
    [parameters setObject:[totalDic objectForKey:@"xghyqjnr"] forKey:@"xghyqjnr"];
    [parameters setObject:[totalDic objectForKey:@"sjdw"] forKey:@"sjdw"];
    [parameters setObject:[totalDic objectForKey:@"sjr"] forKey:@"sjr"];
    [parameters setObject:[totalDic objectForKey:@"sjrsj"] forKey:@"sjrsj"];
    [parameters setObject:[totalDic objectForKey:@"gcmcsx"] forKey:@"gcmcsx"];
    [parameters setObject:[totalDic objectForKey:@"qd"] forKey:@"qd"];
    [parameters setObject:[totalDic objectForKey:@"zd"] forKey:@"zd"];
    [parameters setObject:[totalDic objectForKey:@"dlgl"] forKey:@"dlgl"];
    [parameters setObject:[totalDic objectForKey:@"ql"] forKey:@"ql"];
    [parameters setObject:[totalDic objectForKey:@"bk"] forKey:@"bk"];
    [parameters setObject:[totalDic objectForKey:@"gxgc"] forKey:@"gxgc"];
    [parameters setObject:[totalDic objectForKey:@"jsgc"] forKey:@"jsgc"];
    [parameters setObject:[totalDic objectForKey:@"gcghxkzh"] forKey:@"gcghxkzh"];
    [parameters setObject:[totalDic objectForKey:@"xknr"] forKey:@"xknr"];
    [parameters setObject:[totalDic objectForKey:@"sgxcql"] forKey:@"sgxcql"];
    [parameters setObject:[totalDic objectForKey:@"yqccjz"] forKey:@"yqccjz"];
    [parameters setObject:[totalDic objectForKey:@"jrczxt"] forKey:@"jrczxt"];
    [parameters setObject:[totalDic objectForKey:@"sclx"] forKey:@"sclx"];
   
     NSString *table= [self convertToJsonData:parameters];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    [dic setObject:table forKey:@"table"];
    printf("办事提交 %s \n",[[NSString stringWithFormat:@"%@",parameters]UTF8String]);
    [session POST:serviceURLString parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSLog(@"imageNameArray   %@",imageNameArray);
        for (int i=0; i<imageArray.count; i++) {
                    UIImage *object=[imageArray objectAtIndex:i];
                    NSData *imageData=UIImageJPEGRepresentation(object, 0.5);
                    [formData appendPartWithFileData:imageData name:[imageNameArray objectAtIndex:i] fileName:[imageNameArray objectAtIndex:i] mimeType:@"png/jpeg/jpg"];
            
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"成功  %@",str);
        GetCommitBlock(dic,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        GetCommitBlock(nil,error);
    }];

}
+(NSString *)convertToJsonData:(NSDictionary *)dict

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}
@end
