//
//  LoadSimpleMusicNet.m
//  TongDao
//
//  Created by sunyong on 13-11-26.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "LoadSimpleMusicNet.h"
#import "AllVariable.h"
#import "SimpleQueMusicHandle.h"

@implementation LoadSimpleMusicNet
@synthesize Name;
@synthesize musicUrl;

/**
 * version 2.0
 */
- (id)initWithClass:(Class)TClass
{
    self = [super init];
    if (self) {
        TaskClass = TClass;
    }
    return self;
}
- (void)loadMenuFromUrl
{
    [self loadMusicData:musicUrl musicName:Name];
}
- (void)cancelLoad
{
    if (connect)
        [connect cancel];
}

////////////////////////////////////////////////


- (void)loadMusicData:(NSString*)url musicName:(NSString*)musicName
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"music/%@", musicName]];
    BOOL dirt = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&dirt])
    { //// 音乐文件已经存在
        BOOL isExist = NO;
        for (int i = 0; i < AllMusicQueAry.count; i++)
        {
            if ([[AllMusicQueAry objectAtIndex:i] isEqualToString:musicName])
            {
                isExist = YES;
                break;
            }
        }
        if (!isExist) //// 音乐文件名不存在音乐名数组中，就添加进去
            [AllMusicQueAry addObject:musicName];
        [TaskClass setCurrentLenght:1];
        [TaskClass taskFinish:self];
        return;
    }
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0f];
    [request setHTTPMethod:@"GET"];
    Name = musicName;
    connect = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connect)
    {
        backData = [[NSMutableData alloc] init];
    }
    else
    {
        backData = nil;
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [backData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [TaskClass setCurrentLenght:1];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"music/%@", Name]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:filePath contents:backData attributes:nil];
    [AllMusicQueAry addObject:Name];
    [TaskClass taskFinish:self];
}

- (void)dealloc
{
    connect  = nil;
    backData = nil;
    Name     = nil;
}
@end
