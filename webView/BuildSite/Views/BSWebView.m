//
//  BSWebView.m
//  BuildSite
//
//  Created by huangbin on 14-6-13.
//  Copyright (c) 2014年 58. All rights reserved.
//

#import "BSWebView.h"

@implementation BSWebView

-(id) initWithFrame:(CGRect)frame
{
    CGRect webViewFrame = CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height-60);
    if (self = [super initWithFrame:frame]) {
        self.contentView = [[UIWebView alloc] initWithFrame:webViewFrame];
        [self addSubview:self.contentView];
        CGRect newFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.loadingView = [[UIWebView alloc] initWithFrame:newFrame];
        NSBundle * bundle = [NSBundle mainBundle];
        NSString * loadViewPath = [[bundle resourcePath] stringByAppendingPathComponent:@"loading.html"];
        [self.loadingView loadHTMLString:[NSString stringWithContentsOfFile:loadViewPath encoding:NSUTF8StringEncoding error:nil] baseURL:[NSURL fileURLWithPath:[bundle bundlePath]]];
        self.errorView = [[BSErrorView alloc] initWithFrame:newFrame delegate:self];
        NSString * errorViewPath = [[bundle resourcePath] stringByAppendingPathComponent:@"error.html"];
        [self.errorView loadHTMLString: [NSString stringWithContentsOfFile:errorViewPath encoding:NSUTF8StringEncoding error:nil] baseURL:[NSURL fileURLWithPath:[bundle bundlePath]]];
        _isErrorViewShowed = NO;
        _isLoadingViewShowed = NO;
        self.buttonBar =  [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-60, frame.size.width, 40)];
        self.buttonBar.backgroundColor = HexToUIColorRGB(0xf7f8fa);
        self.backButton = [self createButtonWithFrame:[self makeCGrectFrameWithPosition:1] imageName:@"goback" action:@selector(goBack:)];
        self.backButton.tag =  1000;
        self.forwardButton = [self createButtonWithFrame:[self makeCGrectFrameWithPosition:2] imageName:@"goforward" action:@selector(goForward:)];
        self.forwardButton.tag = 1001;
        self.phoneButton = [self createButtonWithFrame:[self makeCGrectFrameWithPosition:3] imageName:@"phone" action:@selector(dailPhone:)];
        self.phoneButton.tag = 1002;
        self.refreshButton = [self createButtonWithFrame:[self makeCGrectFrameWithPosition:4] imageName:@"refresh" action:@selector(refresh:)];
        self.refreshButton.tag = 1003;
        self.homeButton = [self createButtonWithFrame:[self makeCGrectFrameWithPosition:5] imageName:@"home" action:@selector(goHome:)];
        self.homeButton.tag = 1004;
        [self.buttonBar addSubview:self.backButton];
        [self.buttonBar addSubview:self.forwardButton];
        [self.buttonBar addSubview:self.phoneButton];
        [self.buttonBar addSubview:self.refreshButton];
        [self.buttonBar addSubview:self.homeButton];
        [self addSubview:self.buttonBar];
    }
    return self;
}

- (void) setButtunState:(UIButton *) button name:(NSString *) name{
    if ([self canGoBack] || [self canGoForward]) {
       [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_enable",name]] forState:UIControlStateNormal];
    }else{
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_disable",name]] forState:UIControlStateNormal];
    }
}

-(CGRect) makeCGrectFrameWithPosition:(int) pos{
    CGRect frame = CGRectMake((pos-1)*104/2+30, 0, 104/2, 40);
    return frame;
}

-(UIButton *) createButtonWithFrame:(CGRect) frame
                          imageName:(NSString *) name
                              action:(SEL) selector
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_enable",name]] forState:UIControlStateNormal];
    if ([name isEqualToString:@"goback" ] || [name isEqualToString:@"goforward"]) {
        [self setButtunState:button name:name];
         [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_disable",name]] forState:UIControlStateHighlighted];
    }
    [button setImageEdgeInsets:UIEdgeInsetsMake(15/2.0f,27/2.0f,15/2.0f,27/2.0f)];
    [button addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(IBAction)touchDown:(UIButton *)button{
    [button setBackgroundColor:HexToUIColorRGB(0xe6e8eb)];
}


-(IBAction) goBack:(UIButton *) button{
    [button setBackgroundColor:HexToUIColorRGB(0xf7f8fa)];
    if ([self.contentView canGoBack]) {
        [self.contentView goBack];
    }
}

-(IBAction) goForward:(UIButton *)button{
    [button setBackgroundColor:HexToUIColorRGB(0xf7f8fa)];
    if ([self.contentView canGoForward]) {
        [self.contentView goForward];
    }
}

-(IBAction) dailPhone:(UIButton *)button{
    [button setBackgroundColor:HexToUIColorRGB(0xf7f8fa)];
    NSString * phoneNum = [[NSUserDefaults standardUserDefaults] objectForKey:self.key];
    if ( ![phoneNum isEqualToString:@""]) {
        NSString * tel = [NSString stringWithFormat:@"tel://%@",phoneNum];
        UIWebView * phoneView = [[UIWebView alloc] init];
        phoneView.backgroundColor = [UIColor redColor];
        [phoneView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:tel]]];
        [self addSubview:phoneView];
    }
}

-(IBAction) refresh:(UIButton *)button{
    [button setBackgroundColor:HexToUIColorRGB(0xf7f8fa)];
    [self.contentView reload];
}


-(IBAction) goHome:(UIButton *) button
{
    [button setBackgroundColor:HexToUIColorRGB(0xf7f8fa)];
    [self hideErrorView];
    [self hideLoadingView];
    [self.contentView loadRequest:self.webViewRequest];
}

-(void) showLoadingView
{
    if ( _isLoadingViewShowed == NO ) {
        [self addSubview:self.loadingView];
        _isLoadingViewShowed = YES;
    }
    if ( _isErrorViewShowed == YES ) {
        [self.errorView removeFromSuperview];
        _isErrorViewShowed =  NO;
    }
}

-(void) hideLoadingView
{
    if (_isLoadingViewShowed == YES) {
         [self.loadingView removeFromSuperview];
        _isLoadingViewShowed = NO;
    }
}

-(void) showErrorView
{
    if (_isErrorViewShowed == NO) {
        [self addSubview:self.errorView];
        _isErrorViewShowed = YES;
    }
    
}

-(void) hideErrorView
{
    if (_isErrorViewShowed == YES) {
        [self.errorView removeFromSuperview];
        _isErrorViewShowed = NO;
    }

}

-(void) reloadRequest:(UITapGestureRecognizer *) recognizer
{
    NSLog(@"tap on the screen");
    [self hideErrorView];
    [self.contentView loadRequest:self.webViewRequest];
}
@end
