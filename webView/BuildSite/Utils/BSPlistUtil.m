//
//  BSPlistUtil.m
//  BuildSite
//
//  Created by huangbin on 14-6-16.
//  Copyright (c) 2014年 58. All rights reserved.
//

#import "BSPlistUtil.h"
#import "BSFileManagerUtil.h"

@implementation BSPlistUtil


+(NSObject *) plistToObject:(NSString *)name ofType:(DataType)type{

    NSString * fileName = [self plistFileName:name];
    switch (type) {
        case DIC:
            return [[NSMutableDictionary alloc] initWithContentsOfFile:fileName];
        case ARY:
            return [[NSMutableArray alloc] initWithContentsOfFile:fileName];
        default: return nil;
    }
};

+(BOOL) writeToPlistWithName:(NSString *) name
                        data:(id) data{
    NSString * fileName = [self plistFileName:name];
    @try{
        [data writeToFile:fileName atomically:YES];
        return YES;
    }
    @catch(NSException * e){
#pragma mark - for the sake of statistic, we can record excepitons to a log file
        NSLog(@"write plist file exception: %@",e.reason);
        return NO;
    }
}

+(NSString *) plistFileName:(NSString *) name
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                          NSUserDomainMask,
                                                          YES);
    NSString * path = [paths objectAtIndex:0];
    NSString * fileName = [path stringByAppendingPathComponent:name];
    NSLog(@"filename = %@",fileName);
    if (![self isPlistFileExist:fileName]) {
        [self createPlistFileWithName:fileName];
    }
    return fileName;
}

+(BOOL) createPlistFileWithName:(NSString *) fileName{
    @try {
        if (![self isPlistFileExist:fileName]) {
            //创建一个没有数据的plist文件
            [[[NSMutableDictionary alloc] init] writeToFile:fileName
                                                 atomically:YES];
        }
        NSLog(@"create plist file successed!");
        return YES;
    }
    @catch (NSException *exception) {
        NSLog(@"create plist file failed,reason: %@ ",exception.reason);
        return NO;
    }
    @finally {
        
    }
}

+(BOOL) removePlistFileWithName:(NSString *) fileName{
    return [BSFileManagerUtil deleteFileWithPath:fileName];
}

+(BOOL) isPlistFileExist:(NSString *) path
{
   return [BSFileManagerUtil isFileExist:path];
}

@end
