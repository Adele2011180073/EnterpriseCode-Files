

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
// MARK: 2.在线办事提交
+(void)BanShiWithCompanyid:(NSString*)companyid  userid:(NSString*)userid  qlsxcode:(NSString*)qlsxcode uuid:(NSString*)uuid uploadtime:(NSString*)uploadtime synctime:(NSString*)synctime linerange:(NSString*)linerange tzdm:(NSString*)tzdm tdgyfs:(NSString*)tdgyfs  qlsxzx:(NSString*)qlsxzx  lxwh:(NSString*)lxwh  sqr:(NSString*)sqr  xmmc:(NSString*)xmmc  fddbr:(NSString*)fddbr lxdh:(NSString*)lxdh  wtr:(NSString*)wtr  sjh:(NSString*)sjh  jsnrjgm:(NSString*)jsnrjgm  jsdzq:(NSString*)jsdzq  jsdzl:(NSString*)jsdzl zbdz:(NSString*)zbdz  zbnz:(NSString*)zbnz  zbxz:(NSString*)zbxz zbbz:(NSString*)zbbz  lzbg:(NSString*)lzbg sxslh:(NSString*)sxslh applysource:(NSString*)applysource xmsmqk:(NSString*)xmsmqk filecode:(NSString*)filecode businessId:(NSString*)businessId resuuid:(NSString*)resuuid ydqsqk:(NSString*)ydqsqk sfqdfapf:(NSString*)sfqdfapf sfghtjbg:(NSString*)sfghtjbg tdcb:(NSString*)tdcb tznrjly:(NSString*)tznrjly modifiedTag:(NSString*)modifiedTag orgId:(NSString*)orgId imageArray:(NSMutableArray *)imageArray imageNameArray:(NSArray *)imageNameArray AddBlock:(ReturnData)GetCommitBlock{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *serviceURLString = [NSString stringWithFormat:@"%@%@",kDemoBaseURL,kUploadApprovalURL];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval=60.f;
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
    
    NSLog(@"办事提交  parameters %@ ",parameters);
    [session POST:serviceURLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i=0; i<imageArray.count; i++) {
            NSArray *imagelittleArray=[imageArray objectAtIndex:i];
            if (imagelittleArray.count>0) {
                for (int j=0; j<imagelittleArray.count; j++) {
                    UIImage *object=[imageArray objectAtIndex:j];
                    NSData *imageData=UIImageJPEGRepresentation(object, 0.1);
                    [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"image%d",i+1] fileName:[NSString stringWithFormat:@"image%d.png",i+1] mimeType:@"png/jpeg/jpg"];
                }
            }
            
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
@end
