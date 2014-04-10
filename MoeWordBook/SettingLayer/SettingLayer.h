//
//  SettingLayer.h
//  MoeWordBook
//
//  Created by lyy on 12-12-29.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"



@interface SettingLayer : CCLayer<UITextFieldDelegate>
{
    NSString * _languageString;
    
    CCSprite * _bgSprite;
    
    NSMutableArray * _menuArray;
    
    CCMenuItemFont * _aItemFont;

    
    UITextField * _timeField;
    
    CCMenuItemSprite * _plusitemSprite;
    CCMenuItemSprite * _minusSprite;
    
}
@property(nonatomic,retain)NSString * languageString;
@property(nonatomic,retain) CCSprite * bgSprite;
@property(nonatomic,retain)NSMutableArray * menuArray;
@property(nonatomic,retain)CCMenuItemFont * aItemFont;

@property(nonatomic,retain)UITextField * timeField;
@property(nonatomic,retain)CCMenuItemSprite * plusitemSprite;
@property(nonatomic,retain)CCMenuItemSprite * minusSprite;

+(CCScene *) scene;
-(void)addBg;
-(void)setMenu;
-(void)addItem;

@end
