//
//  BSFileManagerUtil.m
//  BuildSite
//
//  Created by huangbin on 14-6-18.
//  Copyright (c) 2014年 58. All rights reserved.
//

#import "BSFileManagerUtil.h"

@implementation BSFileManagerUtil

+(BOOL) isFileExist:(NSString *) path{
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return YES;
    }
    else{
        return NO;
    }
}

+(BOOL) isDirectoryExist:(NSString *) path
{
    BOOL isDir = YES;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir]) {
        return YES;
    }
    else
        return NO;
}

+(BOOL) createDirectory:(NSString *) path
{
  return [[NSFileManager defaultManager]createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
}

+(BOOL) deleteFileWithPath:(NSString *)path
{
    @try {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        
        return YES;
    }
    @catch (NSException *exception) {
        return NO;
    }
    @finally {
        
    }
}

@end
