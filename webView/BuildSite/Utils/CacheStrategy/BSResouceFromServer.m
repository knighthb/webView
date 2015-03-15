//
//  BSResouceFromServer.m
//  BuildSite
//
//  Created by huangbin on 14-6-13.
//  Copyright (c) 2014年 58. All rights reserved.
//

#import "BSResouceFromServer.h"
#import "BSResponseModel.h"
#import "BSCacheUtil.h"
#import "BSFileManagerUtil.h"
#import "BSPlistUtil.h"

@implementation BSResouceFromServer

-(NSCachedURLResponse *) handleRequst:(NSURLRequest *)request {
    NSString * url = [request.URL absoluteString];
    NSString * valueForHeaderField = [[request allHTTPHeaderFields] objectForKey:Cache_Process_Indentifier];
    int type = [valueForHeaderField integerValue];
    switch (type) {
        case NONE:
            return nil;
        case ADD:
            return [self serverResource:url type:ADD];
        case UPDATE:
            return [self serverResource:url type:UPDATE];
        default:
            return nil;
    }
}

-(NSCachedURLResponse *) serverResource:(NSString *) url type:(processType) type
{
    if (!self.responseDic) {
        self.responseDic = [[BSURLCache sharedUrlCache] resCacheDic];
    }
    NSURL * nsURL = [[NSURL alloc] initWithString:url];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:nsURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    [request addValue:Conn_Indentifier forHTTPHeaderField:Conn_Indentifier_Header];
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            //这里搞个失败页面，当没有网络时要展现失败页面，不然是空白页
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"网络连接失败" message:@"网络连接失败，请检查网络并重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            NSLog(@"%@异步请求发送失败..",url);
        }else{
            BSResponseModel * model = [[BSResponseModel alloc] init];
            model.response  = response;
            model.data = data;
            NSString * absoluteString  = request.URL.absoluteString;
            float version = [[BSCacheUtil sharedInstance] versionFromUrl:absoluteString];
            if ([[BSCacheUtil sharedInstance] hasCacheIndentifier:absoluteString]) {
                NSString * key = [[BSCacheUtil sharedInstance] keyFromUrl:absoluteString];
                //把key作为文件名的一部分，这样在删除的时候就能够轻易的找到要删除的文件，否则带上版本号删除时会比较麻烦
                NSString * cachePath = [[BSCacheUtil sharedInstance] pathFromUrl:key];
                if (type == UPDATE) {
                    //删除本地的文件
                    [BSFileManagerUtil deleteFileWithPath:cachePath];
                }
                [NSKeyedArchiver archiveRootObject:model toFile:cachePath];
                NSMutableArray * array = [[NSMutableArray alloc ] init];
                [array addObject:[NSNumber numberWithFloat:version]];
                [array addObject:cachePath];
                [self.responseDic setObject:array forKey:key];
#pragma mark - 这个地方要做写plist文件的操作,每次都要写一次 ，效率太低，有没有别的办法？
                [BSPlistUtil writeToPlistWithName:PLIST_NAME data:self.responseDic];
            }
            
        }
    }];
    return nil;
}

@end
