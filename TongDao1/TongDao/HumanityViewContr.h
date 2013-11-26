//
//  HumanityViewContr.h
//  TongDao
//
//  Created by sunyong on 13-9-15.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HumanityViewContr : UIViewController<UIScrollViewDelegate>
{
    IBOutlet UIScrollView *contentScrolV;
    IBOutlet UIImageView *mainImageV;
    
    UILabel *progressLb;
    
    NSArray *initAry;
    
    int pageLenght;
}
- (void)loadSubview:(NSArray*)ary;

@end
