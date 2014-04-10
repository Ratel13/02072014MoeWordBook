//
//  WordBookLayer.m
//  MoeWordBook
//
//  Created by lyy on 12-11-1.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyWordBookLayer1.h"
#import "MyWordBookLayer2.h"


#import "MyListLayer.h"

#import "MyListAllWordLayer.h"
#import "MyWordBookMaskView.h"

#import "PersonalApiCplu.h"

#import "VoiceRecognition.h"
#import "TTSOnline.h"

@implementation MyWordBookLayer1


@synthesize languageString = _languageString;
@synthesize bgSprite = _bgSprite;
@synthesize bgArray = _bgArray;
@synthesize bgInArrayIndex = _bgInArrayIndex;
@synthesize nowWordIndex = _nowWordIndex;
@synthesize aItemFont = _aItemFont;
@synthesize indexlabel = _indexlabel;
@synthesize fromListName = _fromListName;
@synthesize menuArray = _menuArray;
@synthesize sameWordReplaceInArrayIndex = _sameWordReplaceInArrayIndex;
@synthesize memoryListName =_memoryListName;
@synthesize itemSprite = _itemSprite;
@synthesize isChangeModel;
@synthesize playItemFont = _playItemFont;
@synthesize wifiOr3gItemFont = _wifiOr3gItemFont;
@synthesize receiveData = _receiveData;
@synthesize aVoiceRecognition = _aVoiceRecognition;

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	
	MyWordBookLayer1 *layer = [MyWordBookLayer1 node];
	
	[scene addChild: layer];
	
	return scene;
}

-(id) init
{
	if( (self=[super init]) )
    {
        /*
        TTSOnline * aTTSOnline = [[TTSOnline alloc] initWithLanguage:@"vixyun" Text:@"我是歌手第二季，是湖南卫视2014年第一季度重磅打造的歌手音乐对决电视节目。我是歌手2将于2014年1月3日黄金档周五晚20:10播出，乐视网会全程独家呈现我是"];
        
        [aTTSOnline StartTTS:self];
        */
        //  读取语言
        NSUserDefaults * _aUserDefaults = [NSUserDefaults standardUserDefaults];
        _languageString = [_aUserDefaults objectForKey:@"language"];
        
        
        if ([[SingleTonTool defaultMemory].wordListArray count]>0)
        {
            //Gesture swipe to right
            horizontalRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeToHorizontalRight:)];
            
            [horizontalRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
            
            [[[CCDirector  sharedDirector] view] addGestureRecognizer:horizontalRight];
            
            
            
            //Gesture swipe to left
            horizontalLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeToHorizontalLeft:)];
            
            [horizontalLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
            
            [[[CCDirector  sharedDirector] view] addGestureRecognizer:horizontalLeft];
            
        }
        _nowWordIndex = [SingleTonTool defaultMemory].nowWordIndex;//当前在第几个单词
        
        
        labelChangeSizeDuration1 = labelChangeSizeDuration1_macro;
        labelChangeSizeScale1 = labelChangeSizeScale1_macro;
        
        labelChangeSizeDuration2 = labelChangeSizeDuration2_macro;
        labelChangeSizeScale2 = labelChangeSizeScale2_macro;
        
        isAnimeFinished = YES;
        isStopAllAction = NO;
        
        
     
        isOpenSpeechToText = NO;
        _menuArray= [[NSMutableArray alloc] initWithCapacity:0];
        
        isChangeModel = NO;
     
        [self addBg];
        
        [self setMenu];
        
        [self showWord];
       
        
   	}
	return self;
}

-(void)addBg
{
    
   /* _bgArray = [[NSMutableArray alloc] initWithCapacity:6];
    
    for (int i =0; i<14-3; i++)
    {
        
        [_bgArray addObject:[NSString stringWithFormat:@"hatsunemiku%d.jpg",i+4]];
        
        
    }
    
    int num1 = [_bgArray count]-1;
    
    
    _bgInArrayIndex = arc4random()%num1;
    
    
    
    
    NSString * bgString = [_bgArray objectAtIndex:_bgInArrayIndex];
    */
    
    _bgSprite = [CCSprite spriteWithFile:@"hatsunemiku10.jpg"];
    
    
    _bgSprite.position = CGPointMake(self.contentSize.width/15,self.contentSize.height/15);
    
    _bgSprite.contentSize = CGSizeMake(self.contentSize.width/8,self.contentSize.height/8);
    
    [self addChild:_bgSprite];
    
    
    //[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeBg) userInfo:nil repeats:YES];
    
}

-(void)changeBg
{
    
    int num1 = [_bgArray count]-1;
    
    
    while (true)
    {
        int aNum = arc4random()%num1;
        if (_bgInArrayIndex!=aNum)
        {
            _bgInArrayIndex = aNum;
            break;
        }
    }
    
    NSString * bgString = [_bgArray objectAtIndex:_bgInArrayIndex];
    
    CCTexture2D * aTexture = [[CCTextureCache sharedTextureCache] addImage: bgString];
	_bgSprite.texture = aTexture;
    
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
    if ([[SingleTonTool defaultMemory].wordListArray count]>0)
    {
        {
            CCMenuItemFont * aItemFont = [CCMenuItemFont itemWithString:@"LIST" target:self selector:@selector(goListPage:)];
            CGPoint aPoint = CGPointMake(self.boundingBox.size.width-aItemFont.contentSize.width-offsetX,self.boundingBox.size.height-aItemFont.contentSize.height);
            aItemFont.position =  aPoint;
            [aItemFont setFontSize:30];
            [aItemFont setFontName:@"Zapfino"];
            
            CCMenu * aMenu = [CCMenu menuWithItems:nil];
            aMenu.position = ccp(0,0);
            [aMenu addChild:aItemFont];
            [self addChild:aMenu];
            [_menuArray addObject:aMenu];
        }
        
        
        {
            CCMenuItemFont * aItemFont = [CCMenuItemFont itemWithString:@"Memory" target:self selector:@selector(memory:)];
            CGPoint aPoint = CGPointMake(aItemFont.contentSize.width-offsetX,self.boundingBox.size.height-aItemFont.contentSize.height);
            aItemFont.position =  aPoint;
            [aItemFont setFontSize:30];
            [aItemFont setFontName:@"Zapfino"];
            
            CCMenu * aMenu = [CCMenu menuWithItems:nil];
            aMenu.position = ccp(0,0);
            [aMenu addChild:aItemFont];
            [self addChild:aMenu];
            [_menuArray addObject:aMenu];
        }
        
        {
            [SingleTonTool defaultMemory].fontColor = ccRED;
            
            CCMenuItemFont * aItemFont = [CCMenuItemFont itemWithString:@"Delete" target:self selector:@selector(Delete:)];
            CGPoint aPoint = CGPointMake(aItemFont.contentSize.width-offsetX,aItemFont.contentSize.height);
            aItemFont.position =  aPoint;
            [aItemFont setFontSize:30];
            [aItemFont setFontName:@"Zapfino"];
            
            CCMenu * aMenu = [CCMenu menuWithItems:nil];
            aMenu.position = ccp(0,0);
            [aMenu addChild:aItemFont];
            [self addChild:aMenu];
            [_menuArray addObject:aMenu];
            
            [SingleTonTool defaultMemory].fontColor = ccWHITE;
        }
        
        {
            [SingleTonTool defaultMemory].fontColor = ccBLACK;
            
            self.playItemFont = [CCMenuItemFont itemWithString:@"Play" target:self selector:@selector(Play)];
            CGPoint aPoint = CGPointMake(self.boundingBox.size.width/2,self.boundingBox.size.height-self.playItemFont.contentSize.height);
            self.playItemFont.position =  aPoint;
            [self.playItemFont setFontSize:30];
            [self.playItemFont setFontName:@"Zapfino"];
            
            CCMenu * aMenu = [CCMenu menuWithItems:nil];
            aMenu.position = ccp(0,0);
            [aMenu addChild:self.playItemFont];
            [self addChild:aMenu];
            [_menuArray addObject:aMenu];
            
            [SingleTonTool defaultMemory].fontColor = ccWHITE;
        }
        {
            [SingleTonTool defaultMemory].fontColor = ccBLACK;
            
            self.indexlabel = [CCLabelTTF labelWithString:@"NO.1" fontName:@"Zapfino" fontSize:20];
            CGPoint aPoint = CGPointMake(self.boundingBox.size.width/6,self.boundingBox.size.height-self.playItemFont.contentSize.height);
            self.indexlabel.position =  aPoint;
            [self.indexlabel setColor:[SingleTonTool defaultMemory].fontColor];
            [self addChild:_indexlabel];
            [SingleTonTool defaultMemory].fontColor = ccWHITE;
        }
        
        {
            NSUserDefaults * _aUserDefaults = [NSUserDefaults standardUserDefaults];
            
            NSString * isWifiOr3g = [_aUserDefaults objectForKey:@"wifiOr3g"];
            
            if (isWifiOr3g == nil)
            {
                [_aUserDefaults setObject:@"wifi" forKey:@"wifiOr3g"];
                isWifiOr3g = @"WIFI";
            }
            if ([isWifiOr3g isEqualToString:@"3g"])
            {
                isWifiOr3g = @"3G/WIFI";
            }
            if ([isWifiOr3g isEqualToString:@"wifi"])
            {
                isWifiOr3g = @"WIFI";
            }
            
            [SingleTonTool defaultMemory].fontColor = ccRED;
            
            self.wifiOr3gItemFont = [CCMenuItemFont itemWithString:isWifiOr3g target:self selector:@selector(wifiOr3g)];
            CGPoint aPoint = CGPointMake(self.boundingBox.size.width/2,self.wifiOr3gItemFont.contentSize.height);
            self.wifiOr3gItemFont.position =  aPoint;
            [self.wifiOr3gItemFont setFontSize:20];
            
            CCMenu * aMenu = [CCMenu menuWithItems:nil];
            aMenu.position = ccp(0,0);
            [aMenu addChild:self.wifiOr3gItemFont];
            [self addChild:aMenu];
            [_menuArray addObject:aMenu];
            
            [SingleTonTool defaultMemory].fontColor = ccWHITE;
        }
    }
    
    [SingleTonTool defaultMemory].fontColor = ccWHITE;
    
}

-(void)back:(CCMenuItemFont * )aItemFont
{
    [PersonalApi playSoundEffect:@"backButtonEffect.mp3"];//按键音效
    
    
    [SingleTonTool defaultMemory].nowWordIndex = 0;
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[MyListLayer scene]]];
    
    
}
-(void)goListPage:(CCMenuItemFont * )aItemFont
{
    [PersonalApi playSoundEffect:@"appearButtonEffect.mp3"];//按键音效
    [SingleTonTool defaultMemory].nowWordIndex = _nowWordIndex;
    
    CCScene *scene = [CCScene node];
    MyListAllWordLayer * myListAllWordLayer = [[MyListAllWordLayer alloc]init];
    [scene addChild:myListAllWordLayer];
    
    myListAllWordLayer.fromListName = _fromListName;
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:scene withColor:ccWHITE]];
    
}

-(void)memory:(CCMenuItemFont * )aItemFont
{
    [PersonalApi playSoundEffect:@"okButtonEffect.mp3"];//按键音效
    isStopAllAction = YES;
    
    for (CCMenu * aMenu in _menuArray)
    {
        aMenu.enabled = NO;
    }
    
    MyWordBookMaskView * myWordBookMaskView = [[MyWordBookMaskView alloc] initWithFrame:self.boundingBox];
    myWordBookMaskView.nowWordIndex = _nowWordIndex;
    myWordBookMaskView.myWordBookLayer1 = self;
    [[[CCDirector sharedDirector] view] addSubview:myWordBookMaskView];
    
}


-(void)Delete:(CCMenuItemFont * )aItemFont
{
    [PersonalApi playSoundEffect:@"deleteButtonEffect.mp3"];//按键音效
    NSUserDefaults * _aUserDefaults = [NSUserDefaults standardUserDefaults];//开启持久化储存类
    
    NSMutableDictionary * myListDic = (NSMutableDictionary *)[_aUserDefaults objectForKey:@"myListDic"];
    
    NSMutableDictionary * aDic = [[NSMutableDictionary alloc] initWithDictionary:myListDic copyItems:YES];
    
    NSMutableArray * tempArray = [[NSMutableArray alloc] initWithArray:[aDic objectForKey:_fromListName] copyItems:YES];
    
    
    [tempArray removeObjectAtIndex:_nowWordIndex];
    [SingleTonTool defaultMemory].wordListArray = tempArray;
    
    [aDic setObject:tempArray forKey:_fromListName];
    
    [_aUserDefaults setObject:aDic forKey:@"myListDic"];
    
    if ([[SingleTonTool defaultMemory].wordListArray count]>0)
    {
        [self handleSwipeToHorizontalRight:nil];
    }
    else
    {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionTurnOffTiles transitionWithDuration:0.5 scene:[MyWordBookLayer1 node]]];
    }
    
}

-(void)Play
{
    if (isOpenSpeechToText ==NO)
    {
        [self speechRecognition];
        [self autoPlay];
        isOpenSpeechToText = YES;
    }
    else
    {
        [self.aVoiceRecognition dealloc];
        
        [self.playItemFont setString:@"Play"];
        [self unschedule:@selector(autoPlayNextOne)];
       
        isOpenSpeechToText = NO;
    }
}
-(void)wifiOr3g
{
    NSUserDefaults * _aUserDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString * isWifiOr3g = [_aUserDefaults objectForKey:@"wifiOr3g"];
    
    if ([isWifiOr3g isEqualToString:@"wifi"])
    {
        [_aUserDefaults setObject:@"3g" forKey:@"wifiOr3g"];
        [self.wifiOr3gItemFont setString:@"3G/WIFI"];
    }
    
    if ([isWifiOr3g isEqualToString:@"3g"])
    {
        [_aUserDefaults setObject:@"wifi" forKey:@"wifiOr3g"];
        
        [self.wifiOr3gItemFont setString:@"WIFI"];
    }
}

-(void)changeModel
{
    if (isChangeModel == NO)
    {
        isChangeModel = YES;
        [self.playItemFont setString:@"Speech"];
        [self unschedule:@selector(autoPlayNextOne)];
    }
    else
    {
        isChangeModel = NO;
        [self autoPlay];
    }
    
}

-(void) autoPlay
{
    //自动播放
    [self.playItemFont setString:@"AutoPlay"];
    NSUserDefaults * _aUserDefaults = [NSUserDefaults standardUserDefaults];
    float autoPlayTime = [_aUserDefaults floatForKey:@"autoPlayTime"];
    
    [self schedule:@selector(autoPlayNextOne) interval:autoPlayTime];//定时期＋时间的使用
}
-(void) autoPlayNextOne
{
    if (_nowWordIndex == [[SingleTonTool defaultMemory].wordListArray count]-1)
    {
        _nowWordIndex = 0;
    }
    [self next];
}
-(void)speechRecognition
{
    [self.playItemFont setString:@"Speech"];
    
    self.aVoiceRecognition = [[VoiceRecognition alloc] init];
    [self.aVoiceRecognition StartRecognition:self];
}

-(void)next
{
    [self turnRight];
}
-(void)showWord
{
    if ([[SingleTonTool defaultMemory].wordListArray count]>0)
    {
        
        NSMutableArray * aArray = [[SingleTonTool defaultMemory].wordListArray objectAtIndex:_nowWordIndex];
        
        NSString * aString = [aArray objectAtIndex:0];
        aString = [self downLoadPhonetic:aString];
        
        [SingleTonTool defaultMemory].fontColor = ccGREEN;
        _aItemFont = [CCMenuItemFont itemWithString:aString target:self selector:@selector(menuMethod:)];
        _aItemFont.position =  ccp(self.contentSize.width/2, self.contentSize.height/2);
        [_aItemFont setFontSize:30];
        
        CCMenu * aMenu = [CCMenu menuWithItems:nil];
        aMenu.position = ccp(0,0);
        [aMenu addChild:_aItemFont];
        [self addChild:aMenu];
        [_menuArray addObject:aMenu];
        
        [SingleTonTool defaultMemory].fontColor = ccWHITE;
        
        //语音发音
        CCSprite* sprite1 = [CCSprite spriteWithFile:@"sound.png"];
        [sprite1 setColor:ccRED];
        CCSprite* sprite2 = [CCSprite spriteWithFile:@"sound.png"];
        //[sprite2 setColor:ccBLACK];
        _itemSprite=[CCMenuItemSprite itemWithNormalSprite:sprite1 selectedSprite:sprite2 target:self selector:@selector(sound)];
        
        
        _itemSprite.position=ccp(_aItemFont.position.x+_aItemFont.contentSize.width/2+_itemSprite.contentSize.width,_aItemFont.position.y);
        _itemSprite.visible=YES;
        
        [aMenu addChild:_itemSprite];
    }
    else
    {
        NSString * searchPath = [[NSBundle mainBundle] pathForResource:@"MyWordBookLayer" ofType:@"plist"];
        NSDictionary * dic1 = [NSDictionary dictionaryWithContentsOfFile:searchPath];
        NSDictionary * dic2 = [dic1 objectForKey:@"noWord"];
        NSString * noWordString = [dic2 objectForKey:_languageString];
        
        CCLabelTTF * noWordLabel = [CCLabelTTF labelWithString:noWordString fontName:@"Verdana" fontSize:30];
        noWordLabel.position =  ccp(self.contentSize.width/2, self.contentSize.height/2);
        
        [self addChild:noWordLabel];
        
    }
}

-(void)sound
{
    NSMutableArray * aArray = [[SingleTonTool defaultMemory].wordListArray objectAtIndex:_nowWordIndex];
    NSString * aString = [aArray objectAtIndex:0];
    NSMutableArray * aArray1 = (NSMutableArray *)[aString componentsSeparatedByString:@"["];//去头
    aString = [aArray1 objectAtIndex:0];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                         objectAtIndex:0];
    NSString *fileDirectory;
    fileDirectory = [docPath stringByAppendingPathComponent:@"Sound"];
    fileDirectory = [fileDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",aString]];
    
    if (![fileManager fileExistsAtPath:fileDirectory])
    {
        if (![PersonalApi isConnectionAvailable])
        {
            if ([SingleTonTool defaultMemory].isAlerted)
            {
                [SingleTonTool defaultMemory].isAlerted = true;
                UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"Network is Unavailable" message:@"Make sure your Network is available" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil] autorelease];
                
                [alert show];
            }
            return;
        }
        else
        {
            if(![self downLoadSound:aString])
            {
                if ([SingleTonTool defaultMemory].isAlerted)
                {
                    [SingleTonTool defaultMemory].isAlerted = true;
                    UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"Network is Unavailable" message:@"Make sure your Network is available" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil] autorelease];
                    
                    [alert show];
                }
                return;
            }
        }
    }
    
    fileDirectory = [docPath stringByAppendingPathComponent:@"Sound"];
    fileDirectory = [fileDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",aString]];
    [PersonalApi playSoundEffect:fileDirectory];//按键音效
}
-(BOOL)downLoadSound:(NSString *) parserStr
{
    if (![PersonalApi isConnectionAvailable])
    {
        return false;
    }
    NSString * seachStr = [parserStr stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString * urlString  = [NSString stringWithFormat:@"http://tts.baidu.com/text2audio?lan=en&pid=101&ie=UTF-8&text=%@&spd=2",seachStr];
    NSURL *url = [NSURL URLWithString:urlString];
    //第二步，通过URL创建网络请求
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy
                                             timeoutInterval:10];
    //第三步，连接服务器,发送同步请求
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(0 == received.length)
    {
        return false;
    }
    [PersonalApi writeFileToSandBox:[NSString stringWithFormat:@"%@.mp3",parserStr] Data:received FolderName:@"Sound"];
    
    return true;
}

-(void)menuMethod:(CCMenuItemFont *)aItemFont
{
    [PersonalApi playSoundEffect:@"nextButtonEffect.mp3"];//按键音效
    CCScene *scene = [CCScene node];
    [SingleTonTool defaultMemory].nowWordIndex = _nowWordIndex;//当前在第几个单词
    MyWordBookLayer2 * myWordBookLayer2 = [[MyWordBookLayer2 alloc]init];
    [scene addChild:myWordBookLayer2];
    
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionTurnOffTiles transitionWithDuration:0.5 scene:scene]];
    
}
-(void)handleSwipeToHorizontalRight:(UISwipeGestureRecognizer *)recognizer//向右滑动
{
    if (isOpenSpeechToText == NO)
    {
        [self turnRight];
    }
}

-(void)turnRight
{
    if (_nowWordIndex ==25)
    {
        CCLOG(@"24");
        CCLOG(@"%@",[SingleTonTool defaultMemory].wordListArray);
    }
    if (isStopAllAction == NO)
    {
        CCLOG(@"right");
        if (_nowWordIndex >= [[SingleTonTool defaultMemory].wordListArray count]-1)
        {
            _nowWordIndex = [[SingleTonTool defaultMemory].wordListArray count]-1;
            
            //提示到头尾
            if (isAnimeFinished == YES)
            {
                isAnimeFinished = NO;
                NSString * searchPath = [[NSBundle mainBundle] pathForResource:@"MyWordBookLayer" ofType:@"plist"];
                NSDictionary * dic1 = [NSDictionary dictionaryWithContentsOfFile:searchPath];
                NSDictionary * dic2 = [dic1 objectForKey:@"isEnd"];
                NSString * headString = [dic2 objectForKey:_languageString];
                
                
                CCLabelTTF * aLabel = [CCLabelTTF labelWithString:headString fontName:@"Verdana" fontSize:30];
                aLabel.position =  ccp(self.contentSize.width/2, self.contentSize.height/2);
                [self addChild:aLabel];
                aLabel.color = ccRED;
    
                id ac0 = [CCScaleTo actionWithDuration:labelChangeSizeDuration1 scaleX:labelChangeSizeScale1 scaleY:labelChangeSizeScale1];
                id ac1 = [CCScaleTo actionWithDuration:labelChangeSizeDuration2 scaleX:labelChangeSizeScale2 scaleY:labelChangeSizeScale2];
                id ac2 = [CCFadeTo actionWithDuration:0.1 opacity:0];
                id acf = [CCCallFunc actionWithTarget:self selector:@selector(animeFinish:)];
                
                CCSequence * seq = [CCSequence actions:ac0,ac1,ac2,acf,nil];
                [aLabel runAction:seq];
            }
            
        }
        else
        {
            _nowWordIndex++;
        }
        NSMutableArray * aArray = [[SingleTonTool defaultMemory].wordListArray objectAtIndex:_nowWordIndex];
        NSString * aString = [aArray objectAtIndex:0];
        //获取音标
        [_aItemFont setString:[self downLoadPhonetic:aString]];
        
        //调整语音键的位置
        _itemSprite.position=ccp(_aItemFont.position.x+_aItemFont.contentSize.width/2+_itemSprite.contentSize.width,_aItemFont.position.y);
        if (isOpenSpeechToText == YES)
        {
            [self sound];
        }
        [self.indexlabel setString:[NSString stringWithFormat:@"NO.%d",_nowWordIndex]];
    }
}

-(void)handleSwipeToHorizontalLeft:(UISwipeGestureRecognizer *)recognizer//向左滑动
{
    if (isOpenSpeechToText == NO)
    {
        [self turnLeft];
    }
    
}
-(void)turnLeft
{
    if (isStopAllAction == NO)
    {
        CCLOG(@"left");
        if (_nowWordIndex <=0)
        {
            _nowWordIndex = 0;
            
            
            //提示到头牌
            if (isAnimeFinished == YES)
            {
                isAnimeFinished = NO;
                NSString * searchPath = [[NSBundle mainBundle] pathForResource:@"MyWordBookLayer" ofType:@"plist"];
                NSDictionary * dic1 = [NSDictionary dictionaryWithContentsOfFile:searchPath];
                NSDictionary * dic2 = [dic1 objectForKey:@"isHead"];
                NSString * headString = [dic2 objectForKey:_languageString];
                
                
                
                CCLabelTTF * aLabel = [CCLabelTTF labelWithString:headString fontName:@"Verdana" fontSize:30];
                aLabel.position =  ccp(self.contentSize.width/2, self.contentSize.height/2);
                [self addChild:aLabel];
                aLabel.color = ccRED;
                
                id ac0 = [CCScaleTo actionWithDuration:labelChangeSizeDuration1 scaleX:labelChangeSizeScale1 scaleY:labelChangeSizeScale1];
                id ac1 = [CCScaleTo actionWithDuration:labelChangeSizeDuration2 scaleX:labelChangeSizeScale2 scaleY:labelChangeSizeScale2];
                id ac2 = [CCFadeTo actionWithDuration:0.1 opacity:0];
                id acf = [CCCallFunc actionWithTarget:self selector:@selector(animeFinish:)];
                
                CCSequence * seq = [CCSequence actions:ac0,ac1,ac2,acf,nil];
                [aLabel runAction:seq];
            }
        }
        else
        {
            _nowWordIndex--;
        }
        NSMutableArray * aArray = [[SingleTonTool defaultMemory].wordListArray objectAtIndex:_nowWordIndex];
        NSString * aString = [aArray objectAtIndex:0];
        //获取音标
        [_aItemFont setString:[self downLoadPhonetic:aString]];       
        
        //调整语音键的位置
        _itemSprite.position=ccp(_aItemFont.position.x+_aItemFont.contentSize.width/2+_itemSprite.contentSize.width,_aItemFont.position.y);
        if (isOpenSpeechToText == YES)
        {
            [self sound];
        }
        [self.indexlabel setString:[NSString stringWithFormat:@"NO.%d",_nowWordIndex]];
    }
    
}
-(NSString *)downLoadPhonetic:(NSString *) parserStr
{
   
    NSString * resultStr;
    
    NSUserDefaults * aUserDefaults = [NSUserDefaults standardUserDefaults];//开启持久化储存类
    
    NSString * keyStr = [aUserDefaults objectForKey:[NSString stringWithFormat:@"%@Phonetic",parserStr]];
    
    NSRange range = [keyStr rangeOfString:parserStr];//判断字符串是否包含
    
    if (range.length>0)//包含
    {
        return keyStr;
    }
    else//不包含
    {
        if (![PersonalApi isConnectionAvailable])
        {
            return parserStr;
        }
        NSString * urlString  = [NSString stringWithFormat:@"http://dict.youdao.com/search?q=%@&keyfrom=fanyi.smartResult",parserStr];
        NSURL *url = [NSURL URLWithString:urlString];
        //第二步，通过URL创建网络请求
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                 timeoutInterval:10];
        //第三步，连接服务器,发送同步请求
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if (0 == received.length)
        {
            return parserStr;
        }
        NSString *str = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
        const char * receiveStrChar = [str UTF8String];
        
    
        NSMutableArray *phoneticArray = ( NSMutableArray *)PersonalApiCplu::getPhonetic(receiveStrChar);
     
        NSString * englishPhonetic = [phoneticArray objectAtIndex:0];
        NSString * americanPhonetic = [phoneticArray objectAtIndex:1];
        
        resultStr  = [NSString stringWithFormat:@"%@\n（英）\n%@",parserStr,englishPhonetic];
        resultStr  = [NSString stringWithFormat:@"%@\n（美）\n%@",resultStr,americanPhonetic];
        
        [aUserDefaults setObject:resultStr forKey:[NSString stringWithFormat:@"%@Phonetic",parserStr]];
        return resultStr;
    }
  
    return resultStr;
}
-(void)animeFinish:(CCLabelTTF * )aLabel
{
    isAnimeFinished = YES;
    // [aLabel removeFromParentAndCleanup:YES];
}
-(void)setAllActionStart
{
    isStopAllAction = NO;
    for (CCMenu * aMenu in _menuArray)
    {
        aMenu.enabled = YES;
    }
}
-(void)setSameWordReplaceInArrayIndex:(int)sameWordReplaceInArrayIndex ListName:(NSString *)listNameString
{
    _sameWordReplaceInArrayIndex = sameWordReplaceInArrayIndex;
    _memoryListName = listNameString;
    
    NSUserDefaults * _aUserDefaults = [NSUserDefaults standardUserDefaults];//开启持久化储存类
    NSString * languageString = [_aUserDefaults objectForKey:@"language"];
    
    NSString * searchPath = [[NSBundle mainBundle] pathForResource:@"WordBookLayer1" ofType:@"plist"];
    NSDictionary * dic1 = [NSDictionary dictionaryWithContentsOfFile:searchPath];
    
    
    NSDictionary * titleDic = [dic1 objectForKey:@"sameWordTitle"];
    NSString * title = [titleDic objectForKey:languageString];
    
    NSDictionary * messageDic = [dic1 objectForKey:@"rewriteMessage"];
    NSString * message = [messageDic objectForKey:languageString];
    
    NSDictionary * cancelDic = [dic1 objectForKey:@"cancelTitle"];
    NSString * cancel = [cancelDic objectForKey:languageString];
    
    NSDictionary * otherTitlesDic = [dic1 objectForKey:@"okTitle"];
    NSString * otherTitles = [otherTitlesDic objectForKey:languageString];
    
    UIAlertView * aAlertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancel otherButtonTitles:otherTitles, nil];
    [aAlertView show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [PersonalApi playSoundEffect:@"okButtonEffect.mp3"];//按键音效
        NSUserDefaults *_aUserDefaults = [NSUserDefaults standardUserDefaults];//开启持久化储存类
        
        NSMutableDictionary * myListDic = (NSMutableDictionary *)[_aUserDefaults objectForKey:@"myListDic"];
        
        NSMutableDictionary * aDic = [[NSMutableDictionary alloc] initWithDictionary:myListDic copyItems:YES];
        
        NSMutableArray * tempArray = [[NSMutableArray alloc] initWithArray:[aDic objectForKey:@"MyList"] copyItems:YES];
        
        
        NSMutableArray * newWordArray = [[NSMutableArray alloc] initWithArray:[[SingleTonTool defaultMemory].wordListArray objectAtIndex:_nowWordIndex] copyItems:YES] ;
        
        [tempArray replaceObjectAtIndex:_sameWordReplaceInArrayIndex withObject:newWordArray];
        
        [aDic setObject:tempArray forKey:_memoryListName];
        
        [_aUserDefaults setObject:aDic forKey:@"myListDic"];
 
    }
    else
    {
        [PersonalApi playSoundEffect:@"cancelButtonEffect.mp3"];//按键音效
    }
    
}

-(void) onExit//推出layer
{
	[[[CCDirector  sharedDirector] view] removeGestureRecognizer:horizontalRight];
    
    [[[CCDirector  sharedDirector] view] removeGestureRecognizer:horizontalLeft];
    
    [self unschedule:@selector(next)];
    [self.aVoiceRecognition dealloc];
}

-(void)recogniztionResult:(NSString *)resultStr
{
     NSLog(@"resultStr===%@",resultStr);
    
    if ([resultStr rangeOfString:@"切换"].length>0)
    {
        [self changeModel];
    }
    
    
    if (!isChangeModel)
    {
        return;
    }
    if ([resultStr rangeOfString:@"上"].length>0)
    {
        [self turnLeft];
    }
    if ([resultStr rangeOfString:@"下"].length>0)
    {
        [self turnRight];
    }
   
}

@end





