//
//  EPPostQueueViewModel.h
//  MVVMExample
//
//  Created by Eli Perkins on 10/21/13.
//  Copyright (c) 2013 Eli Perkins. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACCommand;

@interface EPPostQueueViewModel : NSObject

@property (nonatomic, strong, readonly) NSArray *posts;

@property (nonatomic, strong, readonly) RACCommand *loadPostsCommand;

@property (nonatomic, strong) NSNumber *viewedPostIndex;

@end
