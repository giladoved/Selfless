//
//  MainViewController.h
//  Selfless
//
//  Created by Alejandro Silveyra on 2/28/15.
//  Copyright (c) 2015 selfles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNFrostedSidebar.h"

@interface MainViewController : UIViewController <RNFrostedSidebarDelegate>

- (IBAction)sidebarButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *sidebarButton;
@property (strong, nonatomic) RNFrostedSidebar* callout;
@end
