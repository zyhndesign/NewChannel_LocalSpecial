//
//  QueueZipHandle.m
//  GYSJ
//
//  Created by sunyong on 13-9-24.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "QueueZipHandle.h"
#import "LoadZipFileNet.h"
#import "AllVariable.h"
#import "ViewController.h"

@implementation QueueZipHandle
static __strong NSMutableArray *allTaskAry;

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
        [RootViewContr startLoadMovie];
    }
}

static int position;
+ (void)addTarget:(id)target
{
    if (AllOnceLoad)
    {
        [allTaskAry addObject:target];
        return;
    }
    if ([QueueZipHandle isEixstInAry:allTaskAry zipNet:target])
    {
        LoadZipFileNet *tempProNet = (LoadZipFileNet*)[allTaskAry lastObject];
        LoadZipFileNet *currentProNet = target;
        if ([tempProNet.urlStr isEqualToString:currentProNet.urlStr])
        {
        
        }
        else
        {
            [tempProNet cancelLoad];
            [allTaskAry exchangeObjectAtIndex:position withObjectAtIndex:allTaskAry.count-1];
            [currentProNet loadMenuFromUrl];
        }
        return;
    }
    if (allTaskAry.count == 0)
    {
        [allTaskAry addObject:target];
        LoadZipFileNet *tempProNet = (LoadZipFileNet*)target;
        [tempProNet loadMenuFromUrl];
    }
    else
    {
        LoadZipFileNet *tempProNet = (LoadZipFileNet*)[allTaskAry lastObject];
        [tempProNet cancelLoad];
        [allTaskAry addObject:target];
        LoadZipFileNet *tempCurrentProNet = (LoadZipFileNet*)target;
        [tempCurrentProNet loadMenuFromUrl];
    }
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
        [RootViewContr caculateMovieLoad];
    };
}

@end
