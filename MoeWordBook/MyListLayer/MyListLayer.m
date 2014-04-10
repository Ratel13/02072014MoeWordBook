//
//  MyListLayer.m
//  MoeWordBook
//
//  Created by lyy on 12-11-4.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyListLayer.h"
#import "MyListLayerViewController.h"
#import "MainLayer.h"

@implementation MyListLayer

@synthesize bgSprite = _bgSprite;

@synthesize myListLayerViewController = _myListLayerViewController;
@synthesize listNameField = _listNameField;
@synthesize maskView= _maskView;
@synthesize editaItemFont =_editaItemFont;


+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	
	MyListLayer *layer = [MyListLayer node];
	
	[scene addChild: layer];
	
	return scene;
}

-(id) init
{
    
	if( (self=[super init]) )
    {
        self.isTouchEnabled = YES;
        
        inputSameListName = NO;
        
        
        //注册监听   1.dele类，2.优先级，3.YES为阻碍其他类的move 和 end
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:1000 swallowsTouches:YES];
        
        NSString * bgString = @"hatsunemiku7.jpg";
        
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
        
        {
            CCMenuItemFont * aItemFont = [CCMenuItemFont itemWithString:@"AddList" target:self selector:@selector(AddList)];
            [aItemFont setColor:ccBLACK];
            CGPoint aPoint = CGPointMake(aItemFont.contentSize.width,self.boundingBox.size.height - aItemFont.contentSize.height);
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
        
        isEditing = NO;
        
        
        [SingleTonTool defaultMemory].fontColor = ccWHITE;//CCMenuItemFont字体颜色设置复原
        
        
        [self performSelector:@selector(setUpTableView) withObject:nil afterDelay:0.5];
        
        
        
   	}
	return self;
}

-(void)setUpTableView
{
    _myListLayerViewController = [[MyListLayerViewController alloc] init];
    _myListLayerViewController.tableView.frame = CGRectMake(self.boundingBox.size.width,0, self.boundingBox.size.width/2, self.boundingBox.size.height/2);
    _myListLayerViewController.tableView.center = CGPointMake(self.boundingBox.size.width/4, self.boundingBox.size.height/2);

    
    [_myListLayerViewController.tableView setBackgroundColor:[UIColor clearColor]];
    _myListLayerViewController.myListLayer = self;
    _myListLayerViewController.editaItemFont = _editaItemFont;
    [[[CCDirector sharedDirector] view] addSubview:_myListLayerViewController.tableView];
    
    
}

-(void)BACK:(CCMenuItemFont * )aItemFont
{
    if (isEditing ==NO)
    {
        [PersonalApi playSoundEffect:@"backButtonEffect.mp3"];//按键音效
        [_myListLayerViewController.tableView removeFromSuperview];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[MainLayer scene]]];
        
    }
    
}

-(void)AddList
{
    if (isEditing ==NO)
    {
    [PersonalApi playSoundEffect:@"appearButtonEffect.mp3"];//按键音效
    {
        _maskView = [[UIView alloc] initWithFrame:self.boundingBox];
        
        [_maskView setBackgroundColor:[UIColor blackColor]];
        [_maskView setAlpha:0.6];
        
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
        
        cancelButton.frame = CGRectMake(0, 100, 60, 30);
        [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [aImageView addSubview:cancelButton];
        
        UIButton * addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        [addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//设置button字体颜色
        [addButton setTitle:@"addList" forState:UIControlStateNormal];
        
        addButton.frame = CGRectMake(200, 100, 60, 30);
        [addButton addTarget:self action:@selector(addButton) forControlEvents:UIControlEventTouchUpInside];
        [aImageView addSubview:addButton];
        
        
    }
    }
}


-(void)cancel
{
    
    [PersonalApi playSoundEffect:@"cancelButtonEffect.mp3"];//按键音效
    inputSameListName = NO;
    [_maskView removeFromSuperview];
}

-(void)Edit:(CCMenuItemFont * )aItemFont
{
    
    if (isEditing == NO)
    {
        
        [PersonalApi playSoundEffect:@"appearButtonEffect.mp3"];//按键音效
        
        isEditing = YES;
        [_editaItemFont setString:@"Delete"];
       //设置状态为可编辑
        
        [self.myListLayerViewController.tableView setEditing:YES animated:YES];

    }
    else
    {
        int count = [_myListLayerViewController.selectedArray count];
        if (count > 0 )
        {
            [PersonalApi playSoundEffect:@"deleteButtonEffect.mp3"];//按键音效
            NSUserDefaults * _aUserDefaults = [NSUserDefaults standardUserDefaults];//开启持久化储存类
            
            NSMutableArray * myListNameArray = (NSMutableArray *)[_aUserDefaults objectForKey:@"myListNameArray"];
            NSMutableArray * dataArray = [[NSMutableArray alloc] initWithArray:myListNameArray copyItems:YES];
            
            NSString * aObj = @"";//替换删除标志
            for (int i = 0; i < count; i++)//因为第一位不能编辑所以要去除第一位的搜索
            {
                NSInteger row = [[_myListLayerViewController.selectedArray objectAtIndex:i] row];//数组存的对象是indexPath，就是每个cell的地址，通过它可以索引到它在tableview的位置。
                [dataArray replaceObjectAtIndex:row withObject:aObj];
              
            }
            
            [dataArray removeObject:aObj];
            
            [_aUserDefaults setObject:dataArray forKey:@"myListNameArray"];
            
            
            [_myListLayerViewController.tableView deleteRowsAtIndexPaths:_myListLayerViewController.selectedArray withRowAnimation:UITableViewRowAnimationFade];
            if ([_myListLayerViewController.selectedArray count]>0)
            {
                 [_myListLayerViewController.selectedArray removeAllObjects];
            }
           
            
            isEditing = NO;
            
            _editaItemFont.label.string = @"Edit";
            
            [_myListLayerViewController.tableView setEditing:NO animated:YES];
           
        }
        else
        {
            
            [PersonalApi playSoundEffect:@"cancelButtonEffect.mp3"];//按键音效
            isEditing = NO;
            _editaItemFont.label.string = @"Edit";
            
            [_myListLayerViewController.tableView setEditing:NO animated:YES];
        }
    }
  
}
-(void)addButton
{
    if (inputSameListName ==NO)
    {
        if ([[_listNameField text] length]>0)
        {
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
            
            [_maskView removeFromSuperview];
            NSUserDefaults * aUserDefaults = [NSUserDefaults standardUserDefaults];//开启持久化储存类
            {
                NSDictionary * myListDic = (NSDictionary *)[aUserDefaults objectForKey:@"myListDic"];
                
                
                NSMutableDictionary * aDic = [[NSMutableDictionary alloc] initWithDictionary:myListDic copyItems:YES];
                
                NSMutableArray * aArray = [[NSMutableArray alloc] initWithCapacity:0];
                
                [aDic setObject:aArray forKey:[_listNameField text]];
                
                [aUserDefaults setObject:aDic forKey:@"myListDic"];
                
            }
            {
                NSMutableArray * myListNameArray = (NSMutableArray *)[aUserDefaults objectForKey:@"myListNameArray"];
                
                NSMutableArray * myListNameArray1 = [[NSMutableArray alloc] initWithArray:myListNameArray copyItems:YES];
                
                [myListNameArray1 addObject:[_listNameField text]];
                
                [aUserDefaults setObject:myListNameArray1 forKey:@"myListNameArray"];
            }
            
            [_myListLayerViewController.tableView reloadData];
        }
        else
        {
            _listNameField.text = @"List名不能为空";
            
            _listNameField.textColor = [UIColor redColor];
            
            inputSameListName = YES;
        }
    }
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
