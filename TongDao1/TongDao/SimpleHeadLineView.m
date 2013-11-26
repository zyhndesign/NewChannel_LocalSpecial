//
//  SimpleHeadLineView.m
//  TongDao
//
//  Created by sunyong on 13-9-26.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "SimpleHeadLineView.h"
#import "HeadProImageNet.h"
#import "AllVariable.h"
#import "ContentView.h"
#import "ViewController.h"

@implementation SimpleHeadLineView

- (id)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(frame.origin.x, frame.origin.y, 260, 410);
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addView];
    }
    return self;
}

- (id)initWithInfoDict:(NSDictionary*)infoDict
{
    self = [super initWithFrame:CGRectMake(0, 0, 260, 410)];
    if (self)
    {
        _infoDict = [[NSDictionary alloc] initWithDictionary:infoDict];
        [self addView];
    }
    return self;
}

- (void)addView
{
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, 240, 410)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];
    
    UITapGestureRecognizer *tapGestureR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
    [self addGestureRecognizer:tapGestureR];
    
    titleLb = [[UILabel alloc] initWithFrame:CGRectMake(15, 240, 210, 35)];
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.textColor       = RedColor;
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.font = [UIFont boldSystemFontOfSize:17];
    titleLb.text = [_infoDict objectForKey:@"name"];
    [whiteView addSubview:titleLb];
   
    if (ios7)
        detailTextV = [[TextLayoutView alloc] initWithFrame:CGRectMake(15, 285, 210, 76)];
    else
        detailTextV = [[TextLayoutView alloc] initWithFrame:CGRectMake(15, 285, 210, 95)];
    
    detailTextV.backgroundColor = [UIColor clearColor];
    detailTextV.textColor       = [UIColor blackColor];
    detailTextV.font = [UIFont systemFontOfSize:14];
    detailTextV.userInteractionEnabled = NO;
    detailTextV.text = [_infoDict objectForKey:@"description"];
    detailTextV.linesSpacing = 6;
    [whiteView addSubview:detailTextV];
    
    ////////defultbg-210.png
    proImageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 210, 210)];
    [whiteView addSubview:proImageV];
    
    ////////
    UIImageView *redImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"time_bg.png"]];
    [redImageV setFrame:CGRectMake(0, 15, 90, 53)];
    [self addSubview:redImageV];
    
    timeLb = [[UILabel alloc] initWithFrame:CGRectMake(2, 18, 60, 22)];
    timeLb.textAlignment = NSTextAlignmentRight;
    timeLb.backgroundColor = [UIColor clearColor];
    timeLb.textColor = [UIColor whiteColor];
    timeLb.font = [UIFont systemFontOfSize:16];
    [self addSubview:timeLb];
    
    yearLb = [[UILabel alloc] initWithFrame:CGRectMake(2, 35, 60, 22)];
    yearLb.textAlignment = NSTextAlignmentRight;
    yearLb.backgroundColor = [UIColor clearColor];
    yearLb.textColor = [UIColor whiteColor];
    yearLb.font = [UIFont systemFontOfSize:16];
    [self addSubview:yearLb];
    
    videoImageV = [[UIImageView alloc] initWithFrame:CGRectMake(proImageV.frame.size.width - 40, 0, 40, 35)];
    [proImageV addSubview:videoImageV];
    if ([[_infoDict objectForKey:@"hasVideo"] isEqualToString:@"true"])
        [videoImageV setImage:[UIImage imageNamed:@"video.png"]];
    
    NSString *timeStr = [_infoDict objectForKey:@"postDate"];
    if (timeStr.length >= 8)
    {
        NSString *yearStr = [timeStr substringToIndex:4];
        yearLb.text = yearStr;
        NSString *monthStr = [[timeStr substringFromIndex:4] substringToIndex:2];
        NSString *dayStr   = [timeStr substringFromIndex:6];
        timeLb.text = [NSString stringWithFormat:@"%@/%@", monthStr, dayStr];
    }

    NSString *imageURL = [_infoDict objectForKey:@"profile"];
    NSArray *tempAry = [imageURL componentsSeparatedByString:@"."];
    imageURL = [tempAry objectAtIndex:0];
    for (int i = 1; i < tempAry.count; i++)
    {
        if (i == tempAry.count - 1)
        {
            imageURL = [NSString stringWithFormat:@"%@-200x200.%@", imageURL, [tempAry objectAtIndex:i]];
        }
        else
            imageURL = [NSString stringWithFormat:@"%@.%@", imageURL, [tempAry objectAtIndex:i]];
    }
    
    NSString *ProImgeFormat = [[imageURL componentsSeparatedByString:@"."] lastObject];
    NSString *pathProFile = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"ProImage/%@.%@",[_infoDict objectForKey:@"id"], ProImgeFormat]];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:pathProFile])
    {
        UIImage *image = [UIImage imageWithContentsOfFile:pathProFile];
        if(image)
            [proImageV setImage:[UIImage imageWithContentsOfFile:pathProFile]];
        else
            [proImageV setImage:[UIImage imageNamed:@"defultbg-210.png"]];
    }
    else
    {
        [proImageV setImage:[UIImage imageNamed:@"defultbg-210.png"]];
        HeadProImageNet *proImageLoadNet = [[HeadProImageNet alloc] initWithDict:_infoDict];
        proImageLoadNet.delegate = self;
        proImageLoadNet.imageUrl = imageURL;
        [proImageLoadNet loadImageFromUrl];
    }
}

- (void)dealloc
{
    [proImageV   removeFromSuperview];
    proImageV   = nil;
    [titleLb     removeFromSuperview];
    timeLb      = nil;
    [detailTextV removeFromSuperview];
    detailTextV = nil;
    [timeLb      removeFromSuperview];
    timeLb      = nil;
    [yearLb      removeFromSuperview];
    yearLb      = nil;
    _infoDict   = nil;
}

#pragma mark - tapGesture

- (void)tapView
{
    if (AllOnlyShowPresentOne == 1)
    {
        return;
    }
    [RootViewContr presentViewContr:_infoDict];
}


#pragma mark - net delegate
- (void)didReciveImage:(UIImage *)backImage
{
    [proImageV setImage:backImage];
}

- (void)didReceiveErrorCode:(NSError *)ErrorDict
{
    
}


@end
