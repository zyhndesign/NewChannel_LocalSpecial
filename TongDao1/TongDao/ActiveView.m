//
//  ActiveView.m
//  TongDao
//
//  Created by sunyong on 13-9-17.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "ActiveView.h"

@implementation ActiveView

- (id)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(frame.origin.x, frame.origin.y, 40, 24);
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    [self addMySubView];
    return self;
}

- (void)addMySubView
{    
    self.backgroundColor = [UIColor clearColor];
    oneLb = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 8, 8)];
    oneLb.backgroundColor = [UIColor redColor];
    oneLb.alpha = 1;
    [self addSubview:oneLb];
    
    two_oneLb = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 8, 8)];
    two_oneLb.backgroundColor = [UIColor redColor];
    two_oneLb.alpha = 0.6;
    [self addSubview:two_oneLb];
    
    two_twoLb = [[UILabel alloc] initWithFrame:CGRectMake(24, 8, 8, 8)];
    two_twoLb.backgroundColor = [UIColor redColor];
    two_twoLb.alpha = 0.6;
    [self addSubview:two_twoLb];
    
    thr_oneLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 16, 8, 8)];
    thr_oneLb.backgroundColor = [UIColor redColor];
    thr_oneLb.alpha = 0.2;
    [self addSubview:thr_oneLb];
    
    thr_twoLb = [[UILabel alloc] initWithFrame:CGRectMake(32, 16, 8, 8)];
    thr_twoLb.backgroundColor = [UIColor redColor];
    thr_twoLb.alpha = 0.2;
    [self addSubview:thr_twoLb];
    
    oneAlpha = 1;
    twoAlpha = 0.6;
    thrAlpha = 0.2;
    count = 0;
}

- (void)dealloc
{
    [oneLb removeFromSuperview];
    [two_oneLb removeFromSuperview];
    [two_twoLb removeFromSuperview];
    [thr_oneLb removeFromSuperview];
    [thr_twoLb removeFromSuperview];
    oneLb     = nil;
    two_oneLb = nil;
    two_twoLb = nil;
    thr_oneLb = nil;
    thr_twoLb = nil;
}

- (void)startActive
{
    self.hidden = NO;
    if (stop)
        return;
    [UIView animateWithDuration:0.35f
                     animations:^(void){
                         oneLb.alpha = oneAlpha;
                         two_oneLb.alpha = twoAlpha;
                         two_twoLb.alpha = twoAlpha;
                         thr_oneLb.alpha = thrAlpha;
                         thr_twoLb.alpha = thrAlpha;
                     }
                     completion:^(BOOL finish){
                         ++count;
                         if (count%4 == 1 || count%4 == 2)
                             oneAlpha -= 0.4;
                         else
                             oneAlpha += 0.4;
                         if ((count+1)%4 == 1 || (count+1)%4 == 2)
                             twoAlpha -= 0.4;
                         else
                             twoAlpha += 0.4;
                         if ((count+2)%4 == 1 || (count+2)%4 == 2)
                             thrAlpha -= 0.4;
                         else
                             thrAlpha += 0.4;
                         [self startActive];
                     }];
}

- (void)stopActive
{
    stop = YES;
    count = 0;
    oneLb.alpha = 1;
    two_oneLb.alpha = 0.6;
    two_twoLb.alpha = 0.6;
    thr_oneLb.alpha = 0.4;
    thr_twoLb.alpha = 0.4;
    oneAlpha = 1;
    twoAlpha = 0.6;
    thrAlpha = 0.2;
    self.hidden = YES;
}
@end
