//
//  LoaderViewController.m
//  TongDao
//
//  Created by sunyong on 13-12-9.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "LoaderViewController.h"
#import "AllVariable.h"

@interface LoaderViewController ()

@end

@implementation LoaderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

#define ScrolViewWidth 584
#define ScrolViewHeigh 582
#define ViewHeigh 60
- (void)viewDidLoad
{
    menuAry = [[NSMutableArray alloc] initWithObjects:@"音乐",@"风景", @"人文",@"物语",@"社区",@"视频",nil];
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
    for (int i = 0; i < menuAry.count; i++)
    {
        UIView *view = [self builtProgreeView:i+1];
        [progresScrolV addSubview:view];
    }
    [loadProgresView addSubview:progresScrolV];
    [progresScrolV setContentSize:CGSizeMake(584, 583)];
    [super viewDidLoad];
}

- (UIView*)builtProgreeView:(NSInteger)viewTag
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, (viewTag-1)*60, ScrolViewWidth, ViewHeigh)];
    view.tag = viewTag*10;
    
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
    implyLb.tag = viewTag*1000;
    implyLb.textColor = [UIColor grayColor];
    implyLb.backgroundColor = [UIColor clearColor];
    implyLb.font = [UIFont systemFontOfSize:16];
    implyLb.text = @"等待中";
    [view addSubview:implyLb];
    
    UIButton *canleBt = [UIButton buttonWithType:UIButtonTypeCustom];
    [canleBt setBackgroundColor:[UIColor lightGrayColor]];
    [canleBt setTitle:@"取消" forState:UIControlStateNormal];
    canleBt.titleLabel.font = [UIFont systemFontOfSize:14];
    [canleBt addTarget:self action:@selector(canleLoader:) forControlEvents:UIControlEventTouchDown];
    [canleBt setFrame:CGRectMake(ScrolViewWidth-40-10, 20, 40, 20)];
    [view addSubview:canleBt];
    
    if (viewTag == menuAry.count)
    {
        UILabel *bottomLineLb = [[UILabel alloc] initWithFrame:CGRectMake(0, ViewHeigh-1, ScrolViewWidth, 1)];
        bottomLineLb.backgroundColor = [UIColor lightGrayColor];
        [view addSubview:bottomLineLb];
    }
    return view;
}
- (UIView*)builtMenuView:(NSInteger)viewTag
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, (viewTag-1)*60, ScrolViewWidth, ViewHeigh)];
    view.tag = viewTag*10;
    
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
    swithV.tag = viewTag*1000;
    [view addSubview:swithV];
    
    if (viewTag == menuAry.count)
    {
        UILabel *bottomLineLb = [[UILabel alloc] initWithFrame:CGRectMake(0, ViewHeigh-1, ScrolViewWidth, 1)];
        bottomLineLb.backgroundColor = [UIColor lightGrayColor];
        [view addSubview:bottomLineLb];
    }
    return view;
}

#pragma mark - Bt Event
- (void)canleLoader:(UIButton*)sender
{
    
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
    if (sender.tag == 1)
    {
        
    }
    else
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
    
}

- (IBAction)closeAllTask:(UIButton*)sender
{
    
}
@end
