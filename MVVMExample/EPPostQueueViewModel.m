//
//  EPPostQueueViewModel.m
//  MVVMExample
//
//  Created by Eli Perkins on 10/21/13.
//  Copyright (c) 2013 One Mighty Roar. All rights reserved.
//

#import "EPPostQueueViewModel.h"

#import "EPHTTPClient.h"

@implementation EPPostQueueViewModel

- (id)init {
    self = [super init];
    if (self) {
        self.posts = [[NSMutableArray alloc] init];
    }
    return self;
}

- (RACCommand *)loadPostsCommand {
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal startEagerlyWithScheduler:[RACScheduler scheduler] block:^(id<RACSubscriber> subscriber) {
           [[EPHTTPClient sharedClient] getGlobalTimelinePostsWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
               [self.posts addObjectsFromArray:responseObject];
               [subscriber sendNext:responseObject];
               [subscriber sendCompleted];
           } failure:^(NSURLSessionDataTask *task, NSError *error) {
               [subscriber sendError:error];
           }];
        }];
    }];
}

@end
