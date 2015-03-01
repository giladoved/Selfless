//
//  MainViewController.m
//  Selfless
//
//  Created by Alejandro Silveyra on 2/28/15.
//  Copyright (c) 2015 selfles. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.optionIndices = [NSMutableIndexSet indexSet];
    [self.view setBackgroundColor:[UIColor colorWithRed:134.0/255.0 green:226.0/255.0 blue:213.0/255.0 alpha:1.0]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)sidebarButtonPressed:(id)sender {
    NSArray *images = @[
                        [UIImage imageNamed:@"feed"],
                        [UIImage imageNamed:@"profile"],
                        [UIImage imageNamed:@"charity"],
                        [UIImage imageNamed:@"activity"],
                        [UIImage imageNamed:@"settings"],
                        [UIImage imageNamed:@"about"],
                        [UIImage imageNamed:@"logout"]
                        ];
    NSArray *colors = @[
                        [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0],
                        [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0],
                        [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0],
                        [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0],
                        [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0],
                        [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0],
                        [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]
                        ];

    _callout = [[RNFrostedSidebar alloc] initWithImages:images selectedIndices:self.optionIndices borderColors:colors];
    _callout.isSingleSelect = YES;
    _callout.width = 110;
    _callout.borderWidth = 5.0;
    _callout.delegate = self;
    _callout.itemBackgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.6];
    [_callout show];
}


#pragma mark - RNFrostedSidebarDelegate

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    NSLog(@"Tapped item at index %lu",(unsigned long)index);
    [sidebar dismissAnimated:YES completion:nil];
    [self initModViewIndex:index];
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didEnable:(BOOL)itemEnabled itemAtIndex:(NSUInteger)index {
    static int previousIndex;
    NSLog(@"index valye is %d", index);
    if (itemEnabled) {
        [self.optionIndices addIndex:index];
        previousIndex = index;
    }
    else {
        [self.optionIndices removeIndex:index];
    }
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didDismissFromScreenAnimated:(BOOL)animatedYesOrNo{
    
}

- (void)initModViewIndex:(int)index{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [self.modView setAutoresizesSubviews:YES];
    if (index == 0) {
        FeedViewController* newFeed = [FeedViewController new];
        [newFeed.view setFrame:screenRect];
        [self.modView addSubview:newFeed.view];
    }
    else if (index == 1){
        ProfileViewController* newProfile = [ProfileViewController new];
        [newProfile.view setFrame:screenRect];
        [self.modView addSubview:newProfile.view];
    }
    else if (index == 2){
        CharityViewController* newCharity = [CharityViewController new];
        [newCharity.view setFrame:screenRect];
        [self.modView addSubview:newCharity.view];
    }
    else if (index == 3){
        ActivityViewController* newActivity = [ActivityViewController new];
        [newActivity.view setFrame:screenRect];
        [self.modView addSubview:newActivity.view];
    }
    else if (index == 4){
        SettingsViewController* newSettings = [SettingsViewController new];
        [newSettings.view setFrame:screenRect];
        [self.modView addSubview:newSettings.view];
    }
    else if (index == 5){
        AboutViewController* newAbout = [AboutViewController new];
        [newAbout.view setFrame:screenRect];
        [self.modView addSubview:newAbout.view];
    }
}



@end
