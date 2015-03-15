//
//  BSFileManagerUtil.h
//  BuildSite
//
//  Created by huangbin on 14-6-18.
//  Copyright (c) 2014年 58. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSFileManagerUtil : NSObject

+(BOOL) isFileExist:(NSString *) path;

+(BOOL) createDirectory:(NSString *) path;

+(BOOL) isDirectoryExist:(NSString *) path;

+(BOOL) deleteFileWithPath:(NSString *) path;

@end
