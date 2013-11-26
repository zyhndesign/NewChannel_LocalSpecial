//
//  VersionViewContr.m
//  TongDao
//
//  Created by sunyong on 13-9-17.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//
/*
 通道侗族自治县位于湖南、广西、贵州三省交界处，通道全县总人口22.5万人，其中侗族人口占到78.4%，境内生态环境极为秀美，民族文化保存完好，被誉为“侗族文化圣地”，是充分展示侗族之魅力、文化之灿烂、社会之和谐的福地。
 虽然通道物产丰富，森林覆盖率达74%，年产商品材17万立方米，但经济形式单一，至今仍然是全国贫困县，2008年农民人均纯收入1571元。
 本项目针对通道这样一个具备“独特的自然生态环境与丰富的非物质文化遗产”但经济发展落后的少数民族地区，整合不同专业和学科的优势，通过合理的村镇规划、生态旅游开发、信息与物流网络建设、产品与服务系统整合、非物质文化遗产保护等综合的工作方法，建立一个国际化的设计创新联盟和基于网络的信息平台，参与式的促进当地居民的文化自主意识和产业创新。在保持当地居民的和谐生活形态和发展需要的前提下，实现从落后的农耕文明社区，不经历资源消耗型的工业发展阶段，直接“蛙跳”进入以文化和信息为中心的创新社区，成为新型工业化和两型社会的典范。
 */
#import "VersionViewContr.h"

@interface VersionViewContr ()

@end

@implementation VersionViewContr

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    NSString *string = [NSString stringWithFormat:@"通道侗族自治县位于湖南、广西、贵州三省交界处，通道全县总人口22.5万人，其中侗族人口占到78.4%，境内生态环境极为秀美，民族文化保存完好，被誉为“侗族文化圣地”，是充分展示侗族之魅力、文化之灿烂、社会之和谐的福地。\n虽然通道物产丰富，森林覆盖率达74%，年产商品材17万立方米，但经济形式单一，至今仍然是全国贫困县，2008年农民人均纯收入1571元。\n本项目针对通道这样一个具备“独特的自然生态环境与丰富的非物质文化遗产”但经济发展落后的少数民族地区，整合不同专业和学科的优势，通过合理的村镇规划、生态旅游开发、信息与物流网络建设、产品与服务系统整合、非物质文化遗产保护等综合的工作方法，建立一个国际化的设计创新联盟和基于网络的信息平台，参与式的促进当地居民的文化自主意识和产业创新。在保持当地居民的和谐生活形态和发展需要的前提下，实现从落后的农耕文明社区，不经历资源消耗型的工业发展阶段，直接“蛙跳”进入以文化和信息为中心的创新社区，成为新型工业化和两型社会的典范。"];
    self.view.backgroundColor = [UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:1];
    [super viewDidLoad];
    
    detailTextV.text = string;
    detailTextV.linesSpacing = 6;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
