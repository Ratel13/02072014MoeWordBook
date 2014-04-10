//
//  SingleTonTool.h
//  PDFTest
//
//  Created by lyy on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface SingleTonTool : NSObject<AVAudioPlayerDelegate>
{
    NSMutableArray * _wordListArray;
    int _nowWordIndex;
    
    ccColor3B  _fontColor;
    BOOL firstInMainLayer;
    
    
    
    ///唱机部分
    NSMutableArray * _musicArray;
    int _musicIndex;
    AVAudioPlayer * _thePlayer;
    NSURL * _musicURL;
    NSMutableArray * _playerArray;
    ///唱机部分
    
    NSMutableArray * _pronunceArray;
    NSMutableArray * _sentenceArray;
    
    BOOL _isAlerted;
}

@property(nonatomic,retain)NSMutableArray * wordListArray;
@property(nonatomic,assign)int nowWordIndex;
@property(nonatomic,assign)ccColor3B fontColor;
@property(nonatomic,assign)BOOL firstInMainLayer;

///唱机部分
@property(nonatomic,retain)NSMutableArray * musicArray;
@property(nonatomic,assign)int musicIndex;
@property(nonatomic,retain)AVAudioPlayer * thePlayer;
@property(nonatomic,retain)NSURL * musicURL;
@property(nonatomic,retain)NSMutableArray * playerArray;

@property(nonatomic,assign)BOOL isAlerted;


+(SingleTonTool *)defaultMemory;
-(void)orderToPlayBackGroundMusic;
-(void)playBackGroundSound;


@end
