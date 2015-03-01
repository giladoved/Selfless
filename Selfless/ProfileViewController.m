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
    // Do any additional setup after loading the view from its nib.
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"userInfo"];
    NSLog(@"amdin token: %@", userInfo);
    NSString *bio = userInfo[@"bio"];
    NSString *fullname = userInfo[@"full_name"];
    //long *userID = (long)userInfo[@"id"];
    NSString *profilePictureURL = userInfo[@"profile_picture"];
    NSURL *imageUrl = [NSURL URLWithString:profilePictureURL];
    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
    UIImage *profilePicture = [[UIImage alloc] initWithData:imageData];
    NSString *username = userInfo[@"username"];
    //NSString *website = userInfo[@"website"];
    
    _nameLabel.text = fullname;
    _usernameLabel.text = [NSString stringWithFormat:@"@%@",username];
    _bioView.text = [NSString stringWithFormat:@"Bio: %@",bio];
    _imageView.image = profilePicture;
    _imageView.layer.borderWidth = 1.0f;
    _imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _imageView.layer.cornerRadius = 50;
    _imageView.layer.masksToBounds = NO;
    _imageView.clipsToBounds = YES;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://54.67.44.197:3000"]];
    [_webView loadRequest:request];
                                                               

    
}

- (void)viewDidAppear:(BOOL)animated{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
