//
//  EPPostQueueViewModel.h
//  MVVMExample
//
//  Created by Eli Perkins on 10/21/13.
//  Copyright (c) 2013 One Mighty Roar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPPostQueueViewModel : NSObject

@property (nonatomic, strong) NSMutableArray *posts;

@property (nonatomic, strong) RACCommand *loadPostsCommand;

@property (nonatomic, strong) NSNumber *postsRemaining;

@end
