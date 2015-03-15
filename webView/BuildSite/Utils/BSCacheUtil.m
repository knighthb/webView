//
//  BSCacheUtil.m
//  BuildSite
//
//  Created by huangbin on 14-6-17.
//  Copyright (c) 2014年 58. All rights reserved.
//

#import "BSCacheUtil.h"
#import "BSCacheFromLocal.h"
#import "BSResouceFromServer.h"
#import "BSFileManagerUtil.h"

@implementation BSCacheUtil
@synthesize fromLocal;
@synthesize fromServer;

+(BSCacheUtil *) sharedInstance
{
    @synchronized(self){
        if (instance == nil) {
            instance = [[BSCacheUtil alloc] init];
        }
    }
    return instance;
}

-(id) init
{
    if (self = [super init]) {
        if (!self.fromServer) {
            self.fromServer = [[BSResouceFromServer alloc] initWithNext:nil];
        }

        if (!self.fromLocal) {
            self.fromLocal =  [[BSCacheFromLocal alloc] initWithNext:self.fromServer];
        }
    }
    return self;
}

-(NSCachedURLResponse *) handleRequest:(NSURLRequest * ) request
{
  return [self.fromLocal handleRequst:request];
}

-(float) versionFromUrl:(NSString *) url
{
    int position = [url rangeOfString:Cache_Indentifier].location;
    position += Cache_Indentifier.length;
    NSString * subStrWithVerCode = [url substringFromIndex:(position)];//cachevers=321或者后面还有别的参数 如cachevers=321@abc=df。。。
    NSArray * array = [subStrWithVerCode componentsSeparatedByString:@"&"];
    int version = -1;
    if (array) {
        @try {
            version = [[array objectAtIndex:0] floatValue];
        }
        @catch (NSException *exception) {
            version = -1;
        }
        @finally {
            
        }
    }
    return version;
}

-(NSString *) keyFromUrl:(NSString *) url
{
    NSArray * array = [url componentsSeparatedByString:@"?"];
    if (array) {
        return [array objectAtIndex:0];
    }else
        return nil;
}

-(NSString *) pathFromUrl:(NSString *) url
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                          NSUserDomainMask,
                                                          YES);
    NSString * path = [paths objectAtIndex:0];
    path = [path stringByAppendingPathComponent:Cache_path];
    if (![BSFileManagerUtil isDirectoryExist:path]) {
        [BSFileManagerUtil createDirectory:path];
    }
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%x",[url hash]]];
    return path;
    
}

-(BOOL) hasConnIndentifierHeader:(NSURLRequest *) request
{
    NSString * connHeader = [[request allHTTPHeaderFields] objectForKey:Conn_Indentifier_Header];
    if (connHeader) {
        return YES;
    }else{
        return NO;
    }
}

-(BOOL) hasCacheIndentifier:(NSString *) url
{
    if ([url rangeOfString:Cache_Indentifier].length > 0) {
        return YES;
    }else{
        return NO;
    }
}

-(BOOL) setMutableRequestHeaderField:(NSString *) key
                          value:(NSString *) value
                        request:(NSMutableURLRequest *) request
{
    if (!request) {
        return NO;
    }
    else{
        NSDictionary * allHeaders = [request allHTTPHeaderFields];
        if ([request valueForHTTPHeaderField:key]) {//有headerField，则重新设置
            [request setValue:value forHTTPHeaderField:key];
        }
        else{//无header，则新增headerField
            [request addValue:value forHTTPHeaderField:key];
        }
        return YES;
    }
}

@end
