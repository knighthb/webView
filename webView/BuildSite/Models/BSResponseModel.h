//
//  BSResponseModel.h
//  BuildSite
//
//  Created by huangbin on 14-6-17.
//  Copyright (c) 2014年 58. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSResponseModel : NSObject<NSCoding>
@property (nonatomic, strong) NSData * data;
@property (nonatomic, strong) NSURLResponse * response;

@end
