//
//  WXBaseRequest.m
//  mypod
//
//  Created by 王鑫 on 2019/6/27.
//  Copyright © 2019年 wangxin. All rights reserved.
//

#import "WXBaseRequest.h"
#import <WXBaseObject.h>
#import <WXShareObject.h>
#import <YYKit.h>
#import <AFNetworking.h>

@implementation WXBaseRequest

+ (void)request:(NSString *)s params:(NSDictionary *)params model:(id)model success:(void (^)(id))success failed:(void (^)(id))failed {
    AFHTTPSessionManager *manager = [self configManager];
    NSDictionary *d = [self configParams:params];
    [self configHeader:manager params:d];
    NSURLSessionTask *dataTask = [manager POST:[self configURLString:s params:d]
                                    parameters:d
                                      progress:nil
                                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                           success([self configSuccess:responseObject model:model]);
                                       }
                                       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                           
                                       }];
    [dataTask resume];
}

/**
 @brief 配置manager
 */
+ (AFHTTPSessionManager *)configManager {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    manager.responseSerializer = responseSerializer;
    return manager;
}

/**
 @brief 配置请求参数
 */
+ (NSDictionary *)configParams:(NSDictionary *)params {
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    [d setValue:[NSString stringWithFormat:@"%ld", (long)([[NSDate date] timeIntervalSince1970]*1000)] forKey:@"timestamp"];
    if (params[@"params"]) {
        [d setValue:params[@"method"] forKey:@"method"];
        [d setValue:[params[@"params"] modelToJSONString] forKey:@"params"];
    }
    return d;
}

/**
 @brief 配置请求头
 */
+ (void)configHeader:(AFHTTPSessionManager *)manager params:(NSDictionary *)params {
    NSString *sign =[NSString stringWithFormat:@"%@secret=%@_%@_*.mb", [self serializeParams:params], @"l%p^e&n*g%$#@!", [WXShareObject shared].appId];
    NSMutableDictionary *authentication = [NSMutableDictionary dictionary];
    [authentication setValue:[sign md5String] forKey:@"sign"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[authentication jsonStringEncoded] forHTTPHeaderField:@"authentication"];
}

/**
 @brief 序列化参数
 */
+ (NSString *)serializeParams:(NSDictionary *)params {
    NSMutableString *s = [NSMutableString stringWithFormat:@""];
    NSArray *array = [params.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult resuest = [obj1 compare:obj2];
        return resuest;
    }];
    for (int i = 0; i < array.count; i++) {
        NSString *key = array[i];
        [s appendFormat:@"%@=%@&", key, params[key]];
    }
    return s;
}

/**
 @brief 配置URL
 */
+ (NSString *)configURLString:(NSString *)s params:(NSDictionary *)params {
    NSString *URL = @"";
    if (params[@"method"]) {
        URL = [NSString stringWithFormat:@"%@/%@?method=%@", [WXShareObject shared].appHost, s, params[@"method"]];
    }
    NSLog(@"%@", URL);
    return URL;
}

/**
 @brief 请求成功后的成功处理
 */
+ (id)configSuccess:(id)responseObject model:(Class)model {
    NSDictionary *d = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
    WXBaseObject *obj = [WXBaseObject modelWithDictionary:d];
    if ([[model className] isEqualToString:@"WXBaseObject"]) {
        return obj;
    } else {
        if ([obj.result isKindOfClass:[NSArray class]]) {
            return [NSArray modelArrayWithClass:[model class] json:obj.result];
        } else {
            return [model modelWithDictionary:[obj.result modelToJSONObject]];
        }
    }
}

@end
