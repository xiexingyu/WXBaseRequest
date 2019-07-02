//
//  WXBaseRequest.h
//  mypod
//
//  Created by 王鑫 on 2019/6/27.
//  Copyright © 2019年 wangxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXBaseRequest : NSObject

/**
 @brief 请求通用方法
 */
+ (void)request:(NSString *)s params:(NSDictionary *)params model:(id)model success:(void(^)(id object))success failed:(void(^)(id object))failed;

@end
