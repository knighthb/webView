//
//  BSMainViewController.h
//  BuildSite
//
//  Created by huangbin on 14-6-13.
//  Copyright (c) 2014年 58. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BSWebView;
@interface BSMainViewController : UIViewController<NSURLConnectionDataDelegate,UIWebViewDelegate>

@property (nonatomic, strong) BSWebView * webView;

-(id) initWithWebView:(BSWebView *) webView;

@end
