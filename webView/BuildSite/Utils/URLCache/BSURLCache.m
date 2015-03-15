//
//  BSURLCache.m
//  BuildSite
//
//  Created by huangbin on 14-6-13.
//  Copyright (c) 2014年 58. All rights reserved.
//

#import "BSURLCache.h"
#import "BSCacheFromLocal.h"
#import "BSCacheStrategy.h"
#import "BSResouceFromServer.h"
#import "BSPlistUtil.h"
#import "BSCacheUtil.h"

@implementation BSURLCache
@synthesize resCacheDic;

//主要是这个方法，该方法会拦截每个http请求，拦截后根据缓存规则来做相应处理
// BSCacheUtil里面 写成责任链模式，方便以后有新缓存规则加入的扩展（不同策略按照不同的组合扩展）
/**缓存规则：
  *1.对于有Cache_Indentifier的请求，会从缓存里取
  *2.没有Cache_Indentifier的请求，直接从server获取
 */
-(NSCachedURLResponse *) cachedResponseForRequest:(NSURLRequest *)request{
   
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"request" message:request.URL.absoluteString delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
////    [alert show];
    NSCachedURLResponse *responsese =
    [[BSCacheUtil sharedInstance] handleRequest:request];
    return responsese==nil?[super cachedResponseForRequest:request]:responsese;
}

-(id) initWithMemoryCapacity:(NSUInteger)memoryCapacity
                diskCapacity:(NSUInteger)diskCapacity
                    diskPath:(NSString *)path
{
    if (self = [super initWithMemoryCapacity:memoryCapacity diskCapacity:diskCapacity diskPath:path]) {
        self.resCacheDic = (NSMutableDictionary *)[BSPlistUtil plistToObject:PLIST_NAME ofType:DIC];
    }
    return self;
}

+(BSURLCache *) sharedUrlCache{
    return (BSURLCache *) [NSURLCache sharedURLCache];
}



@end

