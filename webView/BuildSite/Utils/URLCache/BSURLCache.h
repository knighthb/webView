//
//  BSURLCache.h
//  BuildSite
//
//  Created by huangbin on 14-6-13.
//  Copyright (c) 2014年 58. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSURLCache : NSURLCache

@property (nonatomic , strong) NSMutableDictionary * resCacheDic;

-(NSObject *) resourcesForKey:(NSString *) key;

+(BSURLCache *) sharedUrlCache;

-(NSMutableDictionary *) resCacheDic;

@end
