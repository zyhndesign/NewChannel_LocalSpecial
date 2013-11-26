//
//  SimpleHumanityView.m
//  TongDao
//
//  Created by sunyong on 13-9-26.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "SimpleHumanityView.h"
#import "AllVariable.h"
#import "ContentView.h"
#import "ProImageLoadNet.h"
#import "ViewController.h"

@implementation SimpleHumanityView
@synthesize proImageLoadNet;

- (id)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(frame.origin.x, frame.origin.y, 220, 400);
    self = [super initWithFrame:frame];
    if (self) {
    
    }
    return self;
}

- (id)initWithInfoDict:(NSDictionary*)infoDict mode:(int)mode
{
    self = [super initWithFrame:CGRectMake(0, 0, 220, 400)];
    if (self) {
        Mode = mode;
        _infoDict = [[NSDictionary alloc] initWithDictionary:infoDict];
        
        [self addView];
    }
    return self;
}

- (void)addView
{
    UITapGestureRecognizer *tapGestureR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
    [self addGestureRecognizer:tapGestureR];
    
    titleLb = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 180, 40)];
    titleLb.textColor = RedColor;
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.font = [UIFont boldSystemFontOfSize:18];
    [self addSubview:titleLb];
    
    midLineLb = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, 180, 1)];
    midLineLb.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:midLineLb];

    timeLb = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, 180, 40)];
    timeLb.textColor = [UIColor blackColor];
    timeLb.backgroundColor = [UIColor clearColor];
    timeLb.font = [UIFont systemFontOfSize:17];
    [self addSubview:timeLb];
    
    if (ios7)
        detailTextV = [[TextLayoutView alloc] initWithFrame:CGRectMake(20, 90, 188, 80)];
    else
        detailTextV = [[TextLayoutView alloc] initWithFrame:CGRectMake(20, 90, 188, 80)];

    detailTextV.font = [UIFont systemFontOfSize:14];
    detailTextV.textColor = [UIColor blackColor];
    detailTextV.text = [_infoDict objectForKey:@"description"];
    detailTextV.linesSpacing = 6;
    [self addSubview:detailTextV];
    
    proImageV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 204, 180, 180)];
    [self addSubview:proImageV];
    
    videoImageV = [[UIImageView alloc] initWithFrame:CGRectMake(proImageV.frame.size.width - 40, 0, 40, 35)];
    [proImageV addSubview:videoImageV];
    if ([[_infoDict objectForKey:@"hasVideo"] isEqualToString:@"true"])
        [videoImageV setImage:[UIImage imageNamed:@"video.png"]];
    
    if (Mode == 0)
        [self modeTwo];
    
    NSString *timeStr = [_infoDict objectForKey:@"postDate"];
    if (timeStr.length >= 8)
    {
        NSString *yearStr = [timeStr substringToIndex:4];
        NSString *monthSt = [[timeStr substringFromIndex:4] substringToIndex:2];
        NSString *dayStr  = [timeStr substringFromIndex:6];
        timeLb.text = [NSString stringWithFormat:@"%@/%@/%@", yearStr, monthSt, dayStr];
    }
    titleLb.text       = [_infoDict objectForKey:@"name"];
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
            [proImageV setImage:[UIImage imageNamed:@"defultbg-180.png"]];
    }
    else
    {
        [proImageV setImage:[UIImage imageNamed:@"defultbg-180.png"]];
        proImageLoadNet = [[ProImageLoadNet alloc] initWithDict:_infoDict];
        proImageLoadNet.delegate = self;
        proImageLoadNet.imageUrl = imageURL;
        [QueueProHanle addTarget:proImageLoadNet];
    }

}


- (void)modeTwo
{
    [proImageV setFrame:CGRectMake(proImageV.frame.origin.x, titleLb.frame.origin.y + 10, proImageV.frame.size.width, proImageV.frame.size.height)];
    
    [titleLb setFrame:CGRectMake(titleLb.frame.origin.x, titleLb.frame.origin.y + proImageV.frame.size.height + 20, titleLb.frame.size.width, titleLb.frame.size.height)];
    [midLineLb setFrame:CGRectMake(midLineLb.frame.origin.x, midLineLb.frame.origin.y + proImageV.frame.size.height + 20, midLineLb.frame.size.width, midLineLb.frame.size.height)];
    [timeLb setFrame:CGRectMake(timeLb.frame.origin.x, timeLb.frame.origin.y + proImageV.frame.size.height + 20, timeLb.frame.size.width, timeLb.frame.size.height)];
    [detailTextV setFrame:CGRectMake(detailTextV.frame.origin.x, timeLb.frame.origin.y + timeLb.frame.size.height + 4, detailTextV.frame.size.width, detailTextV.frame.size.height)];
    
}

- (void)dealloc
{
    [proImageV   removeFromSuperview];
    [titleLb     removeFromSuperview];
    [timeLb      removeFromSuperview];
    [midLineLb   removeFromSuperview];
    [detailTextV removeFromSuperview];
    proImageLoadNet = nil;
    proImageV   = nil;
    titleLb     = nil;
    midLineLb   = nil;
    timeLb      = nil;
    detailTextV = nil;
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
