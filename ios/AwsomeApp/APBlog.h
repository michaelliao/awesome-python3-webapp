//
//  APBlog.h
//  AwsomeApp
//
//  Created by Michael on 14-6-5.
//  Copyright (c) 2014年 iTranswarp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APBlog : NSObject

@property (strong) NSString* id;

@property (strong) NSString* name;

@property (strong) NSString* summary;

@property (strong) NSString* content;

@property (strong) NSString* user_id;

@property (strong) NSString* user_name;

@property NSNumber* created_at;

+ (APBlog*) blogWithDictionary:(NSDictionary*) dictionary;

@end
