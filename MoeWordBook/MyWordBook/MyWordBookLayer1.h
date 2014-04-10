//
//  WordBookLayer.h
//  MoeWordBook
//
//  Created by lyy on 12-11-1.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "VoiceRecognition.h"

#define labelChangeSizeDuration1_macro 0.4
#define labelChangeSizeScale1_macro 1.5

#define labelChangeSizeDuration2_macro 0.3
#define labelChangeSizeScale2_macro 4.5

@class VoiceRecognition;
@interface MyWordBookLayer1 : CCLayer
{
    NSString * _languageString;
    
    CCSprite * _bgSprite;
    
    NSMutableArray * _bgArray;
    
    int _bgInArrayIndex;
    
    
    UISwipeGestureRecognizer *  horizontalRight;

    UISwipeGestureRecognizer * horizontalLeft;
    
    int _nowWordIndex;
    
    CCMenuItemFont * _aItemFont;
    
    CCLabelTTF * _indexlabel;
    //////////////////////////////////////
    
    
    
    float labelChangeSizeDuration1; 
    float labelChangeSizeScale1; 
    
    float labelChangeSizeDuration2;
    float labelChangeSizeScale2;
    
    BOOL isAnimeFinished;
    
    NSString * _fromListName;
    
    BOOL isStopAllAction;
    
    NSMutableArray * _menuArray;
    int _sameWordReplaceInArrayIndex;
    NSString * _memoryListName;
    
    
    CCMenuItemSprite * _itemSprite;
    
    BOOL isOpenSpeechToText;
    BOOL isChangeModel;
    
    CCMenuItemFont * _playItemFont;
    CCMenuItemFont * _wifiOr3gItemFont;
    
    NSMutableData * _receiveData;
    
    VoiceRecognition * _aVoiceRecognition;
    
}


@property(nonatomic,retain)NSString * languageString;
@property(nonatomic,retain) CCSprite * bgSprite;
@property(nonatomic,retain)  NSMutableArray * bgArray;
@property(nonatomic,assign)int bgInArrayIndex;
@property(nonatomic,assign)int nowWordIndex;
@property(nonatomic,retain)CCMenuItemFont * aItemFont;
@property(nonatomic,retain)CCLabelTTF * indexlabel;
@property(nonatomic,retain)NSString * fromListName;
@property(nonatomic,retain)NSMutableArray * menuArray;
@property(nonatomic,assign)int sameWordReplaceInArrayIndex;
@property(nonatomic,retain)NSString * memoryListName;
@property(nonatomic,retain)CCMenuItemSprite * itemSprite;
@property(nonatomic,assign) BOOL isChangeModel;
@property(nonatomic,retain) CCMenuItemFont * playItemFont;
@property(nonatomic,retain) CCMenuItemFont * wifiOr3gItemFont;
@property(nonatomic,retain)NSMutableData * receiveData;
@property(nonatomic,retain) NSString * recogniztionResult;
@property(nonatomic,retain)VoiceRecognition * aVoiceRecognition;

+(CCScene *) scene;
-(void)addBg;
-(void)setMenu;
-(void)showWord;
-(void)setAllActionStart;
-(void)setSameWordReplaceInArrayIndex:(int)sameWordReplaceInArrayIndex ListName:(NSString *) listNameString;

-(void)turnLeft;
-(void)turnRight;

-(void)changeModel;
-(void) autoPlay;
-(void) speechRecognition;
-(NSString *)downLoadPhonetic:(NSString *) parserStr;
-(BOOL)downLoadSound:(NSString *) parserStr;
-(void)recogniztionResult:(NSString *)resultStr;

@end
