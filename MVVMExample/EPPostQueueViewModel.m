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
        
        @weakify(self);
        
        self.loadPostsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            RACSignal *networkSignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {\
                [[EPHTTPClient sharedClient] getGlobalTimelinePostsWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
                    @strongify(self);
                    
                    [self.posts addObjectsFromArray:responseObject];
                    [subscriber sendNext:responseObject];
                    [subscriber sendCompleted];
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    [subscriber sendError:error];
                }];

                return nil;
            }] setNameWithFormat:@"EPPostQueueViewModel loadPostsCommandSignal"];
            
            return networkSignal;
        }];
        
        // Observe how many posts remain and load more when less than 4
        [RACObserve(self, postsRemaining) subscribeNext:^(id x) {
            if ([x integerValue] < 4) {
                [self.loadPostsCommand execute:nil];
            }
        }];
    }
    return self;
}

@end
