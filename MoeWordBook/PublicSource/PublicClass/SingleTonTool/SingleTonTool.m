//
//  SingleTonTool.m
//  PDFTest
//
//  Created by lyy on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SingleTonTool.h"
#import "cocos2d.h"
static SingleTonTool * singleTonTool = nil;

@implementation SingleTonTool


@synthesize wordListArray = _wordListArray;
@synthesize nowWordIndex = _nowWordIndex;
@synthesize fontColor = _fontColor;
@synthesize firstInMainLayer = _firstInMainLayer;
@synthesize musicArray = _musicArray;
@synthesize musicIndex = _musicIndex;
@synthesize thePlayer = _thePlayer;
@synthesize musicURL = _musicURL;
@synthesize playerArray = _playerArray;
@synthesize isAlerted =_isAlerted;

- (id)init
{
    self = [super init];
    if (self) 
    {

        _wordListArray = [[NSMutableArray alloc] initWithCapacity:0];
        
    
        
        _nowWordIndex = 0;
        
        _fontColor = ccWHITE;
        
        _firstInMainLayer = YES;
        
        _playerArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        self.isAlerted = false;
       
    }
    
    return self;
}




-(void)dealloc
{
    
    [_wordListArray release];
    _wordListArray = nil;
    
    
    [_playerArray release];
    _playerArray = nil;
    /*[_ release];
    _ = nil;*/
    
    _isAlerted = nil;
    
    [super dealloc];
}


+(SingleTonTool *)defaultMemory
{
    if (!singleTonTool)
    {
        singleTonTool = [[SingleTonTool alloc] init];
    }
    
    return singleTonTool;
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    [self orderToPlayBackGroundMusic];
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
    [self orderToPlayBackGroundMusic];
    
}
-(void)orderToPlayBackGroundMusic
{

    [SingleTonTool defaultMemory].musicIndex++;
    if ([SingleTonTool defaultMemory].musicIndex == [[SingleTonTool defaultMemory].musicArray count])
    {
        [SingleTonTool defaultMemory].musicIndex = 0;
    }
    NSString * musicName = [[SingleTonTool defaultMemory].musicArray objectAtIndex:[SingleTonTool defaultMemory].musicIndex];
   
   
    NSString * musicFilePath = [[NSBundle mainBundle] pathForResource:musicName ofType:@"mp3"];      //创建音乐文件路径
 
    NSURL * musicURL= [[NSURL alloc] initFileURLWithPath:musicFilePath];
    AVAudioPlayer * thePlayer  = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil];
    thePlayer.delegate = self;
    [thePlayer play];
    [thePlayer setVolume:1];   //设置音量大小
    thePlayer.numberOfLoops = 1;//设置音乐播放次数  -1为一直循环
    
    [musicURL release];
    
    [SingleTonTool defaultMemory].thePlayer = thePlayer;
    [[SingleTonTool defaultMemory].playerArray removeAllObjects];
    [[SingleTonTool defaultMemory].playerArray addObject:thePlayer];
    
    
}
-(void)playBackGroundSound
{
    [SingleTonTool defaultMemory].musicArray = [[NSMutableArray alloc] initWithCapacity:0];
    
   /* [[SingleTonTool defaultMemory].musicArray addObject:@"初音ミク-World Is Mine"];
    [[SingleTonTool defaultMemory].musicArray addObject:@"Avril Lavigne-Girlfrieng"];
    [[SingleTonTool defaultMemory].musicArray addObject:@"浜崎あゆみ-evolution"];
    [[SingleTonTool defaultMemory].musicArray addObject:@"植物大战僵尸 通关歌曲"];
    [[SingleTonTool defaultMemory].musicArray addObject:@"初音ミク-炉心融解"];
    [[SingleTonTool defaultMemory].musicArray addObject:@"杜岩-千年缘《仙剑奇侠传四》主题曲"];
    [[SingleTonTool defaultMemory].musicArray addObject:@"初音ミク-深海少女"];
    */
    
    int k = arc4random()%3;
    
    switch (k)
    {
        case 0:
            [SingleTonTool defaultMemory].musicIndex = 0;
            break;
        case 1:
            [SingleTonTool defaultMemory].musicIndex = 2;
            break;
        case 2:
            [SingleTonTool defaultMemory].musicIndex = 3;
            break;
            
        default:
            [SingleTonTool defaultMemory].musicIndex = 3;
            break;
    }
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
    if(err)
    {
        NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        
    }
    [audioSession setActive:YES error:&err];
    err = nil;
    if(err)
    {
        NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        
    }
    
    //禁止程序运行时自动锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    
    NSString * musicFilePath = [[NSBundle mainBundle] pathForResource:[[SingleTonTool defaultMemory].musicArray objectAtIndex:[SingleTonTool defaultMemory].musicIndex] ofType:@"mp3"];      //创建音乐文件路径
   NSURL * musicURL= [[NSURL alloc] initFileURLWithPath:musicFilePath];
    
    AVAudioPlayer * thePlayer  = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil];
    thePlayer.delegate = self;
    [thePlayer play];
    [thePlayer setVolume:1];   //设置音量大小
    thePlayer.numberOfLoops = 1;//设置音乐播放次数  -1为一直循环
    
    [musicURL release];
    [[SingleTonTool defaultMemory].playerArray addObject:thePlayer];
    [SingleTonTool defaultMemory].thePlayer = thePlayer;
    
    
    
    
    //播一半的歌曲退出后台后停止
    /*MPMusicPlayerController *musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
     MPMusicPlaybackState playbackState = musicPlayer.playbackState;
     if (playbackState == MPMusicPlaybackStateStopped || playbackState == MPMusicPlaybackStatePaused) {
     [musicPlayer play];
     } else if (playbackState == MPMusicPlaybackStatePlaying) {
     [musicPlayer pause];
     }*/
    
}



@end
