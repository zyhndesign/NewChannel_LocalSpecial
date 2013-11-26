//
//  HomePageViewContr.m
//  TongDao
//
//  Created by sunyong on 13-9-15.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "HomePageViewContr.h"
#import "SimpleHeadLineView.h"
#import "ContentView.h"
#import "ViewController.h"
#import "AllVariable.h"
#import "MovieBgPlayViewCtr.h"

@interface HomePageViewContr ()

@end

@implementation HomePageViewContr

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    contentScrolV.backgroundColor = [UIColor colorWithRed:219/255.0 green:218/255.0 blue:188/255.0 alpha:1];
    [contentScrolV setContentSize:CGSizeMake(1024*3, 768)];
    
    UITapGestureRecognizer *tapGestureR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [movieView addGestureRecognizer:tapGestureR];
    
    [super viewDidLoad];
}

#define StartX 107
#define StartY 60
#define Gap 15
- (void)loadSubview:(NSArray*)ary
{
    initAry = [[NSArray alloc] initWithArray:ary];
    if (initAry.count == 0) 
        return;
    /// 第一个
    if (initAry.count < 1)
        return;
    NSDictionary *infoDict = [initAry objectAtIndex:0];
    titleLb.text = [infoDict objectForKey:@"name"];
    
    NSString *timeStr = [infoDict objectForKey:@"postDate"];
    if (timeStr.length >= 8)
    {
        NSString *yearStr = [timeStr substringToIndex:4];
        NSString *monthSt = [[timeStr substringFromIndex:4] substringToIndex:2];
        NSString *dayStr  = [timeStr substringFromIndex:6];
        timeLb.text = [NSString stringWithFormat:@"%@/%@/%@", yearStr, monthSt, dayStr];
    }
    
    NSString *backGround = [infoDict objectForKey:@"background"];
    NSArray *tempAry = [backGround componentsSeparatedByString:@"."];
    if ([[tempAry lastObject] isEqualToString:@"mp4"])
    {
        NSString *pathProFile = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)  lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@", [infoDict objectForKey:@"id"], backGround]];
        if([[NSFileManager defaultManager] fileExistsAtPath:pathProFile])
        {
            movieBgPlayVC = [[MovieBgPlayViewCtr alloc] initwithURL:pathProFile];
            [movieView addSubview:movieBgPlayVC.view];
        }
        else
        {
           // [mainImageV setImage:[UIImage imageNamed:@"bg0.png"]];
        }
    }
    else
    {
       // [mainImageV setImage:[UIImage imageNamed:@"bg0.png"]];
//        NSString *pathProFile = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)  lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@", [infoDict objectForKey:@"id"], backGround]];
//        if([[NSFileManager defaultManager] fileExistsAtPath:pathProFile])
//        {
//            [mainImageV setImage:[UIImage imageWithContentsOfFile:pathProFile]];
//        }
//        else
//        {
//            
//        }
    }
    
    //// 后三个
    for (int i = 1; i < initAry.count; i++)
    {
        if (i > 3)
            break;
        SimpleHeadLineView *simpleHLView = [[SimpleHeadLineView alloc] initWithInfoDict:[initAry objectAtIndex:i]];
        [simpleHLView setFrame:CGRectMake(StartX + Gap*(i-1) + simpleHLView.frame.size.width*(i-1), StartY, simpleHLView.frame.size.width, simpleHLView.frame.size.height)];
        [contentScrolV addSubview:simpleHLView];
    }
}

- (void)dealloc
{
    initAry = nil;
}

#pragma mark - tapGesture
- (void)tapView:(UIGestureRecognizer*)gestureR
{
    CGPoint gestPoint = [gestureR locationInView:self.view];
    if (initAry.count == 0)
        return;
    if (CGRectContainsPoint(CGRectMake(0, 0, 1024, 668), gestPoint))
    {
        [RootViewContr presentViewContr:[initAry objectAtIndex:0]];
    }
}

@end
