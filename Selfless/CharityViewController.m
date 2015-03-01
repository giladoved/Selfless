//
//  CharityViewController.m
//  Selfless
//
//  Created by Alejandro Silveyra on 3/1/15.
//  Copyright (c) 2015 selfles. All rights reserved.
//

#import "CharityViewController.h"
#import "AFHTTPRequestOperationManager.h"

@interface CharityViewController () {
    NSString *admin_token;
}

@end

@implementation CharityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    admin_token = [[NSUserDefaults standardUserDefaults] stringForKey:@"admin_token"];
    NSLog(@"amdin token: %@", admin_token);
    //Register on the server
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{
                             @"admin_token":admin_token
                             };
    [manager GET:@"http://54.67.44.197:3000/v1/charities" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        //[self getCharity:<#(NSInteger)#>]
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}

-(void) getCharity:(NSInteger) charityID {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlStr = [NSString stringWithFormat:@"http://54.67.44.197:3000/v1/charity/%d/%@", charityID, admin_token];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
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
