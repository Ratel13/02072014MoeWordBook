//
//  MainLayer.h
//  MoeWordBook
//
//  Created by lyy on 12-10-30.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


#define menuPositionX_macro 240.0
#define menuPositionY_macro 320.0

@class OpenEarSTT;
@interface MainLayer : CCLayer<AVAudioSessionDelegate>
{
    
   
    
    NSString * _languageString;
    
    CGSize _screenSize;
    CCArray * _itemMenuArray;
    
    NSDictionary * _menuFountPlistDic;
    
    int _menuFontNum;
    
    
    int _menuFontCount;
    
    CCScheduler * _scheduler;
    
    CCRepeatForever * _scaleAction;
    
    CCMenuItemFont * _runActionItemFont;

    NSArray * languageArray;
    
    int languageArrayCount;
    
    NSMutableArray * musicArray;
    int musicIndex;
    AVAudioPlayer * thePlayer;
    NSURL * musicURL;

    OpenEarSTT * _openEarSTT;
}


@property(nonatomic,retain)NSString * languageString;
@property(nonatomic,retain)CCArray * itemMenuArray;
@property(nonatomic,retain)CCScheduler * scheduler;
@property(nonatomic,retain)NSDictionary * menuFountPlistDic;
@property(nonatomic,retain)CCRepeatForever * scaleAction;
@property(nonatomic,retain)CCMenuItemFont * runActionItemFont;
@property(nonatomic,retain)NSArray * languageArray;
@property(nonatomic,retain)OpenEarSTT * openEarSTT;


+(CCScene *) scene;
-(void)addMenuFont;
-(void)menuFontAnimation;


@end
