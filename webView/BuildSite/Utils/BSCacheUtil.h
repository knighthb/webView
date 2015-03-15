//
//  BSCacheUtil.h
//  BuildSite
//
//  Created by huangbin on 14-6-17.
//  Copyright (c) 2014年 58. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BSCacheUtil;
@class BSCacheFromLocal;
@class BSResouceFromServer;
#import "BSCacheStrategy.h"

static BSCacheUtil * instance;
@interface BSCacheUtil : NSObject

@property (nonatomic , strong) BSCacheFromLocal * fromLocal;
@property (nonatomic , strong) BSResouceFromServer * fromServer;

+(BSCacheUtil *) sharedInstance;

-(NSCachedURLResponse *) handleRequest:(NSURLRequest * ) request;

-(float) versionFromUrl:(NSString *) url;

-(NSString *) keyFromUrl:(NSString *) url;

-(NSString *) pathFromUrl:(NSString *) url;

-(BOOL) hasConnIndentifierHeader:(NSURLRequest *) request;

-(BOOL) hasCacheIndentifier:(NSString *) url;

-(id) init;

-(BOOL) setMutableRequestHeaderField:(NSString *) key
                               value:(NSString *) value
                             request:(NSMutableURLRequest *) request;


@end
