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

@interface SignUpViewController () <CardIOPaymentViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
    NSArray *listOfCharities;
    BOOL donePressed;
}

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    listOfCharities = @[@"Ma", @"Pa", @"Red Cross"];
    
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    
    if (donePressed) {
        AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        // here i can set accessToken received on previous login
        appDelegate.instagram.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
        appDelegate.instagram.sessionDelegate = self;
        if ([appDelegate.instagram isSessionValid]) {
            [self performSegueWithIdentifier:@"signUpToMain" sender:nil];
        } else {
            [appDelegate.instagram authorize:[NSArray arrayWithObjects:@"comments", @"likes", nil]];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [CardIOUtilities preload];
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

- (IBAction)registerUser:(id)sender {
    donePressed = YES;
    [self login];
}


-(void)login {
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.instagram authorize:[NSArray arrayWithObjects:@"comments", @"likes", nil]];
}

#pragma - IGSessionDelegate

-(void)igDidLogin {
    NSLog(@"Instagram did login");
    // here i can store accessToken
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [[NSUserDefaults standardUserDefaults] setObject:appDelegate.instagram.accessToken forKey:@"accessToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self performSegueWithIdentifier:@"signUpToMain" sender:nil];
}

-(void)igDidNotLogin:(BOOL)cancelled {
    NSLog(@"Instagram did not login");
    NSString* message = nil;
    if (cancelled) {
        message = @"Access cancelled!";
    } else {
        message = @"Access denied!";
    }
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}

-(void)igDidLogout {
    NSLog(@"Instagram did logout");
    // remove the accessToken
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"accessToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)igSessionInvalidated {
    NSLog(@"Instagram session was invalidated");
}





@end
