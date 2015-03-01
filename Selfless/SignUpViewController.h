//
//  SignUpViewController.h
//  Selfless
//
//  Created by Alejandro Silveyra on 2/28/15.
//  Copyright (c) 2015 selfles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardIOPaymentViewControllerDelegate.h"
#import "Instagram.h"
#import "JCRBlurView.h"

@interface SignUpViewController : UIViewController <IGSessionDelegate>

- (IBAction)scanCardClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *creditCardLbl;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
- (IBAction)registerUser:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *blurView;

@end
