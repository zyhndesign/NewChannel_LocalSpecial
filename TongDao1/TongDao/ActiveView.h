//
//  ActiveView.h
//  TongDao
//
//  Created by sunyong on 13-9-17.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActiveView : UIView
{
    UILabel *oneLb;
    UILabel *two_oneLb;
    UILabel *two_twoLb;
    UILabel *thr_oneLb;
    UILabel *thr_twoLb;
    
    float oneAlpha;
    float twoAlpha;
    float thrAlpha;
    
    int count;
    BOOL stop;
}

- (void)startActive;
- (void)stopActive;
@end
