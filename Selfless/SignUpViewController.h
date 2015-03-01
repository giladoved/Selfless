//
//  SignUpViewController.h
//  Selfless
//
//  Created by Alejandro Silveyra on 2/28/15.
//  Copyright (c) 2015 selfles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardIOPaymentViewControllerDelegate.h"

@interface SignUpViewController : UIViewController

- (IBAction)scanCardClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *creditCardLbl;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end
