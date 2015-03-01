//
//  ProfileViewController.m
//  Selfless
//
//  Created by Alejandro Silveyra on 3/1/15.
//  Copyright (c) 2015 selfles. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"userInfo"];
    NSLog(@"amdin token: %@", userInfo);
    NSString *bio = userInfo[@"bio"];
    NSString *fullname = userInfo[@"full_name"];
    long *userID = (long)userInfo[@"id"];
    NSString *profilePictureURL = userInfo[@"profile_picture"];
    NSURL *imageUrl = [NSURL URLWithString:profilePictureURL];
    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
    UIImage *profilePicture = [[UIImage alloc] initWithData:imageData];
    NSString *username = userInfo[@"username"];
    NSString *website = userInfo[@"website"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
