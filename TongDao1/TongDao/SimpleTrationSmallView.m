//
//  SimpleTrationView.m
//  TongDao
//
//  Created by sunyong on 13-9-26.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "SimpleTrationSmallView.h"
#import "ProImageLoadNet.h"
#import "AllVariable.h"
#import "ContentView.h"
#import "ViewController.h"

@implementation SimpleTrationSmallView
@synthesize proImageLoadNet;

- (id)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, 200, 200);
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithInfoDict:(NSDictionary*)infoDict
{
    self = [super initWithFrame:CGRectMake(0, 0, 200, 200)];
    if (self) {
        _infoDict = [[NSDictionary alloc] initWithDictionary:infoDict];
        [self addView];
    }
    return self;
}

- (void)addView
{
    proImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:proImageV];
    
    UILabel *bgLb = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height-40, self.frame.size.width, 40)];
    bgLb.alpha = 0.65;
    bgLb.backgroundColor = [UIColor blackColor];
    [self addSubview:bgLb];
    
    titleLb  = [[UILabel alloc] initWithFrame:CGRectMake(10, self.frame.size.height-40, self.frame.size.width - 10, 40)];
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.textColor       = [UIColor whiteColor];
    titleLb.font = [UIFont systemFontOfSize:17];
    [self addSubview:titleLb];
    
    videoImageV = [[UIImageView alloc] initWithFrame:CGRectMake(proImageV.frame.size.width - 40, 0, 40, 35)];
    [proImageV addSubview:videoImageV];
    if ([[_infoDict objectForKey:@"hasVideo"] isEqualToString:@"true"])
        [videoImageV setImage:[UIImage imageNamed:@"video.png"]];
    
    
    UITapGestureRecognizer *tapGestureR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
    [self addGestureRecognizer:tapGestureR];
    
    titleLb.text = [_infoDict objectForKey:@"name"];
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
            [proImageV setImage:[UIImage imageNamed:@"defultbg-200.png"]];
    }
    else
    {
        [proImageV setImage:[UIImage imageNamed:@"defultbg-200.png"]];
        proImageLoadNet = [[ProImageLoadNet alloc] initWithDict:_infoDict];
        proImageLoadNet.delegate = self;
        proImageLoadNet.imageUrl = imageURL;
        [QueueProHanle addTarget:proImageLoadNet];
    }
}

- (void)dealloc
{
    proImageLoadNet = nil;
    [proImageV removeFromSuperview];
    proImageV = nil;
    [titleLb   removeFromSuperview];
    titleLb   = nil;
    _infoDict = nil;
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
