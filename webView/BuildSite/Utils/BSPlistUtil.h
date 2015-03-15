//
//  BSPlistUtil.h
//  BuildSite
//
//  Created by huangbin on 14-6-16.
//  Copyright (c) 2014年 58. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum DataType{
    DIC,
    ARY
} DataType;

@interface BSPlistUtil : NSObject

+(NSObject *) plistToObject:(NSString *) name ofType:(DataType) type;

+(BOOL) writeToPlistWithName:(NSString *) name
                        data:(id) data;

+(NSString *) plistFileName:(NSString *) name;

+(BOOL) isPlistFileExist:(NSString *) path;

+(BOOL) removePlistFileWithName:(NSString *) fileName;
@end
