//
//  BSRegexValidate.h
//  UMO
//
//  Created by Soul Taker on 13-7-18.
//  Copyright (c) 2013年 Bangsun FIT Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSRegexValidate : NSObject
+ (BOOL)validateUserName:(NSString *)userName;
+ (BOOL)validateTelephone:(NSString *)telephone;
+ (BOOL)validateRealName:(NSString *)realName;
+ (BOOL)validateIdCard:(NSString *)idCard;
+ (BOOL)validateAddress:(NSString *)address;
+ (BOOL)stringContainsEmoji:(NSString *)string;
@end
