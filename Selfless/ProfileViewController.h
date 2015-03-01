//
//  ProfileViewController.h
//  Selfless
//
//  Created by Alejandro Silveyra on 3/1/15.
//  Copyright (c) 2015 selfles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMSimpleLineGraphView.h"

@interface ProfileViewController : UIViewController <BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>
@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *graphView;

@end
