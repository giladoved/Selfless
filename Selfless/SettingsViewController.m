//
//  SettingsViewController.m
//  Selfless
//
//  Created by Alejandro Silveyra on 3/1/15.
//  Copyright (c) 2015 selfles. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"userInfo"];
    NSString *username = [NSString stringWithFormat:@"@%@", userInfo[@"username"]];
    NSLog(@"username: %@", username);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
