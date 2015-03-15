//
//  BSCacheStrategy.m
//  BuildSite
//
//  Created by huangbin on 14-6-13.
//  Copyright (c) 2014年 58. All rights reserved.
//

#import "BSCacheStrategy.h"

@implementation BSCacheStrategy
@synthesize next;
@synthesize responseDic;

-(id) initWithNext:(BSCacheStrategy *) aNext{
    if (self = [super init]) {
        self.next = aNext;
    }
    return self;
}

-(NSCachedURLResponse *) handleRequst:(NSURLRequest *)request{
    return [self.next handleRequst:request];
}
@end
