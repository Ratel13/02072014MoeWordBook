//
//  MainLayer.m
//  MoeWordBook
//
//  Created by lyy on 12-10-30.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "MainLayer.h"
#import "ExternalListLayer.h"
//#include <libxls/xls.h>
#include "ExcelParser.h"
#include "PersonalApiCplu.h"
#import "PersonalApi.h"

@implementation MainLayer


@synthesize languageString = _languageString;
@synthesize itemMenuArray = _itemMenuArray;
@synthesize menuFountPlistDic = _menuFountPlistDic;
@synthesize scheduler = _scheduler;
@synthesize scaleAction = _scaleAction;
@synthesize runActionItemFont = _runActionItemFont;
@synthesize languageArray = _languageArray;

+(CCScene *) scene
{
   
	CCScene *scene = [CCScene node];
	
	MainLayer *layer = [MainLayer node];
	
	[scene addChild: layer];
	
	return scene;
}




-(id) init
{

	if( (self=[super init]) )
    {
        
        if ([SingleTonTool defaultMemory].firstInMainLayer == YES)
        {
            [SingleTonTool defaultMemory].firstInMainLayer = NO;
            //[[SingleTonTool defaultMemory] playBackGroundSound];//播放背景音乐
        }
        
		_screenSize = [[CCDirector sharedDirector] winSize];
        
        self.itemMenuArray = [CCArray arrayWithCapacity:0];
        
        {
            CCSprite * bgSprite = [CCSprite spriteWithFile:@"hatsunemiku1.jpg"];
            
            
            bgSprite.scaleX = 0.5;
            bgSprite.scaleY = 0.5;
            [bgSprite setAnchorPoint:ccp(0,0)];
            bgSprite.position = ccp(0,8);
            
            
            [self addChild:bgSprite];
        }
        

        [self addMenuFont];
      
	}
	return self;
}

-(void)addMenuFont
{

    NSString * searchPath = [[NSBundle mainBundle] pathForResource:@"MainLayer" ofType:@"plist"];
    _menuFountPlistDic = [[NSDictionary alloc]initWithContentsOfFile:searchPath];
    
    
    _menuFontNum = [_menuFountPlistDic count];


    float initialWidth = menuPositionX_macro;
    float initialHeight = menuPositionY_macro;
    
    NSUserDefaults * _aUserDefaults = [NSUserDefaults standardUserDefaults];//开启持久化储存类
    
    //获取语言种类
    {
    
        NSDictionary * objDic = [_menuFountPlistDic objectForKey:@"0"];
       
        NSDictionary * nameDic = [objDic objectForKey:@"name"];
      
       
        _languageArray = [[NSArray alloc] initWithArray:[nameDic allKeys] copyItems:YES];
    }
    
    
    int inAppTimes = [_aUserDefaults integerForKey:@"isFirstInApp"];
   
    if (inAppTimes ==0)//first time in app
    {
        inAppTimes++;
        [_aUserDefaults setInteger:inAppTimes forKey:@"isFirstInApp"];
        
  
        languageArrayCount = 1;//选择语言0=日文；1=中文；2=英语
        NSString * aLanguageString = [_languageArray objectAtIndex:languageArrayCount];
        [_aUserDefaults setObject:aLanguageString forKey:@"language"];
        
        
       
        NSMutableDictionary * myListDic = (NSMutableDictionary *)[_aUserDefaults objectForKey:@"myListDic"];
        
        NSMutableDictionary * aDic = [[NSMutableDictionary alloc] initWithDictionary:myListDic copyItems:YES];
        NSMutableArray * aArray = [[NSMutableArray alloc] initWithCapacity:0];
        [aDic setObject:aArray forKey:@"MyList"];
        
        [_aUserDefaults setObject:aDic forKey:@"myListDic"];
        
        NSMutableArray * myListNameArray = [[NSMutableArray alloc] initWithCapacity:0];
        [myListNameArray addObject:@"MyList"];
        [_aUserDefaults setObject:myListNameArray forKey:@"myListNameArray"];
        
        
        [_aUserDefaults setFloat:3.0 forKey:@"autoPlayTime"];
        
        
    
        //NSLog(@"first!");
    }
    else
    {
        //NSLog(@"NoFirst!");
    }
    
    
 
    
    _languageString = [_aUserDefaults objectForKey:@"language"];
    languageArrayCount++;
    
    //make menu
    for (int i = 0; i<_menuFontNum; i++)
    {
    
        NSDictionary * objDic = [_menuFountPlistDic objectForKey:[NSString stringWithFormat:@"%d",i]];
        NSDictionary * nameDic = [objDic objectForKey:@"name"];
        
        
        NSString * aString = [nameDic objectForKey:_languageString];
        
        
        CCMenuItemFont * aItemFont = [CCMenuItemFont itemWithString:aString target:self selector:@selector(menuMethod:)];
        CGPoint aPoint = CGPointMake(initialWidth, initialHeight- aItemFont.contentSize.height*(i+1)*1.7+12);
        aItemFont.position =  aPoint;
        [aItemFont setFontSize:20];
        [_itemMenuArray addObject:aItemFont];
        
        CCMenu * aMenu = [CCMenu menuWithItems:nil];
        aMenu.position = ccp(0,0);
        [aMenu addChild:aItemFont];
        [self addChild:aMenu];
        
    }
    
    [self menuFontAnimation];
    
}
-(void)menuFontAnimation
{
   
    [NSTimer scheduledTimerWithTimeInterval:_menuFontNum*0.7 target:self selector:@selector(menuChangeString) userInfo:nil repeats:YES];
    
     _menuFontCount = 0;
    id ac1 = [CCScaleTo actionWithDuration:0.5 scaleX:1.5 scaleY:1.5];
    id ac2 = [CCScaleTo actionWithDuration:0.2 scaleX:1 scaleY:1];
    id acf = [CCCallFunc actionWithTarget:self selector:@selector(animeFinish)];
    
    CCSequence * seq = [CCSequence actions:ac1,ac2,acf,nil];
   _scaleAction = [CCRepeatForever actionWithAction:seq];
    
    CCMenuItemFont * aItemFont = [_itemMenuArray objectAtIndex:_menuFontCount];
    _menuFontCount++;
    _runActionItemFont = aItemFont;
    [aItemFont runAction:_scaleAction];
    
}

-(void)menuChangeString
{
 
    if (languageArrayCount == [_languageArray count])
    {
        languageArrayCount = 0;
    }
    
    _languageString = [_languageArray objectAtIndex:languageArrayCount];
    languageArrayCount++;

    for (int i  = 0; i<[_itemMenuArray count]; i++)
    {
        
        NSDictionary * objDic = [_menuFountPlistDic objectForKey:[NSString stringWithFormat:@"%d",i]];
        NSDictionary * nameDic = [objDic objectForKey:@"name"];
        
        NSString * aString = [nameDic objectForKey:_languageString];
        
        CCMenuItemFont * aItemFont = [_itemMenuArray objectAtIndex:i];
        [aItemFont setString:aString];
    }
  
    
}

-(void)animeFinish
{
    [_runActionItemFont stopAllActions];
    
    if (_menuFontCount>_menuFontNum-1)
    {
        _menuFontCount = 0;
    }
    
    
    CCMenuItemFont * aItemFont = [_itemMenuArray objectAtIndex:_menuFontCount];
    _runActionItemFont = aItemFont;
    [aItemFont runAction:_scaleAction];
    
    _menuFontCount++;
}

-(void)menuMethod:(CCMenuItemFont *)aItemFont
{
   
    
    [PersonalApi playSoundEffect:@"nextButtonEffect.mp3"];//按键音效
    
    int aNum = 0;
    
    for(CCMenuItemFont * tempItemFont in _itemMenuArray)
    {
       
        if (aItemFont ==  tempItemFont)
        {
            //[aItemFont setString:[NSString stringWithFormat:@"Finish%d",aNum+1]];
    
            NSDictionary * objDic = [_menuFountPlistDic objectForKey:[NSString stringWithFormat:@"%d",aNum]];
            
  
            NSString * sceneString = [objDic objectForKey:@"methodGoToScene"];
            
            
            if ([sceneString length]>0)
            {
                
               /* for(CCMenuItemFont * tempItemFont in _itemMenuArray)
                {
                    id ac = [CCMoveTo actionWithDuration:0.5 position:ccp(0,0)];
                    [tempItemFont runAction:ac];
                }
                */
                
                id aClass = NSClassFromString(sceneString);
                
                [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[aClass scene] withColor:ccWHITE]];
                
            }
        }
        else
        {
            aNum++;
        }
    }
 
}
- (void) dealloc
{

    [_itemMenuArray release];
    _itemMenuArray = nil;
    
	[super dealloc];
}


@end
