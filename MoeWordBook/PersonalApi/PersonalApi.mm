//
//  PersonalApi.m
//  iword
//
//  Created by crysnova 01 on 12-4-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PersonalApi.h"
#import "PersonalApiMacro.h"
#import "SimpleAudioEngine.h"
#import "PersonalApiCplu.h"
#import "Reachability.h"

@implementation PersonalApi


//jesson  添加按钮
+(CCMenuItemSprite *)addButton:(NSString *)Nimage andHimage:(NSString *)Himage Sel:(SEL)fun Target:(id)target Position:(CGPoint)p Tag:(int)btntag
{
    CCSprite* nsprite = [CCSprite spriteWithSpriteFrameName:Nimage];
    CCSprite* hsprite2 = [CCSprite spriteWithSpriteFrameName:Himage];
    
    CCMenuItemSprite * itemSprite=[CCMenuItemSprite itemWithNormalSprite:nsprite selectedSprite:hsprite2 target:target selector:fun];
    itemSprite.tag = btntag;
    
    CCMenu *myMenu = [CCMenu menuWithItems:itemSprite, nil];
    myMenu.tag = btntag;
    myMenu.position=ccp(p.x,p.y);
    [target addChild:myMenu];
    return itemSprite;
}

+(void)unitMenuButton:(NSString *)Nimage andHimage:(NSString *)Himage Sel:(SEL)fun Target:(id)target Position:(CGPoint)p Tag:(int)btntag
{
    CCSprite* nsprite = [CCSprite spriteWithSpriteFrameName:Nimage];
    CCSprite* hsprite2 = [CCSprite spriteWithSpriteFrameName:Himage];
    
    CCMenuItemSprite * itemSprite=[CCMenuItemSprite itemWithNormalSprite:nsprite selectedSprite:hsprite2 target:target selector:fun];
    itemSprite.tag = btntag;
    if (btntag > 101 && btntag < 107)
    { 
        itemSprite.visible = NO;
        itemSprite.scale = 0.1;
    }
    
    CCMenu *myMenu = [CCMenu menuWithItems:itemSprite, nil];
    myMenu.tag = btntag;
    myMenu.enabled = NO;
    myMenu.position=ccp(p.x,p.y);
    [target addChild:myMenu]; 
}

+(AppController *)getAppInstance
{
    return  (AppController *)[[UIApplication sharedApplication] delegate];
}


+(CCMenuItemSprite *)loadButton:(NSString *)image1 otherImage:(NSString *)image2 Sel:(SEL)fun target:(id)aTarget
{
    CCSprite* sprite1 = [CCSprite spriteWithSpriteFrameName:image1];
    CCSprite* sprite2 = [CCSprite spriteWithSpriteFrameName:image2];
    CCMenuItemSprite * itemSprite=[CCMenuItemSprite itemWithNormalSprite:sprite1 selectedSprite:sprite2 target:aTarget selector:fun];
    sprite1.visible=YES;
    return itemSprite;
    
    
}



+(CCSprite *)addSprite:(NSString *)Image Position:(CGPoint)p Target:(id)object
{
    CCSprite * sprite = [CCSprite spriteWithSpriteFrameName:Image]; 
    sprite.position = p;
    [object addChild:sprite];
    
    return sprite;
}



+(CCMenuItemSprite *)addCCButton:(NSString *)image1 Image:(NSString *)image2 Sel:(SEL)fun FunTarget:(id)target1 AddTarget:(id)target2 Position:(CGPoint)p AddArray:(NSMutableArray *)array
{
  
    CCSprite* sprite1 = [CCSprite spriteWithSpriteFrameName:image1];
    CCSprite* sprite2 = [CCSprite spriteWithSpriteFrameName:image2];
    CCMenuItemSprite * itemSprite=[CCMenuItemSprite itemWithNormalSprite:sprite1 selectedSprite:sprite2 target:target1 selector:fun];
    

     itemSprite.position=p;
     itemSprite.visible=YES;
    
     [target2 addChild:itemSprite];
     
     [array addObject:itemSprite];
    
    return itemSprite;
 
}

+(CCMenuItemSprite *)addCCButton:(NSString *)image Sel:(SEL)fun Menu:(CCMenu *)menu Position:(CGPoint)p ResArr:(NSMutableArray *)ResArr
{
    id aTarget = [menu parent];
    CCSprite* sprite1 = [CCSprite spriteWithSpriteFrameName:image];
    CCSprite* sprite2 = [CCSprite spriteWithSpriteFrameName:image];
    CCMenuItemSprite * itemSprite=[CCMenuItemSprite itemWithNormalSprite:sprite1 selectedSprite:sprite2 target:aTarget selector:fun];
    

    itemSprite.position=p;
    itemSprite.visible=YES;
    [menu addChild:itemSprite];
    if (ResArr!=nil)
    {
        [ResArr addObject:itemSprite];
    }
    
    
    return itemSprite;
    
}


+(id)addSpriteButton:(CGPoint)aPosition TextureName:(NSString *)textureName Target:(id)aTarget Menu:(CCMenu *)menu ResArr:(NSMutableArray *)resArray Fun:(SEL)fun Return:(int)spriteOrButton//做一个带button的Sprite spriteOrButton的0返回sprite而1返回button
{
    
    //[SingleTonTool defaultMemory].self.canPress = NO;
    CCSprite * aSprite = [CCSprite spriteWithSpriteFrameName:textureName];
    aSprite.position = aPosition;
    [aTarget addChild:aSprite z:1];
    [resArray addObject:aSprite];

    
    
    CCSprite* sprite1 = [CCSprite spriteWithSpriteFrameName:textureName];
    CCSprite* sprite2 = [CCSprite spriteWithSpriteFrameName:textureName];
    CCMenuItemSprite * aItemSprite=[CCMenuItemSprite itemWithNormalSprite:sprite1 selectedSprite:sprite2 target:aTarget selector:fun];
    sprite1.visible=YES;
    aItemSprite.position = aSprite.position;
    aItemSprite.opacity = 0;
    [menu addChild:aItemSprite z:1];
    [resArray addObject:aItemSprite];

    //[PersonalApi performSelector:@selector(doublePressLockBug) withObject:nil afterDelay:1.0];
    
    if (spriteOrButton == 0)
    {
        return aSprite;
    }
    else
    {
        return aItemSprite;
    }
    
    return nil;
 
}

+(NSMutableArray *)addSpriteButton:(CGPoint)aPosition TextureName:(NSString *)textureName Menu:(CCMenu *)menu ResArr:(NSMutableArray *)resArray Fun:(SEL)fun//做一个带button的Sprite spriteOrButton的0返回sprite而1返回button
{
    id aTarget = [menu parent];
    
    NSMutableArray * aArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    //[SingleTonTool defaultMemory].self.canPress = NO;
    CCSprite * aSprite = [CCSprite spriteWithSpriteFrameName:textureName];
    aSprite.position = aPosition;
    [aTarget addChild:aSprite z:1];
    [resArray addObject:aSprite];
    [aArray addObject:aSprite];
    
    
    CCSprite* sprite1 = [CCSprite spriteWithSpriteFrameName:textureName];
    CCSprite* sprite2 = [CCSprite spriteWithSpriteFrameName:textureName];
    CCMenuItemSprite * aItemSprite=[CCMenuItemSprite itemWithNormalSprite:sprite1 selectedSprite:sprite2 target:aTarget selector:fun];
    sprite1.visible=YES;
    aItemSprite.position = aSprite.position;
    aItemSprite.opacity = 0;
    [menu addChild:aItemSprite z:1];
    [resArray addObject:aItemSprite];
    [aArray addObject:aItemSprite];
    
    
   // [PersonalApi performSelector:@selector(doublePressLockBug) withObject:nil afterDelay:1.0];

    
    return aArray;
}



/////////////////////////添加batchNode////////////////////////////////////////////////////////////////////////////////////////////////////
+(CCSpriteBatchNode *)addBatchNode:(NSString *)image Plist:(NSString *)name AddTarget:(id)target
{
   // [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
    CCSpriteBatchNode *spritesBgNode;
    spritesBgNode = [CCSpriteBatchNode batchNodeWithFile:image];
    [target addChild:spritesBgNode]; 
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:name];
    
    return spritesBgNode;
}

+(CCSpriteBatchNode *)addBatchNode:(NSString *)imageAndPlistName AddTarget:(id)target
{
    //[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
    //[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    CCSpriteBatchNode *spritesBgNode;
    spritesBgNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.pvr.ccz",imageAndPlistName]];
    [target addChild:spritesBgNode]; 
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.pvr.plist",imageAndPlistName]];
    
    return spritesBgNode;
    
}










///////////////////////////精灵的Image传递////////////////////////////////////////////////////////////////////////////////////////////////////////////
+(CCSprite *)sendTextureImage:(CCSprite *)sprite1 To:(CCSprite *)sprite2 Target:(id)target
{
   
    id texture = [sprite1 texture];//取得纹理指证
    CGPoint spritePosition = sprite2.position;
    int spriteZorder = sprite2.zOrder;
    [sprite2 initWithTexture:texture];//用sprite2的纹理指证来初始化
    sprite2.textureRect = sprite1.textureRect;//让他们的显示区域相同，免得显示了一整张图纸
    sprite2.position = spritePosition;
    [target reorderChild:sprite2 z:spriteZorder];
    
    return sprite2;
}



+(void)spriteChangeTexture:(NSString *)textureName For:(CCSprite *)aSprite
{
    
    CCSprite * imageSprite = [CCSprite spriteWithSpriteFrameName:textureName];
    
    [aSprite setTexture:[imageSprite texture]];
    

}
+(CCSprite *)sendTextureImageTo:(CCSprite *)sprite1
{
    CCSprite * sprite2 = [CCSprite node];
    id texture = [sprite1 texture];//取得纹理指证
    [sprite2 initWithTexture:texture];//用sprite2的纹理指证来初始化
    sprite2.textureRect = sprite1.textureRect;//让他们的显示区域相同，免得显示了一整张图纸
    return sprite2;
}


+(CCSprite *)sendC2DButtonImage:(CCMenuItemSprite *)itemSprite To:(CCSprite *)sprite
{
    
    [sprite initWithTexture:((CCSprite*) itemSprite.normalImage).texture];
    sprite.textureRect = ((CCSprite*) itemSprite.normalImage).textureRect;
    
    
    return sprite;

}










///////////////////////////UI控件和cocos2dtexture之间转换/////////////////////////////////////////////////////////////////////////////////
+(UIImage *) convertSpriteToImage:(CCSprite *)sprite 
{ 
    CGPoint p = sprite.anchorPoint; 
    [sprite setAnchorPoint:ccp(0,0)]; 
    
    CCRenderTexture *renderer = [CCRenderTexture renderTextureWithWidth:sprite.contentSize.width height:sprite.contentSize.height]; 
    
    [renderer begin]; 
    [sprite visit]; 
    [renderer end]; 
    
    [sprite setAnchorPoint:p]; 
    
    return [renderer getUIImage];           
    
}

+(CCSprite *) convertImageToSprite:(UIImage *) image 
{
    
    CGImageRef cgimage=image .CGImage;
    
    CCTexture2D *texture = [[CCTexture2D alloc] initWithCGImage:cgimage resolutionType:kCCResolutioniPadRetinaDisplay];
    CCSprite    *sprite = [CCSprite spriteWithTexture:texture];
    [texture release];
    return sprite;
}











////////////////////////////播放背景音乐音效////////////////////////////////////////////////////////////////////////////////////////////////////////////
+(void)playBackSound:(NSString *)soundName
{
    
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:soundName loop:YES];
}

+(void)playSoundEffect:(NSString *)effectName
{
    NSString * netSoundStr = effectName;
    effectName = [effectName stringByReplacingOccurrencesOfString:@".mp3" withString:@""];
    NSLog(@"%@",effectName);
    NSString *soundPath;
    if ([effectName length]>30)
    {
        soundPath = netSoundStr;
    }
    else
    {
        soundPath =[[NSBundle mainBundle] pathForResource:effectName ofType:@"mp3"];
    }
    
    NSURL *soundUrl=[[NSURL alloc] initFileURLWithPath:soundPath];
    AVAudioPlayer * player=[[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    [player prepareToPlay];
    [player play];
    [soundUrl release];
}














/////////////////////////随机变量范围获取////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*+(NSMutableArray *)var:(int)numbers OffSet:(int)offSet Range:(NSRange)aRange
{
 

    int tempNum = 0;

    NSMutableArray * varArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    while (true) 
    {
        if (tempNum == numbers)
        {
            break;
        }
        
        int tempRandomNum = arc4random()%aRange.location+(aRange.length-aRange.location);
        int countNum = 0;
        
        for (int i =0; i<[varArray count]; i++) 
        {
            int tempNum = [[varArray objectAtIndex:i] intValue];
            
            NSLog(@"a=%d",abs(tempNum -tempRandomNum));
            if (abs(tempNum -tempRandomNum)>offSet)//abs绝对值
            {
                countNum++;
                
            }
        }
        if (countNum == [varArray count])
        {
            [varArray addObject:[NSNumber numberWithInt:tempRandomNum]];
            tempNum++;
        }
    
   
    }
    
    return varArray;
}*/
+(NSMutableArray *)var:(float )numbers Range:(NSRange)aRange
{
    
    NSMutableArray * array1 = [[NSMutableArray alloc] initWithCapacity:0];

    for (int i =1; i<numbers+2; i++)
    {
        [array1 addObject:[NSNumber numberWithInt:aRange.location+((aRange.length-aRange.location)/numbers*i)]];

    }

    int indexNum = 0;
    
    NSMutableArray * varArray = [[NSMutableArray alloc] initWithCapacity:0];
 

    for (int i =0; i<numbers; i++)
    {
        indexNum = arc4random()%([array1 count]-1);
   
        
        [varArray addObject:[NSNumber numberWithInt:[[array1 objectAtIndex:indexNum] intValue]]];
        [array1 removeObjectAtIndex:indexNum];
 
    }
    
    return varArray;
   
}





///////////////////////播放动画序列帧////////////////////////////////////////////////////////////////////////////////////////////////////////////
//检测序列帧有多少
+(int)getSequenceFrameNum:(NSString *)firstFrameName
{
    
    NSString * aString = [firstFrameName substringToIndex:[firstFrameName length]-4];

    aString = [aString substringFromIndex:[aString length]-1];

    int firstPicNum = [aString intValue];
  
    
    firstFrameName = [firstFrameName substringToIndex:[firstFrameName length]-5];

   // NSLog(@"%@",firstFrameName);
    int frameNum = firstPicNum;
    @try  //检测一共有多少序列图
    {  
        //NSException * e;
        while (true)
        {
           // NSLog(@"kk==%@",[NSString stringWithFormat:@"%@%d.png",firstFrameName,frameNum]);
            [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@%d.png",firstFrameName,frameNum]];
            //@throw (e);//抛出异常对象
            frameNum++;
        }
    
    
    }
    @catch (NSException * e)
    {  
    // NSLog(@"Exception: %@", e);//异常原因
        return frameNum-1;

    }

}




+(void)playSequenceFrame:(NSString *)firstFrameName Times:(int)times Delay:(float)delay Sprite:(CCSprite *)aSprite ToHead:(BOOL)ToHead
{
    NSString * aString = [firstFrameName substringToIndex:[firstFrameName length]-4];
    
    aString = [aString substringFromIndex:[aString length]-1];
    
    int firstPicNum = [aString intValue];
    
    
    NSMutableArray *animFrames1 = [NSMutableArray array];
    int frameNum = [PersonalApi getSequenceFrameNum:firstFrameName];
    firstFrameName = [firstFrameName substringToIndex:[firstFrameName length]-5];
    
    for(int i = firstPicNum; i <=frameNum; i++)
    {
        //NSLog(@"Exception: %@", [NSString stringWithFormat:@"%@%d.png",firstFrameName,i]);
        
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@%d.png",firstFrameName,i]];
        
        [animFrames1 addObject:frame];
    }
    
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animFrames1 delay:delay];
    CCAnimate* animate = [CCAnimate actionWithAnimation:animation];
    CCSequence *seq = [CCSequence actions:animate,nil];
    
    if (ToHead == YES)
    {
        animation.restoreOriginalFrame = YES;
    }
    id repeat;
    if (times == -1)
    {
        repeat = [CCRepeatForever actionWithAction:seq];
        [aSprite runAction:[CCSequence actions:repeat,nil]];
    }
    else
    {
        repeat = [CCRepeat actionWithAction:seq times:times];
        id acf = [CCCallFunc actionWithTarget:[aSprite parent] selector:@selector(animeFinish)]; //检测不监测
        [aSprite runAction:[CCSequence actions:repeat,acf,nil]];
        
    }

}


+(void)playSequenceFrameInverse:(NSString *)firstFrameName Times:(int)times Delay:(float)delay Sprite:(CCSprite *)aSprite ToHead:(BOOL)ToHead
{

    NSMutableArray *animFrames1 = [NSMutableArray array];
    int frameNum = [PersonalApi getSequenceFrameNum:firstFrameName];
    firstFrameName = [firstFrameName substringToIndex:[firstFrameName length]-5];
  
    int lastFrame = frameNum;
    
    for(int i = 0; i <=frameNum-1; i++)
    {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@%d.png",firstFrameName,lastFrame]];
        
        [animFrames1 addObject:frame];
        lastFrame--;
    }
    if (ToHead == YES)
    {
        [animFrames1 addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@%d.png",firstFrameName,lastFrame]]];//循环回到第一帧
    }
    
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animFrames1 delay:delay];
    CCAnimate* animate = [CCAnimate actionWithAnimation:animation];
    CCSequence *seq = [CCSequence actions:animate,nil]; 
    id repeat;
    if (times == -1)
    {
        repeat = [CCRepeatForever actionWithAction:seq];
        [aSprite runAction:[CCSequence actions:repeat,nil]];
    }
    else
    {
       repeat = [CCRepeat actionWithAction:seq times:times];
        id acf = [CCCallFunc actionWithTarget:[aSprite parent] selector:@selector(animeFinish)]; 
        [aSprite runAction:[CCSequence actions:repeat,acf,nil]];
        
        
    }
 
   
   
}



+(void)ChangeSize:(id)animaObj Scale:(float)s Delay:(ccTime)t Repeat:(BOOL)repeat//扩大缩小动画
{
    id animation1;
    id animation2;
    if (s>0)
    {
        animation1 = [CCScaleTo actionWithDuration:t scale:1.0];
        animation2 = [CCScaleTo actionWithDuration:t scale:s];
    }
    else
    {
        animation1 = [CCScaleTo actionWithDuration:t scale:s];
        animation2 = [CCScaleTo actionWithDuration:t scale:1.0];
    }
    
        

    
    if (repeat == YES)
    {
        
        CCSequence * seq = [CCSequence actions:animation1, animation2, nil];
        // 将该动画作为精灵的本征动画，一直运行。 
        [animaObj runAction:[CCRepeatForever actionWithAction:seq]]; 
        
    }
    else
    {
        
        
        id acf = [CCCallFunc actionWithTarget:[animaObj parent] selector:@selector(animeFinish)];
        CCSequence * seq = [CCSequence actions:animation1, animation2, acf, nil];
         [animaObj runAction:[CCRepeat actionWithAction:seq times:1]];
    }

    
}


+(void)ChangeColor:(id)animaObj ToColor:(ccColor3B)c Delay:(ccTime)t Repeat:(BOOL)repeat//改变颜色
 {
     
     ccColor3B aColor = ((CCSprite*)animaObj).color;
     id ac1 = [CCTintTo actionWithDuration:t red:c.r green:c.g blue:c.b];
     id ac2 = [CCTintTo actionWithDuration:t red:aColor.r green:aColor.g blue:aColor.b]; 
     
     
     if (repeat == YES)
     {
         
         CCSequence * seq = [CCSequence actions:ac1, ac2, nil];
         // 将该动画作为精灵的本征动画，一直运行。 
         [animaObj runAction:[CCRepeatForever actionWithAction:seq]]; 
         
     }
     else
     {
         
         
         id acf = [CCCallFunc actionWithTarget:[animaObj parent] selector:@selector(animeFinish)];
         CCSequence * seq = [CCSequence actions:ac1, ac2, acf, nil];
         [animaObj runAction:[CCRepeat actionWithAction:seq times:1]];
     }
 
 }
 
+(void)Move:(id)animaObj Position:(CGPoint)p Delay:(ccTime)t Target:(id)aTarget//移动动画
{
    id ac = [CCMoveTo actionWithDuration:t position:p];
  
     
    id acf = [CCCallFunc actionWithTarget:aTarget selector:@selector(animeFinish)];
    CCSequence * seq = [CCSequence actions:ac, acf, nil];
    [animaObj runAction:seq];
 
}



//////////////////////////根据一个精灵的大小，设定一个他的可交互区域后面的changeRect中的四个数字分别代表要加或者减少多少交互区域////////////////////////////////////////////////////
//根据一个精灵的大小，设定一个他的可交互区域后面的changeRect中的四个数字分别代表要加或者减少多少交互区域
+(CGRect)creatNewRect:(CCSprite *)aSprite ChangeNum:(CGRect)changeRect
{
    
    
    float x = changeRect.origin.x;
    float y = changeRect.origin.y;
    float width = changeRect.size.width;
    float height = changeRect.size.height;
    
    CGRect aRect;
    if (0)//isNewIpad)
    {
        aRect = CGRectMake(aSprite.position.x-aSprite.contentSize.width/4-x,
                                  aSprite.position.y+aSprite.contentSize.height/4-y,
                                  aSprite.contentSize.width-width,
                                  aSprite.contentSize.height-height);
    }
    else
    {
        aRect = CGRectMake(aSprite.position.x-aSprite.contentSize.width/2-x,
                           aSprite.position.y+aSprite.contentSize.height/2-y,
                           aSprite.contentSize.width-width,
                           aSprite.contentSize.height-height);
    }
   
    
    
    return aRect;
}












//////////////////数组传递CGPoint和接受////////////////////////////////////////////////////////////////////////////////////////////////////////
+(NSMutableArray *)pointToArray:(NSMutableArray *)pointArray Point:(CGPoint)aPoint
{
    [pointArray addObject:[NSValue valueWithCGPoint:aPoint]];
    return pointArray;
    
}
+(CGPoint)getPoint:(NSMutableArray *)pointArray Index:(int)indexNum
{
    CGPoint aPoint = [[pointArray objectAtIndex:indexNum] CGPointValue];
    
    return aPoint;
    
}



//////////////////粒子效果////////////////////////////////////////////////////////////////////////////////////////////////////////
+(void)particle_Over:(NSString *)particleName Target:(CCMenuItemSprite *)aTarget//粒子特效
{
    CCParticleSystemQuad  *emitter =[CCParticleSystemQuad particleWithFile:particleName];

    if (emitter) 
    {
         emitter.autoRemoveOnFinish = YES;
        emitter.position = aTarget.position;        
        //[emitter setColor:ccBLUE];
        
        [[[aTarget parent] parent] addChild:emitter z:3]; 
    }
}

+(void)CreateFolderToSandBox:(NSString *) folderName;
{
    //写xml
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                         objectAtIndex:0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testDirectory = [docPath stringByAppendingPathComponent:folderName];
    // 创建目录
    [fileManager createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
}


+(void)writeFileToSandBox:(NSString *) fileName Data:(NSData *)aData FolderName:(NSString *) folderName;
{
    //写xml
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                         objectAtIndex:0];
    NSString *fileDirectory = [docPath stringByAppendingPathComponent:folderName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (folderName!=NULL && ![fileManager fileExistsAtPath:fileDirectory])
    {
        // 创建目录
        [fileManager createDirectoryAtPath:fileDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    fileDirectory = [fileDirectory stringByAppendingPathComponent:fileName];
    
    [aData writeToFile:fileDirectory atomically:YES];
}

+(BOOL)isExistFileInSandBox:(NSString *) fileName FolderName:(NSString *) folderName
{
    //写xml
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                         objectAtIndex:0];
    NSString *fileDirectory = [docPath stringByAppendingPathComponent:folderName];
    fileDirectory = [fileDirectory stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:fileDirectory])
    {
        return true;
    }
    else
    {
        return false;
    }
}

+(NSString*)currntNetworkType
{
    NSString* result;
    
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    
    switch ([r currentReachabilityStatus])
    {
        case NotReachable:    // 没有网络连接
        {
            result = nil;
        }
            break;
            
        case ReachableViaWWAN:// 3G
        {
            result = @"3G";
        }
            break;
            
        case ReachableViaWiFi:// WiFi
        {
            result = @"WIFI";
        }
            break;
    }
    return result;
}

+(BOOL)isConnectionAvailable
{
    NSUserDefaults * _aUserDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString * isWifiOr3g = [_aUserDefaults objectForKey:@"wifiOr3g"];
    
    
    BOOL isConnectiing = false;
    
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    
    switch ([r currentReachabilityStatus])
    {
        case NotReachable:    // 没有网络连接
        {
            isConnectiing = false;
        }
            break;
            
        case ReachableViaWWAN:// 3G
        {
            if ([isWifiOr3g isEqualToString:@"wifi"])
            {
                isConnectiing = false;
            }
            
            if ([isWifiOr3g isEqualToString:@"3g"])
            {
                isConnectiing = true;
            }
        }
            break;
            
        case ReachableViaWiFi:// WiFi
        {
            isConnectiing = true;
        }
            break;
    }
    return isConnectiing;
}
@end





















