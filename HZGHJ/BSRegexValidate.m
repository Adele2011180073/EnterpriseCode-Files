//
//  BSRegexValidate.m
//  UMO
//
//  Created by Soul Taker on 13-7-18.
//  Copyright (c) 2013年 Bangsun FIT Ltd. All rights reserved.
//

#import "BSRegexValidate.h"

@implementation BSRegexValidate

/*!
 @method        validateUserName:
 @abstract      This method is used to judge whether the username is validate.
 @param
    userName    The String waited to be judged.
 @return
    YES         if userName only contains 3~32 letters/digits(include '_').
    NO          if userName not satisfied the rule above.
 */
+ (BOOL)validateUserName:(NSString *)userName
{
    NSString *patternStr = [NSString stringWithFormat:@"^[a-zA-Z_0-9]{6,12}$"];
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:patternStr
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:userName
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, userName.length)];
    
    if(numberofMatch > 0)
    {
        return YES;
    }
    return NO;
}
+ (BOOL)validatePassWord:(NSString *)userName
{
    NSString *patternStr = [NSString stringWithFormat:@"^([a-zA-Z_0-9]|[a-z]|[0-9]){6,12}$"];
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:patternStr
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:userName
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, userName.length)];
    
    if(numberofMatch > 0)
    {
        return YES;
    }
    return NO;
}

/*!
 @method        validateTelephone:
 @abstract      This method is used to judge whether the telephone is validate.
 @param
    telephone   The String waited to be judged.
 @return
    YES         if telephone satisfied the rule that it contains 11 digits and should be started with 13, 15 or 18.
    NO          if telephone not satisfied the rule above.
 */
+ (BOOL)validateTelephone:(NSString *)telephone
{
    NSString *patternStr = [NSString stringWithFormat:@"^((13[0-9])|(15[0-9])|(18[0-9])|(17[0-9]))\\d{8}$"];
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:patternStr
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:telephone
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, telephone.length)];
    
    
    if(numberofMatch > 0)
    {
        return YES;
    }
    return NO;
}

/*!
 @method        validateRealName:
 @abstract      This method is used to judge whether the realname is validate.
 @param
    realName    The String waited to be judged.
 @return
    YES         if realName satisfied the rule that it contains only Chinese character and letters (include '.' & '·').
    NO          if realName not satisfied the rule above.
 */
+ (BOOL)validateRealName:(NSString *)realName
{
    NSString *patternStr = [NSString stringWithFormat:@"^$|^([a-zA-Z]{1,20}|[\u4e00-\u9fa5]{1,10})[\\s.]{0,1}([a-zA-Z]{1,20}|[\u4e00-\u9fa5]{5,12})$"];
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:patternStr
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:realName
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, realName.length)];
    
    
    if(numberofMatch > 0)
    {
        return YES;
    }
    return NO;
}

/*!
 @method        validateIdCard:
 @abstract      This method is used to judge whether the idCard is validate.
 @param
    idCard      The String waited to be judged.
 @return
    YES         if idCard satisfied the rule that it contains 15 or 18 characters and if it contains 15 characters all must be digits if it contains 18 characters the last can be 'x' or 'X' and others must be digits.
    NO          if idCard not satisfied the rule above.
 */
+ (BOOL)validateIdCard:(NSString *)idCard
{
    NSString *patternStr = [NSString stringWithFormat:@"^$|^(\\d{15}$|^\\d{17}(\\d|X|x))$"];
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:patternStr
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:idCard
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, idCard.length)];
    
    
    if(numberofMatch > 0)
    {
        return YES;
    }
    return NO;
}

/*!
 @method        validateIdCard:
 @abstract      This method is used to judge whether the address is validate.
 @param
    address     The String waited to be judged.
 @return
    YES         if address satisfied the rule that it contains 5~100 characters and all the letters should only be one of these: letters,digits,Chinese characters,'.', ':', ',', ' ', '&', '，'.
    NO          if address not satisfied the rule above.
 */
+ (BOOL)validateAddress:(NSString *)address
{
    NSString *patternStr = [NSString stringWithFormat:@"^$|^[\\w\\d\\s\u4e00-\u9fa5,.:，&]{5,100}$"];
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:patternStr
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:address
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, address.length)];
    
    
    if(numberofMatch > 0)
    {
        return YES;
    }
    return NO;
}
+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}
@end
