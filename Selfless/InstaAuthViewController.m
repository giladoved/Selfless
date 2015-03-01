//
//  InstaAuthViewController.m
//  Selfless
//
//  Created by Gilad Oved on 3/1/15.
//  Copyright (c) 2015 selfles. All rights reserved.
//

#import "InstaAuthViewController.h"
#import "MainViewController.h"
#import "AFHTTPRequestOperationManager.h"

#define INSTAGRAM_AUTHURL                               @"https://api.instagram.com/oauth/authorize/"
#define INSTAGRAM_APIURl                                @"https://api.instagram.com/v1/users/"
#define INSTAGRAM_CLIENT_ID                             @"8d257fe4486d4b1c8722dd6ef51665ff"
#define INSTAGRAM_CLIENTSERCRET                         @"983eeb9c353f4e46b403f570533db5a6"
#define INSTAGRAM_REDIRECT_URI                          @"http://localhost"
#define INSTAGRAM_ACCESS_TOKEN                          @"access_token"
#define INSTAGRAM_SCOPE                                 @"likes+comments+relationships"
#define typeOfAuthentication                            @"SIGNED"

@interface InstaAuthViewController ()

@end

@implementation InstaAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString* authURL = nil;
    
    if ([typeOfAuthentication isEqualToString:@"UNSIGNED"])
    {
        authURL = [NSString stringWithFormat: @"%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&DEBUG=True",
                   INSTAGRAM_AUTHURL,
                   INSTAGRAM_CLIENT_ID,
                   INSTAGRAM_REDIRECT_URI,
                   INSTAGRAM_SCOPE];
        
    }
    else
    {
        authURL = [NSString stringWithFormat: @"%@?client_id=%@&redirect_uri=%@&response_type=code&scope=%@&DEBUG=True",
                   INSTAGRAM_AUTHURL,
                   INSTAGRAM_CLIENT_ID,
                   INSTAGRAM_REDIRECT_URI,
                   INSTAGRAM_SCOPE];
    }
    self.webview.scrollView.bounces = YES;
    self.webview.scrollView.bouncesZoom = YES;
    self.webview.scrollView.scrollEnabled = YES;
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:authURL]]];
    [self.webview setDelegate:self];
}


#pragma mark -
#pragma mark delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    return [self checkRequestForCallbackURL:request];
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    /*[self.activityIndicator startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.webview.layer removeAllAnimations];
    [UIView animateWithDuration: 0.1 animations:^{
        //loginWebView.alpha = 0.2;
    }];*/
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    /*[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.activityIndicator stopAnimating];
    [self.webview.layer removeAllAnimations];
    self.webview.userInteractionEnabled = YES;
    [UIView animateWithDuration: 0.1 animations:^{
        //loginWebView.alpha = 1.0;
    }];*/
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self webViewDidFinishLoad:webView];
}

- (BOOL) checkRequestForCallbackURL:(NSURLRequest*) request
{
    NSString* urlString = [[request URL] absoluteString];
    NSLog(@"urlsTR: %@", urlString);
    
    if ([typeOfAuthentication isEqualToString:@"UNSIGNED"])
    {
        // check, if auth was succesfull (check for redirect URL)
        if([urlString hasPrefix: INSTAGRAM_REDIRECT_URI])
        {
            NSRange range = [urlString rangeOfString: @"code="];
            [self makePostRequest:[urlString substringFromIndex: range.location+range.length]];
            return NO;
        }
    }
    else
    {
        if([urlString hasPrefix: INSTAGRAM_REDIRECT_URI])
        {
            NSRange range = [urlString rangeOfString: @"code="];
            [self makePostRequest:[urlString substringFromIndex: range.location+range.length]];
            return NO;
        }
    }
    
    return YES;
    
}

-(void)makePostRequest:(NSString *)code
{
    /*NSString *post = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@",INSTAGRAM_CLIENT_ID,INSTAGRAM_CLIENTSERCRET,INSTAGRAM_REDIRECT_URI,code];
    NSMutableURLRequest *requestData = [NSMutableURLRequest requestWithURL:
                                        [NSURL URLWithString:@"https://api.instagram.com/oauth/access_token"]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{
                             @"insta_id": dict[@"user"][@"id"],
                             @"insta_name": dict[@"user"][@"name"],
                             @"os_type": @"iOS",
                             @"push_id": pushId,
                             @"auth_token": dict[@"access_token"]
                             };
    [manager POST:@"http://private-anon-d3281e586-selfless.apiary-mock.com/user" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];*/
    
    
    
    
    NSString *post = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@",INSTAGRAM_CLIENT_ID,INSTAGRAM_CLIENTSERCRET,INSTAGRAM_REDIRECT_URI,code];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *requestData = [NSMutableURLRequest requestWithURL:
                                        [NSURL URLWithString:@"https://api.instagram.com/oauth/access_token"]];
    [requestData setHTTPMethod:@"POST"];
    [requestData setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [requestData setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [requestData setHTTPBody:postData];
    
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:requestData returningResponse:&response error:&requestError];
    NSLog(@"responsedata: %@", responseData);
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONWritingPrettyPrinted error:nil];
    //NSLog(@"PRINTING DICTIONARY %@",dict);
    [self handleAuth:dict];
    
}

-(void) goToMain {
    //NSString *strMethod=[NSString stringWithFormat:@"users/self/feed?access_token=%@",_tokenCopy];
    //AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    //[appDelegate.instagram requestWithMethodName:strMethod params:nil httpMethod:@"GET" delegate:self];
    [self performSegueWithIdentifier:@"registerToMain" sender:nil];

}

- (void) handleAuth: (NSDictionary*) dict
{
    NSLog(@"DIIIIIC:%@", dict);
    NSLog(@"successfully logged in with Tocken == %@",dict[@"access_token"]);
    NSString *admin_token =dict[@"access_token"];
    [[NSUserDefaults standardUserDefaults] setObject:admin_token forKey:@"admin_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.webview stopLoading];
    NSString *pushId = [[NSUserDefaults standardUserDefaults] objectForKey:@"pushToken"];
    NSLog(@"user: %@", dict[@"user"]);
    NSLog(@"user: %@", dict[@"access_token"]);
    NSLog(@"user: %@", dict[@"user"][@"id"]);
    NSLog(@"user: %@", dict[@"user"][@"name"]);

    //Register on the server
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{
                             @"insta_id": dict[@"user"][@"id"],
                             @"insta_name": dict[@"user"][@"username"],
                             @"os_type": @"iOS",
                             @"push_id": pushId,
                             @"auth_token": dict[@"access_token"]
                             };
    [manager POST:@"http://54.67.44.197:3000/v1/user" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [self goToMain];
}

#pragma mark - IGRequestDelegate

- (void)request:(IGRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Instagram did fail: %@", error);
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)request:(IGRequest *)request didLoad:(id)result {
    //NSLog(@"Instagram did load: %@", result);
    _result = result;
    //self.data = (NSArray*)[result objectForKey:@"data"];
    //[self.tableView reloadData];
    MainViewController *mainVC = [[MainViewController alloc] initWithNibName:nil bundle:nil];
    //[self.navigationController pushViewController:mainVC animated:YES];
    
    [self performSegueWithIdentifier:@"registerToMain" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    MainViewController* vc = (MainViewController*)segue.destinationViewController;
    vc.instagramResult = _result;
}

@end
