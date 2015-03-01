//
//  MainViewController.h
//  Selfless
//
//  Created by Alejandro Silveyra on 2/28/15.
//  Copyright (c) 2015 selfles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNFrostedSidebar.h"
#import "FeedViewController.h"
#import "ProfileViewController.h"
#import "CharityViewController.h"
#import "ActivityViewController.h"
#import "SettingsViewController.h"
#import "AboutViewController.h"

@interface MainViewController : UIViewController <RNFrostedSidebarDelegate, UIGestureRecognizerDelegate>

- (IBAction)sidebarButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *sidebarButton;
@property (weak, nonatomic) IBOutlet UIView *modView;
@property (strong, nonatomic) RNFrostedSidebar* callout;
@property (strong, nonatomic) id instagramResult;
@property (strong, nonatomic) NSArray* images;
@property (strong, nonatomic) NSArray* colors;;

@end
