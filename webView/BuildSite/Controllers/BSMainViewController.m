//
//  BSMainViewController.m
//  BuildSite
//
//  Created by huangbin on 14-6-13.
//  Copyright (c) 2014年 58. All rights reserved.
//

#import "BSMainViewController.h"
#import "BSWebView.h"
#import "BSPlistUtil.h"

@interface BSMainViewController ()
{
    NSURLConnection * _conn;
}

@end

@implementation BSMainViewController

- (id)initWithWebView:(BSWebView *) webView
{
    self = [super init];
    if (self) {
        self.webView = webView;
        self.webView.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    NSString * urlStr = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"URLPath"];
    NSString * portalID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"PortalID"];
    NSString * appID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"AppID"];
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/appload/%@",Base_URL,appID]];
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10];
    self.webView.webViewRequest = request;
    [self.webView.contentView loadRequest:request];
    [self.view addSubview: self.webView];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"hahaha didReceiveResponse");
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"hahaha didReceiveData:%@",data);
//    NSCachedURLResponse * response = [NSCachedURLResponse alloc] init
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"opps ..");
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connection finished.................");
    _conn = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
 
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"webView shouldStartLoadWithRequest");
    NSHTTPURLResponse * response = nil;
    if ([request.URL.absoluteString hasPrefix:@"http://"]) {
        NSMutableURLRequest * mutRequest = [[NSMutableURLRequest alloc] initWithURL:request.URL];
        [mutRequest addValue:Conn_Indentifier forHTTPHeaderField:Conn_Indentifier_Header];
        NSData * data = [NSURLConnection sendSynchronousRequest:mutRequest returningResponse:&response error:nil];
        if (response.statusCode == 404) {
            NSLog(@"404 啦!");
            return NO;
        }
        return YES;
    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webView webViewDidStartLoad");
    [self.webView showLoadingView];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webView webViewDidFinishLoad");
    [self.webView hideLoadingView];
    [self.webView hideErrorView];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"webView didFailLoadWithError");
    [self.webView showErrorView];
}



@end
