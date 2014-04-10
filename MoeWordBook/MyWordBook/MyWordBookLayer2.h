//
//  WordBookLayer2.h
//  MoeWordBook
//
//  Created by lyy on 12-11-2.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"



#define fontSize_macro 20

@interface MyWordBookLayer2 : CCLayer<UITableViewDataSource,UITableViewDelegate>
{
    
    
    NSString * _languageString;
    
    CCSprite * _bgSprite;
    
    UISwipeGestureRecognizer *  horizontalRight;
    
    UISwipeGestureRecognizer * horizontalLeft;
    
    UITableView * _wordTabelView;
    
    int _nowWordIndex;
    
    NSMutableArray * _cellRectArray;
    
    //////////////////////////////////////
    
    float labelChangeSizeDuration1;
    float labelChangeSizeScale1;
    
    float labelChangeSizeDuration2;
    float labelChangeSizeScale2;
    
    BOOL isAnimeFinished;
    
    BOOL firstInTableViewLoad;
    
    NSMutableArray * _sentenceArray;
    
    int allTableViewIndex;
}


@property(nonatomic,retain)NSString * languageString;
@property(nonatomic,retain) CCSprite * bgSprite;

@property(nonatomic,retain)UITableView * wordTabelView;
@property(nonatomic,assign)int nowWordIndex;
@property(nonatomic,retain) NSMutableArray * cellRectArray;
@property(nonatomic,retain)NSMutableArray * sentenceArray;
@property(nonatomic,retain) CCMenuItemFont * wifiOr3gItemFont;

+(CCScene *) scene;

-(NSMutableArray *)downLoadSentence:(NSString *) parserStr;

@end
