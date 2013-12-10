//
//  LoaderViewController.m
//  TongDao
//
//  Created by sunyong on 13-12-9.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "LoaderViewController.h"
#import "AllVariable.h"
#import "LoadZipFileNet.h"
#import "SimpleQueSceneHandle.h"

@interface LoaderViewController ()

@end

@implementation LoaderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        LocalFileNameArray = [[NSMutableArray alloc] init];
        
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
        
        [LocalFileNameArray addObjectsFromArray:array];
        [LocalFileNameArray removeObject:@".DS_Store"];
        [LocalFileNameArray removeObject:@"BigImage"];
        [LocalFileNameArray removeObject:@"Data.db"];
        [LocalFileNameArray removeObject:@"movie"];
        [LocalFileNameArray removeObject:@"music"];
        [LocalFileNameArray removeObject:@"ProImage"];
        
    }
    return self;
}

#define ScrolViewWidth 584
#define ScrolViewHeigh 582
#define ViewHeigh 60
- (void)viewDidLoad
{
    menuAry = [[NSMutableArray alloc] initWithObjects:@"音乐",@"风景", @"人文",@"物语",@"社区",@"视频",nil];
    swViewAry  = [[NSMutableArray alloc] init];
    videoArray = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor clearColor];
    menuScrolV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 46, ScrolViewWidth, ScrolViewHeigh)];
    for (int i = 0; i < menuAry.count; i++)
    {
        UIView *view = [self builtMenuView:i+1];
        [menuScrolV addSubview:view];
    }
    [menuView addSubview:menuScrolV];
    [menuScrolV setContentSize:CGSizeMake(584, 583)];
    
    progresScrolV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 46, ScrolViewWidth, ScrolViewHeigh)];
    [loadProgresView addSubview:progresScrolV];
    [progresScrolV setContentSize:CGSizeMake(584, 583)];
    [super viewDidLoad];
}

#pragma mark - Data handle
#define BaseViewTag 100
#define BaseLabelTag 10000
#define BaseSwitchTag 10000
- (void)dataFilter:(int)tag
{
    if (tag == 0)
    {
        
    }
    else if(tag == 1)
    {
        long allSimleSize = 0;
        for (int i = 0; i < AllGroupInfoArray.count; i++)
        {
            NSDictionary *infoDict = [AllGroupInfoArray objectAtIndex:i];
            NSString *idStr  = [infoDict objectForKey:@"id"];
            NSString *videoS = [infoDict objectForKey:@"hasVideo"];
            if (![self isEixstInArray:[AllGroupInfoArray objectAtIndex:tag] content:idStr])
            {
                int simpleSize = [[infoDict objectForKey:@"size"] intValue];
                allSimleSize += simpleSize;
                LoadZipFileNet *loadZipNet = [[LoadZipFileNet alloc] init];
                loadZipNet.delegate = nil;
                loadZipNet.urlStr   = [[infoDict objectForKey:@"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                loadZipNet.md5Str   = [[infoDict objectForKey:@"md5"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                loadZipNet.zipStr   = [infoDict objectForKey:@"id"];
                [SimpleQueSceneHandle addTarget:loadZipNet];
            }
            if([videoS isEqualToString:@"true"])
            {
                [videoArray addObject:infoDict];
            }
        }
        UILabel *label = (UILabel *)[[progresScrolV viewWithTag:BaseViewTag] viewWithTag:tag*BaseLabelTag];
        [SimpleQueSceneHandle setSize:allSimleSize];
        [SimpleQueSceneHandle setImplyLb:label];
    }
    else if(tag == 2)
    {
        
    }
    else ;
}

- (BOOL)isEixstInArray:(NSArray*)initAry content:(NSString*)contentStr
{
    for (int i = 0; i < initAry.count; i++)
    {
        NSString *infoStr = [initAry objectAtIndex:i];
        if ([infoStr isEqualToString:contentStr])
        {
            return YES;
        }
    }
    return NO;
}

#pragma mark - view handle
- (void)rebuildProgressView
{
    [self removeAllChildView:progresScrolV];
    int pos = 1;
    UIView *newView = nil;
    for (int i = 0; i < swViewAry.count; i++)
    {
        UISwitch *switchView = [swViewAry objectAtIndex:i];
        if (switchView.on)
        {
            [self dataFilter:i];
            newView = [self builtProgressView:i+1 position:pos];
            [progresScrolV addSubview:newView];
            pos++;
        }
    }
    if (newView)
    {
        UILabel *bottomLineLb = [[UILabel alloc] initWithFrame:CGRectMake(0, ViewHeigh-1, ScrolViewWidth, 1)];
        bottomLineLb.backgroundColor = [UIColor lightGrayColor];
        [newView addSubview:bottomLineLb];
    }
}

- (UIView*)builtProgressView:(NSInteger)viewTag position:(int)position
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, (position-1)*60, ScrolViewWidth, ViewHeigh)];
    view.tag = viewTag*BaseViewTag;
    
    UILabel *lineLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScrolViewWidth, 1)];
    lineLb.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:lineLb];
    
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 60)];
    titleLb.font = [UIFont boldSystemFontOfSize:18];
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.textColor = [UIColor blackColor];
    titleLb.textAlignment = NSTextAlignmentLeft;
    titleLb.text = [menuAry objectAtIndex:viewTag-1];
    [view addSubview:titleLb];
    
    UILabel *implyLb = [[UILabel alloc] initWithFrame:CGRectMake(420, 0, 80, 60)];
    implyLb.tag = viewTag*BaseLabelTag;
    implyLb.textColor = [UIColor grayColor];
    implyLb.backgroundColor = [UIColor clearColor];
    implyLb.font = [UIFont systemFontOfSize:16];
    implyLb.text = @"等待中";
    [view addSubview:implyLb];
    
    UIButton *canleBt = [UIButton buttonWithType:UIButtonTypeCustom];
    canleBt.tag = viewTag;
    [canleBt setBackgroundColor:[UIColor lightGrayColor]];
    [canleBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [canleBt setTitle:@"取消" forState:UIControlStateNormal];
    canleBt.titleLabel.font = [UIFont systemFontOfSize:14];
    [canleBt addTarget:self action:@selector(canleLoader:) forControlEvents:UIControlEventTouchDown];
    [canleBt setFrame:CGRectMake(ScrolViewWidth-40-10, 20, 40, 20)];
    [view addSubview:canleBt];
    return view;
}

- (UIView*)builtMenuView:(NSInteger)viewTag
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, (viewTag-1)*60, ScrolViewWidth, ViewHeigh)];
    view.tag = viewTag*BaseViewTag;
    
    UILabel *lineLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScrolViewWidth, 1)];
    lineLb.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:lineLb];
    
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 60)];
    titleLb.font = [UIFont boldSystemFontOfSize:18];
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.textColor = [UIColor blackColor];
    titleLb.textAlignment = NSTextAlignmentLeft;
    titleLb.text = [menuAry objectAtIndex:viewTag-1];
    [view addSubview:titleLb];
    
    UISwitch *swithV = [[UISwitch alloc] initWithFrame:CGRectMake(523, 15, 80, 27)];
    swithV.onTintColor = [UIColor blueColor];
    swithV.thumbTintColor = [UIColor lightGrayColor];
    swithV.tag = viewTag*BaseSwitchTag;
    [view addSubview:swithV];
    
    [swViewAry addObject:swithV];
    
    if (viewTag == menuAry.count)
    {
        UILabel *bottomLineLb = [[UILabel alloc] initWithFrame:CGRectMake(0, ViewHeigh-1, ScrolViewWidth, 1)];
        bottomLineLb.backgroundColor = [UIColor lightGrayColor];
        [view addSubview:bottomLineLb];
    }
    return view;
}

- (void)removeAllChildView:(UIView*)view
{
    NSArray *subViewAry = view.subviews;
    for (int i = 0; i < subViewAry.count; i++)
    {
        UIView *subView = [subViewAry objectAtIndex:i];
        [subView removeFromSuperview];
        subView = nil;
    }
}
#pragma mark - Bt Event
- (void)canleLoader:(UIButton*)sender
{
    if ([sender.titleLabel.text isEqualToString:@"已取消"])
        return;
    [sender setTitle:@"已取消" forState:UIControlStateNormal];
    [sender setBackgroundColor:[UIColor whiteColor]];
    sender.titleLabel.font = [UIFont systemFontOfSize:17];
    [sender setFrame:CGRectMake(ScrolViewWidth-60-10, 10, 60, 40)];
    
    UIView *view = [progresScrolV viewWithTag:sender.tag*100];
    UILabel *implyLb = (UILabel*)[view viewWithTag:sender.tag*10000];
    implyLb.hidden = YES;
}

- (IBAction)changeView:(UIButton*)sender
{
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.7;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"oglFlip";
    animation.subtype = kCATransitionFromLeft;
    NSUInteger beforeV = [[subViewBg subviews] indexOfObject:menuView];
    NSUInteger afterV = [[subViewBg subviews] indexOfObject:loadProgresView];
    if (sender.tag == 1)  //// 完成
    {
        [self rebuildProgressView];
    }
    else  ///// 设置
    {
        beforeV = [[subViewBg subviews] indexOfObject:loadProgresView];
        afterV  = [[subViewBg subviews] indexOfObject:menuView];
    }
    
    [subViewBg exchangeSubviewAtIndex:beforeV withSubviewAtIndex:afterV];
    [[subViewBg layer] addAnimation:animation forKey:@"animation"];
}

- (IBAction)hiddenView:(UIButton*)sender
{
    [UIView animateWithDuration:0.7
                     animations:^(void){
                         [self.view setFrame:CGRectMake(0, 768, self.view.frame.size.width, self.view.frame.size.height)];
                     }
                     completion:^(BOOL finish){
                     }];
}

- (IBAction)stopAllTask:(UIButton*)sender
{
    
}

- (IBAction)openAllTask:(UIButton*)sender
{
    for (int i = 0; i < swViewAry.count; i++)
    {
        UISwitch *swView = [swViewAry objectAtIndex:i];
        [swView setOn:YES animated:YES];
    }
}

- (IBAction)closeAllTask:(UIButton*)sender
{
    for (int i = 0; i < swViewAry.count; i++)
    {
        UISwitch *swView = [swViewAry objectAtIndex:i];
        [swView setOn:NO animated:YES];
    }
}
@end
