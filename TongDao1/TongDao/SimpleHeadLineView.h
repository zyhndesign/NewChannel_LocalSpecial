//
//  SimpleHeadLineView.h
//  TongDao
//
//  Created by sunyong on 13-9-26.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkDelegate.h"
#import "TextLayoutView.h"

@interface SimpleHeadLineView : UIView<NetworkDelegate>
{
    UIImageView *proImageV;
    UILabel *titleLb;
    TextLayoutView *detailTextV;
    UILabel *timeLb;
    UILabel *yearLb;
    NSDictionary *_infoDict;
    UIImageView *videoImageV;
}
- (id)initWithInfoDict:(NSDictionary*)infoDict;
@end
