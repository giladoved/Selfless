//
//  InstaAuthViewController.h
//  Selfless
//
//  Created by Gilad Oved on 3/1/15.
//  Copyright (c) 2015 selfles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstaAuthViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@end
