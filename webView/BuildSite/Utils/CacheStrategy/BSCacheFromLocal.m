//
//  BSCacheFromLocal.m
//  BuildSite
//
//  Created by huangbin on 14-6-13.
//  Copyright (c) 2014年 58. All rights reserved.
//

#import "BSCacheFromLocal.h"
#import "BSURLCache.h"
#import "BSResponseModel.h"
#import "BSCacheUtil.h"
#import "BSPlistUtil.h"
#import "BSFileManagerUtil.h"

@implementation BSCacheFromLocal


/*
 *先从缓存字典里查看，有两种情况：
 *1.有 2.没有
 *1.有 判断版本号， 如果 新版本号>当前版本号则更新缓存字典与plist文件，替换本地资源 如果<= 就不做处理
 *2.没有 更新缓存字典、plist文件、保存新资源
 */
-(NSCachedURLResponse *) handleRequst:(NSURLRequest *)request{
    NSString * url = [request.URL absoluteString];
    NSMutableURLRequest * mutRequest = [[NSMutableURLRequest alloc] initWithURL:request.URL];
    NSLog(@"absoluteString = %@",url);
    if (    [self hasCacheIndentifier:url] &&
        ![self hasConnIndentifierHeader:request]      ) {
        //包含要缓存的标志则取缓存，并且不是由我们自己构造的connection，否则从远程server取资源，并且不做缓存
        if (!self.responseDic) {
            self.responseDic = [[BSURLCache sharedUrlCache] resCacheDic];
        }
        NSString * key = [[BSCacheUtil sharedInstance] keyFromUrl:url];
        NSArray * resArray = [self.responseDic objectForKey:key];
        if (resArray) {//命中
            //缓存结构为 dictionary嵌套array，array包含两个 一个为版本号(float)，另一个为对应的资源路径
            float currentVersion = [[resArray objectAtIndex:0] floatValue];//currentVersion 为plist中记录的版本号
            float version = [[BSCacheUtil sharedInstance] versionFromUrl:url];//version为请求url中截取的版本号
            if (version > currentVersion) {
                //从远程服务器上拿,更新缓存
                [[BSCacheUtil sharedInstance] setMutableRequestHeaderField:Cache_Process_Indentifier
                                                                     value:[NSString stringWithFormat:@"%d",UPDATE]
                                                                   request:mutRequest];
                return [super handleRequst:mutRequest];
            }else{//从本地缓存取
                if ([resArray count]>=1) {
                    return [self localResource:[resArray objectAtIndex:1]];
                }else{
                    return nil;
                }
            }
        }else{
            //未命中,从远程服务器上拿，添加缓存
            [[BSCacheUtil sharedInstance] setMutableRequestHeaderField:Cache_Process_Indentifier
                                                                 value:[NSString stringWithFormat:@"%d",ADD]
                                                               request:mutRequest];
            return [super handleRequst:mutRequest];
        }
    }
    else{
        [[BSCacheUtil sharedInstance] setMutableRequestHeaderField:Cache_Process_Indentifier
                                                             value:[NSString stringWithFormat:@"%d",NONE]
                                                           request:mutRequest];
        return [super handleRequst:mutRequest];
    }
}

-(NSCachedURLResponse *) localResource:(NSString *) path
{
    //从plist的第2个位置拿文件的path，然后Unarchiver得到BSResponseModel
    BSResponseModel * model = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return [[NSCachedURLResponse alloc] initWithResponse:model.response data:model.data];
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


#pragma mark - NSURLConnectionDataDelegate

//- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
//{
//    
//}

//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//{
//    NSString * absoluteString = [connection currentRequest].URL.absoluteString;
//    if (![self hasCacheIndentifier:absoluteString]) {
//        //如果没有缓存标志，则不加缓存
//        return;
//    }
//    NSString * key = [self keyFromUrl:absoluteString];
//    
//    BSResponseModel * responseModel = [[BSResponseModel alloc] init];
//    responseModel.response =  response;
//    [ _responseDic setObject:responseModel forKey:key];
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
//    NSString * absoluteString = [connection currentRequest].URL.absoluteString;
//    if (![self hasCacheIndentifier:absoluteString]) {
//        //如果没有缓存标志，则不加缓存
//        return;
//    }
//    NSString * key = [self keyFromUrl:absoluteString];
//    BSResponseModel * responseModel = [_responseDic objectForKey:key];
//    if (!responseModel) {
//        responseModel = [[BSResponseModel alloc] init];
//        responseModel.data =  data;
//        [ _responseDic setObject:responseModel forKey:key];
//    }
//    else
//        responseModel.data = data;
//}
//
////- (NSInputStream *)connection:(NSURLConnection *)connection needNewBodyStream:(NSURLRequest *)request
////{
////    
////}
//
//- (void)connection:(NSURLConnection *)connection   didSendBodyData:(NSInteger)bytesWritten
// totalBytesWritten:(NSInteger)totalBytesWritten
//totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
//{
//    
//}
////
////- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
////{
////    
////}
//
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//    if (![self hasConnIndentifierHeader:[connection currentRequest]]) {
//        return;
//    }
//    NSLog(@"connectionDidFinishLoading...");
//    NSString * absoluteString = [connection currentRequest].URL.absoluteString;
//    float version = [self versionFromUrl:absoluteString];
//    if ([self hasCacheIndentifier:absoluteString]) {
//        NSString * key = [self keyFromUrl:absoluteString];
//        BSResponseModel * model = [_responseDic objectForKey:key];
//        if (model) {
//            NSString * cachePath = [self pathFromUrl:absoluteString];
//            [NSKeyedArchiver archiveRootObject:model toFile:cachePath];
//            NSMutableArray * array = [[NSMutableArray alloc ] init];
//            [array addObject:[NSNumber numberWithFloat:version]];
//            [array addObject:cachePath];
//            [[BSURLCache sharedUrlCache].resCacheDic setObject:array forKey:key];
//#pragma mark - 这个地方要做写plist文件的操作
//        }
//    }
//    //如果没有缓存标志，则不加缓存
////    connection = nil;
//}






@end
