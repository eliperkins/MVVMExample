//
//  EPViewController.m
//  MVVMExample
//
//  Created by Eli Perkins on 10/21/13.
//  Copyright (c) 2013 Eli Perkins. All rights reserved.
//

#import "EPViewController.h"

#import "EPPost.h"
#import "EPPostQueueViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface EPViewController ()

@property (nonatomic, strong) EPPostQueueViewModel *viewModel;

@end

@implementation EPViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.viewModel = [[EPPostQueueViewModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    @weakify(self);
    [RACObserve(self.viewModel, posts) subscribeNext:^(id _) {
        @strongify(self);
        [self.collectionView reloadData];
    }];
    
    RACSignal *indexSignal = [[RACObserve(self.collectionView, contentOffset)
        map:^(NSValue *value) {
            CGPoint offset = value.CGPointValue;
            NSNumber *postsPassed = @(floorf(offset.x/320) + 1);
            
            return postsPassed;
        }]
        distinctUntilChanged];
    
    RAC(self.viewModel, viewedPostIndex) = indexSignal;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.viewModel.posts count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EPPostCell" forIndexPath:indexPath];
    
    [self customizeCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)customizeCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    EPPost *post = [self.viewModel.posts objectAtIndex:indexPath.row];
    // Don't judge me...
    UILabel *label = (UILabel *)[cell viewWithTag:999];
    label.text = post.text;
}

@end
