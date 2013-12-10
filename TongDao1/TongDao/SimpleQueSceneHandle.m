//
//  SimpleQueSceneHandle.m
//  TongDao
//
//  Created by sunyong on 13-12-9.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "SimpleQueSceneHandle.h"
#import "LoadZipFileNet.h"
#import "AllVariable.h"
#import "ViewController.h"

@implementation SimpleQueSceneHandle

static __strong NSMutableArray *allTaskAry;
static long allSize;
UILabel *impLyLB;

+ (void)setSize:(long)size
{
    allSize = size;
}

+ (void)setImplyLb:(UILabel*)implyLb
{
    impLyLB = implyLb;
}

+ (void)init
{
    if (!allTaskAry)
    {
        allTaskAry = [[NSMutableArray alloc] init];
    }
}

+ (BOOL)isHaveTask
{
    if (allTaskAry.count > 0) {
        return YES;
    }
    return NO;
}

+ (void)startTask
{
    if (allTaskAry.count > 0)
    {
        LoadZipFileNet *tempProNet = [allTaskAry lastObject];
        [tempProNet loadMenuFromUrl];
    }
    else
    {
        //finish
    }
}

static int position;
+ (void)addTarget:(id)target
{
    [allTaskAry addObject:target];
}

+ (BOOL)isEixstInAry:(NSArray*)initAry zipNet:(LoadZipFileNet*)target
{
    NSArray *array = [NSArray arrayWithArray:initAry];
    for (int i = 0; i < array.count; i++)
    {
        LoadZipFileNet *zipNet = [array objectAtIndex:i];
        if ([zipNet.urlStr isEqualToString:target.urlStr])
        {
            position = i;
            zipNet.delegate = target.delegate;
            return YES;
        }
    }
    return NO;
}

+ (void)taskFinish:(id)target
{
    [allTaskAry removeObject:target];
    if (allTaskAry.count > 0)
    {
        LoadZipFileNet *tempProNet = (LoadZipFileNet*)[allTaskAry lastObject];
        [tempProNet loadMenuFromUrl];
    }
    else
    {
        //finish
    };
}

@end
