//
//  MyListAllWordLayer.m
//  MoeWordBook
//
//  Created by lyy on 12-11-6.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyListAllWordLayer.h"
#import "MyListAllWordViewController.h"
#import "MyWordBookLayer1.h"
#include "ExcelParser.h"

@implementation MyListAllWordLayer
@synthesize myListAllWordViewController = _myListAllWordViewController;

@synthesize bgSprite = _bgSprite;
@synthesize fileListArray = _fileListArray;
@synthesize fromListName = _fromListName;

@synthesize editaItemFont =_editaItemFont;

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	
	MyListAllWordLayer *layer = [MyListAllWordLayer node];
	
	[scene addChild: layer];
	
	return scene;
}

-(id) init
{
    
	if( (self=[super init]) )
    {

        isEditing = NO;
        
        
        NSString * bgString = @"hatsunemiku12.jpg";
        
        _bgSprite = [CCSprite spriteWithFile:bgString];
        
        _bgSprite.position = CGPointMake(self.contentSize.width/2,self.contentSize.height/2);
        _bgSprite.scale = 0.9;
        [self addChild:_bgSprite];
        
        [SingleTonTool defaultMemory].fontColor = ccBLUE;//CCMenuItemFont字体颜色设置
        {
            CCMenuItemFont * aItemFont = [CCMenuItemFont itemWithString:@"BACK" target:self selector:@selector(BACK:)];
            [aItemFont setColor:ccBLACK];
            CGPoint aPoint = CGPointMake(self.boundingBox.size.width-aItemFont.contentSize.width,aItemFont.contentSize.height);
            aItemFont.position =  aPoint;
            [aItemFont setFontSize:60];
            
            
            CCMenu * aMenu = [CCMenu menuWithItems:nil];
            aMenu.position = ccp(0,0);
            [aMenu addChild:aItemFont];
            [self addChild:aMenu];
        }
        
        //生成excel表
        {
            CCMenuItemFont * aItemFont = [CCMenuItemFont itemWithString:@"Excel" target:self selector:@selector(MakeExcel:)];
            [aItemFont setColor:ccBLACK];
            CGPoint aPoint = CGPointMake(aItemFont.contentSize.width,self.boundingBox.size.height-aItemFont.contentSize.height);
            aItemFont.position =  aPoint;
            [aItemFont setFontSize:60];
            
            
            CCMenu * aMenu = [CCMenu menuWithItems:nil];
            aMenu.position = ccp(0,0);
            [aMenu addChild:aItemFont];
            [self addChild:aMenu];
        }
        
        
        {
            _editaItemFont = [CCMenuItemFont itemWithString:@"Edit" target:self selector:@selector(Edit:)];
            [_editaItemFont setColor:ccBLACK];
            CGPoint aPoint = CGPointMake(self.boundingBox.size.width-_editaItemFont.contentSize.width,self.boundingBox.size.height-_editaItemFont.contentSize.height);
            _editaItemFont.position =  aPoint;
            [_editaItemFont setFontSize:60];
            
            
            CCMenu * aMenu = [CCMenu menuWithItems:nil];
            aMenu.position = ccp(0,0);
            [aMenu addChild:_editaItemFont];
            [self addChild:aMenu];
        }
        [SingleTonTool defaultMemory].fontColor = ccWHITE;//CCMenuItemFont字体颜色设置
        [self performSelector:@selector(setUpTableView) withObject:nil afterDelay:0.5]; 
   	}
	return self;
}

-(void)setUpTableView
{
    _myListAllWordViewController = [[MyListAllWordViewController alloc] init];
    _myListAllWordViewController.tableView.frame = CGRectMake(0,0, self.boundingBox.size.width/2, self.boundingBox.size.height);
    _myListAllWordViewController.tableView.center = CGPointMake(self.boundingBox.size.width/2, self.boundingBox.size.height/2);
    
    _myListAllWordViewController.fromListName = _fromListName;
    [_myListAllWordViewController.tableView setBackgroundColor:[UIColor clearColor]];
    
    [[[CCDirector sharedDirector] view] addSubview:_myListAllWordViewController.tableView];
    
    
}

-(void)BACK:(CCMenuItemFont * )aItemFont
{
    if (isEditing == NO)
    {
        
        [PersonalApi playSoundEffect:@"backButtonEffect.mp3"];//按键音效
        
        NSUserDefaults * _aUserDefaults = [NSUserDefaults standardUserDefaults];//开启持久化储存类
        
        NSMutableDictionary * myListDic = (NSMutableDictionary *)[_aUserDefaults objectForKey:@"myListDic"];
        
     
        NSMutableDictionary * aDic = [[NSMutableDictionary alloc] initWithDictionary:myListDic copyItems:YES];
        
        
        [aDic setObject:[SingleTonTool defaultMemory].wordListArray forKey:_fromListName];
        
        [_aUserDefaults setObject:aDic forKey:@"myListDic"];
        
        [_myListAllWordViewController.tableView removeFromSuperview];
        
        CCScene *scene = [CCScene node];
        MyWordBookLayer1 * myListAllWordLayer = [[MyWordBookLayer1 alloc]init];
        [scene addChild:myListAllWordLayer];
        
        myListAllWordLayer.fromListName = _fromListName;
        
        
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:scene withColor:ccWHITE]];
    }
}

-(void)MakeExcel:(CCMenuItemFont * )aItemFont
{
    if (isEditing == NO)
    {
    [PersonalApi playSoundEffect:@"appearButtonEffect.mp3"];//按键音效
    const char * listName = [_fromListName UTF8String];
    
    ExcelParser::writeExcel(listName);
    }
}

-(void)Edit:(CCMenuItemFont * )aItemFont
{
    [PersonalApi playSoundEffect:@"appearButtonEffect.mp3"];//按键音效
    if (isEditing == NO)
    {
        
        [_editaItemFont setString:@"Done"];
        [self.myListAllWordViewController setEditing:!isEditing animated:YES];//设置状态为可编辑
        
        [self.myListAllWordViewController.tableView setEditing:!isEditing animated:YES];
        
        
    }
    else
    {
        [_editaItemFont setString:@"Edit"];
        
        [self.myListAllWordViewController setEditing:!isEditing animated:YES];//设置状态为可编辑
        
        [self.myListAllWordViewController.tableView setEditing:!isEditing animated:YES];
    }
    
    isEditing = !isEditing;
}
@end
