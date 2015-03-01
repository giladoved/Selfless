//
//  LoginViewController.m
//  Selfless
//
//  Created by Alejandro Silveyra on 2/28/15.
//  Copyright (c) 2015 selfles. All rights reserved.
//

#import "LoginViewController.h"
#import "SignUpViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)singInButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"loginToMain" sender:nil];
}

- (IBAction)signUpButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"loginToSignUp" sender:nil];
    
}
@end
