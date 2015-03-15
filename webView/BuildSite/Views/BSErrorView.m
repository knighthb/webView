//
//  BSErrorView.m
//  BuildSite
//
//  Created by jianzhan on 14-7-25.
//  Copyright (c) 2014年 58. All rights reserved.
//

#import "BSErrorView.h"

@implementation BSErrorView

-(id) initWithFrame:(CGRect)frame delegate:(id)delegate{
    self = [super initWithFrame:frame];
    if (self) {
        self.webViewDelegate = delegate;
        UITapGestureRecognizer * tapGestureRec = [[UITapGestureRecognizer alloc] initWithTarget:self.webViewDelegate action:@selector(reloadRequest:)];
        tapGestureRec.delegate = self;
        [self addGestureRecognizer:tapGestureRec];
    }
    return self;
}

-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}



@end
