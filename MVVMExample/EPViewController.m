//
//  EPViewController.m
//  MVVMExample
//
//  Created by Eli Perkins on 10/21/13.
//  Copyright (c) 2013 One Mighty Roar. All rights reserved.
//

#import "EPViewController.h"

#import "EPPost.h"
#import "EPPostQueueViewModel.h"

@interface EPViewController ()

@property (nonatomic, strong) EPPostQueueViewModel *postQueue;

@end

@implementation EPViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.postQueue = [[EPPostQueueViewModel alloc] init];
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
    
    // When the load command is executed, update our view accordingly
    [self.postQueue.loadPostsCommand.executionSignals subscribeNext:^(id signal) {
        [signal subscribeCompleted:^{
            @strongify(self);
            [self.collectionView reloadData];
        }];
    }];

    RACSignal *postsRemainingSignal = [[RACObserve(self.collectionView, contentOffset) map:^(id value) {
        // The value returned from the signal will be an NSValue
        CGPoint offset = [value CGPointValue];
        NSNumber *postsPassed = @(floorf(offset.x/320) + 1);
        
        return @([self.postQueue.posts count] - [postsPassed integerValue]);
    }] distinctUntilChanged];
    
    // Assign the value of the posts remaining to the view model
    [postsRemainingSignal subscribeNext:^(id x) {
        self.postQueue.postsRemaining = x;
    }];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.postQueue.posts count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EPPostCell" forIndexPath:indexPath];
    
    [self customizeCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)customizeCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    EPPost *post = [self.postQueue.posts objectAtIndex:indexPath.row];
    UILabel *label = (UILabel *)[cell viewWithTag:999];
    label.text = post.text;
}


@end
