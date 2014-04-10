//
//  WordBookLayer2.m
//  MoeWordBook
//
//  Created by lyy on 12-11-2.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyWordBookLayer2.h"
#import "MyWordBookLayer1.h"
#import "ExternalListLayer.h"
#import "MyListLayer.h"
#import "PersonalApiCplu.h"

@implementation MyWordBookLayer2


@synthesize languageString = _languageString;
@synthesize bgSprite = _bgSprite;


@synthesize wordTabelView = _wordTabelView;
@synthesize nowWordIndex = _nowWordIndex;
@synthesize cellRectArray = _cellRectArray;
@synthesize sentenceArray = _sentenceArray;
@synthesize wifiOr3gItemFont = _wifiOr3gItemFont;

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	
	MyWordBookLayer2 *layer = [MyWordBookLayer2 node];
	
	[scene addChild: layer];
	
	return scene;
}

-(id) init
{
	if( (self=[super init]) )
    {
        
        firstInTableViewLoad = YES;
        //  读取语言
        NSUserDefaults * _aUserDefaults = [NSUserDefaults standardUserDefaults];
        _languageString = [_aUserDefaults objectForKey:@"language"];
        
        
        //Gesture swipe to right
        horizontalRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeToHorizontalRight:)];
        
        [horizontalRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
        
        [[[CCDirector  sharedDirector] view] addGestureRecognizer:horizontalRight];
        
        
        
        //Gesture swipe to left
        horizontalLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeToHorizontalLeft:)];
        
        [horizontalLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        
        [[[CCDirector  sharedDirector] view] addGestureRecognizer:horizontalLeft];
        
        
        _nowWordIndex = [SingleTonTool defaultMemory].nowWordIndex;//当前在第几个单词
        
        
        isAnimeFinished = YES;
        
        
        _cellRectArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        _bgSprite = [CCSprite spriteWithFile:@"hatsunemiku3.jpg"];
        
        _bgSprite.position = CGPointMake(self.contentSize.width/2,self.contentSize.height/2);
        _bgSprite.scale = 0.9;
        [self addChild:_bgSprite];
        
        
        
        _wordTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, self.boundingBox.size.width/2, self.boundingBox.size.height/2) style:UITableViewStylePlain];
        _wordTabelView.center = CGPointMake(self.boundingBox.size.width/4, self.boundingBox.size.height/2);
        
        _wordTabelView.delegate = self;
        _wordTabelView.dataSource = self;
        [_wordTabelView setBackgroundColor:[UIColor clearColor]];
        [[[CCDirector sharedDirector] view] addSubview:_wordTabelView];
        
        //返回按钮
        [SingleTonTool defaultMemory].fontColor = ccGREEN;
        {
            CCMenuItemFont * aItemFont = [CCMenuItemFont itemWithString:@"BACK" target:self selector:@selector(back:)];
            [aItemFont setColor:ccBLACK];
            CGPoint aPoint = CGPointMake(self.boundingBox.size.width-aItemFont.contentSize.width,aItemFont.contentSize.height);
            aItemFont.position =  aPoint;
            [aItemFont setFontSize:60];
            
            
            CCMenu * aMenu = [CCMenu menuWithItems:nil];
            aMenu.position = ccp(0,0);
            [aMenu addChild:aItemFont];
            [self addChild:aMenu];
        }
        
        {
            CCMenuItemFont * aItemFont = [CCMenuItemFont itemWithString:@"EDIT" target:self selector:@selector(edit:)];
            [aItemFont setColor:ccBLACK];
            CGPoint aPoint = CGPointMake(self.boundingBox.size.width-aItemFont.contentSize.width-10,self.boundingBox.size.height-30);
            aItemFont.position =  aPoint;
            [aItemFont setFontSize:60];
            
            
            CCMenu * aMenu = [CCMenu menuWithItems:nil];
            aMenu.position = ccp(0,0);
            [aMenu addChild:aItemFont];
            [self addChild:aMenu];
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
            
            [SingleTonTool defaultMemory].fontColor = ccWHITE;
        }
        
        [SingleTonTool defaultMemory].fontColor = ccWHITE;
        
   	}
	return self;
}



-(void)back:(CCMenuItemFont * )aItemFont
{
    [PersonalApi playSoundEffect:@"backButtonEffect.mp3"];//按键音效
    [SingleTonTool defaultMemory].nowWordIndex = 0;
    [_wordTabelView removeFromSuperview];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[MyListLayer scene]]];
    
}
-(void)edit:(CCMenuItemFont * )aItemFont
{
    
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


-(void)menuMethod:(CCMenuItemFont *)aItemFont
{
    [PersonalApi playSoundEffect:@"nextButtonEffect.mp3"];//按键音效
    CCScene *scene = [CCScene node];
    [SingleTonTool defaultMemory].nowWordIndex = _nowWordIndex;//当前在第几个单词
    MyWordBookLayer2 * myWordBookLayer2 = [[MyWordBookLayer2 alloc]init];
    [scene addChild:myWordBookLayer2];
    
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:scene withColor:ccWHITE]];
    
}
-(void)handleSwipeToHorizontalRight:(UISwipeGestureRecognizer *)recognizer//向右滑动
{
    CCLOG(@"right");
    if (_nowWordIndex >= [[SingleTonTool defaultMemory].wordListArray count]-1)
    {
        _nowWordIndex = [[SingleTonTool defaultMemory].wordListArray count]-1;
        
        //提示到头牌
        if (isAnimeFinished == YES)
        {
            isAnimeFinished = NO;
            NSString * searchPath = [[NSBundle mainBundle] pathForResource:@"MyWordBookLayer" ofType:@"plist"];
            NSDictionary * dic1 = [NSDictionary dictionaryWithContentsOfFile:searchPath];
            NSDictionary * dic2 = [dic1 objectForKey:@"isHead"];
            NSString * headString = [dic2 objectForKey:_languageString];
            
            CCLabelTTF * aLabel = [CCLabelTTF labelWithString:headString fontName:@"Marker Felt" fontSize:100];
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
    firstInTableViewLoad = YES;
    [_wordTabelView reloadData];
    
}

-(void)handleSwipeToHorizontalLeft:(UISwipeGestureRecognizer *)recognizer//向左滑动
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
            NSDictionary * dic2 = [dic1 objectForKey:@"isEnd"];
            NSString * headString = [dic2 objectForKey:_languageString];
            
            CCLabelTTF * aLabel = [CCLabelTTF labelWithString:headString fontName:@"Marker Felt" fontSize:50];
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
    
    
    firstInTableViewLoad = YES;
    [_wordTabelView reloadData];
    
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableArray * aArray = [[SingleTonTool defaultMemory].wordListArray objectAtIndex:_nowWordIndex];
    if ([aArray count]>1)
    {
        // 列寬
        CGFloat contentWidth = self.wordTabelView.frame.size.width;
        // 用何種字體進行顯示
        UIFont *font = [UIFont systemFontOfSize:fontSize_macro];
        
        
        // 該行要顯示的內容
        NSString *content;// = (NSString *)[aArray objectAtIndex:indexPath.row+1];
        // 該行要顯示的內容
        if (indexPath.row<[aArray count]-1)
        {
            content = (NSString *)[aArray objectAtIndex:indexPath.row+1];
        }
        else
        {
            content = (NSString *)[_sentenceArray objectAtIndex:indexPath.row+1-2];
        }
        
        content = [NSString stringWithFormat:@"\n%@\n\n",content];
        // 計算出顯示完內容需要的最小尺寸
        CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:NSLineBreakByWordWrapping];
        
        // 這裏返回需要的高度
        return size.height;
    }
    else
    {
        // 列寬
        CGFloat contentWidth = self.wordTabelView.frame.size.width;
        // 用何種字體進行顯示
        UIFont *font = [UIFont systemFontOfSize:fontSize_macro];
        
        // 該行要顯示的內容
        NSString *content = (NSString *)[_sentenceArray objectAtIndex:indexPath.row+1];
        content = [NSString stringWithFormat:@"\n%@\n\n",content];
        // 計算出顯示完內容需要的最小尺寸
        CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:NSLineBreakByWordWrapping];
        
        // 這裏返回需要的高度
        return size.height;
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray * aArray = [[SingleTonTool defaultMemory].wordListArray objectAtIndex:_nowWordIndex];
    if ([aArray count]>1)
    {
        if (firstInTableViewLoad ==YES)
        {
            firstInTableViewLoad = NO;
            
            NSString * tempStr1 = (NSString *)[aArray objectAtIndex:0];
            _sentenceArray = [[[NSMutableArray alloc] initWithCapacity:0] retain];
            [_sentenceArray addObject:tempStr1];
            
            NSString * tempStr2 = [tempStr1 substringToIndex:1];
            
            //获取例句
            NSString * sentenceFile = [NSString stringWithFormat:@"%@Sentence",tempStr2];
            NSString * sentenceStr = [[NSBundle mainBundle] pathForResource:sentenceFile ofType:@"xml"];
            sentenceStr = [NSString stringWithContentsOfFile:sentenceStr encoding:NSUTF8StringEncoding error:nil];
            
            NSMutableArray * sentenceTempArray1 = (NSMutableArray *)[sentenceStr componentsSeparatedByString:[NSString stringWithFormat:@"<w>%@</w>",tempStr1]];//去头
            if ([sentenceTempArray1 count]>1)
            {
                NSString * sentenceStr1 = [sentenceTempArray1 objectAtIndex:1];
                
                NSMutableArray * sentenceTempArray2 = (NSMutableArray *)[sentenceStr1 componentsSeparatedByString:@"<w>"];//去头
                sentenceStr1 = [sentenceTempArray2 objectAtIndex:0];
                
                if ([sentenceTempArray1 count]>1)
                {
                    
                    NSMutableArray * sentenceTempArray3 = (NSMutableArray *)[sentenceStr1 componentsSeparatedByString:@"<f>"];//分割各个例句
                    
                    
                    for (int k=1; k<[sentenceTempArray3 count]; k++)
                    {
                        NSString * sentenceStr2 = [sentenceTempArray3 objectAtIndex:k];
                        
                        NSMutableArray * sentenceTempArray4 = (NSMutableArray *)[sentenceStr2 componentsSeparatedByString:@"</f>"];//分割各个例句
                        NSString * sentenceStr3 = [sentenceTempArray4 objectAtIndex:0];
                        [_sentenceArray addObject:sentenceStr3];
                        
                        NSString * sentenceStr4 = [sentenceTempArray4 objectAtIndex:1];
                        sentenceStr4 = [sentenceStr4 stringByReplacingOccurrencesOfString:@"<s>" withString:@""];
                        sentenceStr4 = [sentenceStr4 stringByReplacingOccurrencesOfString:@"</s>" withString:@""];
                        [_sentenceArray addObject:sentenceStr4];
                    }
                    
                }
            }
            else
            {
                if (![PersonalApi isConnectionAvailable])
                {
                    if ([SingleTonTool defaultMemory].isAlerted)
                    {
                        [SingleTonTool defaultMemory].isAlerted = true;
                        UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"Network is Unavailable" message:@"Make sure your Network is available" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil] autorelease];
                        
                        [alert show];
                    }
                }
                else
                {
                    self.sentenceArray = [self downLoadSentence:tempStr1];
                }
            }
            
        }
        allTableViewIndex = [_sentenceArray count]+[aArray count]-1;
        return [_sentenceArray count]+[aArray count]-1;
    }
    allTableViewIndex = [aArray count] - 1;
    return [aArray count] - 1;
    
}

-(NSMutableArray *)downLoadSentence:(NSString *) parserStr
{
    NSMutableArray * emptyArray = [[NSMutableArray alloc] initWithCapacity:0];
    if (![PersonalApi isConnectionAvailable])
    {
        return emptyArray;
    }
    NSUserDefaults * aUserDefaults = [NSUserDefaults standardUserDefaults];//开启持久化储存类
    
    
    emptyArray = [aUserDefaults objectForKey:[NSString stringWithFormat:@"%@Sentence",parserStr]];
    
    
    if ([emptyArray count]>0)//包含
    {
        return emptyArray;
    }
    else//不包含
    {
        NSString * urlString  = [NSString stringWithFormat:@"http://www.iciba.com/%@",parserStr];
        NSURL *url = [NSURL URLWithString:urlString];
        //第二步，通过URL创建网络请求
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                 timeoutInterval:10];
        //第三步，连接服务器,发送同步请求
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if (0 == received.length)
        {
            return emptyArray;
        }
        NSString *str = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
        const char * receiveStrChar = [str UTF8String];
        
        NSMutableArray * SentenceArray = (NSMutableArray *)PersonalApiCplu::getSentence(receiveStrChar);
        
        [aUserDefaults setObject:SentenceArray forKey:[NSString stringWithFormat:@"%@Sentence",parserStr]];
        
        SentenceArray = [self getChinese:str ScentenceArray:SentenceArray];
        
        return SentenceArray;
    }
    
    return emptyArray;
}

-(NSMutableArray *)getChinese:(NSString *)parserText ScentenceArray:(NSMutableArray *)aArray
{
    const char * receiveStrChar = [parserText UTF8String];
    NSString * chineseStr = (NSString *)PersonalApiCplu::getSentence(receiveStrChar);
    [aArray insertObject:chineseStr atIndex:0];
    return aArray;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger indexPathRow = indexPath.row;
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSMutableArray * aArray = [[SingleTonTool defaultMemory].wordListArray objectAtIndex:_nowWordIndex];
    
    
    // 列寬
    CGFloat contentWidth = self.wordTabelView.frame.size.width;
    // 用何種字體進行顯示
    UIFont *font = [UIFont systemFontOfSize:fontSize_macro];
    
    NSString *content;
    if ([aArray count]>1)
    {
        // 該行要顯示的內容
        if (indexPathRow<[aArray count]-1)
        {
            content = (NSString *)[aArray objectAtIndex:indexPathRow+1];
        }
        else
        {
            content = (NSString *)[_sentenceArray objectAtIndex:indexPathRow+1-2];
        }
        
    }
    else
    {
        
        content = (NSString *)[_sentenceArray objectAtIndex:indexPathRow+1];
        
    }
    
    
    
    content = [NSString stringWithFormat:@"\n%@\n\n",content];
    
    
    // 計算出顯示完內容需要的最小尺寸
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:UILineBreakModeWordWrap];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    CGRect rect = [cell.textLabel textRectForBounds:cell.textLabel.frame limitedToNumberOfLines:0];
    // 設置顯示榘形大小
    rect.size = size;
    // 重置列文本區域
    cell.textLabel.frame = rect;
    
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    if (1 == indexPathRow)
    {
        cell.textLabel.text = @"例句：";
    }
    else
    {
        cell.textLabel.text = content;
    }
    
    // 設置自動換行(重要)
    cell.textLabel.numberOfLines = 0;
    // 設置顯示字體(一定要和之前計算時使用字體一至)
    cell.textLabel.font = font;
    
    //COLOR
    if (indexPath.row%2==0)
    {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    else
    {
        cell.textLabel.textColor = [UIColor redColor];
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [PersonalApi playSoundEffect:@"nextButtonEffect.mp3"];//按键音效
    [_wordTabelView removeFromSuperview];
    
    CCScene *scene = [CCScene node];
    [SingleTonTool defaultMemory].nowWordIndex = _nowWordIndex;//当前在第几个单词
    MyWordBookLayer1 * myWordBookLayer1 = [[MyWordBookLayer1 alloc]init];
    [scene addChild:myWordBookLayer1];
    
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5 scene:scene]];
}



@end
