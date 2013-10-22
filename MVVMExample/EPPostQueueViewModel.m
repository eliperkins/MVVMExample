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
        
        self.loadPostsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [[EPHTTPClient sharedClient] getGlobalTimelinePostsWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
                    [self.posts addObjectsFromArray:responseObject];
                    [subscriber sendNext:responseObject];
                    [subscriber sendCompleted];
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    [subscriber sendError:error];
                }];

                return nil;
            }];
        }];
        
        self.postsRemainingSubject = [RACSubject subject];
        
        [self.postsRemainingSubject subscribeNext:^(id x) {
            if ([x integerValue] < 4) {
                [self.loadPostsCommand execute:nil];
            }
        }];
    }
    return self;
}


@end
