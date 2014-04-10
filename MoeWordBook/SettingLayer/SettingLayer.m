//
//  SettingLayer.m
//  MoeWordBook
//
//  Created by lyy on 12-12-29.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingLayer.h"
#import "MainLayer.h"



@implementation SettingLayer

@synthesize languageString = _languageString;
@synthesize bgSprite = _bgSprite;
@synthesize menuArray = _menuArray;
@synthesize aItemFont = _aItemFont;


@synthesize timeField = _timeField;
@synthesize plusitemSprite = _plusitemSprite;
@synthesize minusSprite = _minusSprite;


+(CCScene *) scene
{
    
	CCScene *scene = [CCScene node];
	
	SettingLayer *layer = [SettingLayer node];
	
	[scene addChild: layer];
	
	return scene;
}


-(id) init
{
    
	if( (self=[super init]) )
    {
        //  读取语言
        NSUserDefaults * _aUserDefaults = [NSUserDefaults standardUserDefaults];
        _languageString = [_aUserDefaults objectForKey:@"language"];
        
        
        _menuArray= [[NSMutableArray alloc] initWithCapacity:0];
        
        //注册监听   1.dele类，2.优先级，3.YES为阻碍其他类的move 和 end
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:1000 swallowsTouches:YES];
        
        
        [self addBg];
        
        [self setMenu];
        
        [self addItem];
	}
	return self;
}

-(void)addBg
{
    _bgSprite = [CCSprite spriteWithFile:@"hatsunemiku11.jpg"];
    
    _bgSprite.position = CGPointMake(self.contentSize.width/15,self.contentSize.height/15);
    
    _bgSprite.contentSize = CGSizeMake(self.contentSize.width/8,self.contentSize.height/8);
    
    [self addChild:_bgSprite];
}

-(void)setMenu
{
    
    int offsetX = 20;
    
    [SingleTonTool defaultMemory].fontColor = ccBLUE;
    {
        CCMenuItemFont * aItemFont = [CCMenuItemFont itemWithString:@"BACK" target:self selector:@selector(back:)];
        CGPoint aPoint = CGPointMake(self.boundingBox.size.width-aItemFont.contentSize.width-offsetX,aItemFont.contentSize.height);
        aItemFont.position =  aPoint;
        [aItemFont setFontSize:30];
        [aItemFont setFontName:@"Zapfino"];
        
        CCMenu * aMenu = [CCMenu menuWithItems:nil];
        aMenu.position = ccp(0,0);
        [aMenu addChild:aItemFont];
        [self addChild:aMenu];
        [_menuArray addObject:aMenu];
    }
 
    [SingleTonTool defaultMemory].fontColor = ccWHITE;
    
}

-(void)back:(CCMenuItemFont * )aItemFont
{
    [_timeField removeFromSuperview];
    [PersonalApi playSoundEffect:@"backButtonEffect.mp3"];//按键音效
    [SingleTonTool defaultMemory].nowWordIndex = 0;
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[MainLayer scene]]];
}
-(void)addItem
{
    [self performSelector:@selector(setUpTimeField) withObject:nil afterDelay:0.5];

  /*
   
   CCMenu * aMenu = [CCMenu menuWithItems:nil];
    aMenu.position = ccp(0,0);
 
    [self addChild:aMenu];
    //加号
    {
        CCSprite* sprite1 = [CCSprite spriteWithFile:@"sound.png"];
        [sprite1 setColor:ccRED];
        CCSprite* sprite2 = [CCSprite spriteWithFile:@"sound.png"];
        //[sprite2 setColor:ccBLACK];
        _plusitemSprite=[CCMenuItemSprite itemWithNormalSprite:sprite1 selectedSprite:sprite2 target:self selector:@selector(plus)];
        
        
        _plusitemSprite.position=ccp(_timeField.center.x+_timeField.frame.size.width/2-_plusitemSprite.contentSize.width,_timeField.center.y);
        _plusitemSprite.visible=YES;
        
        [aMenu addChild:_plusitemSprite];
    }
    
    //减号
    {
        CCSprite* sprite1 = [CCSprite spriteWithFile:@"sound.png"];
        [sprite1 setColor:ccRED];
        CCSprite* sprite2 = [CCSprite spriteWithFile:@"sound.png"];
        //[sprite2 setColor:ccBLACK];
        _minusSprite=[CCMenuItemSprite itemWithNormalSprite:sprite1 selectedSprite:sprite2 target:self selector:@selector(minus)];
        
        
        _minusSprite.position=ccp(_timeField.center.x+_timeField.frame.size.width/2+_plusitemSprite.contentSize.width,_timeField.center.y);
        _minusSprite.visible=YES;
        
        [aMenu addChild:_minusSprite];
    
    }
    */
}
-(void)setUpTimeField
{
    _timeField = [[UITextField alloc] initWithFrame:CGRectMake(self.boundingBox.size.width/2, self.boundingBox.size.height/8,self.boundingBox.size.width/6, self.boundingBox.size.height/8)];
    _timeField.backgroundColor = [UIColor redColor];
    
    _timeField.delegate = self;
    NSUserDefaults * _aUserDefaults = [NSUserDefaults standardUserDefaults];//开启持久化储存类
    
    float autoPlayTime = [_aUserDefaults floatForKey:@"autoPlayTime"];
    NSString * autoPlayTimeString = [NSString stringWithFormat:@"%.0f",autoPlayTime];
    _timeField.placeholder = autoPlayTimeString;
    _timeField.textColor = [UIColor blackColor];
    _timeField.autocorrectionType = UITextAutocorrectionTypeNo;
    _timeField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _timeField.returnKeyType = UIReturnKeyDone;
    [[[CCDirector sharedDirector] view] addSubview:_timeField];
    
}
/*
-(void)plus
{
    
}

-(void)minus
{
    
}
*/
#pragma mark - return键方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_timeField resignFirstResponder];
    
    return YES;
}


-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    if (touch.view != _timeField)
    {
        [_timeField resignFirstResponder];
    }
    return YES;
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSUserDefaults * _aUserDefaults = [NSUserDefaults standardUserDefaults];//开启持久化储存类

    NSString * autoPlayTimeString = _timeField.text;
    
    [_aUserDefaults setFloat:[autoPlayTimeString floatValue] forKey:@"autoPlayTime"];
    
}


@end
