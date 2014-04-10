//
//  MyListLayerViewController.m
//  MoeWordBook
//
//  Created by lyy on 12-11-4.
//
//

#import "MyListLayerViewController.h"
#import "MyWordBookLayer1.h"
#import "cocos2d.h"


@interface MyListLayerViewController ()

@end

@implementation MyListLayerViewController
@synthesize fileListArray = _fileListArray;
@synthesize maskView = _maskView;
@synthesize listNameField = _listNameField;
@synthesize addWordArray = _addWordArray;
@synthesize selectedArray = _selectedArray;
@synthesize myListLayer = _myListLayer;
@synthesize editaItemFont =_editaItemFont;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _addWordArray = [[NSMutableArray alloc] initWithCapacity:0];
    
   _selectedArray = [[NSMutableArray alloc] initWithCapacity:0];
  
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    {
        NSUserDefaults * _aUserDefaults = [NSUserDefaults standardUserDefaults];//开启持久化储存类
        
        NSMutableArray * myListNameArray = (NSMutableArray *)[_aUserDefaults objectForKey:@"myListNameArray"];
        _fileListArray = [[NSMutableArray alloc] initWithArray:myListNameArray copyItems:YES];

    }
    return [_fileListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    

    if (cell == nil)
    {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        
        cell.textLabel.text = [_fileListArray objectAtIndex:indexPath.row];
        
    }
    
    cell.textLabel.text = [_fileListArray objectAtIndex:indexPath.row];
    
  
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[_editaItemFont.label string] isEqualToString:@"Delete"])//多选删除
    {
         [PersonalApi playSoundEffect:@"selectButtonEffect.mp3"];//按键音效
        [self.selectedArray addObject:indexPath];
       // NSLog(@"%@",self.selectedArray);
    }
    else
    {
         [PersonalApi playSoundEffect:@"nextButtonEffect.mp3"];//按键音效
        NSUserDefaults * _aUserDefaults = [NSUserDefaults standardUserDefaults];//开启持久化储存类
        
        NSDictionary * myListDic = (NSDictionary *)[_aUserDefaults objectForKey:@"myListDic"];
        //NSMutableArray * aArray = [myListDic objectForKey:[_fileListArray objectAtIndex:indexPath.row]];
        
        
        //if ([aArray count]>0)
        {
            
            [SingleTonTool defaultMemory].wordListArray = [myListDic objectForKey:[_fileListArray objectAtIndex:indexPath.row]];
           
            [self.tableView removeFromSuperview];
            CCScene *scene = [CCScene node];
            MyWordBookLayer1 * myWordBookLayer1 = [[MyWordBookLayer1 alloc]init];
            [scene addChild:myWordBookLayer1];
            myWordBookLayer1.fromListName = [_fileListArray objectAtIndex:indexPath.row];
            
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:scene withColor:ccWHITE]];
        }
        /*else
         {
         selectedIndexPath = indexPath.row;
         
         NSUserDefaults * _aUserDefaults = [NSUserDefaults standardUserDefaults];//开启持久化储存类
         NSString * languageString = [_aUserDefaults objectForKey:@"language"];
         
         NSString * searchPath = [[NSBundle mainBundle] pathForResource:@"MyList" ofType:@"plist"];
         NSDictionary * dic1 = [NSDictionary dictionaryWithContentsOfFile:searchPath];
         
         
         NSDictionary * titleDic = [dic1 objectForKey:@"noWordTitle"];
         NSString * title = [titleDic objectForKey:languageString];
         
         NSDictionary * messageDic = [dic1 objectForKey:@"addWordMessage"];
         NSString * message = [messageDic objectForKey:languageString];
         
         NSDictionary * cancelDic = [dic1 objectForKey:@"cancelTitle"];
         NSString * cancel = [cancelDic objectForKey:languageString];
         
         NSDictionary * otherTitlesDic = [dic1 objectForKey:@"okTitle"];
         NSString * otherTitles = [otherTitlesDic objectForKey:languageString];
         
         UIAlertView * aAlertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancel otherButtonTitles:otherTitles, nil];
         [aAlertView show];
         }*/
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1)
    {
        [PersonalApi playSoundEffect:@"nextButtonEffect.mp3"];//按键音效
        NSUserDefaults * _aUserDefaults = [NSUserDefaults standardUserDefaults];//开启持久化储存类
        NSString * languageString = [_aUserDefaults objectForKey:@"language"];
        
        NSString * searchPath = [[NSBundle mainBundle] pathForResource:@"MyList" ofType:@"plist"];
        NSDictionary * dic1 = [NSDictionary dictionaryWithContentsOfFile:searchPath];
        
        
        {
            _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 460, 320)];
            
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
            
            NSDictionary * addEnglishDic = [dic1 objectForKey:@"AddEnglish"];
            NSString * addEnglish = [addEnglishDic objectForKey:languageString];
            _listNameField.placeholder = addEnglish;
            _listNameField.autocorrectionType = UITextAutocorrectionTypeNo;
            _listNameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            _listNameField.returnKeyType = UIReturnKeyDone;
            [aImageView addSubview:_listNameField];
            
            
            
            NSDictionary * cancelDic = [dic1 objectForKey:@"cancel"];
            NSString * cancel = [cancelDic objectForKey:languageString];
            UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//设置button字体颜色
            [cancelButton setTitle:cancel forState:UIControlStateNormal];
            
            cancelButton.frame = CGRectMake(0, 100, 60, 30);
            [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
            [aImageView addSubview:cancelButton];
            
            
            inPutTimes = 0;
            NSDictionary * otherTitlesDic = [dic1 objectForKey:@"ok"];
            NSString * otherTitles = [otherTitlesDic objectForKey:languageString];
            UIButton * addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//设置button字体颜色
            [addButton setTitle:otherTitles forState:UIControlStateNormal];
            
            addButton.frame = CGRectMake(200, 100, 60, 30);
            [addButton addTarget:self action:@selector(addButton) forControlEvents:UIControlEventTouchUpInside];
            [aImageView addSubview:addButton];
            
            
        }
    }
    else
    {
        [PersonalApi playSoundEffect:@"cancelButtonEffect.mp3"];//按键音效
    }
    
}


#pragma mark - return键方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_listNameField resignFirstResponder];
    
    return YES;
}
-(void)cancel
{
    [PersonalApi playSoundEffect:@"cancelButtonEffect.mp3"];//按键音效
    [_maskView removeFromSuperview];
}
-(void)addButton
{
    

    switch (inPutTimes)
    {
        case 0:
        {
            [_addWordArray addObject:[_listNameField text]];
            _listNameField.text = @" ";
            _listNameField.placeholder = @"添加中文解释";
            inPutTimes++;
        }
            break;
        case 1:
        {
           [_addWordArray addObject:[_listNameField text]];
            _listNameField.text = @" ";
            _listNameField.placeholder = @"添加记忆方法";
            inPutTimes++;
        }
            break;
        case 2:
        {
            [_addWordArray addObject:[_listNameField text]];
            
            NSMutableArray * aArray = [[NSMutableArray alloc] initWithArray:_addWordArray copyItems:YES];
            
            NSUserDefaults * aUserDefaults = [NSUserDefaults standardUserDefaults];//开启持久化储存类            
            NSMutableDictionary * myListDic = (NSMutableDictionary *)[aUserDefaults objectForKey:@"myListDic"];            
            NSMutableDictionary * aDic = [[NSMutableDictionary alloc] initWithDictionary:myListDic copyItems:YES];            
            NSMutableArray * aArray1 = [[NSMutableArray alloc] initWithCapacity:0];           
            [aArray1 addObject:aArray];
            [aDic setObject:aArray1 forKey:[_fileListArray objectAtIndex:selectedIndexPath]];
            [aUserDefaults setObject:aDic forKey:@"myListDic"];
            
       
            inPutTimes = 0;
            [_addWordArray removeAllObjects];
            [_maskView removeFromSuperview];
            
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - 单选多选
//取消一项
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [PersonalApi playSoundEffect:@"selectButtonEffect.mp3"];//按键音效
    
    
    if ([[_editaItemFont.label string] isEqualToString:@"Delete"])//多选删除
    {
        
        [self.selectedArray addObject:indexPath];
   
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
   /* if (indexPath.row == 0)
    {
        return NO;
    }*/
    return indexPath.row != 0;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    
}



/*-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    if (touch.view == _maskView)
    {
        [_listNameField resignFirstResponder];
    }
    return YES;
    
}
*/


@end






