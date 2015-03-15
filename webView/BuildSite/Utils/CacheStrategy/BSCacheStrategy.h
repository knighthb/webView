//
//  BSCacheStrategy.h
//  BuildSite
//  缓存策略基类，采用责任链模式，便于以后缓存策略的扩展与新策略组合
//  Created by huangbin on 14-6-13.
//  Copyright (c) 2014年 58. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    NONE,
    ADD,
    UPDATE
}processType;

@interface BSCacheStrategy : NSObject
{
    NSMutableDictionary * _responseDic;
}

@property (nonatomic,strong) NSMutableDictionary * responseDic;
@property (nonatomic,weak) BSCacheStrategy * next;

-(id) initWithNext:(BSCacheStrategy *) next;

-(NSCachedURLResponse *) handleRequst:(NSURLRequest * ) request;

@end
