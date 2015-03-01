//
//  InstaAuthViewController.h
//  Selfless
//
//  Created by Gilad Oved on 3/1/15.
//  Copyright (c) 2015 selfles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Instagram.h"
#import "AppDelegate.h"

@interface InstaAuthViewController : UIViewController <UIWebViewDelegate, IGRequestDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) NSString* tokenCopy;
@property (strong, nonatomic) id result;
@end
