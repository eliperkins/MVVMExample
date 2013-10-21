//
//  EPHTTPClient.h
//  MVVMExample
//
//  Created by Eli Perkins on 10/21/13.
//  Copyright (c) 2013 One Mighty Roar. All rights reserved.
//

typedef void (^EPHTTPClientSuccess)(NSURLSessionDataTask *task, id responseObject);
typedef void (^EPHTTPClientFailure)(NSURLSessionDataTask *task, NSError *error);

@interface EPHTTPClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

- (void)getGlobalTimelinePostsWithSuccess:(EPHTTPClientSuccess)success failure:(EPHTTPClientFailure)failure;

@end
