//
//  ProfileViewController.h
//  Selfless
//
//  Created by Alejandro Silveyra on 3/1/15.
//  Copyright (c) 2015 selfles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController
@property int temp;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextView *bioView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
