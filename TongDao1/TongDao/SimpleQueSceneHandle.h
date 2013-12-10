//
//  SimpleQueSceneHandle.h
//  TongDao
//
//  Created by sunyong on 13-12-9.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimpleQueSceneHandle : NSObject
{
    
}
+ (void)setSize:(long)size;
+ (void)setImplyLb:(UILabel*)implyLb;
+ (void)init;
+ (void)addTarget:(id)target;
+ (void)taskFinish:(id)target;
+ (BOOL)isHaveTask;
+ (void)startTask;

@end
