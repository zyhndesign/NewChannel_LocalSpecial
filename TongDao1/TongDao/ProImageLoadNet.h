//
//  ProImageLoadNet.h
//  GYSJ
//
//  Created by sunyong on 13-9-12.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkDelegate.h"

@interface ProImageLoadNet : NSObject
{
    NSMutableData *backData;
    int connectNum;
    NSDictionary *_infoDict;
    NSString *imageUrl;
}
@property(nonatomic, assign)id<NetworkDelegate>delegate;
@property(nonatomic, strong)NSDictionary *_infoDict;
@property(nonatomic, strong)NSString *imageUrl;

- (id)initWithDict:(NSDictionary*)infoDict;
- (void)loadImageFromUrl;
@end
