//
//  BSWebView.h
//  BuildSite
//
//  Created by huangbin on 14-6-13.
//  Copyright (c) 2014年 58. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSErrorView.h"

@interface BSWebView : UIWebView
{
    BOOL _isLoadingViewShowed;
    BOOL _isErrorViewShowed;
}
@property (nonatomic, strong) NSString * key;
@property (nonatomic, strong) NSURLRequest * webViewRequest;
@property (nonatomic, strong) UIWebView * loadingView;
@property (nonatomic, strong) UIWebView * errorView;
@property (nonatomic, strong) UIView * buttonBar;
@property (nonatomic, strong) UIButton * backButton;
@property (nonatomic, strong) UIButton * forwardButton;
@property (nonatomic, strong) UIButton * phoneButton;
@property (nonatomic, strong) UIButton * refreshButton;
@property (nonatomic, strong) UIButton * homeButton;
@property (nonatomic, strong) UIWebView * contentView;
//-(id) initWithFrame:(CGRect)frame request:(NSURLRequest *) request;
-(void) reloadRequest:(UITapGestureRecognizer *) recognizer;
-(void) showLoadingView;
-(void) hideLoadingView;
-(void) showErrorView;
-(void) hideErrorView;
@end
