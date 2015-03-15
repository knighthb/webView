//
//  BSResponseModel.m
//  BuildSite
//
//  Created by huangbin on 14-6-17.
//  Copyright (c) 2014年 58. All rights reserved.
//

#import "BSResponseModel.h"

@implementation BSResponseModel
@synthesize  data;
@synthesize  response;

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[self data] forKey:NSKeyed_Data];
    [aCoder encodeObject:[self response] forKey:NSKeyed_Response];
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        [self setData:[aDecoder decodeObjectForKey:NSKeyed_Data]];
        [self setResponse:[aDecoder decodeObjectForKey:NSKeyed_Response]];
    }
    return self;
}
@end
