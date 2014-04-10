//
//  MyWordBookMaskView.m
//  MoeWordBook
//
//  Created by lyy on 12-11-7.
//
//

#import "MyWordBookMaskView.h"
#import "MyWordBookLayer1.h"
@implementation MyWordBookMaskView
@synthesize allMyListTableView = _allMyListTableView;
@synthesize fileListArray = _fileListArray;
@synthesize nowWordIndex = _nowWordIndex;
@synthesize myWordBookLayer1 = _myWordBookLayer1;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.6;
        
        NSUserDefaults * _aUserDefaults = [NSUserDefaults standardUserDefaults];//开启持久化储存类
        NSString * languageString = [_aUserDefaults objectForKey:@"language"];
        
        NSString * searchPath = [[NSBundle mainBundle] pathForResource:@"MyWordBookMaskView" ofType:@"plist"];
        NSDictionary * dic1 = [NSDictionary dictionaryWithContentsOfFile:searchPath];
        
        
        {
          
            // UIImageView * aImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1"]];
            UIView * aImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 150)];
            aImageView.backgroundColor = [UIColor lightGrayColor];
            aImageView.center = self.center;
            [self addSubview:aImageView];
            
            
            _allMyListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,aImageView.frame.size.width, aImageView.frame.size.height-30)];
            _allMyListTableView.backgroundColor = [UIColor clearColor];
            
            _allMyListTableView.delegate = self;
            _allMyListTableView.dataSource = self;
            [aImageView addSubview:_allMyListTableView];
            
            
            
            NSDictionary * cancelDic = [dic1 objectForKey:@"cancel"];
            NSString * cancel = [cancelDic objectForKey:languageString];
            UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//设置button字体颜色
            [cancelButton setTitle:cancel forState:UIControlStateNormal];
            
            cancelButton.frame = CGRectMake(0, 100, aImageView.frame.size.width, 30);
            [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
            [aImageView addSubview:cancelButton];
            
        }
        
    }
    return self;
}
-(void)cancel
{
    [PersonalApi playSoundEffect:@"cancelButtonEffect.mp3"];//按键音效
    [_myWordBookLayer1 setAllActionStart];//回复所有按钮可以按
    [self removeFromSuperview];
    
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
    
    [PersonalApi playSoundEffect:@"nextButtonEffect.mp3"];//按键音效
    NSUserDefaults * _aUserDefaults = [NSUserDefaults standardUserDefaults];//开启持久化储存类
    
    NSMutableDictionary * myListDic = (NSMutableDictionary *)[_aUserDefaults objectForKey:@"myListDic"];
    
    NSMutableDictionary * aDic = [[NSMutableDictionary alloc] initWithDictionary:myListDic copyItems:YES];
    
    NSString * listNameString = [_fileListArray objectAtIndex:indexPath.row];
    
    NSMutableArray * tempArray = [[NSMutableArray alloc] initWithArray:[aDic objectForKey:listNameString] copyItems:YES];
    
    if ([tempArray count]>0)
    {
        
        NSMutableArray * newWordArray = [[NSMutableArray alloc] initWithArray:[[SingleTonTool defaultMemory].wordListArray objectAtIndex:_nowWordIndex] copyItems:YES] ;
        
        BOOL isSameWordInList = NO;
        sameWordReplaceInArrayIndex = 0;
        for(NSArray * wordArray in tempArray)
        {
            NSString * englishString = [wordArray objectAtIndex:0];
            
            if ([[newWordArray objectAtIndex:0] isEqual:englishString])
            {
                isSameWordInList = YES;
                
                [_myWordBookLayer1 setAllActionStart];//回复所有按钮可以按
                [_myWordBookLayer1 setSameWordReplaceInArrayIndex:sameWordReplaceInArrayIndex ListName:listNameString];
                [self removeFromSuperview];
        
            }
            sameWordReplaceInArrayIndex++;
        }
        
        
        if (isSameWordInList == NO)
        {
    
            [tempArray addObject:newWordArray];
            
            [aDic setObject:tempArray forKey:listNameString];
            
            [_aUserDefaults setObject:aDic forKey:@"myListDic"];
            
            [_myWordBookLayer1 setAllActionStart];//回复所有按钮可以按
            [self removeFromSuperview];
        }
    }
    else
    {
        
        
        NSMutableArray * aArray = [[NSMutableArray alloc] initWithArray:[[SingleTonTool defaultMemory].wordListArray objectAtIndex:_nowWordIndex] copyItems:YES] ;
        [tempArray addObject:aArray];
        
        [aDic setObject:tempArray forKey:listNameString];
        
        [_aUserDefaults setObject:aDic forKey:@"myListDic"];
        
        [_myWordBookLayer1 setAllActionStart];//回复所有按钮可以按
        [self removeFromSuperview];
    }
    
     
 
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
