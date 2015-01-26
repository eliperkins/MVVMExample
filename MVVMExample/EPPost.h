//
//  EPPost.h
//  MVVMExample
//
//  Created by Eli Perkins on 10/21/13.
//  Copyright (c) 2013 Eli Perkins. All rights reserved.
//
#import <Mantle/Mantle.h>

@interface EPPost : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *text;

@end
