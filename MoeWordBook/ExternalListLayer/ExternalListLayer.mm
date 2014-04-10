//
//  MyWordListLayer.m
//  MoeWordBook
//
//  Created by lyy on 12-10-30.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "ExternalListLayer.h"
#import "MainLayer.h"
#import "ListTableViewController.h"
#include "ExcelParser.h"
#include "PersonalApiCplu.h"

@implementation ExternalListLayer

@synthesize bgSprite = _bgSprite;
@synthesize fileListArray = _fileListArray;
@synthesize listTableViewController = _listTableViewController;
@synthesize editaItemFont = _editaItemFont;
@synthesize menuArray = _menuArray;

@synthesize listNameField = _listNameField;
@synthesize maskView= _maskView;
@synthesize isEditing;
@synthesize listTableViewController2 = _listTableViewController2;
@synthesize fileListArray2 = _fileListArray2;
@synthesize isItunesShareList;

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	
	ExternalListLayer *layer = [ExternalListLayer node];
	
	[scene addChild: layer];
	
	return scene;
}

-(id) init
{
    
	if( (self=[super init]) )
    {
        isStopAllAction = NO;
        inputSameListName = NO;
        isItunesShareList = NO;
       
      
       /* NSString *docPath = [[NSBundle mainBundle]resourcePath];
        NSString *documentLibraryFolderPath = [NSString stringWithFormat:@"%@/PublicSource/word/",docPath];

        NSArray *namesArray = [[NSBundle mainBundle] pathsForResourcesOfType:@"xml" inDirectory:documentLibraryFolderPath];
        NSLog(@"%@",namesArray);
        */
        self.fileListArray = [[NSMutableArray alloc] initWithObjects:@"CET6分级2.xml",
                              @"CET6分级3.xml",
                              @"CET6分级4.xml",
                              @"CET6分级5.xml",
                              @"GMAT.xml",
                              @"GRE.xml",
                              @"TOEFL.xml",
                              @"北语雅思完全版.xml",
                              @"大学英语六级.xml",
                              @"大学英语四级.xml",
                              @"新概念英语第一册.xml",
                              @"新概念英语第二册.xml",
                              @"新概念英语第三册.xml",
                              @"新概念英语第四册.xml",
                              @"研究生考试.xml",nil];
        
        
        //遍历所有文件名
        
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                             objectAtIndex:0];
        NSString *documentLibraryFolderPath = [docPath stringByAppendingPathComponent:@""];
        
        NSError *error = nil;
        
        NSFileManager * fileManage = [NSFileManager defaultManager];
        
        //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
        NSMutableArray * allItunesFileArray = (NSMutableArray *)[fileManage contentsOfDirectoryAtPath:documentLibraryFolderPath error:&error];
        self.fileListArray2 = [[NSMutableArray alloc] initWithCapacity:0];
        NSEnumerator *e = [allItunesFileArray objectEnumerator];//枚举
        NSString *filename;
        while ((filename = [e nextObject]))
        {
            
             NSString *extension = @"xml";//后缀
             if ([[filename pathExtension] isEqualToString:extension])
             {
                 [_fileListArray2 addObject:filename];

             }
             
        }
        
        
     
        NSString * bgString = @"hatsunemiku2.jpg";
        
        _bgSprite = [CCSprite spriteWithFile:bgString];
        
        _bgSprite.position = CGPointMake(self.contentSize.width/2,self.contentSize.height/2);
        _bgSprite.scale = 0.9;
        [self addChild:_bgSprite];
        
        [SingleTonTool defaultMemory].fontColor = ccBLACK;//ccGRAY;
        {
            CCMenuItemFont * aItemFont = [CCMenuItemFont itemWithString:@"BACK" target:self selector:@selector(BACK:)];
         
            CGPoint aPoint = CGPointMake(self.boundingBox.size.width-aItemFont.contentSize.width,aItemFont.contentSize.height);
            aItemFont.position =  aPoint;
            [aItemFont setFontSize:60];
            
            
            CCMenu * aMenu = [CCMenu menuWithItems:nil];
            aMenu.position = ccp(0,0);
            [aMenu addChild:aItemFont];
            [self addChild:aMenu];
            [_menuArray addObject:aMenu];
        }
        
        
        {
            /*_editaItemFont = [CCMenuItemFont itemWithString:@"AddToList" target:self selector:@selector(AddToList:)];
           
            CGPoint aPoint = CGPointMake(self.boundingBox.size.width-_editaItemFont.contentSize.width,self.boundingBox.size.height-_editaItemFont.contentSize.height);
            _editaItemFont.position =  aPoint;
            [_editaItemFont setFontSize:60];
            
            
            CCMenu * aMenu = [CCMenu menuWithItems:nil];
            aMenu.position = ccp(0,0);
            [aMenu addChild:_editaItemFont];
            [self addChild:aMenu];
            [_menuArray addObject:aMenu];
             */
            
            
        }
    
        
        [SingleTonTool defaultMemory].fontColor = ccWHITE;
        
        
        [self performSelector:@selector(setUpTableView) withObject:nil afterDelay:0.5];
       
        
   	}
	return self;
}

-(void)setUpTableView
{
    _listTableViewController = [[ListTableViewController alloc] init];
    //_listTableViewController.tableView.frame = CGRectMake(self.boundingBox.size.width/4-20,0, self.boundingBox.size.width/2, self.boundingBox.size.height*2/3);
    //_listTableViewController.tableView.center = CGPointMake(self.boundingBox.size.width/4,self.boundingBox.size.height/2);
    _listTableViewController.tableView.frame = CGRectMake(0,20, self.boundingBox.size.width/2, self.boundingBox.size.height*2/3);
    _listTableViewController.fileListArray = _fileListArray;
    _listTableViewController.isItunesShareList = NO;
    [_listTableViewController.tableView setBackgroundColor:[UIColor clearColor]];
    
    _listTableViewController.isStopAllAction = isStopAllAction;
    _listTableViewController.menuArray = _menuArray;
    
    _listTableViewController.externalListLayer = self;
    
    [[[CCDirector sharedDirector] view] addSubview:_listTableViewController.tableView];
    
    [self.listTableViewController.tableView setEditing:YES animated:YES];
    
    //////////////////
    
    _listTableViewController2 = [[ListTableViewController alloc] init];
    _listTableViewController2.tableView.frame = CGRectMake(self.boundingBox.size.width-self.boundingBox.size.width/2,20, self.boundingBox.size.width/2, self.boundingBox.size.height*2/3);
    
    _listTableViewController2.fileListArray = _fileListArray2;
    _listTableViewController2.isItunesShareList = YES;
    [_listTableViewController2.tableView setBackgroundColor:[UIColor clearColor]];
    
    _listTableViewController2.isStopAllAction = isStopAllAction;
    _listTableViewController2.menuArray = _menuArray;
    
    _listTableViewController2.externalListLayer = self;
    
    [[[CCDirector sharedDirector] view] addSubview:_listTableViewController2.tableView];
    
    [self.listTableViewController2.tableView setEditing:YES animated:YES];
    
    
    
    
}

-(void)BACK:(CCMenuItemFont * )aItemFont
{
    if (isEditing == NO)
    {
        [PersonalApi playSoundEffect:@"backButtonEffect.mp3"];//按键音效
        [_listTableViewController.tableView removeFromSuperview];
        [_listTableViewController2.tableView removeFromSuperview];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[MainLayer scene]]];
        
    }
    
}

-(void)AddToList:(CCMenuItemFont * )aItemFont
{
    
    if (isEditing == NO)
    {
        
        [PersonalApi playSoundEffect:@"appearButtonEffect.mp3"];//按键音效
        
        isEditing = YES;
        [_editaItemFont setString:@"OK"];
        //设置状态为可编辑
        
        [self.listTableViewController.tableView setEditing:YES animated:YES];
        
    }
    else
    {
        [PersonalApi playSoundEffect:@"cancelButtonEffect.mp3"];//按键音效
        
        isEditing = NO;
        [_editaItemFont setString:@"AddToList"];
        //设置状态为可编辑
        
        [self.listTableViewController.tableView setEditing:NO animated:YES];
    }
}


-(void)setAllActionStart
{
    isStopAllAction = NO;
    for (CCMenu * aMenu in _menuArray)
    {
        aMenu.enabled = YES;
    }
}


-(void)AddList:(NSUInteger)selectIndex
{
    
    _selectIndex = selectIndex;
    
    
    [PersonalApi playSoundEffect:@"appearButtonEffect.mp3"];//按键音效
    {
        _maskView = [[UIView alloc] initWithFrame:self.boundingBox];
        
        [_maskView setBackgroundColor:[UIColor blackColor]];
        [_maskView setAlpha:0.85];
        
        [[[CCDirector sharedDirector] view] addSubview:_maskView];
        
        
        
        // UIImageView * aImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1"]];
        UIView * aImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 150)];
        aImageView.backgroundColor = [UIColor lightGrayColor];
        aImageView.center = _maskView.center;
        [_maskView addSubview:aImageView];
        
        
        _listNameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0,aImageView.frame.size.width, aImageView.frame.size.height/3)];
        _listNameField.backgroundColor = [UIColor whiteColor];
        //_listNameField.center = _maskView.center;
        _listNameField.delegate = self;
        _listNameField.placeholder = @"ListName";
        _listNameField.textColor = [UIColor blackColor];
        _listNameField.autocorrectionType = UITextAutocorrectionTypeNo;
        _listNameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _listNameField.returnKeyType = UIReturnKeyDone;
        [aImageView addSubview:_listNameField];
        
        UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//设置button字体颜色
        [cancelButton setTitle:@"cancel" forState:UIControlStateNormal];
        
        cancelButton.frame = CGRectMake(10, 110, 60, 30);
        [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [aImageView addSubview:cancelButton];
        
        UIButton * addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        [addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//设置button字体颜色
        [addButton setTitle:@"addList" forState:UIControlStateNormal];
        
        addButton.frame = CGRectMake(190, 110, 60, 30);
        [addButton addTarget:self action:@selector(addButton) forControlEvents:UIControlEventTouchUpInside];
        [aImageView addSubview:addButton];
    }
}

-(void)cancel
{
    [PersonalApi playSoundEffect:@"cancelButtonEffect.mp3"];//按键音效
    
    isEditing = NO;
    [_editaItemFont setString:@"AddToList"];
    //设置状态为可编辑
    
    //[self.listTableViewController.tableView setEditing:NO animated:YES];
    self.listTableViewController.isStopAllAction = NO;
    inputSameListName = NO;
    isEditing = NO;
    [_maskView removeFromSuperview];
}
-(void)addButton
{
    if (inputSameListName ==NO)
    {
        if ([[_listNameField text] length]>0)
        {
            isEditing = YES;
            [PersonalApi playSoundEffect:@"warningButtonEffect.mp3"];//按键音效
            
            NSUserDefaults * _aUserDefaults = [NSUserDefaults standardUserDefaults];//开启持久化储存类
            
            NSMutableArray * myListNameArray = (NSMutableArray *)[_aUserDefaults objectForKey:@"myListNameArray"];
            
            
            
            for(NSString * aString in myListNameArray)
            {
                if ([[_listNameField text] isEqual:aString])
                {
                    _listNameField.text = @"该List已经存在";
                    
                    _listNameField.textColor = [UIColor redColor];
                    
                    inputSameListName = YES;
                    
                    return;
                }
            }
            
  
            [PersonalApi playSoundEffect:@"okButtonEffect.mp3"];//按键音效
            
            aActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [aActivityIndicatorView setFrame:CGRectMake(0, self.contentSize.height/2, 300, 100)];
            [aActivityIndicatorView setCenter:CGPointMake(self.contentSize.width/2, self.contentSize.height/2)];
            [[[CCDirector sharedDirector] view] addSubview:aActivityIndicatorView];
            [aActivityIndicatorView startAnimating];//小菊花开始旋转
            
            [self performSelector:@selector(parser) withObject:nil afterDelay:0.0];
            
        }
        else
        {
            _listNameField.text = @"List名不能为空";
            
            _listNameField.textColor = [UIColor redColor];
            
            inputSameListName = YES;
        }
    }
       
}


-(void)parser
{
    [SingleTonTool defaultMemory].wordListArray = [[NSMutableArray alloc] initWithCapacity:0];
    //解析得到的list
    if (isItunesShareList == NO)
    {
        NSString * tempStr = [_fileListArray objectAtIndex:_selectIndex];
        
        
        int strLength = [tempStr length]-4;
        tempStr = [tempStr substringToIndex:strLength];
        
        NSString * wordListXmlStr = [[NSBundle mainBundle] pathForResource:tempStr ofType:@"xml"];
        wordListXmlStr = [NSString stringWithContentsOfFile:wordListXmlStr encoding:NSUTF8StringEncoding error:nil];
        
    
        NSMutableArray * mySubArr1 = (NSMutableArray *)[wordListXmlStr componentsSeparatedByString:@"<0>"];//去头
        
        for (int i=1 ; i<[mySubArr1 count]; i++)
        {
            NSMutableArray * wordArr1 =[[NSMutableArray alloc] initWithCapacity:0];
            NSString * str1 = [mySubArr1 objectAtIndex:i];
            NSMutableArray * mySubArr2 = (NSMutableArray *)[str1 componentsSeparatedByString:@"<1/>"];//去尾
            NSString * str2 = [mySubArr2 objectAtIndex:0];
            str2= [str2 stringByReplacingOccurrencesOfString:@"<1>" withString:@" "];
            str2 = [str2 stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];//去空格
            [wordArr1 addObject:str2];
  
            if ([mySubArr2 count]>1)
            {
                NSString * str3 = [mySubArr2 objectAtIndex:1];
                NSMutableArray * mySubArr3 = (NSMutableArray *)[str3 componentsSeparatedByString:@"<3>"];//去头
                NSString * str4 = [mySubArr3 objectAtIndex:1];
                NSMutableArray * mySubArr4 = (NSMutableArray *)[str4 componentsSeparatedByString:@"<3/>"];//去尾
                NSString * str5 = [mySubArr4 objectAtIndex:0];
                [wordArr1 addObject:str5];
            }
            
     
            [[SingleTonTool defaultMemory].wordListArray addObject:wordArr1];
            [wordArr1 release];
        }
        
    }
    else
    {
        //解析得到的list
        
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                             objectAtIndex:0];
        
        NSString * _listName = [_fileListArray2 objectAtIndex:_selectIndex];
        
        NSString *filePath = [docPath stringByAppendingPathComponent:_listName];
        const char * filePathChar = [filePath UTF8String];
        
        
        {
            
            char *pchBuf = NULL;
            int  nLen = 0;
            string path = filePathChar;
            FILE *fp = fopen(path.c_str(), "r");
            
            fseek(fp, 0, SEEK_END); //文件指针移到文件尾
            nLen = ftell(fp);  //得到当前指针位置, 即是文件的长度
            rewind(fp);    //文件指针恢复到文件头位置
            
            //动态申请空间, 为保存字符串结尾标志\0, 多申请一个字符的空间
            pchBuf = (char*) malloc(sizeof(char)*nLen+1);
            if(!pchBuf)
            {
                perror("内存不够!\n");
                exit(0);
            }
            
            //读取文件内容//读取的长度和源文件长度有可能有出入，这里自动调整 nLen
            nLen = fread(pchBuf, sizeof(char), nLen, fp);
            
            pchBuf[nLen] = '\0'; //添加字符串结尾标志
            
            //printf("%s\n", pchBuf); //把读取的内容输出到屏幕看看
            string detailStr = pchBuf;
            fclose(fp);  //关闭文件
            free(pchBuf); //释放空间
            
            
            ExcelParser::paserExcel(detailStr);
            
        }
    }
    
    //NSLog(@"%@",[SingleTonTool defaultMemory].wordListArray);
    NSUserDefaults * aUserDefaults = [NSUserDefaults standardUserDefaults];//开启持久化储存类
    {
        NSDictionary * myListDic = (NSDictionary *)[aUserDefaults objectForKey:@"myListDic"];
        
        
        NSMutableDictionary * aDic = [[NSMutableDictionary alloc] initWithDictionary:myListDic copyItems:YES];
        
        NSMutableArray * aArray = [[NSMutableArray alloc] initWithArray:[SingleTonTool defaultMemory].wordListArray copyItems:YES];
        
        [aDic setObject:aArray forKey:[_listNameField text]];
        
        [aUserDefaults setObject:aDic forKey:@"myListDic"];
        [aDic release];
    }
    //名字索引排序用数组
    {
        NSMutableArray * myListNameArray = (NSMutableArray *)[aUserDefaults objectForKey:@"myListNameArray"];
        
        NSMutableArray * myListNameArray1 = [[NSMutableArray alloc] initWithArray:myListNameArray copyItems:YES];
        
        [myListNameArray1 addObject:[_listNameField text]];
        
        [aUserDefaults setObject:myListNameArray1 forKey:@"myListNameArray"];
        
        [myListNameArray1 release];
    }
    
    [[SingleTonTool defaultMemory].wordListArray removeAllObjects];
   // [[SingleTonTool defaultMemory].wordListArray release];
    
    
    isEditing = NO;
    
    [_editaItemFont setString:@"AddToList"];
    //设置状态为可编辑
    
    //[self.listTableViewController.tableView setEditing:NO animated:YES];
    
    inputSameListName = NO;
    isEditing = NO;
    [aActivityIndicatorView stopAnimating];
    [aActivityIndicatorView removeFromSuperview];
    [_maskView removeFromSuperview];
    
}

#pragma mark - return键方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_listNameField resignFirstResponder];
    
    return YES;
}


-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    if (touch.view == _maskView)
    {
        [_listNameField resignFirstResponder];
    }
    return YES;
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (inputSameListName ==YES)
    {
        inputSameListName = NO;
        
        _listNameField.text = @"";
        _listNameField.textColor = [UIColor blackColor];
    }
    return YES;
}

@end






