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
    //NSLog(@"FINAL RESULTS ARE %@",_instagramResult);
    self.optionIndices = [NSMutableIndexSet indexSet];
    [_optionIndices addIndex:5];

    [self.view setBackgroundColor:[UIColor colorWithRed:134.0/255.0 green:226.0/255.0 blue:213.0/255.0 alpha:1.0]];


}

- (void)viewDidAppear:(BOOL)animated{
    CGRect screenRect = [[UIScreen mainScreen] bounds];

    AboutViewController* newAbout = [AboutViewController new];
    [newAbout.view setFrame:screenRect];
    [self.modView addSubview:newAbout.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)sidebarButtonPressed:(id)sender {
    _images = @[
                        [UIImage imageNamed:@"feed_white"],
                        [UIImage imageNamed:@"profile_white"],
                        [UIImage imageNamed:@"charity_white"],
                        [UIImage imageNamed:@"activity_white"],
                        [UIImage imageNamed:@"settings_white"],
                        [UIImage imageNamed:@"about_white"],
                        [UIImage imageNamed:@"logout_white"]
                        ];
    _colors = @[
                        [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0],
                        [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0],
                        [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0],
                        [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0],
                        [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0],
                        [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0],
                        [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]
                        ];



    
    _callout = [[RNFrostedSidebar alloc] initWithImages:_images selectedIndices:self.optionIndices borderColors:_colors];
    _callout.isSingleSelect = YES;
    _callout.width = 110;
    _callout.borderWidth = 5.0;
    _callout.delegate = self;
    _callout.itemBackgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
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
    [_optionIndices removeAllIndexes];
    [_optionIndices addIndex:index];
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didDismissFromScreenAnimated:(BOOL)animatedYesOrNo{
    _callout = [[RNFrostedSidebar alloc] initWithImages:_images selectedIndices:_optionIndices borderColors:_colors];
    _callout.isSingleSelect = YES;
    _callout.width = 110;
    _callout.borderWidth = 5.0;
    _callout.delegate = self;
    _callout.itemBackgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
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
