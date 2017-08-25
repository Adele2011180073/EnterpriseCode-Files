

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
//MARK:在线办事
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
+(void)BanShiWithCompanyid:(NSString*)companyid  userid:(NSString*)userid  qlsxcode:(NSString*)qlsxcode uuid:(NSString*)uuid uploadtime:(NSString*)uploadtime synctime:(NSString*)synctime linerange:(NSString*)linerange tzdm:(NSString*)tzdm tdgyfs:(NSString*)tdgyfs  qlsxzx:(NSString*)qlsxzx  lxwh:(NSString*)lxwh  sqr:(NSString*)sqr  xmmc:(NSString*)xmmc  fddbr:(NSString*)fddbr lxdh:(NSString*)lxdh  wtr:(NSString*)wtr  sjh:(NSString*)sjh  jsnrjgm:(NSString*)jsnrjgm  jsdzq:(NSString*)jsdzq  jsdzl:(NSString*)jsdzl zbdz:(NSString*)zbdz  zbnz:(NSString*)zbnz  zbxz:(NSString*)zbxz zbbz:(NSString*)zbbz  lzbg:(NSString*)lzbg sxslh:(NSString*)sxslh applysource:(NSString*)applysource xmsmqk:(NSString*)xmsmqk filecode:(NSString*)filecode businessId:(NSString*)businessId resuuid:(NSString*)resuuid ydqsqk:(NSString*)ydqsqk sfqdfapf:(NSString*)sfqdfapf sfghtjbg:(NSString*)sfghtjbg tdcb:(NSString*)tdcb tznrjly:(NSString*)tznrjly modifiedTag:(NSString*)modifiedTag orgId:(NSString*)orgId imageArray:(NSMutableArray *)imageArray imageNameArray:(NSArray *)imageNameArray AddBlock:(ReturnData)GetCommitBlock{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *serviceURLString = [NSString stringWithFormat:@"%@%@",kDemoBaseURL,kUploadApprovalURL];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval=100.f;
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:companyid forKey:@"companyid"];
     [parameters setObject:userid forKey:@"userid"];
     [parameters setObject:qlsxcode forKey:@"qlsxcode"];
     [parameters setObject:uuid forKey:@"uuid"];
     [parameters setObject:uploadtime forKey:@"uploadtime"];
     [parameters setObject:synctime forKey:@"synctime"];
     [parameters setObject:linerange forKey:@"linerange"];
     [parameters setObject:tzdm forKey:@"tzdm"];
     [parameters setObject:tdgyfs forKey:@"tdgyfs"];
     [parameters setObject:qlsxzx forKey:@"qlsxzx"];
     [parameters setObject:lxwh forKey:@"lxwh"];
     [parameters setObject:sqr forKey:@"sqr"];
     [parameters setObject:xmmc forKey:@"xmmc"];
     [parameters setObject:fddbr forKey:@"fddbr"];
     [parameters setObject:lxdh forKey:@"lxdh"];
     [parameters setObject:wtr forKey:@"wtr"];
     [parameters setObject:sjh forKey:@"sjh"];
     [parameters setObject:jsnrjgm forKey:@"jsnrjgm"];
     [parameters setObject:jsdzq forKey:@"jsdzq"];
     [parameters setObject:jsdzl forKey:@"jsdzl"];
     [parameters setObject:zbdz forKey:@"zbdz"];
     [parameters setObject:zbnz forKey:@"zbnz"];
     [parameters setObject:zbxz forKey:@"zbxz"];
     [parameters setObject:zbbz forKey:@"zbbz"];
     [parameters setObject:lzbg forKey:@"lzbg"];
     [parameters setObject:sxslh forKey:@"sxslh"];
     [parameters setObject:applysource forKey:@"applysource"];
     [parameters setObject:xmsmqk forKey:@"xmsmqk"];
     [parameters setObject:filecode forKey:@"filecode"];
     [parameters setObject:businessId forKey:@"businessId"];
     [parameters setObject:resuuid forKey:@"resuuid"];
     [parameters setObject:ydqsqk forKey:@"ydqsqk"];
     [parameters setObject:sfqdfapf forKey:@"sfqdfapf"];
     [parameters setObject:sfghtjbg forKey:@"sfghtjbg"];
     [parameters setObject:tdcb forKey:@"tdcb"];
     [parameters setObject:tznrjly forKey:@"tznrjly"];
     [parameters setObject:modifiedTag forKey:@"modifiedTag"];
     [parameters setObject:orgId forKey:@"orgId"];
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
