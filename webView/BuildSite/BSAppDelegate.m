//
//  BSAppDelegate.m
//  BuildSite
//
//  Created by huangbin on 14-6-13.
//  Copyright (c) 2014年 58. All rights reserved.
//

#import "BSAppDelegate.h"
#import "BSURLCache.h"
#import "BSMainViewController.h"
#import "BSWebView.h"
#import <AFNetworking.h>
#import "BSPlistUtil.h"

@implementation BSAppDelegate{
    NSInteger firstOtherButtonIndex;
    NSString * version;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //检测更新
    NSString * urlStr = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"URLPath"];
    NSArray * array = [urlStr componentsSeparatedByString:@"."];
    version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    //可以装多个app，所以要加唯一标识

     NSString * appID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"AppID"];
    
    NSString * getPhoneNum = [NSString stringWithFormat:@"%@/app/getphonenumber/%@",Base_URL,appID];
    NSURL * getPhoneUrl = [NSURL URLWithString:getPhoneNum];
    NSURLRequest * getPhoneRequest = [[NSURLRequest alloc] initWithURL:getPhoneUrl];
    
    NSString * checkUrl = [NSString stringWithFormat:@"%@/checkapp/%@/%@",Base_URL,appID,version];
    NSURL * url = [NSURL URLWithString:checkUrl];
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
    
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"text/json", @"text/javascript",@"application/json",@"text/html",@"text/plain", nil]];
    __block NSString * key = @"";
    AFJSONRequestOperation * getPhoneOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:getPhoneRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary * phoneNumDic = (NSDictionary *) JSON;
        NSString * phoneNumStr = [phoneNumDic objectForKey:@"msg"];
        if (![phoneNumStr isEqualToString:@""]) {
            key = [NSString stringWithFormat:@"%@_%@",Phone_Num,appID];
            [[NSUserDefaults standardUserDefaults] setObject:phoneNumStr forKey:key];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"获取用户手机失败");
    }];
    [getPhoneOperation start];
    AFJSONRequestOperation * operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary * resultJson = (NSDictionary *) JSON;
        NSLog(@"aaa");
        NSString * updateStr = [resultJson objectForKey:@"isupdate"];
        if ([@"true" isEqualToString:updateStr]) {
            self.downLoadUrl = [resultJson objectForKey:@"downurl"];
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"有更新" message:@"应用有更新" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
            firstOtherButtonIndex = alertView.firstOtherButtonIndex;
            [[NSUserDefaults standardUserDefaults] setObject:version forKey:Old_Version];
            [alertView show];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"出错了,%@",error);
    }];
    [operation start];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //缓存初始化，初始化之后所有的url都会被cachedResponseForRequest拦截，在这个里面处理缓存策略
    BSURLCache * urlCache = [[BSURLCache alloc] initWithMemoryCapacity:Memory_Cache_Size diskCapacity:Disk_Cache_Size diskPath:nil];
    [NSURLCache setSharedURLCache:urlCache];
    BSWebView * webView = [[BSWebView alloc] initWithFrame:CGRectMake(0, 20,[UIScreen mainScreen].bounds.size.width
                                                                      ,[UIScreen mainScreen].bounds.size.height-20
                                                                      )];
    webView.key = [NSString stringWithFormat:@"%@_%@",Phone_Num,appID];
    BSMainViewController * mainViewController = [[BSMainViewController alloc] initWithWebView:webView];
    
    self.window.rootViewController  = mainViewController;
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == firstOtherButtonIndex) {
        //打开safari
        [BSPlistUtil removePlistFileWithName:[BSPlistUtil plistFileName:PLIST_NAME]];
        NSString * updateUrl = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",self.downLoadUrl];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
    }
}

@end
