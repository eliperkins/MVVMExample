//
//  EPHTTPClient.h
//  MVVMExample
//
//  Created by Eli Perkins on 10/21/13.
//  Copyright (c) 2013 Eli Perkins. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef void (^EPHTTPClientSuccess)(NSURLSessionDataTask *task, id responseObject);
typedef void (^EPHTTPClientFailure)(NSURLSessionDataTask *task, NSError *error);

@interface EPHTTPClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

- (NSURLSessionDataTask *)getGlobalTimelinePostsWithSuccess:(EPHTTPClientSuccess)success failure:(EPHTTPClientFailure)failure;

@end
