//
//  EPHTTPClient.m
//  MVVMExample
//
//  Created by Eli Perkins on 10/21/13.
//  Copyright (c) 2013 Eli Perkins. All rights reserved.
//

#import "EPHTTPClient.h"
#import "EPPost.h"

static NSString * const EPAppDotNetAPIBaseURLString = @"https://alpha-api.app.net/";

@implementation EPHTTPClient

+ (instancetype)sharedClient {
    static EPHTTPClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[EPHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:EPAppDotNetAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (NSURLSessionDataTask *)getGlobalTimelinePostsWithSuccess:(EPHTTPClientSuccess)success failure:(EPHTTPClientFailure)failure {
    return [self GET:@"stream/0/posts/stream/global" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *postDictsFromResponse = [responseObject valueForKeyPath:@"data"];
        
        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postDictsFromResponse count]];
        
        for (NSDictionary *postDict in postDictsFromResponse) {
            EPPost *post = [MTLJSONAdapter modelOfClass:[EPPost class] fromJSONDictionary:postDict error:nil];
            [mutablePosts addObject:post];
        }
        
        if (success) {
            success(task, [NSArray arrayWithArray:mutablePosts]);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task, error);
        }
    }];
}

@end
