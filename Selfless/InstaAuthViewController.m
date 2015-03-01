//
//  InstaAuthViewController.m
//  Selfless
//
//  Created by Gilad Oved on 3/1/15.
//  Copyright (c) 2015 selfles. All rights reserved.
//

#import "InstaAuthViewController.h"
#import "MainViewController.h"

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
    [self goToMain];
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
    
    if ([typeOfAuthentication isEqualToString:@"UNSIGNED"])
    {
        // check, if auth was succesfull (check for redirect URL)
        if([urlString hasPrefix: INSTAGRAM_REDIRECT_URI])
        {
            // extract and handle access token
            NSRange range = [urlString rangeOfString: @"#access_token="];
            [self handleAuth: [urlString substringFromIndex: range.location+range.length]];
            return NO;
        }
    }
    else
    {
        if([urlString hasPrefix: INSTAGRAM_REDIRECT_URI])
        {
            // extract and handle code
            NSRange range = [urlString rangeOfString: @"code="];
            [self makePostRequest:[urlString substringFromIndex: range.location+range.length]];
            return NO;
        }
    }
    
    return YES;
    
}

-(void)makePostRequest:(NSString *)code
{
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
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
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
    NSLog(@"successfully logged in with Tocken == %@",dict[@"access_token"]);
    [self.webview stopLoading];
    //Register on the server
    NSString *pushId = [[NSUserDefaults standardUserDefaults] objectForKey:@"pushToken"];
    NSURL *URL = [NSURL URLWithString:@"http://private-anon-d3281e586-selfless.apiary-mock.com/user"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[@{
                          @"insta_id": dict[@"user"][@"id"],
                          @"insta_name": dict[@"user"][@"name"],
                          @"os_type": @"iOS",
                          @"push_id": pushId,
                          @"auth_token": dict[@"access_token"]
                          } dataUsingEncoding:NSUTF8StringEncoding]];
                          
                          NSURLSession *session = [NSURLSession sharedSession];
                          NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                                  completionHandler:
                                                        ^(NSData *data, NSURLResponse *response, NSError *error) {
                                                            
                                                            if (error) {
                                                                // Handle error...
                                                                return;
                                                            }
                                                            
                                                            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                                                                NSLog(@"Response HTTP Status code: %ld\n", (long)[(NSHTTPURLResponse *)response statusCode]);
                                                                NSLog(@"Response HTTP Headers:\n%@\n", [(NSHTTPURLResponse *)response allHeaderFields]);
                                                            }
                                                            
                                                            NSString* body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                            NSLog(@"Response Body:\n%@\n", body);
                                                        }];
                          [task resume];
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
