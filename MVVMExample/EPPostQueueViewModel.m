//
//  EPPostQueueViewModel.m
//  MVVMExample
//
//  Created by Eli Perkins on 10/21/13.
//  Copyright (c) 2013 Eli Perkins. All rights reserved.
//

#import "EPPostQueueViewModel.h"
#import "EPHTTPClient.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation EPPostQueueViewModel

- (id)init {
    self = [super init];
    if (self) {
        _loadPostsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {\
                NSURLSessionTask *timelineTask = [[EPHTTPClient sharedClient] getGlobalTimelinePostsWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
                    [subscriber sendNext:responseObject];
                    [subscriber sendCompleted];
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    [subscriber sendError:error];
                }];

                return [RACDisposable disposableWithBlock:^{
                    [timelineTask cancel];
                }];
            }] setNameWithFormat:@"[EPPostQueueViewModel -loadPostsCommandSignal]"];
        }];
        
        RAC(self, posts) = [[self.loadPostsCommand.executionSignals
            flatten]
            scanWithStart:@[] reduce:^(NSArray *running, NSArray *next) {
                return [running arrayByAddingObjectsFromArray:next];
            }];
        
        @weakify(self);
        RACSignal *loadPostsSignal = [RACObserve(self, viewedPostIndex) filter:^BOOL(NSNumber *index) {
            @strongify(self);
            return index.integerValue > @(self.posts.count - 4).integerValue;
        }];
        
        [self.loadPostsCommand rac_liftSelector:@selector(execute:) withSignals:loadPostsSignal, nil];
    }
    return self;
}

@end
