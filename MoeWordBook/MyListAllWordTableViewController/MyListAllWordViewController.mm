//
//  MyListAllWordViewController.m
//  MoeWordBook
//
//  Created by lyy on 12-11-6.
//
//

#import "MyListAllWordViewController.h"
#import "MyWordBookLayer1.h"
#include "PersonalApiCplu.h"

@interface MyListAllWordViewController ()

@end

@implementation MyListAllWordViewController
@synthesize fromListName = _fromListName;
@synthesize isMovingBlock = _isMovingBlock;
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
    self.isMovingBlock = false;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //CCLOG(@"1111111");
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //CCLOG(@"222222");
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        //CCLOG(@"33333");
    return [[SingleTonTool defaultMemory].wordListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //CCLOG(@"44444");
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        
        NSString * temStr = [[[SingleTonTool defaultMemory].wordListArray objectAtIndex:indexPath.row] objectAtIndex:0];
     
        cell.textLabel.text = temStr;
        cell.textLabel.textColor = [UIColor cyanColor];
        
    }

    NSString * temStr = [[[SingleTonTool defaultMemory].wordListArray objectAtIndex:indexPath.row] objectAtIndex:0];
  
    cell.textLabel.text = temStr;
    cell.textLabel.textColor = [UIColor cyanColor];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //CCLOG(@"5555555");
    [PersonalApi playSoundEffect:@"nextButtonEffect.mp3"];//按键音效
    [self.tableView removeFromSuperview];
    [SingleTonTool defaultMemory].nowWordIndex = indexPath.row;
    
    CCScene *scene = [CCScene node];
    MyWordBookLayer1 * myListAllWordLayer1 = [[MyWordBookLayer1 alloc]init];
    [scene addChild:myListAllWordLayer1];
    
    myListAllWordLayer1.fromListName = _fromListName;
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:scene]];
}


-(BOOL)tableView:(UITableView *)tableView
canEditRowIndexPath:(NSIndexPath *)indexPath
{
    //CCLOG(@"666666");
    if (indexPath.row ==0)
    {
        return NO;
    }
	return YES;
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView
		  editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //CCLOG(@"777777");
  
	if (indexPath.row == [[SingleTonTool defaultMemory].wordListArray count])
	{
		return UITableViewCellEditingStyleInsert;
	}
	return UITableViewCellEditingStyleDelete;
    

    //return UITableViewCellEditingStyleNone;
}




-(void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
   //CCLOG(@"8888888");
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
        [PersonalApi playSoundEffect:@"deleteButtonEffect.mp3"];//按键音效
		[[SingleTonTool defaultMemory].wordListArray removeObjectAtIndex:indexPath.row];
        
		[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:
											indexPath] withRowAnimation:
		 UITableViewRowAnimationLeft];
	}
	
	if (editingStyle == UITableViewCellEditingStyleInsert)
	{
		
		[[SingleTonTool defaultMemory].wordListArray addObject:@"New Custom"];
		
		[self.tableView insertRowsAtIndexPaths:
		 [NSArray arrayWithObject:indexPath]
                          withRowAnimation:
		 UITableViewRowAnimationTop];
	}
  
}

-(BOOL)tableView:(UITableView *)tableView
canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    //CCLOG(@"99999999");
    if(indexPath.section == 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
	//return [[SingleTonTool defaultMemory].wordListArray count]==indexPath.row;
}

-(void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
	 toIndexPath:(NSIndexPath *)destinationIndexPath
{
    //CCLOG(@"aaaaaa");
    NSString * customViewController = [[[SingleTonTool defaultMemory].wordListArray objectAtIndex:sourceIndexPath.row] retain];
	[[SingleTonTool defaultMemory].wordListArray removeObjectAtIndex:sourceIndexPath.row];
	[[SingleTonTool defaultMemory].wordListArray insertObject:customViewController atIndex:destinationIndexPath.row];
    [customViewController release];
    if (true==self.isMovingBlock)
    {
        self.isMovingBlock = false;
        return;
    }
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(JugmentMovingBlock) userInfo:nil repeats:NO];
}

-(NSIndexPath *)tableView:(UITableView *)tableView
targetIndexPathForMoveFromRowAtIndexPath:
(NSIndexPath *)sourceIndexPath
	  toProposedIndexPath:
(NSIndexPath *)proposedDestinationIndexPath
{
    //CCLOG(@"bbbbbbbb");
    self.isMovingBlock = true;
    if( sourceIndexPath.section != proposedDestinationIndexPath.section )
    {
        return sourceIndexPath;
    }
    else
    {
        return proposedDestinationIndexPath;
    }
	/*if (proposedDestinationIndexPath.row == [[SingleTonTool defaultMemory].wordListArray count])
	{
		return sourceIndexPath;
	}
	return proposedDestinationIndexPath;*/
}
-(void)JugmentMovingBlock
{
     //CCLOG(@"cccccccc");
}
@end
