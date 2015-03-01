//
//  InstaLoginViewController.m
//  Selfless
//
//  Created by Gilad Oved on 2/28/15.
//  Copyright (c) 2015 selfles. All rights reserved.
//

#define APP_ID @"dd12116b383d40b8a3cda5f8170cc0e7"


#import "InstaLoginViewController.h"
#import "Instagram.h"
#import "AppDelegate.h"
#import "MainViewController.h"

@interface InstaLoginViewController ()

@end

@implementation InstaLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    // here i can set accessToken received on previous login
    appDelegate.instagram.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    appDelegate.instagram.sessionDelegate = self;
    if ([appDelegate.instagram isSessionValid]) {
        MainViewController *mainVC = [[MainViewController alloc]
                                      initWithNibName:@"MainViewController" bundle:nil];
        [self presentViewController:mainVC animated:YES completion:nil];
    } else {
        [appDelegate.instagram authorize:[NSArray arrayWithObjects:@"comments", @"likes", nil]];
    }
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
    
    MainViewController *mainVC = [[MainViewController alloc]
                                  initWithNibName:@"MainViewController" bundle:nil];
    [self presentViewController:mainVC animated:YES completion:nil];
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
