//
//  EPPost.h
//  MVVMExample
//
//  Created by Eli Perkins on 10/21/13.
//  Copyright (c) 2013 One Mighty Roar. All rights reserved.
//

@interface EPPost : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *text;

@end
