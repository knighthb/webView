//
//  BSErrorView.h
//  BuildSite
//
//  Created by jianzhan on 14-7-25.
//  Copyright (c) 2014年 58. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSErrorView : UIWebView<UIGestureRecognizerDelegate>
@property (nonatomic, strong) id webViewDelegate;
-(id) initWithFrame:(CGRect)frame delegate:(id) delegate;
@end
