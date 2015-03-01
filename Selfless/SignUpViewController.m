//
//  SignUpViewController.m
//  Selfless
//
//  Created by Alejandro Silveyra on 2/28/15.
//  Copyright (c) 2015 selfles. All rights reserved.
//

#import "SignUpViewController.h"
#import "CardIO.h"
#import "AppDelegate.h"
#import "MainViewController.h"

@interface SignUpViewController () <CardIOPaymentViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
    NSArray *listOfCharities;
    BOOL donePressed;
}

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    listOfCharities = @[
                        @"Wounded Warrior Project",
                        @"Heifer Project International",
                        @"American Red Cross",
                        @"Doctors Without Borders, USA",
                        @"ALSAC - St. Jude Children’s Research Hospital",
                        @"World Vision",
                        @"DAV (Disabled American Veterans) Charitable Service Trust",
                        @"Save the Children",
                        @"Samaritan Purse",
                        @"United States Fund for UNICEF"];
    
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    
    if (donePressed) {
        AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        // here i can set accessToken received on previous login
        appDelegate.instagram.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
        appDelegate.instagram.sessionDelegate = self;
        if ([appDelegate.instagram isSessionValid]) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MainViewController *vc = (MainViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
            [self presentViewController:vc animated:YES completion:nil];
        } else {
            [appDelegate.instagram authorize:[NSArray arrayWithObjects:@"comments", @"likes", nil]];
        }
    }
    [_blurView setImage:[UIImage imageNamed:@"main_background_blur.jpg"]];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [CardIOUtilities preload];
}

#pragma mark - UIPickerView

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = @"Preferred Charity";
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return attString;
    
}

#pragma mark - User Actions

- (void)scanCardClicked:(id)sender {
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:scanViewController animated:YES completion:nil];
}

#pragma mark - CardIOPaymentViewControllerDelegate

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSLog(@"Scan succeeded with info: %@", info);
    // Do whatever needs to be done to deliver the purchased items.
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.creditCardLbl.text = [NSString stringWithFormat:@"Received card info. Number: %@, expiry: %02lu/%lu, cvv: %@.", info.redactedCardNumber, (unsigned long)info.expiryMonth, (unsigned long)info.expiryYear, info.cvv];
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSLog(@"User cancelled scan");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return listOfCharities.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return listOfCharities[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
}


@end
